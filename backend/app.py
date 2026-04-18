import os
import bcrypt
from functools import wraps

import oracledb
from dotenv import load_dotenv
from flask import Flask, redirect, render_template, request, session, url_for

from pathlib import Path
load_dotenv(dotenv_path=Path(__file__).parent.parent / ".env")

oracle_client_dir = os.getenv("ORACLE_CLIENT_DIR")
ORACLE_CLIENT_DIR = os.path.expanduser(oracle_client_dir) if oracle_client_dir else None

DB_USER     = "RICHARDTRAAD_SCHEMA_3RVCI"
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_DSN      = "db.freesql.com:1521/23ai_34ui2"
SECRET_KEY  = os.getenv("SECRET_KEY", "change-this-in-production")

if not ORACLE_CLIENT_DIR:
    raise RuntimeError("ORACLE_CLIENT_DIR is not set in your .env file.")
if not DB_PASSWORD:
    raise RuntimeError("DB_PASSWORD is not set in your .env file.")

oracledb.init_oracle_client(lib_dir=ORACLE_CLIENT_DIR)
print("Oracle client initialized. Version:", oracledb.clientversion())

# ── App ────────────────────────────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(
    __name__,
    template_folder=os.path.join(BASE_DIR, "../frontend/templates"),
    static_folder=os.path.join(BASE_DIR, "../frontend/static"),
)
app.secret_key = SECRET_KEY

# ── Database helpers ───────────────────────────────────────────────────────
def get_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)


def fetch_one(query, params=None):
    conn = cur = None
    try:
        conn = get_connection()
        cur  = conn.cursor()
        cur.execute(query, params or [])
        return cur.fetchone()
    finally:
        if cur:  cur.close()
        if conn: conn.close()


def run_write(query, params, success_message, not_found_message=None):
    conn = cur = None
    try:
        conn = get_connection()
        cur  = conn.cursor()
        cur.execute(query, params)
        conn.commit()
        if not_found_message and cur.rowcount == 0:
            return go_home(not_found_message, "error")
        return go_home(success_message, "success")
    except Exception as error:
        if conn: conn.rollback()
        return go_home(format_db_error(error), "error")
    finally:
        if cur:  cur.close()
        if conn: conn.close()


def optional_number(value):
    value = (value or "").strip().lower()
    return None if value in {"", "none"} else int(value)


def format_db_error(error):
    msg = str(error)
    if "ORA-12514" in msg: return "ORA-12514: Service name not found. Check your DSN."
    if "DPY-3001"  in msg: return "Oracle Thick mode not initialised correctly."
    if "DPY-6005"  in msg: return "Could not connect to Oracle. Check DSN/credentials."
    if "ORA-01017" in msg: return "Invalid username or password."
    if "ORA-00001" in msg: return "That record already exists or uses a duplicate value."
    if "ORA-02291" in msg: return "A referenced record does not exist."
    if "ORA-02292" in msg: return "Delete blocked — this record has dependent rows."
    return msg


def go_home(message, message_type):
    return redirect(url_for("index", message=message, message_type=message_type))


# ── Auth decorators ────────────────────────────────────────────────────────
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated


def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "user_id" not in session:
            return redirect(url_for("login"))
        if session.get("role") != "admin":
            return go_home("Admin access required.", "error")
        return f(*args, **kwargs)
    return decorated


def current_user():
    if "user_id" not in session:
        return None
    return {
        "user_id":  session["user_id"],
        "username": session["username"],
        "role":     session["role"],
    }


# ── Auth routes ────────────────────────────────────────────────────────────
@app.route("/login", methods=["GET", "POST"])
def login():
    if "user_id" in session:
        return redirect(url_for("index"))

    error = None
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        if not username or not password:
            error = "Username and password are required."
        else:
            row = fetch_one(
                "SELECT user_id, password_hash, role FROM AppUser WHERE username = :1",
                [username],
            )
            if row and bcrypt.checkpw(password.encode("utf-8"), row[1].encode("utf-8")):
                session.clear()
                session["user_id"]  = row[0]
                session["username"] = username
                session["role"]     = row[2]
                return redirect(url_for("index"))
            else:
                error = "Invalid username or password."

    return render_template("login.html", error=error)


