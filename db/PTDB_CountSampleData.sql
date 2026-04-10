-- Check row counts for every table
SELECT 'Trainer' AS tbl, COUNT(*) AS cnt FROM Trainer UNION ALL
SELECT 'Gym',              COUNT(*) FROM Gym UNION ALL
SELECT 'Client',           COUNT(*) FROM Client UNION ALL
SELECT 'TrainerGym',       COUNT(*) FROM TrainerGym UNION ALL
SELECT 'MuscleGroup',      COUNT(*) FROM MuscleGroup UNION ALL
SELECT 'Exercise',         COUNT(*) FROM Exercise UNION ALL
SELECT 'WorkoutPlan',      COUNT(*) FROM WorkoutPlan UNION ALL
SELECT 'PlanExercise',     COUNT(*) FROM PlanExercise UNION ALL
SELECT 'PlanExerciseSet',  COUNT(*) FROM PlanExerciseSet UNION ALL
SELECT 'WorkoutSession',   COUNT(*) FROM WorkoutSession UNION ALL
SELECT 'PerformanceLog',   COUNT(*) FROM PerformanceLog UNION ALL
SELECT 'PerformanceLogSet',COUNT(*) FROM PerformanceLogSet UNION ALL
SELECT 'BodyMetric',       COUNT(*) FROM BodyMetric UNION ALL
SELECT 'Notification',     COUNT(*) FROM Notification;