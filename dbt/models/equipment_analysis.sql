{{ config(materialized='table') }}

SELECT
    country,
    origin,
    system,
    status,
    url,
    date_recorded,
    "sysID" as sysid,
    "imageID" as imageid,
    "statusID" as statusid,
    "matID" as matid,
    {{ predict_equipment_category('system') }} AS predicted_category
FROM {{ source('raw', 'equipment_losses') }}
