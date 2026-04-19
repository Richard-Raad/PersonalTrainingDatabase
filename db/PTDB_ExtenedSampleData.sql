-- ============================================================
-- Personal Training Database - Extended Sample Data
-- Run AFTER create.sql and sample_data.sql
-- Adds sessions + performance logs for clients missing data
-- ============================================================


-- ============================================================
-- SECTION 1: TYLER BROOKS (client_id=1)
-- Add logs to existing leg day (session 3 has no perf logs)
-- Then add one new push day session
-- ============================================================
DECLARE
    v_sid NUMBER;
    v_l1 NUMBER; v_l2 NUMBER; v_l3 NUMBER;
BEGIN
    -- Find Tyler's existing leg day session (plan_id=3)
    SELECT session_id INTO v_sid FROM WorkoutSession
    WHERE client_id = 1 AND plan_id = 3 AND ROWNUM = 1;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 8, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 9, NULL) RETURNING log_id INTO v_l3;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 245.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 245.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 4, 265.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 185.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 185.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 205.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 1, 'Working', 12, 270.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 2, 'Working', 12, 270.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 3, 'Working', 10, 315.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Tyler: new push day week 2
DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER; v_l3 NUMBER;
BEGIN
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (1, 1, DATE '2026-03-08', 75, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 10, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 14, NULL) RETURNING log_id INTO v_l3;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 190.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 190.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  6, 200.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Warm-up', 8, 65.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 8, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 8, 115.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 4, 'Working', 6, 125.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 1, 'Working', 12, 52.50, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 2, 'Working', 12, 52.50, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 3, 'Working', 10, 57.50, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 2: MEGAN FOSTER (client_id=2)
-- Fix session 5 (no logs), add one new session
-- ============================================================
DECLARE
    v_sid NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT session_id INTO v_sid FROM WorkoutSession
    WHERE client_id = 2 AND TRUNC(session_date) = DATE '2026-03-06';

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 1, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 65.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 120.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 120.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  8, 130.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 87.50, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 87.50, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 95.00,  8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Also fix Megan's missing Cable Row sets (log already exists from sample_data)
DECLARE
    v_log NUMBER;
BEGIN
    SELECT pl.log_id INTO v_log
    FROM PerformanceLog pl
    JOIN WorkoutSession ws ON pl.session_id = ws.session_id
    WHERE ws.client_id = 2 AND pl.exercise_id = 6 AND ROWNUM = 1;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_log, 1, 'Working', 12, 70.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_log, 2, 'Working', 12, 70.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_log, 3, 'Working', 10, 80.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Megan: new full body session week 3
DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER; v_l3 NUMBER;
BEGIN
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (2, 4, DATE '2026-03-09', 62, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1,  NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l3;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 65.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 125.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 135.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 90.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 92.50, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 97.50, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 1, 'Working', 12, 115.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 2, 'Working', 12, 135.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 3, 'Working', 10, 145.00, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 3: JORDAN HAYES (client_id=3)
-- 3 new sessions - currently has 0
-- ============================================================
DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER; v_l3 NUMBER;
BEGIN
    -- Session 1: Upper body (Mar 07)
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (3, NULL, DATE '2026-03-07', 68, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 5,  NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 10, NULL) RETURNING log_id INTO v_l3;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 165.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 165.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  6, 175.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 8, 0.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 7, 0.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 5, 0.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 1, 'Working', 8, 105.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 2, 'Working', 8, 105.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 3, 'Working', 6, 115.00, 9, NULL);

    -- Session 2: Lower body (Mar 11)
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (3, NULL, DATE '2026-03-11', 70, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 8, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 225.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 225.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 3, 245.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 175.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 185.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 195.00, 8, NULL);

    -- Session 3: Upper body week 2 (Mar 14)
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (3, NULL, DATE '2026-03-14', 65, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1,  'Bench +5lbs') RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 12, NULL)          RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 170.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 170.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  5, 180.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 70.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 72.50, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 80.00, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 4: AISHA THOMPSON (client_id=4)
-- Fix existing free session (no logs), add 2 more
-- ============================================================
DECLARE
    v_sid NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT session_id INTO v_sid FROM WorkoutSession
    WHERE client_id = 4 AND plan_id IS NULL AND ROWNUM = 1;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 16, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 12, 95.00,  7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 12, 105.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 115.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 95.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 135.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (4, NULL, DATE '2026-03-10', 52, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 10, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 6,  NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 8, 75.00,  7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 8, 80.00,  8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 6, 85.00,  9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 70.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 75.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 80.00, 7, NULL);

    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (4, NULL, DATE '2026-03-14', 55, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 10, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 125.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 135.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 115.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 135.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 145.00, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 5: LIAM NGUYEN (client_id=5) - 2 more sessions
-- ============================================================
DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER; v_l3 NUMBER;
BEGIN
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (5, 5, DATE '2026-03-08', 58, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 5,  NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 12, NULL) RETURNING log_id INTO v_l3;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 160.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 160.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  6, 170.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 7, 0.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 6, 0.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 5, 0.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 1, 'Working', 10, 67.50, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 2, 'Working', 10, 70.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l3, 3, 'Working',  8, 77.50, 8, NULL);

    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (5, NULL, DATE '2026-03-12', 60, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 9, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 6, 205.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 6, 215.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 4, 225.00, 9, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 250.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 270.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 290.00, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 6: RACHEL STONE (client_id=6)
-- Fix existing session (no logs), add 2 more
-- ============================================================
DECLARE
    v_sid NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT session_id INTO v_sid FROM WorkoutSession
    WHERE client_id = 6 AND ROWNUM = 1;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_sid, 1, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 95.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 95.00,  7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  8, 105.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 65.00, 5, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 65.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 75.00, 7, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (6, 6, DATE '2026-03-09', 50, NULL) RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 100.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 110.00, 8, NULL);

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 105.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 120.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 135.00, 8, NULL);

    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text)
    VALUES (6, 6, DATE '2026-03-14', 52, 'Squat PR - 115lbs!') RETURNING session_id INTO v_s;

    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, 'New PR') RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 8, NULL)      RETURNING log_id INTO v_l2;

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 110.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 110.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  6, 115.00, 9, 'PR');

    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 10, 105.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 10, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working',  8, 125.00, 8, NULL);
    COMMIT;
