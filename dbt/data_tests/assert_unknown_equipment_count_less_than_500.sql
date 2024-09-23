{{ config(severity='error') }}

SELECT COUNT(*) as row_count
FROM {{ ref('unknown_equipment') }}
HAVING row_count >= 500
