

SELECT
    date_recorded,
    predicted_category,
    COUNT(*) AS daily_losses,
    SUM(COUNT(*)) OVER (PARTITION BY predicted_category ORDER BY date_recorded) AS cumulative_losses
FROM "dbt_equipment_losses"."public"."stg_equipment_losses"
GROUP BY date_recorded, predicted_category