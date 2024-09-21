

SELECT
    ec.predicted_category,
    ec.total_losses,
    ec.destroyed,
    ec.captured,
    ec.damaged,
    cl.date_recorded,
    cl.cumulative_losses
FROM "dbt_equipment_losses"."public"."int_equipment_categories" ec
JOIN "dbt_equipment_losses"."public"."int_cumulative_losses" cl
    ON ec.predicted_category = cl.predicted_category