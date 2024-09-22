{{ config(materialized='view') }}

SELECT DISTINCT system
FROM {{ ref('equipment_analysis') }}
WHERE predicted_category = 'Unknown'
