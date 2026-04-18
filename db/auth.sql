-- ============================================================
-- Personal Training Database — Authentication Table
-- CS 4604, Dr. Nizamani, Spring 2026
-- Run AFTER create.sql
-- ============================================================
-- AppUser stores application login accounts independently
-- from the Trainer and Client business tables.
-- Passwords are stored as bcrypt hashes — never plaintext.
-- Roles: 'admin', 'trainer', 'client'
-- trainer_id / client_id link the login account to the
-- corresponding business record (nullable — admin has neither).
-- ============================================================

CREATE TABLE AppUser (
    user_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username      VARCHAR2(100)  NOT NULL UNIQUE,
    password_hash VARCHAR2(255)  NOT NULL,
    role          VARCHAR2(20)   NOT NULL,
    trainer_id    NUMBER,
    client_id     NUMBER,
    created_at    DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_appuser_trainer FOREIGN KEY (trainer_id)
        REFERENCES Trainer(trainer_id),
    CONSTRAINT fk_appuser_client FOREIGN KEY (client_id)
        REFERENCES Client(client_id),
    CONSTRAINT chk_appuser_role CHECK (role IN ('admin', 'trainer', 'client'))
);
