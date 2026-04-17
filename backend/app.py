import os
import oracledb
from flask import Flask, redirect, render_template, request, url_for
from dotenv import load_dotenv

# Load .env values
load_dotenv()

# Oracle client path from .env
oracle_client_dir = os.getenv("ORACLE_CLIENT_DIR")
ORACLE_CLIENT_DIR = os.path.expanduser(oracle_client_dir) if oracle_client_dir else None

# Use the provider's exact connection values
DB_USER = "RICHARDTRAAD_SCHEMA_3RVCI"
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_DSN = "db.freesql.com:1521/23ai_34ui2"

if not ORACLE_CLIENT_DIR:
    raise RuntimeError("ORACLE_CLIENT_DIR is not set in your .env file.")

if not DB_PASSWORD:
    raise RuntimeError("DB_PASSWORD is not set in your .env file.")

print("ORACLE_CLIENT_DIR =", ORACLE_CLIENT_DIR)
print("DB_DSN =", repr(DB_DSN))
print("Thin mode before init:", oracledb.is_thin_mode())

oracledb.init_oracle_client(lib_dir=ORACLE_CLIENT_DIR)

print("Oracle client initialized successfully.")
print("Thin mode after init:", oracledb.is_thin_mode())
print("Oracle client version:", oracledb.clientversion())

app = Flask(
    __name__,
    template_folder="../frontend/templates",
    static_folder="../frontend/static"
)


def get_connection():
    print("Connecting with DSN:", repr(DB_DSN))
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)


def go_home(message, message_type):
    return redirect(url_for("index", message=message, message_type=message_type))


def optional_number(value):
    value = (value or "").strip().lower()
    if value in {"", "none"}:
        return None
    return int(value)


def format_db_error(error):
    message = str(error)

    if "ORA-12514" in message:
        return (
            "ORA-12514: The app reached the Oracle listener, but the service name "
            "was not accepted. Double-check the DSN/service name and try again."
        )
    if "DPY-3001" in message:
        return (
            "Connection failed because the database requires Oracle Thick mode, "
            "but the Oracle client was not initialized correctly."
        )
    if "DPY-6005" in message:
        return (
            "Could not connect to the Oracle database. Verify the DSN, username, "
            "password, and Oracle client setup."
        )
    if "ORA-01017" in message:
        return "Invalid username or password."
    if "ORA-00001" in message:
        return "That record already exists or uses a duplicate email."
    if "ORA-02291" in message:
        return "A referenced trainer or gym does not exist."
    if "ORA-02292" in message:
        return "Delete blocked because this record has related child rows in other tables."

    return message


def fetch_one(query, params=None):
    conn = None
    cur = None

    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(query, params or [])
        return cur.fetchone()
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


def run_write(query, params, success_message, not_found_message=None):
    conn = None
    cur = None

    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(query, params)
        conn.commit()

        if not_found_message and cur.rowcount == 0:
            return go_home(not_found_message, "error")

        return go_home(success_message, "success")
    except Exception as error:
        if conn is not None:
            conn.rollback()
        return go_home(format_db_error(error), "error")
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


