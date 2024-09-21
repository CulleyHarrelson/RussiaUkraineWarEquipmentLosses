{{ config(materialized='table') }}

SELECT
    ec.predicted_category,
    ec.total_losses,
    ec.destroyed,
    ec.captured,
    ec.damaged,
    cl.date_recorded,
    cl.cumulative_losses
FROM {{ ref('int_equipment_categories') }} ec
JOIN {{ ref('int_cumulative_losses') }} cl
    ON ec.predicted_category = cl.predicted_category
