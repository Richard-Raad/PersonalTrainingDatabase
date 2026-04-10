-- ============================================================
-- Personal Training Database - Sample Data
-- CS 4604, Dr. Nizamani, Spring 2026
-- Richard Raad, Aiden Racelis, Vissu Manchem, Sid Jain
-- ============================================================
-- Run after CREATE TABLE script.
-- Insert order respects FK dependencies.
-- ============================================================


-- ------------------------------------------------------------
-- 1. TRAINER (5 rows)
-- Fitness coaches in the Blacksburg/VT area
-- ------------------------------------------------------------
INSERT INTO Trainer (first_name, last_name, email, bio, credentials) VALUES
    ('Marcus', 'Johnson', 'mjohnson@vtfit.com',
     'Specializes in strength and powerlifting. 8 years coaching experience.',
     'NSCA-CSCS, CPT');

INSERT INTO Trainer (first_name, last_name, email, bio, credentials) VALUES
    ('Sara', 'Kim', 'skim@vtfit.com',
     'Focuses on hypertrophy and body recomposition for college athletes.',
     'NASM-CPT, CES');

INSERT INTO Trainer (first_name, last_name, email, bio, credentials) VALUES
    ('Derek', 'Williams', 'dwilliams@vtfit.com',
     'Former VT football player. Specializes in athletic performance and HIIT.',
     'ACE-CPT, PES');

INSERT INTO Trainer (first_name, last_name, email, bio, credentials) VALUES
    ('Priya', 'Patel', 'ppatel@vtfit.com',
     'Yoga and mobility specialist with a background in physical therapy.',
     'RYT-200, NASM-CPT');

INSERT INTO Trainer (first_name, last_name, email, bio, credentials) VALUES
    ('James', 'Carter', 'jcarter@vtfit.com',
     'Endurance and functional fitness coach. Runs the VT triathlon club.',
     'USAT-L1, ACE-CPT');


-- ------------------------------------------------------------
-- 2. GYM (5 rows)
-- Real gyms in the Blacksburg/VT area
-- ------------------------------------------------------------
INSERT INTO Gym (gym_name, street, city, state, zip) VALUES
    ('War Memorial Hall', '176 McComas Hall', 'Blacksburg', 'VA', '24061');

INSERT INTO Gym (gym_name, street, city, state, zip) VALUES
    ('McComas Hall Fitness Center', '201 McComas Hall', 'Blacksburg', 'VA', '24061');

INSERT INTO Gym (gym_name, street, city, state, zip) VALUES
    ('The Weight Club', '1100 N Main St', 'Blacksburg', 'VA', '24060');

INSERT INTO Gym (gym_name, street, city, state, zip) VALUES
    ('Blacksburg Rec Center', '725 Patrick Henry Dr', 'Blacksburg', 'VA', '24060');

INSERT INTO Gym (gym_name, street, city, state, zip) VALUES
    ('Iron Paradise Gym', '3012 S Main St', 'Blacksburg', 'VA', '24060');


-- ------------------------------------------------------------
-- 3. CLIENT (6 rows)
-- Mix of trainer-guided and self-guided clients
-- Trainer IDs: Marcus=1, Sara=2, Derek=3, Priya=4, James=5
-- Gym IDs: War Memorial=1, McComas=2, Weight Club=3, Rec=4, Iron=5
-- ------------------------------------------------------------
INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Tyler', 'Brooks', 'tbrooks@vt.edu', 1, 3);

INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Megan', 'Foster', 'mfoster@vt.edu', 2, 2);

INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Jordan', 'Hayes', 'jhayes@vt.edu', 1, 3);

INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Aisha', 'Thompson', 'athompson@vt.edu', 3, 1);

INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Liam', 'Nguyen', 'lnguyen@vt.edu', NULL, 4);

INSERT INTO Client (first_name, last_name, email, current_trainer_id, home_gym_id) VALUES
    ('Rachel', 'Stone', 'rstone@vt.edu', NULL, 2);