@app.route("/logout")
@login_required
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.route("/signup", methods=["GET", "POST"])
def signup():
    if "user_id" in session:
        return redirect(url_for("index"))

    error = None
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        confirm  = request.form.get("confirm_password", "")

        if not username or not password:
            error = "Username and password are required."
        elif len(password) < 6:
            error = "Password must be at least 6 characters."
        elif password != confirm:
            error = "Passwords do not match."
        else:
            existing = fetch_one(
                "SELECT user_id FROM AppUser WHERE username = :1", [username]
            )
            if existing:
                error = "That username is already taken."
            else:
                pw_hash = bcrypt.hashpw(
                    password.encode("utf-8"), bcrypt.gensalt()
                ).decode("utf-8")
                conn = cur = None
                try:
                    conn = get_connection()
                    cur  = conn.cursor()
                    cur.execute(
                        "INSERT INTO AppUser (username, password_hash, role) "
                        "VALUES (:1, :2, 'client')",
                        [username, pw_hash],
                    )
                    conn.commit()
                    return redirect(url_for("login"))
                except Exception as e:
                    if conn: conn.rollback()
                    error = format_db_error(e)
                finally:
                    if cur:  cur.close()
                    if conn: conn.close()

    return render_template("signup.html", error=error)


@app.route("/change-password", methods=["GET", "POST"])
@login_required
def change_password():
    error = success = None

    if request.method == "POST":
        current_pw = request.form.get("current_password", "")
        new_pw     = request.form.get("new_password", "")
        confirm_pw = request.form.get("confirm_password", "")

        if not current_pw or not new_pw:
            error = "All fields are required."
        elif len(new_pw) < 6:
            error = "New password must be at least 6 characters."
        elif new_pw != confirm_pw:
            error = "New passwords do not match."
        else:
            row = fetch_one(
                "SELECT password_hash FROM AppUser WHERE user_id = :1",
                [session["user_id"]],
            )
            if not row or not bcrypt.checkpw(
                current_pw.encode("utf-8"), row[0].encode("utf-8")
            ):
                error = "Current password is incorrect."
            else:
                new_hash = bcrypt.hashpw(
                    new_pw.encode("utf-8"), bcrypt.gensalt()
                ).decode("utf-8")
                conn = cur = None
                try:
                    conn = get_connection()
                    cur  = conn.cursor()
                    cur.execute(
                        "UPDATE AppUser SET password_hash = :1 WHERE user_id = :2",
                        [new_hash, session["user_id"]],
                    )
                    conn.commit()
                    success = "Password changed successfully."
                except Exception as e:
                    if conn: conn.rollback()
                    error = format_db_error(e)
                finally:
                    if cur:  cur.close()
                    if conn: conn.close()

    return render_template(
        "change_password.html",
        error=error,
        success=success,
        current_user=current_user(),
    )


@app.route("/admin/create-user", methods=["GET", "POST"])
@admin_required
def admin_create_user():
    error = success = None

    if request.method == "POST":
        username   = request.form.get("username", "").strip()
        password   = request.form.get("password", "")
        role       = request.form.get("role", "client")
        trainer_id = optional_number(request.form.get("trainer_id"))
        client_id  = optional_number(request.form.get("client_id"))

        if not username or not password:
            error = "Username and password are required."
        elif len(password) < 6:
            error = "Password must be at least 6 characters."
        elif role not in ("admin", "trainer", "client"):
            error = "Invalid role."
        else:
            existing = fetch_one(
                "SELECT user_id FROM AppUser WHERE username = :1", [username]
            )
            if existing:
                error = "That username is already taken."
            else:
                pw_hash = bcrypt.hashpw(
                    password.encode("utf-8"), bcrypt.gensalt()
                ).decode("utf-8")
                conn = cur = None
                try:
                    conn = get_connection()
                    cur  = conn.cursor()
                    cur.execute(
                        "INSERT INTO AppUser "
                        "(username, password_hash, role, trainer_id, client_id) "
                        "VALUES (:1, :2, :3, :4, :5)",
                        [username, pw_hash, role, trainer_id, client_id],
                    )
                    conn.commit()
                    success = f"User '{username}' ({role}) created successfully."
                except Exception as e:
                    if conn: conn.rollback()
                    error = format_db_error(e)
                finally:
                    if cur:  cur.close()
                    if conn: conn.close()

    trainers = clients = []
    conn = cur = None
    try:
        conn = get_connection()
        cur  = conn.cursor()
        cur.execute(
            "SELECT trainer_id, first_name || ' ' || last_name "
            "FROM Trainer ORDER BY trainer_id"
        )
        trainers = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]
        cur.execute(
            "SELECT client_id, first_name || ' ' || last_name "
            "FROM Client ORDER BY client_id"
        )
        clients = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]
    except Exception:
        pass
    finally:
        if cur:  cur.close()
        if conn: conn.close()

    return render_template(
        "create_user.html",
        error=error,
        success=success,
        trainers=trainers,
        clients=clients,
        current_user=current_user(),
    )


