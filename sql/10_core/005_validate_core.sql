-- ============================================================
-- CORE VALIDATION
-- ============================================================


-- Row counts

SELECT
    'project' AS table_name,
    COUNT(*) AS rows
FROM core.project

UNION ALL

SELECT
    'promoter',
    COUNT(*)
FROM core.promoter

UNION ALL

SELECT
    'construct',
    COUNT(*)
FROM core.construct

UNION ALL

SELECT
    'experiment',
    COUNT(*)
FROM core.experiment

UNION ALL

SELECT
    'perturbation',
    COUNT(*)
FROM core.perturbation

UNION ALL

SELECT
    'experiment_perturbation',
    COUNT(*)
FROM core.experiment_perturbation

UNION ALL

SELECT
    'cell',
    COUNT(*)
FROM core.cell

UNION ALL

SELECT
    'measurement',
    COUNT(*)
FROM core.measurement;


-- Experiments missing a construct

SELECT *
FROM core.experiment
WHERE construct_id IS NULL;


-- Cells missing experiments should be impossible
-- because of FK constraints, but verify.

SELECT c.*
FROM core.cell c

LEFT JOIN core.experiment e
    ON c.experiment_id =
       e.experiment_id

WHERE e.experiment_id IS NULL;


-- Measurements missing cells

SELECT m.*
FROM core.measurement m

LEFT JOIN core.cell c
    ON m.cell_id =
       c.cell_id

WHERE c.cell_id IS NULL;