-- ------------------------------------------------------------
-- 4. TRAINERGYM (6 rows)
-- Which trainers work at which gyms
-- ------------------------------------------------------------
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (1, 3);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (1, 5);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (2, 2);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (2, 1);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (3, 1);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (4, 4);
INSERT INTO TrainerGym (trainer_id, gym_id) VALUES (5, 4);


-- ------------------------------------------------------------
-- 5. MUSCLEGROUP (8 rows)
-- Standard muscle group classifications
-- ------------------------------------------------------------
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Chest');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Back');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Legs');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Shoulders');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Biceps');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Triceps');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Core');
INSERT INTO MuscleGroup (muscle_group_name) VALUES ('Glutes');


-- ------------------------------------------------------------
-- 6. EXERCISE (16 rows)
-- Common exercises organized by muscle group
-- MuscleGroup IDs: Chest=1, Back=2, Legs=3, Shoulders=4,
--                  Biceps=5, Triceps=6, Core=7, Glutes=8
-- ------------------------------------------------------------

-- Chest
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Barbell Bench Press', 'Barbell, Bench', 1,
     'Lie on bench, lower barbell to chest and press up. Primary chest compound movement.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Incline Dumbbell Press', 'Dumbbells, Incline Bench', 1,
     'Incline bench press with dumbbells targeting upper chest.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Cable Fly', 'Cable Machine', 1,
     'Standing cable fly for chest isolation and stretch.');

-- Back
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Barbell Deadlift', 'Barbell', 2,
     'Hip hinge movement lifting barbell from floor. King of back exercises.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Pull-Up', 'Pull-Up Bar', 2,
     'Bodyweight vertical pull. Targets lats and upper back.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Seated Cable Row', 'Cable Machine', 2,
     'Horizontal pull targeting mid-back and lats.');

-- Legs
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Barbell Back Squat', 'Barbell, Squat Rack', 3,
     'Foundational lower body compound movement targeting quads, hamstrings, and glutes.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Romanian Deadlift', 'Barbell', 3,
     'Hip hinge movement emphasizing hamstrings and glutes.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Leg Press', 'Leg Press Machine', 3,
     'Machine-based quad-dominant pressing movement.');

-- Shoulders
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Overhead Press', 'Barbell', 4,
     'Standing barbell press overhead. Primary shoulder compound movement.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Lateral Raise', 'Dumbbells', 4,
     'Dumbbell lateral raise for side deltoid isolation.');

-- Biceps
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Barbell Curl', 'Barbell', 5,
     'Standing barbell curl for bicep mass.');

INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Hammer Curl', 'Dumbbells', 5,
     'Neutral grip dumbbell curl targeting biceps and brachialis.');

-- Triceps
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Tricep Pushdown', 'Cable Machine', 6,
     'Cable pushdown for tricep isolation.');

-- Core
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Plank', 'Bodyweight', 7,
     'Isometric core hold. Builds stability and endurance.');

-- Glutes
INSERT INTO Exercise (exercise_name, equipment, primary_muscle_group_id, description) VALUES
    ('Hip Thrust', 'Barbell, Bench', 8,
     'Barbell hip thrust for glute isolation and strength.');


-- ------------------------------------------------------------
-- 7. WORKOUTPLAN (6 rows)
-- Push/Pull/Legs split for trainer-guided clients,
-- plus self-guided plans for Liam and Rachel
-- Client IDs: Tyler=1, Megan=2, Jordan=3, Aisha=4, Liam=5, Rachel=6
-- Trainer IDs: Marcus=1, Sara=2, Derek=3
-- ------------------------------------------------------------

-- Tyler's Push Day (trainer: Marcus)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (1, 1, 'Tyler - Push Day', 0);

-- Tyler's Pull Day (trainer: Marcus)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (1, 1, 'Tyler - Pull Day', 0);

-- Tyler's Leg Day (trainer: Marcus)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (1, 1, 'Tyler - Leg Day', 0);

-- Megan's Full Body Hypertrophy (trainer: Sara)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (2, 2, 'Megan - Full Body Hypertrophy', 0);