# ── Dashboard data ─────────────────────────────────────────────────────────
def load_dashboard_data():
    data = {
        "db_status": "Connection Failed", "status_color": "red",
        "db_detail": "Unable to load database data.",
        "counts": [], "trainers": [], "gyms": [],
        "client_options": [], "plan_options": [],
        "clients": [], "plans": [],
        "report_client_progress": [], "report_trainer_workload": [],
    }

    conn = cur = None
    try:
        conn = get_connection()
        cur  = conn.cursor()

        data["db_status"]    = "Connected"
        data["status_color"] = "green"
        data["db_detail"]    = (
            f"Oracle DB Version: {conn.version} | "
            f"Database: 23ai_34ui2 | User: {DB_USER}"
        )

        for label, tbl in [
            ("Trainers", "Trainer"), ("Gyms", "Gym"), ("Clients", "Client"),
            ("Plans", "WorkoutPlan"), ("Exercises", "Exercise"),
            ("Notifications", "Notification"), ("App Users", "AppUser"),
        ]:
            cur.execute(f"SELECT COUNT(*) FROM {tbl}")
            data["counts"].append({"label": label, "count": cur.fetchone()[0]})

        cur.execute(
            "SELECT trainer_id, first_name || ' ' || last_name "
            "FROM Trainer ORDER BY trainer_id"
        )
        data["trainers"] = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]

        cur.execute("SELECT gym_id, gym_name FROM Gym ORDER BY gym_id")
        data["gyms"] = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]

        cur.execute(
            "SELECT client_id, first_name || ' ' || last_name "
            "FROM Client ORDER BY client_id"
        )
        data["client_options"] = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]

        cur.execute("SELECT plan_id, plan_name FROM WorkoutPlan ORDER BY plan_id")
        data["plan_options"] = [{"id": r[0], "name": r[1]} for r in cur.fetchall()]

        cur.execute(
            """
            SELECT c.client_id,
                   c.first_name || ' ' || c.last_name,
                   c.email,
                   NVL(t.first_name || ' ' || t.last_name, 'None'),
                   NVL(g.gym_name, 'None')
            FROM Client c
            LEFT JOIN Trainer t ON c.current_trainer_id = t.trainer_id
            LEFT JOIN Gym     g ON c.home_gym_id        = g.gym_id
            ORDER BY c.client_id
            FETCH FIRST 20 ROWS ONLY
            """
        )
        data["clients"] = [
            {"id": r[0], "name": r[1], "email": r[2], "trainer": r[3], "gym": r[4]}
            for r in cur.fetchall()
        ]

        cur.execute(
            """
            SELECT p.plan_id, p.plan_name,
                   c.first_name || ' ' || c.last_name,
                   NVL(t.first_name || ' ' || t.last_name, 'Self-guided'),
                   CASE WHEN p.is_archived = 1 THEN 'Yes' ELSE 'No' END
            FROM WorkoutPlan p
            JOIN  Client  c ON p.client_id  = c.client_id
            LEFT JOIN Trainer t ON p.trainer_id = t.trainer_id
            ORDER BY p.plan_id
            FETCH FIRST 20 ROWS ONLY
            """
        )
        data["plans"] = [
            {"id": r[0], "name": r[1], "client": r[2], "trainer": r[3], "archived": r[4]}
            for r in cur.fetchall()
        ]

        # Report 1
        cur.execute(
            """
            SELECT
                c.client_id,
                c.first_name || ' ' || c.last_name          AS client_name,
                CASE WHEN t.trainer_id IS NULL THEN 'Self-guided'
                     ELSE t.first_name || ' ' || t.last_name
                END                                          AS trainer_name,
                COUNT(DISTINCT ws.session_id)                AS total_sessions,
                COUNT(DISTINCT pl.log_id)                    AS total_exercises_logged,
                ROUND(AVG(pls.rpe), 1)                       AS avg_rpe
            FROM Client c
            LEFT JOIN Trainer           t   ON t.trainer_id  = c.current_trainer_id
            LEFT JOIN WorkoutSession    ws  ON ws.client_id  = c.client_id
            LEFT JOIN PerformanceLog    pl  ON pl.session_id = ws.session_id
            LEFT JOIN PerformanceLogSet pls ON pls.log_id   = pl.log_id
            GROUP BY
                c.client_id, c.first_name, c.last_name,
                t.trainer_id, t.first_name, t.last_name
            ORDER BY total_sessions DESC NULLS LAST, c.client_id
            """
        )
        data["report_client_progress"] = [
            {
                "client_name":            r[1],
                "trainer_name":           r[2],
                "total_sessions":         r[3],
                "total_exercises_logged": r[4],
                "avg_rpe":                r[5] if r[5] is not None else "N/A",
            }
            for r in cur.fetchall()
        ]

        # Report 2
        cur.execute(
            """
            SELECT
                t.trainer_id,
                t.first_name || ' ' || t.last_name   AS trainer_name,
                t.credentials,
                COUNT(DISTINCT c.client_id)           AS total_clients,
                COUNT(DISTINCT wp.plan_id)            AS total_plans_assigned,
                COUNT(DISTINCT tg.gym_id)             AS gyms_affiliated
            FROM Trainer t
            LEFT JOIN Client      c  ON c.current_trainer_id = t.trainer_id
            LEFT JOIN WorkoutPlan wp ON wp.trainer_id        = t.trainer_id
            LEFT JOIN TrainerGym  tg ON tg.trainer_id        = t.trainer_id
            GROUP BY t.trainer_id, t.first_name, t.last_name, t.credentials
            ORDER BY total_clients DESC NULLS LAST, t.trainer_id
            """
        )
        data["report_trainer_workload"] = [
            {
                "trainer_name":         r[1],
                "credentials":          r[2] or "N/A",
                "total_clients":        r[3],
                "total_plans_assigned": r[4],
                "gyms_affiliated":      r[5],
            }
            for r in cur.fetchall()
        ]

    except Exception as error:
        data["db_detail"] = format_db_error(error)
    finally:
        if cur:  cur.close()
        if conn: conn.close()

    return data


