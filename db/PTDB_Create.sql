-- ============================================================
-- Personal Training Database
-- CS 4604, Dr. Nizamani, Spring 2026
-- Richard Raad, Aiden Racelis, Vissu Manchem, Sid Jain
-- ============================================================
-- TABLE ORDER (respects FK dependencies):
--  1. Trainer
--  2. Gym
--  3. Client
--  4. TrainerGym
--  5. MuscleGroup
--  6. Exercise
--  7. WorkoutPlan
--  8. PlanExercise
--  9. PlanExerciseSet
-- 10. WorkoutSession
-- 11. PerformanceLog
-- 12. PerformanceLogSet
-- 13. BodyMetric
-- 14. Notification
-- ============================================================

-- ------------------------------------------------------------
-- 1. TRAINER
-- Fitness coaches who create workout plans and manage clients.
-- A trainer can be affiliated with multiple gyms.
-- ------------------------------------------------------------
CREATE TABLE Trainer (
    trainer_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR2(50)  NOT NULL,
    last_name    VARCHAR2(50)  NOT NULL,
    email        VARCHAR2(100) NOT NULL UNIQUE,
    bio          VARCHAR2(500),
    credentials  VARCHAR2(200),
    created_at   DATE DEFAULT SYSDATE NOT NULL
);

-- ------------------------------------------------------------
-- 2. GYM
-- Physical gym locations. Used for trainer discovery —
-- clients can search for trainers by gym.
-- ------------------------------------------------------------
CREATE TABLE Gym (
    gym_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gym_name  VARCHAR2(100) NOT NULL,
    street    VARCHAR2(150),
    city      VARCHAR2(100),
    state     VARCHAR2(50),
    zip       VARCHAR2(20)
);

-- ------------------------------------------------------------
-- 3. CLIENT
-- Users who track workouts. May be trainer-guided or
-- self-guided. At most one active trainer at a time.
-- home_gym_id and current_trainer_id are nullable —
-- not every client has a gym or trainer assigned.
-- ------------------------------------------------------------
CREATE TABLE Client (
    client_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name         VARCHAR2(50)  NOT NULL,
    last_name          VARCHAR2(50)  NOT NULL,
    email              VARCHAR2(100) NOT NULL UNIQUE,
    current_trainer_id NUMBER,
    home_gym_id        NUMBER,
    created_at         DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_client_trainer FOREIGN KEY (current_trainer_id)
        REFERENCES Trainer(trainer_id),
    CONSTRAINT fk_client_gym FOREIGN KEY (home_gym_id)
        REFERENCES Gym(gym_id)
);

-- ------------------------------------------------------------
-- 4. TRAINERGYM
-- Associative table for the many-to-many relationship
-- between Trainer and Gym. A trainer can work at multiple
-- gyms and each gym can have multiple trainers.
-- ------------------------------------------------------------
CREATE TABLE TrainerGym (
    trainer_id NUMBER NOT NULL,
    gym_id     NUMBER NOT NULL,
    CONSTRAINT pk_trainergym PRIMARY KEY (trainer_id, gym_id),
    CONSTRAINT fk_tg_trainer FOREIGN KEY (trainer_id)
        REFERENCES Trainer(trainer_id),
    CONSTRAINT fk_tg_gym FOREIGN KEY (gym_id)
        REFERENCES Gym(gym_id)
);