-- Liam's self-guided Upper Body plan (no trainer)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (5, NULL, 'Liam - Self Upper Body', 0);

-- Rachel's self-guided Full Body plan (no trainer)
INSERT INTO WorkoutPlan (client_id, trainer_id, plan_name, is_archived) VALUES
    (6, NULL, 'Rachel - Self Full Body', 0);


-- ------------------------------------------------------------
-- 8. PLANEXERCISE (14 rows)
-- Exercise slots within each plan, ordered by sequence_num
-- Plan IDs: Tyler Push=1, Tyler Pull=2, Tyler Legs=3,
--           Megan Full=4, Liam Upper=5, Rachel Full=6
-- Exercise IDs: BenchPress=1, InclineDB=2, CableFly=3,
--   Deadlift=4, PullUp=5, CableRow=6, Squat=7, RDL=8,
--   LegPress=9, OHP=10, LateralRaise=11, BarbellCurl=12,
--   HammerCurl=13, TricepPushdown=14, Plank=15, HipThrust=16
-- ------------------------------------------------------------

-- Push Day (Plan 1): Bench, Incline DB, Cable Fly, OHP, Lateral Raise, Tricep Pushdown
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 1, 1, 'Primary chest compound - focus on full range of motion');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 2, 2, 'Upper chest emphasis');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 3, 3, 'Chest finisher - feel the stretch');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 10, 4, 'Shoulder compound');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 11, 5, 'Side delt isolation');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (1, 14, 6, 'Tricep finisher');

-- Pull Day (Plan 2): Deadlift, Pull-Up, Cable Row, Barbell Curl, Hammer Curl
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (2, 4, 1, 'Primary back compound - brace your core');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (2, 5, 2, 'Vertical pull - full hang at bottom');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (2, 6, 3, 'Mid back focus');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (2, 12, 4, 'Bicep mass builder');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (2, 13, 5, 'Brachialis emphasis');

-- Leg Day (Plan 3): Squat, RDL, Leg Press, Hip Thrust, Plank
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (3, 7, 1, 'Primary quad compound - hit depth');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (3, 8, 2, 'Hamstring focus - slow eccentric');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (3, 9, 3, 'Quad volume work');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (3, 16, 4, 'Glute finisher');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (3, 15, 5, 'Core stability - hold tight');

-- Megan Full Body (Plan 4): Squat, Bench, Cable Row, OHP, Plank
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (4, 7, 1, 'Legs first while fresh');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (4, 1, 2, 'Upper push compound');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (4, 6, 3, 'Upper pull compound');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (4, 10, 4, 'Shoulder strength');
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (4, 15, 5, 'Core finisher');

