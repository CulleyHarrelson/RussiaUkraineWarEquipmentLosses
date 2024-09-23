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
),
max_cumulative_losses AS (
    SELECT
        country,
        predicted_category,
        MAX(cumulative_loss_count) AS max_cumulative_loss
    FROM cumulative_losses
    GROUP BY country, predicted_category
    HAVING MAX(cumulative_loss_count) > 500
)
SELECT
    cl.date_recorded,
    cl.country,
    cl.predicted_category,
    cl.daily_loss_count,
    cl.cumulative_loss_count
FROM cumulative_losses cl
INNER JOIN max_cumulative_losses mcl
    ON cl.country = mcl.country
    AND cl.predicted_category = mcl.predicted_category
ORDER BY cl.country, cl.predicted_category, cl.date_recorded
