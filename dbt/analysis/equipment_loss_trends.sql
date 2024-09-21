WITH monthly_losses AS (
    SELECT
        DATE_TRUNC('month', date_recorded) AS month,
        predicted_category,
        COUNT(*) AS monthly_loss_count
    FROM {{ ref('stg_equipment_losses') }}
    GROUP BY 1, 2
)

SELECT
    month,
    predicted_category,
    monthly_loss_count,
    SUM(monthly_loss_count) OVER (PARTITION BY predicted_category ORDER BY month) AS cumulative_losses
FROM monthly_losses
ORDER BY month, predicted_category