def load_dashboard_data():
    data = {
        "db_status": "Connection Failed",
        "status_color": "red",
        "db_detail": "Unable to load database data.",
        "counts": [],
        "trainers": [],
        "gyms": [],
        "client_options": [],
        "plan_options": [],
        "clients": [],
        "plans": [],
        # Report 1: Client Progress Summary
        "report_client_progress": [],
        # Report 2: Trainer Workload Summary
        "report_trainer_workload": [],
    }

    conn = None
    cur = None

    try:
        conn = get_connection()
        cur = conn.cursor()

        data["db_status"] = "Connected"
        data["status_color"] = "green"
        data["db_detail"] = (
            f"Oracle DB Version: {conn.version} | Database: 23ai_34ui2 | User: {DB_USER}"
        )

        count_tables = [
            ("Trainers", "Trainer"),
            ("Gyms", "Gym"),
            ("Clients", "Client"),
            ("Plans", "WorkoutPlan"),
            ("Exercises", "Exercise"),
            ("Notifications", "Notification"),
        ]

        for label, table_name in count_tables:
            cur.execute(f"SELECT COUNT(*) FROM {table_name}")
            data["counts"].append({"label": label, "count": cur.fetchone()[0]})

        cur.execute(
            """
            SELECT trainer_id, first_name || ' ' || last_name AS trainer_name
            FROM Trainer
            ORDER BY trainer_id
            """
        )
        data["trainers"] = [{"id": row[0], "name": row[1]} for row in cur.fetchall()]

        cur.execute(
            """
            SELECT gym_id, gym_name
            FROM Gym
            ORDER BY gym_id
            """
        )
        data["gyms"] = [{"id": row[0], "name": row[1]} for row in cur.fetchall()]

        cur.execute(
            """
            SELECT client_id, first_name || ' ' || last_name AS client_name
            FROM Client
            ORDER BY client_id
            """
        )
        data["client_options"] = [{"id": row[0], "name": row[1]} for row in cur.fetchall()]

        cur.execute(
            """
            SELECT plan_id, plan_name
            FROM WorkoutPlan
            ORDER BY plan_id
            """
        )
        data["plan_options"] = [{"id": row[0], "name": row[1]} for row in cur.fetchall()]

        cur.execute(
            """
            SELECT
                c.client_id,
                c.first_name || ' ' || c.last_name AS client_name,
                c.email,
                NVL(t.first_name || ' ' || t.last_name, 'None') AS trainer_name,
                NVL(g.gym_name, 'None') AS gym_name
            FROM Client c
            LEFT JOIN Trainer t ON c.current_trainer_id = t.trainer_id
            LEFT JOIN Gym g ON c.home_gym_id = g.gym_id
            ORDER BY c.client_id
            FETCH FIRST 20 ROWS ONLY
            """
        )
        data["clients"] = [
            {
                "id": row[0],
                "name": row[1],
                "email": row[2],
                "trainer": row[3],
                "gym": row[4],
            }
            for row in cur.fetchall()
        ]

        cur.execute(
            """
            SELECT
                p.plan_id,
                p.plan_name,
                c.first_name || ' ' || c.last_name AS client_name,
                NVL(t.first_name || ' ' || t.last_name, 'Self-guided') AS trainer_name,
                CASE WHEN p.is_archived = 1 THEN 'Yes' ELSE 'No' END AS archived_flag
            FROM WorkoutPlan p
            JOIN Client c ON p.client_id = c.client_id
            LEFT JOIN Trainer t ON p.trainer_id = t.trainer_id
            ORDER BY p.plan_id
            FETCH FIRST 20 ROWS ONLY
            """
        )
        data["plans"] = [
            {
                "id": row[0],
                "name": row[1],
                "client": row[2],
                "trainer": row[3],
                "archived": row[4],
            }
            for row in cur.fetchall()
        ]

        # ------------------------------------------------------------
        # REPORT 1: Client Progress Summary
        # For each client, shows total sessions logged, total distinct
        # exercises performed, and average RPE across all sets.
        # Uses: LEFT JOINs across Client, WorkoutSession,
        #       PerformanceLog, PerformanceLogSet + GROUP BY
        # ------------------------------------------------------------
        cur.execute(
            """
            SELECT
                c.client_id,
                c.first_name || ' ' || c.last_name          AS client_name,
                NVL(t.first_name || ' ' || t.last_name,
                    'Self-guided')                           AS trainer_name,
                COUNT(DISTINCT ws.session_id)                AS total_sessions,
                COUNT(DISTINCT pl.log_id)                    AS total_exercises_logged,
                ROUND(AVG(pls.rpe), 1)                       AS avg_rpe
            FROM Client c
            LEFT JOIN Trainer          t   ON t.trainer_id   = c.current_trainer_id
            LEFT JOIN WorkoutSession   ws  ON ws.client_id   = c.client_id
            LEFT JOIN PerformanceLog   pl  ON pl.session_id  = ws.session_id
            LEFT JOIN PerformanceLogSet pls ON pls.log_id    = pl.log_id
            GROUP BY
                c.client_id,
                c.first_name, c.last_name,
                t.first_name, t.last_name
            ORDER BY total_sessions DESC NULLS LAST, c.client_id
            """
        )
        data["report_client_progress"] = [
            {
                "client_name": row[1],
                "trainer_name": row[2],
                "total_sessions": row[3],
                "total_exercises_logged": row[4],
                "avg_rpe": row[5] if row[5] is not None else "N/A",
            }
            for row in cur.fetchall()
        ]

        # ------------------------------------------------------------
        # REPORT 2: Trainer Workload Summary
        # For each trainer, shows total active clients, total workout
        # plans assigned, and number of gyms affiliated with.
        # Uses: LEFT JOINs across Trainer, Client, WorkoutPlan,
        #       TrainerGym + GROUP BY
        # ------------------------------------------------------------
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
            LEFT JOIN Client      c   ON c.current_trainer_id = t.trainer_id
            LEFT JOIN WorkoutPlan wp  ON wp.trainer_id        = t.trainer_id
            LEFT JOIN TrainerGym  tg  ON tg.trainer_id        = t.trainer_id
            GROUP BY
                t.trainer_id,
                t.first_name, t.last_name,
                t.credentials
            ORDER BY total_clients DESC NULLS LAST, t.trainer_id
            """
        )
        data["report_trainer_workload"] = [
            {
                "trainer_name": row[1],
                "credentials": row[2] or "N/A",
                "total_clients": row[3],
                "total_plans_assigned": row[4],
                "gyms_affiliated": row[5],
            }
            for row in cur.fetchall()
        ]

    except Exception as error:
        data["db_detail"] = format_db_error(error)
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()

    return data


@app.route("/")
def index():
    data = load_dashboard_data()
    data["message"] = request.args.get("message", "")
    data["message_type"] = request.args.get("message_type", "success")
    return render_template("index.html", **data)


@app.post("/clients/add")
def add_client():
    first_name = request.form.get("first_name", "").strip()
    last_name = request.form.get("last_name", "").strip()
    email = request.form.get("email", "").strip()
    trainer_id = optional_number(request.form.get("current_trainer_id"))
    home_gym_id = optional_number(request.form.get("home_gym_id"))

    if not first_name or not last_name or not email:
        return go_home("First name, last name, and email are required.", "error")

    return run_write(
        """
        INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id)
        VALUES (:1, :2, :3, :4, :5)
        """,
        [first_name, last_name, email, trainer_id, home_gym_id],
        f"Client {first_name} {last_name} was added successfully.",
    )


@app.post("/clients/update")
def update_client():
    client_id = request.form.get("client_id", "").strip()

    if not client_id:
        return go_home("Please choose a client to update.", "error")

    try:
        row = fetch_one(
            """
            SELECT first_name, last_name, email, current_trainer_id, home_gym_id
            FROM Client
            WHERE client_id = :1
            """,
            [int(client_id)],
        )

        if row is None:
            return go_home("Client not found.", "error")

        first_name = request.form.get("first_name", "").strip() or row[0]
        last_name = request.form.get("last_name", "").strip() or row[1]
        email = request.form.get("email", "").strip() or row[2]

        trainer_value = request.form.get("current_trainer_id", "")
        gym_value = request.form.get("home_gym_id", "")

        trainer_id = row[3] if trainer_value == "" else optional_number(trainer_value)
        home_gym_id = row[4] if gym_value == "" else optional_number(gym_value)

        return run_write(
            """
            UPDATE Client
            SET first_name = :1,
                last_name = :2,
                email = :3,
                current_trainer_id = :4,
                home_gym_id = :5
            WHERE client_id = :6
            """,
            [first_name, last_name, email, trainer_id, home_gym_id, int(client_id)],
            f"Client {client_id} was updated successfully.",
            "Client not found.",
        )
    except Exception as error:
        return go_home(format_db_error(error), "error")


@app.post("/clients/delete")
def delete_client():
    client_id = request.form.get("client_id", "").strip()

    if not client_id:
        return go_home("Please choose a client to delete.", "error")

    return run_write(
        "DELETE FROM Client WHERE client_id = :1",
        [int(client_id)],
        f"Client {client_id} was deleted successfully.",
        "Client not found.",
    )


@app.post("/plans/add")
def add_plan():
    client_id = request.form.get("client_id", "").strip()
    trainer_id = optional_number(request.form.get("trainer_id"))
    plan_name = request.form.get("plan_name", "").strip()
    is_archived = int(request.form.get("is_archived", "0"))

    if not client_id or not plan_name:
        return go_home("Please choose a client and enter a plan name.", "error")

    return run_write(
        """
        INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived)
        VALUES (:1, :2, :3, :4)
        """,
        [int(client_id), trainer_id, plan_name, is_archived],
        f"Workout plan '{plan_name}' was added successfully.",
    )


@app.post("/plans/update")
def update_plan():
    plan_id = request.form.get("plan_id", "").strip()

    if not plan_id:
        return go_home("Please choose a workout plan to update.", "error")

    try:
        row = fetch_one(
            """
            SELECT trainer_id, plan_name, is_archived
            FROM WorkoutPlan
            WHERE plan_id = :1
            """,
            [int(plan_id)],
        )

        if row is None:
            return go_home("Workout plan not found.", "error")

        trainer_value = request.form.get("trainer_id", "")
        archived_value = request.form.get("is_archived", "")

        trainer_id = row[0] if trainer_value == "" else optional_number(trainer_value)
        plan_name = request.form.get("plan_name", "").strip() or row[1]
        is_archived = row[2] if archived_value == "" else int(archived_value)

        return run_write(
            """
            UPDATE WorkoutPlan
            SET trainer_id = :1,
                plan_name = :2,
                is_archived = :3
            WHERE plan_id = :4
            """,
            [trainer_id, plan_name, is_archived, int(plan_id)],
            f"Workout plan {plan_id} was updated successfully.",
            "Workout plan not found.",
        )
    except Exception as error:
        return go_home(format_db_error(error), "error")


@app.post("/plans/delete")
def delete_plan():
    plan_id = request.form.get("plan_id", "").strip()

    if not plan_id:
        return go_home("Please choose a workout plan to delete.", "error")

    return run_write(
        "DELETE FROM WorkoutPlan WHERE plan_id = :1",
        [int(plan_id)],
        f"Workout plan {plan_id} was deleted successfully.",
        "Workout plan not found.",
    )


if __name__ == "__main__":
    app.run(debug=True)