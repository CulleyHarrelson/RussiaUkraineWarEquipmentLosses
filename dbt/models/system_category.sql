{{ config(materialized='view') }}


SELECT DISTINCT
    system,
    predicted_category
FROM {{ ref('equipment_analysis') }}
ORDER BY system, predicted_category
