SELECT *
FROM {{ ref('stg_equipment_losses') }}
WHERE predicted_category IS NULL