# ── Main dashboard ─────────────────────────────────────────────────────────
@app.route("/")
@login_required
def index():
    data = load_dashboard_data()
    data["message"]      = request.args.get("message", "")
    data["message_type"] = request.args.get("message_type", "success")
    data["current_user"] = current_user()
    return render_template("index.html", **data)


# ── Client CRUD ────────────────────────────────────────────────────────────
@app.post("/clients/add")
@login_required
def add_client():
    first_name  = request.form.get("first_name", "").strip()
    last_name   = request.form.get("last_name",  "").strip()
    email       = request.form.get("email",      "").strip()
    trainer_id  = optional_number(request.form.get("current_trainer_id"))
    home_gym_id = optional_number(request.form.get("home_gym_id"))

    if not first_name or not last_name or not email:
        return go_home("First name, last name, and email are required.", "error")

    return run_write(
        "INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) "
        "VALUES (:1, :2, :3, :4, :5)",
        [first_name, last_name, email, trainer_id, home_gym_id],
        f"Client {first_name} {last_name} added successfully.",
    )


@app.post("/clients/update")
@login_required
def update_client():
    client_id = request.form.get("client_id", "").strip()
    if not client_id:
        return go_home("Please choose a client to update.", "error")
    try:
        row = fetch_one(
            "SELECT first_name, last_name, email, current_trainer_id, home_gym_id "
            "FROM Client WHERE client_id = :1",
            [int(client_id)],
        )
        if not row:
            return go_home("Client not found.", "error")

        first_name  = request.form.get("first_name", "").strip() or row[0]
        last_name   = request.form.get("last_name",  "").strip() or row[1]
        email       = request.form.get("email",      "").strip() or row[2]
        trainer_val = request.form.get("current_trainer_id", "")
        gym_val     = request.form.get("home_gym_id", "")
        trainer_id  = row[3] if trainer_val == "" else optional_number(trainer_val)
        home_gym_id = row[4] if gym_val     == "" else optional_number(gym_val)

        return run_write(
            "UPDATE Client SET first_name=:1, last_name=:2, email=:3, "
            "current_trainer_id=:4, home_gym_id=:5 WHERE client_id=:6",
            [first_name, last_name, email, trainer_id, home_gym_id, int(client_id)],
            f"Client {client_id} updated successfully.",
            "Client not found.",
        )
    except Exception as error:
        return go_home(format_db_error(error), "error")


