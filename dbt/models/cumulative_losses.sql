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
    cumulative_losses.date_recorded,
    cumulative_losses.country,
    cumulative_losses.predicted_category,
    cumulative_losses.daily_loss_count,
    cumulative_losses.cumulative_loss_count,
    country_cumulative_losses.country_daily_loss_count,
    country_cumulative_losses.country_cumulative_loss_count
FROM cumulative_losses
JOIN country_cumulative_losses
    ON cumulative_losses.date_recorded = country_cumulative_losses.date_recorded
    AND cumulative_losses.country = country_cumulative_losses.country
ORDER BY cumulative_losses.country, cumulative_losses.predicted_category, cumulative_losses.date_recorded
