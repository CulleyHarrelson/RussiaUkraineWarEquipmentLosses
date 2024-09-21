{{ config(materialized='table') }}

SELECT
    predicted_category,
    COUNT(*) AS total_losses,
    COUNT(CASE WHEN status = 'destroyed' THEN 1 END) AS destroyed,
    COUNT(CASE WHEN status = 'captured' THEN 1 END) AS captured,
    COUNT(CASE WHEN status = 'damaged' THEN 1 END) AS damaged
FROM {{ ref('stg_equipment_losses') }}
GROUP BY predicted_category