-- ------------------------------------------------------------
-- 5. MUSCLEGROUP
-- Reference table for muscle group classifications.
-- Used to categorize exercises consistently.
-- e.g. Chest, Back, Legs, Shoulders, Arms, Core
-- ------------------------------------------------------------
CREATE TABLE MuscleGroup (
    muscle_group_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    muscle_group_name VARCHAR2(100) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- 6. EXERCISE
-- Master list of reusable exercises. Each exercise targets
-- one primary muscle group. Equipment is stored as an
-- attribute (not a separate entity) per project design.
-- ------------------------------------------------------------
CREATE TABLE Exercise (
    exercise_id             NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    exercise_name           VARCHAR2(100) NOT NULL,
    equipment               VARCHAR2(100),
    primary_muscle_group_id NUMBER NOT NULL,
    description             VARCHAR2(500),
    CONSTRAINT fk_exercise_muscle FOREIGN KEY (primary_muscle_group_id)
        REFERENCES MuscleGroup(muscle_group_id)
);

-- ------------------------------------------------------------
-- 7. WORKOUTPLAN
-- A structured workout program assigned to a client.
-- trainer_id is nullable — self-guided clients create
-- their own plans with no trainer.
-- is_archived: 0 = active, 1 = archived (kept for history)
-- ------------------------------------------------------------
CREATE TABLE WorkoutPlan (
    plan_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id   NUMBER NOT NULL,
    trainer_id  NUMBER,
    plan_name   VARCHAR2(100) NOT NULL,
    is_archived NUMBER(1) DEFAULT 0 NOT NULL,
    created_at  DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_wp_client  FOREIGN KEY (client_id)
        REFERENCES Client(client_id),
    CONSTRAINT fk_wp_trainer FOREIGN KEY (trainer_id)
        REFERENCES Trainer(trainer_id),
    CONSTRAINT chk_wp_archived CHECK (is_archived IN (0, 1))
);

-- ------------------------------------------------------------
-- 8. PLANEXERCISE
-- Represents one exercise slot within a workout plan.
-- sequence_num defines the order of exercises in the plan.
-- Using a surrogate PK (plan_exercise_id) allows the same
-- exercise to appear multiple times in one plan.
-- UNIQUE on (plan_id, sequence_num) prevents ordering gaps.
-- ------------------------------------------------------------
CREATE TABLE PlanExercise (
    plan_exercise_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plan_id          NUMBER NOT NULL,
    exercise_id      NUMBER NOT NULL,
    sequence_num     NUMBER NOT NULL,
    notes            VARCHAR2(300),
    CONSTRAINT fk_pe_plan FOREIGN KEY (plan_id)
        REFERENCES WorkoutPlan(plan_id),
    CONSTRAINT fk_pe_exercise FOREIGN KEY (exercise_id)
        REFERENCES Exercise(exercise_id),
    CONSTRAINT uq_pe_sequence UNIQUE (plan_id, sequence_num)
);

-- ------------------------------------------------------------
-- 9. PLANEXERCISESET
-- Defines each individual set within a plan exercise slot.
-- This allows different set types (Warm-up, Working, Drop)
-- each with their own target reps, weight, and rest time.
-- e.g. Set 1: Warm-up 135lbs x 12, Set 2: Working 185lbs x 8
-- set_type enforced via CHECK constraint.
-- ------------------------------------------------------------
CREATE TABLE PlanExerciseSet (
    plan_set_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plan_exercise_id NUMBER NOT NULL,
    set_number       NUMBER NOT NULL,
    set_type         VARCHAR2(20) DEFAULT 'Working' NOT NULL,
    target_reps      NUMBER,
    target_weight    NUMBER(6,2),
    rest_seconds     NUMBER,
    CONSTRAINT fk_pes_planexercise FOREIGN KEY (plan_exercise_id)
        REFERENCES PlanExercise(plan_exercise_id),
    CONSTRAINT uq_pes_set UNIQUE (plan_exercise_id, set_number),
    CONSTRAINT chk_pes_type CHECK (
        set_type IN ('Warm-up', 'Working', 'Drop', 'Failure', 'Cooldown')
    )
);

-- ------------------------------------------------------------
-- 10. WORKOUTSESSION
-- A single real workout event performed by a client.
-- plan_id is nullable — clients can log free sessions
-- not tied to any plan.
-- feedback_text allows trainer comments on the session.
-- ------------------------------------------------------------
CREATE TABLE WorkoutSession (
    session_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id        NUMBER NOT NULL,
    plan_id          NUMBER,
    session_date     DATE NOT NULL,
    duration_minutes NUMBER,
    feedback_text    VARCHAR2(500),
    created_at       DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_ws_client FOREIGN KEY (client_id)
        REFERENCES Client(client_id),
    CONSTRAINT fk_ws_plan FOREIGN KEY (plan_id)
        REFERENCES WorkoutPlan(plan_id)
);

-- ------------------------------------------------------------
-- 11. PERFORMANCELOG
-- One record per exercise performed within a session.
-- Acts as the parent record for the actual sets logged.
-- Mirrors the PlanExercise structure for easy comparison
-- between planned vs actual performance.
-- ------------------------------------------------------------
CREATE TABLE PerformanceLog (
    log_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    session_id  NUMBER NOT NULL,
    exercise_id NUMBER NOT NULL,
    notes       VARCHAR2(300),
    CONSTRAINT fk_pl_session FOREIGN KEY (session_id)
        REFERENCES WorkoutSession(session_id),
    CONSTRAINT fk_pl_exercise FOREIGN KEY (exercise_id)
        REFERENCES Exercise(exercise_id)
);

-- ------------------------------------------------------------
-- 12. PERFORMANCELOGSET
-- One record per actual set performed during a session.
-- Mirrors PlanExerciseSet so planned vs actual can be
-- directly compared (e.g. planned 185lbs x 8, did 175lbs x 7).
-- rpe = Rate of Perceived Exertion (1-10 scale).
-- ------------------------------------------------------------
CREATE TABLE PerformanceLogSet (
    perf_set_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    log_id         NUMBER NOT NULL,
    set_number     NUMBER NOT NULL,
    set_type       VARCHAR2(20) DEFAULT 'Working' NOT NULL,
    reps_completed NUMBER,
    weight_used    NUMBER(6,2),
    rpe            NUMBER(3,1),
    notes          VARCHAR2(300),
    CONSTRAINT fk_pls_log FOREIGN KEY (log_id)
        REFERENCES PerformanceLog(log_id),
    CONSTRAINT uq_pls_set UNIQUE (log_id, set_number),
    CONSTRAINT chk_pls_type CHECK (
        set_type IN ('Warm-up', 'Working', 'Drop', 'Failure', 'Cooldown')
    ),
    CONSTRAINT chk_pls_rpe CHECK (rpe BETWEEN 1 AND 10)
);

-- ------------------------------------------------------------
-- 13. BODYMETRIC
-- Body measurement records for a client over time.
-- Supports long-term progress tracking beyond just lifts.
-- All measurement fields nullable — clients log what they track.
-- ------------------------------------------------------------
CREATE TABLE BodyMetric (
    metric_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id        NUMBER NOT NULL,
    recorded_at      DATE NOT NULL,
    body_weight      NUMBER(5,2),
    body_fat_percent NUMBER(4,2),
    waist_in         NUMBER(4,2),
    chest_in         NUMBER(4,2),
    notes            VARCHAR2(300),
    CONSTRAINT fk_bm_client FOREIGN KEY (client_id)
        REFERENCES Client(client_id)
);

-- ------------------------------------------------------------
-- 14. NOTIFICATION
-- System alerts delivered to a client or trainer.
-- Either recipient_client_id or recipient_trainer_id must
-- be set, OR is_broadcast = 1 for system-wide notifications.
-- is_read: 0 = unread, 1 = read
-- ------------------------------------------------------------
CREATE TABLE Notification (
    notification_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipient_client_id  NUMBER,
    recipient_trainer_id NUMBER,
    is_broadcast         NUMBER(1) DEFAULT 0 NOT NULL,
    title                VARCHAR2(150) NOT NULL,
    message              VARCHAR2(500),
    created_at           DATE DEFAULT SYSDATE NOT NULL,
    is_read              NUMBER(1) DEFAULT 0 NOT NULL,
    CONSTRAINT fk_notif_client FOREIGN KEY (recipient_client_id)
        REFERENCES Client(client_id),
    CONSTRAINT fk_notif_trainer FOREIGN KEY (recipient_trainer_id)
        REFERENCES Trainer(trainer_id),
    CONSTRAINT chk_notif_recipient CHECK (
        recipient_client_id IS NOT NULL OR
        recipient_trainer_id IS NOT NULL OR
        is_broadcast = 1
    ),
    CONSTRAINT chk_notif_read CHECK (is_read IN (0, 1)),
    CONSTRAINT chk_notif_broadcast CHECK (is_broadcast IN (0, 1))
);