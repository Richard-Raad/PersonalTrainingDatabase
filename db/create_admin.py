"""
create_admin.py
---------------
Run this ONCE after create.sql, sample_data.sql, and auth.sql
to seed the initial admin account and sample user accounts.

Usage:
    python create_admin.py

Requires: pip install bcrypt python-oracledb python-dotenv
"""

import os
import bcrypt
import oracledb
from dotenv import load_dotenv

load_dotenv()

ORACLE_CLIENT_DIR = os.path.expanduser(os.getenv("ORACLE_CLIENT_DIR"))
DB_USER = "RICHARDTRAAD_SCHEMA_3RVCI"
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_DSN = "db.freesql.com:1521/23ai_34ui2"

oracledb.init_oracle_client(lib_dir=ORACLE_CLIENT_DIR)
conn = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
cur = conn.cursor()


def make_hash(plain_password: str) -> str:
    return bcrypt.hashpw(plain_password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def insert_user(username, password, role, trainer_id=None, client_id=None):
    try:
        cur.execute(
            """
            INSERT INTO AppUser (username, password_hash, role, trainer_id, client_id)
            VALUES (:1, :2, :3, :4, :5)
            """,
            [username, make_hash(password), role, trainer_id, client_id],
        )
        print(f"  Created {role:8s}  username={username!r}  password={password!r}")
    except Exception as e:
        print(f"  SKIP {username!r}: {e}")


print("Creating users...")

# ── Admin ──────────────────────────────────────────────────────────────────
# No trainer_id or client_id — admin manages the system, not a profile
insert_user("admin",   "admin123",   "admin")

# ── Trainer accounts (trainer_id values from your sample_data.sql) ─────────
# Marcus Johnson = trainer_id 1, Sara Kim = 2, Derek Williams = 3
insert_user("marcus",  "trainer123", "trainer", trainer_id=1)
insert_user("sara",    "trainer123", "trainer", trainer_id=2)
insert_user("derek",   "trainer123", "trainer", trainer_id=3)

# ── Client accounts (client_id values from your sample_data.sql) ──────────
# Tyler Brooks = 1, Megan Foster = 2, Jordan Hayes = 3
insert_user("tyler",   "client123",  "client",  client_id=1)
insert_user("megan",   "client123",  "client",  client_id=2)
insert_user("jordan",  "client123",  "client",  client_id=3)

conn.commit()
cur.close()
conn.close()

print("\nDone. IMPORTANT: change all default passwords before any real use.")