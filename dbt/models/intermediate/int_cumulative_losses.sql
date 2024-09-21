{{ config(materialized='table') }}

SELECT
    date_recorded,
    predicted_category,
    COUNT(*) AS daily_losses,
    SUM(COUNT(*)) OVER (PARTITION BY predicted_category ORDER BY date_recorded) AS cumulative_losses
FROM {{ ref('stg_equipment_losses') }}
GROUP BY date_recorded, predicted_category
