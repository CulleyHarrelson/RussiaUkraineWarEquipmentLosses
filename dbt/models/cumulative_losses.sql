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
country_daily_losses AS (
    SELECT
        date_recorded,
        country,
        SUM(daily_loss_count) AS country_daily_loss_count
    FROM daily_losses
    GROUP BY date_recorded, country
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
country_cumulative_losses AS (
    SELECT
        date_recorded,
        country,
        country_daily_loss_count,
        SUM(country_daily_loss_count) OVER (
            PARTITION BY country
            ORDER BY date_recorded
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS country_cumulative_loss_count
    FROM country_daily_losses
)
SELECT
    cl.date_recorded,
    cl.country,
    cl.predicted_category,
    cl.daily_loss_count,
    cl.cumulative_loss_count,
    ccl.country_daily_loss_count,
    ccl.country_cumulative_loss_count
FROM cumulative_losses cl
JOIN country_cumulative_losses ccl
    ON cl.date_recorded = ccl.date_recorded
    AND cl.country = ccl.country
ORDER BY cl.country, cl.predicted_category, cl.date_recorded
