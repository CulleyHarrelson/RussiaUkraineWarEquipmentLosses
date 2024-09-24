{{ config(materialized='view') }}

SELECT DISTINCT predicted_category
FROM {{ ref('equipment_analysis') }}
WHERE predicted_category IS NOT NULL
ORDER BY predicted_category
