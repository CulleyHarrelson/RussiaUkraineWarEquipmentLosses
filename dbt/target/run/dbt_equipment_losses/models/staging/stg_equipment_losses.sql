
  create view "dbt_equipment_losses"."public"."stg_equipment_losses__dbt_tmp"
    
    
  as (
    

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
    
    CASE
        WHEN system ~* 'UAV|drone|Orlan' THEN 'UAV'
        WHEN system ~* 'truck|vehicle' THEN 'Ground Vehicle'
        WHEN system ~* 'tank|APC' THEN 'Armored Vehicle'
        WHEN system ~* 'aircraft|plane|jet' THEN 'Aircraft'
        WHEN system ~* 'helicopter' THEN 'Helicopter'
        WHEN system ~* 'ship|boat|vessel' THEN 'Naval'
        ELSE 'Other'
    END
 AS predicted_category
FROM "dbt_equipment_losses"."public"."equipment_losses"
  );