@app.post("/clients/delete")
@login_required
def delete_client():
    client_id = request.form.get("client_id", "").strip()
    if not client_id:
        return go_home("Please choose a client to delete.", "error")
    return run_write(
        "DELETE FROM Client WHERE client_id = :1",
        [int(client_id)],
        f"Client {client_id} deleted successfully.",
        "Client not found.",
    )


# ── Workout Plan CRUD ──────────────────────────────────────────────────────
@app.post("/plans/add")
@login_required
def add_plan():
    client_id   = request.form.get("client_id", "").strip()
    trainer_id  = optional_number(request.form.get("trainer_id"))
    plan_name   = request.form.get("plan_name", "").strip()
    is_archived = int(request.form.get("is_archived", "0"))

    if not client_id or not plan_name:
        return go_home("Please choose a client and enter a plan name.", "error")

    return run_write(
        "INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) "
        "VALUES (:1, :2, :3, :4)",
        [int(client_id), trainer_id, plan_name, is_archived],
        f"Workout plan '{plan_name}' added successfully.",
    )


@app.post("/plans/update")
@login_required
def update_plan():
    plan_id = request.form.get("plan_id", "").strip()
    if not plan_id:
        return go_home("Please choose a workout plan to update.", "error")
    try:
        row = fetch_one(
            "SELECT trainer_id, plan_name, is_archived FROM WorkoutPlan WHERE plan_id = :1",
            [int(plan_id)],
        )
        if not row:
            return go_home("Workout plan not found.", "error")

        trainer_val  = request.form.get("trainer_id", "")
        archived_val = request.form.get("is_archived", "")
        trainer_id   = row[0] if trainer_val  == "" else optional_number(trainer_val)
        plan_name    = request.form.get("plan_name", "").strip() or row[1]
        is_archived  = row[2] if archived_val == "" else int(archived_val)

        return run_write(
            "UPDATE WorkoutPlan SET trainer_id=:1, plan_name=:2, is_archived=:3 "
            "WHERE plan_id=:4",
            [trainer_id, plan_name, is_archived, int(plan_id)],
            f"Workout plan {plan_id} updated successfully.",
            "Workout plan not found.",
        )
    except Exception as error:
        return go_home(format_db_error(error), "error")


@app.post("/plans/delete")
@login_required
def delete_plan():
    plan_id = request.form.get("plan_id", "").strip()
    if not plan_id:
        return go_home("Please choose a workout plan to delete.", "error")
    return run_write(
        "DELETE FROM WorkoutPlan WHERE plan_id = :1",
        [int(plan_id)],
        f"Workout plan {plan_id} deleted successfully.",
        "Workout plan not found.",
    )


if __name__ == "__main__":
    app.run(debug=True)