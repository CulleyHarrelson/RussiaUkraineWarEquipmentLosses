{{ config(materialized='view') }}

WITH daily_losses AS (
    SELECT
        date_recorded,
        country,
        predicted_category,
        COUNT(*) AS daily_loss_count
    FROM {{ ref('equipment_analysis') }}
    GROUP BY date_recorded, country, predicted_category
),

cumulative_losses AS (
    SELECT
        date_recorded,
        country,
        predicted_category,
        daily_loss_count,
        SUM(daily_loss_count) OVER (
            PARTITION BY country, predicted_category
            ORDER BY date_recorded
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_loss_count
    FROM daily_losses
)

SELECT
    date_recorded,
    country,
    predicted_category,
    daily_loss_count,
    cumulative_loss_count
FROM cumulative_losses
ORDER BY country, predicted_category, date_recorded