-- Liam Self Upper (Plan 5): Bench, Pull-Up, OHP, Barbell Curl, Tricep Pushdown
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (5, 1, 1, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (5, 5, 2, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (5, 10, 3, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (5, 12, 4, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (5, 14, 5, NULL);

-- Rachel Self Full Body (Plan 6): Squat, Bench, Cable Row, Hip Thrust, Plank
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (6, 7, 1, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (6, 1, 2, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (6, 6, 3, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (6, 16, 4, NULL);
INSERT INTO PlanExercise (plan_id, exercise_id, sequence_num, notes) VALUES
    (6, 15, 5, NULL);


-- ------------------------------------------------------------
-- 9. PLANEXERCISESET
-- Planned sets for each exercise slot.
-- Demonstrates warm-up + working sets with progressive
-- overload, and drop sets where appropriate.
-- PlanExercise IDs follow insertion order (1-based):
--   Push Day: BenchPress=1, InclineDB=2, CableFly=3, OHP=4, LateralRaise=5, TricepPD=6
--   Pull Day: Deadlift=7, PullUp=8, CableRow=9, BBCurl=10, HammerCurl=11
--   Leg Day:  Squat=12, RDL=13, LegPress=14, HipThrust=15, Plank=16
--   Megan:    Squat=17, Bench=18, CableRow=19, OHP=20, Plank=21
--   Liam:     Bench=22, PullUp=23, OHP=24, BBCurl=25, TricepPD=26
--   Rachel:   Squat=27, Bench=28, CableRow=29, HipThrust=30, Plank=31
-- ------------------------------------------------------------

-- Push Day - Bench Press (plan_exercise_id=1): Warm-up + 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (1, 1, 'Warm-up', 10, 95.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (1, 2, 'Working', 8, 185.00, 180);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (1, 3, 'Working', 8, 185.00, 180);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (1, 4, 'Working', 6, 195.00, 180);

-- Push Day - Incline DB Press (plan_exercise_id=2): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (2, 1, 'Working', 10, 65.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (2, 2, 'Working', 10, 65.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (2, 3, 'Working', 8, 70.00, 120);

-- Push Day - Cable Fly (plan_exercise_id=3): 3 working + 1 drop set
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (3, 1, 'Working', 12, 40.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (3, 2, 'Working', 12, 40.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (3, 3, 'Working', 12, 40.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (3, 4, 'Drop', 15, 25.00, 60);

-- Push Day - OHP (plan_exercise_id=4): Warm-up + 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (4, 1, 'Warm-up', 8, 65.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (4, 2, 'Working', 8, 115.00, 150);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (4, 3, 'Working', 8, 115.00, 150);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (4, 4, 'Working', 6, 125.00, 150);

-- Push Day - Lateral Raise (plan_exercise_id=5): 4 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (5, 1, 'Working', 15, 20.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (5, 2, 'Working', 15, 20.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (5, 3, 'Working', 15, 20.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (5, 4, 'Drop', 20, 12.00, 45);

-- Push Day - Tricep Pushdown (plan_exercise_id=6): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (6, 1, 'Working', 12, 50.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (6, 2, 'Working', 12, 50.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (6, 3, 'Working', 10, 55.00, 75);

-- Pull Day - Deadlift (plan_exercise_id=7): Warm-up + 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (7, 1, 'Warm-up', 5, 135.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (7, 2, 'Working', 5, 275.00, 240);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (7, 3, 'Working', 5, 275.00, 240);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (7, 4, 'Working', 3, 295.00, 240);

-- Pull Day - Pull-Up (plan_exercise_id=8): 4 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (8, 1, 'Working', 8, 0.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (8, 2, 'Working', 8, 0.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (8, 3, 'Working', 6, 0.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (8, 4, 'Failure', 0, 0.00, 120);

-- Pull Day - Cable Row (plan_exercise_id=9): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (9, 1, 'Working', 10, 120.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (9, 2, 'Working', 10, 120.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (9, 3, 'Working', 8, 130.00, 90);

-- Pull Day - Barbell Curl (plan_exercise_id=10): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (10, 1, 'Working', 10, 75.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (10, 2, 'Working', 10, 75.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (10, 3, 'Working', 8, 85.00, 75);

-- Pull Day - Hammer Curl (plan_exercise_id=11): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (11, 1, 'Working', 12, 35.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (11, 2, 'Working', 12, 35.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (11, 3, 'Working', 10, 40.00, 60);

-- Leg Day - Squat (plan_exercise_id=12): Warm-up + 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (12, 1, 'Warm-up', 8, 135.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (12, 2, 'Working', 5, 245.00, 210);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (12, 3, 'Working', 5, 245.00, 210);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (12, 4, 'Working', 3, 265.00, 210);

-- Leg Day - RDL (plan_exercise_id=13): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (13, 1, 'Working', 10, 185.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (13, 2, 'Working', 10, 185.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (13, 3, 'Working', 8, 205.00, 120);

-- Leg Day - Leg Press (plan_exercise_id=14): 3 working + 1 drop set
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (14, 1, 'Working', 12, 270.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (14, 2, 'Working', 12, 270.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (14, 3, 'Working', 10, 315.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (14, 4, 'Drop', 15, 180.00, 60);

-- Leg Day - Hip Thrust (plan_exercise_id=15): 3 working sets
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (15, 1, 'Working', 12, 135.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (15, 2, 'Working', 12, 155.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (15, 3, 'Working', 10, 175.00, 90);

-- Leg Day - Plank (plan_exercise_id=16): 3 cooldown sets (target_weight=0, reps=seconds held)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (16, 1, 'Cooldown', 60, 0.00, 45);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (16, 2, 'Cooldown', 60, 0.00, 45);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (16, 3, 'Cooldown', 45, 0.00, 45);

-- Megan Full Body - Squat (plan_exercise_id=17)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (17, 1, 'Warm-up', 10, 65.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (17, 2, 'Working', 10, 115.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (17, 3, 'Working', 10, 115.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (17, 4, 'Working', 8, 125.00, 120);

-- Megan Full Body - Bench (plan_exercise_id=18)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (18, 1, 'Working', 10, 85.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (18, 2, 'Working', 10, 85.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (18, 3, 'Working', 8, 95.00, 90);

-- Megan Full Body - Cable Row (plan_exercise_id=19)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (19, 1, 'Working', 12, 70.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (19, 2, 'Working', 12, 70.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (19, 3, 'Working', 10, 80.00, 75);

-- Megan Full Body - OHP (plan_exercise_id=20)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (20, 1, 'Working', 10, 55.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (20, 2, 'Working', 10, 55.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (20, 3, 'Working', 8, 65.00, 90);

-- Megan Full Body - Plank (plan_exercise_id=21)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (21, 1, 'Cooldown', 45, 0.00, 30);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (21, 2, 'Cooldown', 45, 0.00, 30);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (21, 3, 'Cooldown', 30, 0.00, 30);

-- Liam Self Upper - Bench (plan_exercise_id=22)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (22, 1, 'Warm-up', 10, 95.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (22, 2, 'Working', 8, 155.00, 150);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (22, 3, 'Working', 8, 155.00, 150);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (22, 4, 'Working', 6, 165.00, 150);

-- Liam Self Upper - Pull-Up (plan_exercise_id=23)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (23, 1, 'Working', 6, 0.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (23, 2, 'Working', 6, 0.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (23, 3, 'Working', 5, 0.00, 120);

-- Liam Self Upper - OHP (plan_exercise_id=24)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (24, 1, 'Working', 8, 95.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (24, 2, 'Working', 8, 95.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (24, 3, 'Working', 6, 105.00, 120);

-- Liam Self Upper - Barbell Curl (plan_exercise_id=25)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (25, 1, 'Working', 10, 65.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (25, 2, 'Working', 10, 65.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (25, 3, 'Working', 8, 75.00, 60);

-- Liam Self Upper - Tricep Pushdown (plan_exercise_id=26)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (26, 1, 'Working', 12, 45.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (26, 2, 'Working', 12, 45.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (26, 3, 'Working', 10, 50.00, 60);

-- Rachel Self Full Body - Squat (plan_exercise_id=27)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (27, 1, 'Warm-up', 10, 45.00, 60);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (27, 2, 'Working', 10, 95.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (27, 3, 'Working', 10, 95.00, 120);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (27, 4, 'Working', 8, 105.00, 120);

-- Rachel Self Full Body - Bench (plan_exercise_id=28)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (28, 1, 'Working', 10, 65.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (28, 2, 'Working', 10, 65.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (28, 3, 'Working', 8, 75.00, 90);

-- Rachel Self Full Body - Cable Row (plan_exercise_id=29)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (29, 1, 'Working', 12, 55.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (29, 2, 'Working', 12, 55.00, 75);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (29, 3, 'Working', 10, 65.00, 75);

-- Rachel Self Full Body - Hip Thrust (plan_exercise_id=30)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (30, 1, 'Working', 12, 95.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (30, 2, 'Working', 12, 115.00, 90);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (30, 3, 'Working', 10, 135.00, 90);

-- Rachel Self Full Body - Plank (plan_exercise_id=31)
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (31, 1, 'Cooldown', 45, 0.00, 30);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (31, 2, 'Cooldown', 45, 0.00, 30);
INSERT INTO PlanExerciseSet (plan_exercise_id, set_number, set_type, target_reps, target_weight, rest_seconds) VALUES (31, 3, 'Cooldown', 30, 0.00, 30);


-- ------------------------------------------------------------
-- 10. WORKOUTSESSION (8 rows)
-- Actual workout events performed by clients
-- Client IDs: Tyler=1, Megan=2, Jordan=3, Aisha=4, Liam=5, Rachel=6
-- Plan IDs: Tyler Push=1, Tyler Pull=2, Tyler Legs=3, Megan=4, Liam=5, Rachel=6
-- ------------------------------------------------------------
INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (1, 1, DATE '2026-03-01', 75, NULL);

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (1, 2, DATE '2026-03-03', 70, 'Great deadlift session. Increase weight next week.');

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (1, 3, DATE '2026-03-05', 80, 'Solid squat depth. Keep working on ankle mobility.');

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (2, 4, DATE '2026-03-02', 60, 'Good form on squats. Ready to increase load next session.');

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (2, 4, DATE '2026-03-06', 65, NULL);

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (5, 5, DATE '2026-03-04', 55, NULL);

INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (6, 6, DATE '2026-03-05', 50, NULL);

-- Free session - Aisha not following a plan
INSERT INTO WorkoutSession (client_id, plan_id, session_date, duration_minutes, feedback_text) VALUES
    (4, NULL, DATE '2026-03-07', 45, NULL);


-- ------------------------------------------------------------
-- 11. PERFORMANCELOG (10 rows)
-- One record per exercise performed in a session
-- Session IDs follow insertion order (1-8)
-- ------------------------------------------------------------

-- Tyler Push Day session (session_id=1): Bench, OHP, Tricep Pushdown
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (1, 1, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (1, 10, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (1, 14, NULL);

-- Tyler Pull Day session (session_id=2): Deadlift, Pull-Up, Cable Row
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (2, 4, 'Felt strong today');
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (2, 5, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (2, 6, NULL);

-- Megan Full Body session 1 (session_id=4): Squat, Bench, Cable Row
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (4, 7, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (4, 1, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (4, 6, NULL);

-- Liam Upper session (session_id=6): Bench, Pull-Up
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (6, 1, NULL);
INSERT INTO PerformanceLog (session_id, exercise_id, notes) VALUES (6, 5, NULL);


-- ------------------------------------------------------------
-- 12. PERFORMANCELOGSET
-- Actual sets performed - mirrors plan but shows real results
-- Log IDs follow insertion order (1-11)
-- ------------------------------------------------------------

-- Tyler Bench Press (log_id=1): Hit planned numbers
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (1, 1, 'Warm-up', 10, 95.00, 3);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (1, 2, 'Working', 8, 185.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (1, 3, 'Working', 8, 185.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (1, 4, 'Working', 5, 195.00, 9);

-- Tyler OHP (log_id=2): Slightly under on last set
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (2, 1, 'Warm-up', 8, 65.00, 3);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (2, 2, 'Working', 8, 115.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (2, 3, 'Working', 7, 115.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (2, 4, 'Working', 5, 125.00, 10);

-- Tyler Tricep Pushdown (log_id=3)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (3, 1, 'Working', 12, 50.00, 6);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (3, 2, 'Working', 12, 50.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (3, 3, 'Working', 10, 55.00, 8);

-- Tyler Deadlift (log_id=4): PR on last set
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (4, 1, 'Warm-up', 5, 135.00, 2);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (4, 2, 'Working', 5, 275.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (4, 3, 'Working', 5, 275.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (4, 4, 'Working', 4, 295.00, 9);

-- Tyler Pull-Up (log_id=5)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (5, 1, 'Working', 9, 0.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (5, 2, 'Working', 8, 0.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (5, 3, 'Working', 6, 0.00, 9);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (5, 4, 'Failure', 5, 0.00, 10);

-- Tyler Cable Row (log_id=6)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (6, 1, 'Working', 10, 120.00, 6);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (6, 2, 'Working', 10, 120.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (6, 3, 'Working', 9, 130.00, 8);

-- Megan Squat (log_id=7)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (7, 1, 'Warm-up', 10, 65.00, 3);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (7, 2, 'Working', 10, 115.00, 6);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (7, 3, 'Working', 10, 115.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (7, 4, 'Working', 8, 125.00, 8);

-- Megan Bench (log_id=8)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (8, 1, 'Working', 10, 85.00, 6);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (8, 2, 'Working', 10, 85.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (8, 3, 'Working', 8, 95.00, 8);

-- Liam Bench (log_id=10)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (10, 1, 'Warm-up', 10, 95.00, 3);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (10, 2, 'Working', 8, 155.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (10, 3, 'Working', 7, 155.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (10, 4, 'Working', 6, 165.00, 9);

-- Liam Pull-Up (log_id=11)
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (11, 1, 'Working', 6, 0.00, 7);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (11, 2, 'Working', 5, 0.00, 8);
INSERT INTO PerformanceLogSet (log_id, set_number, set_type, reps_completed, weight_used, rpe) VALUES (11, 3, 'Working', 4, 0.00, 9);


-- ------------------------------------------------------------
-- 13. BODYMETRIC (8 rows)
-- Body measurements over time for multiple clients
-- ------------------------------------------------------------
INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (1, DATE '2026-01-15', 185.5, 14.2, 33.0, 42.0, 'Starting measurements');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (1, DATE '2026-02-15', 187.0, 13.8, 32.5, 42.5, 'Good progress on recomp');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (1, DATE '2026-03-15', 188.5, 13.1, 32.0, 43.0, 'Strength and size improving');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (2, DATE '2026-01-20', 138.0, 22.5, 27.5, 36.0, 'Baseline check-in');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (2, DATE '2026-02-20', 137.5, 21.8, 27.0, 36.5, 'Slight fat loss, muscle gain');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (3, DATE '2026-02-01', 195.0, 16.5, 34.5, 43.5, NULL);

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (5, DATE '2026-02-10', 172.0, 18.0, 32.0, 40.0, 'Self-tracked baseline');

INSERT INTO BodyMetric (client_id, recorded_at, body_weight, body_fat_percent, waist_in, chest_in, notes) VALUES
    (5, DATE '2026-03-10', 173.5, 17.2, 31.5, 40.5, 'Slow bulk going well');


-- ------------------------------------------------------------
-- 14. NOTIFICATION (7 rows)
-- Mix of trainer feedback alerts, plan updates, and broadcast
-- ------------------------------------------------------------

-- Trainer Marcus sends feedback to Tyler after pull day
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (1, NULL, 0,
     'Feedback on Pull Day Session',
     'Great deadlift numbers today Tyler. You are ready to add 10lbs next session. Keep the back flat on the way up.',
     0);

-- Trainer Marcus sends feedback to Tyler after leg day
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (1, NULL, 0,
     'Leg Day Notes',
     'Squat depth is improving. Focus on ankle mobility before next session. Try 2 min of calf stretching.',
     0);

-- Trainer Sara sends feedback to Megan
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (2, NULL, 0,
     'Ready to Progress on Squats',
     'Your squat form looked solid this week. We are bumping the working weight to 125lbs next session.',
     1);

-- Plan update notification to Tyler
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (1, NULL, 0,
     'Workout Plan Updated',
     'Marcus has updated your Push Day plan. Check the new cable fly drop set added at the end.',
     1);

-- Notification sent to a trainer (Marcus gets a new client request)
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (NULL, 1, 0,
     'New Client Request',
     'A new client has requested to work with you. Log in to review and accept.',
     0);

-- Notification to Jordan from trainer Marcus
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (3, NULL, 0,
     'Reminder: Leg Day Tomorrow',
     'Do not forget your leg day session tomorrow. Make sure to get 8 hours of sleep tonight.',
     0);

-- Broadcast notification to everyone (system-wide)
INSERT INTO Notification (recipient_client_id, recipient_trainer_id, is_broadcast, title, message, is_read) VALUES
    (NULL, NULL, 1,
     'System Maintenance Notice',
     'The platform will be down for scheduled maintenance on Sunday March 22 from 2am to 4am EST.',
     0);