END;
/


-- ============================================================
-- SECTION 7: EXTENDED CLIENTS (email lookup, safe skip)
-- 2 sessions each for clients added via the UI
-- ============================================================

-- Helper macro pattern: each block is independent and silent on NO_DATA_FOUND

-- Noah Evans
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'nevans@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-09', 70, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 4, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 2, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 255.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 265.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 5, 215.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 5, 225.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-14', 68, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 185.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 190.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  5, 205.00, 9, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Olivia Bennett
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'obennett@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-10', 50, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 85.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 90.00,  7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 95.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 125.00, 7, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-15', 48, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 10, 60.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 65.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 70.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Parker Collins
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'pcollins@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-08', 75, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, 'Comp squat') RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 4, NULL)          RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 3, 265.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 3, 280.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 1, 295.00, 9, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Warm-up', 5, 135.00, 2, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 3, 295.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 3, 315.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-15', 72, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 3, 225.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 3, 235.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 1, 245.00, 9, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Quinn Rivera
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'qrivera@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-09', 55, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 5, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 175.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 180.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 8, 0.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 7, 0.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 5, 0.00, 9, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-13', 58, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 235.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 245.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Ryan Mitchell
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'rmitchell@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-11', 55, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 10, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 155.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 160.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 8, 100.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 8, 105.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 6, 110.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-16', 52, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 4, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 225.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 235.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Sophia Turner
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'sturner@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-10', 48, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 100.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 110.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 105.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 125.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 135.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-15', 50, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 10, 65.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 70.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 75.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Travis Ward
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'tward@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-09', 62, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 4, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 245.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 255.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working', 3, 275.00, 9, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 5, 225.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 5, 235.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-14', 60, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 175.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 180.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Victor Sanders, Wendy Price, Xander Hughes, Yara Flores, Zane Powell, Amy Griffin
-- (same pattern: 2 sessions, 1-2 exercises, 3 sets each)

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'vsanders@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-10', 55, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 165.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 170.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-15', 55, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 225.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 235.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'wprice@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-11', 45, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 12, 85.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 12, 100.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 115.00, 7, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-17', 48, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 85.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 95.00, 7, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'xhughes@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-09', 65, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 195.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 200.00, 8, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 4, 'Working',  5, 210.00, 9, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-16', 68, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 5, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 4, 265.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 4, 275.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'yflores@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-10', 45, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 12, 95.00,  5, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 12, 115.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 125.00, 7, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-15', 48, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 95.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 105.00, 7, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'zpowell@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-11', 60, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 95.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working',  8, 175.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 180.00, 8, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-17', 62, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 8, 135.00, 3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 5, 240.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 5, 250.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER; v_l2 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'agriffin@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-12', 50, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7,  NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 16, NULL) RETURNING log_id INTO v_l2;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Warm-up', 10, 45.00,  3, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 85.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 95.00,  7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 1, 'Working', 12, 95.00,  6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 2, 'Working', 12, 115.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l2, 3, 'Working', 10, 125.00, 7, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-17', 48, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 1, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 10, 70.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 10, 75.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working',  8, 80.00, 8, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Uma Peterson
DECLARE
    v_cid NUMBER; v_s NUMBER; v_l1 NUMBER;
BEGIN
    SELECT client_id INTO v_cid FROM Client WHERE email = 'upeterson@vt.edu';
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-12', 40, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 15, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 60, 0.00, 5, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 60, 0.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 45, 0.00, 7, NULL);
    INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES (v_cid, NULL, DATE '2026-03-17', 42, NULL) RETURNING session_id INTO v_s;
    INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (v_s, 7, NULL) RETURNING log_id INTO v_l1;
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 1, 'Working', 12, 65.00, 6, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 2, 'Working', 12, 75.00, 7, NULL);
    INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe, notes) VALUES (v_l1, 3, 'Working', 10, 85.00, 7, NULL);
    COMMIT;
EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
END;
/