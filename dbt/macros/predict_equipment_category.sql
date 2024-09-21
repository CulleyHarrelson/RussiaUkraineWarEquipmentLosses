{% macro predict_equipment_category(column_name) %}
    CASE
        WHEN {{ column_name }} ~* 'UAV|drone|Orlan' THEN 'UAV'
        WHEN {{ column_name }} ~* 'truck|vehicle' THEN 'Ground Vehicle'
        WHEN {{ column_name }} ~* 'tank|APC' THEN 'Armored Vehicle'
        WHEN {{ column_name }} ~* 'aircraft|plane|jet' THEN 'Aircraft'
        WHEN {{ column_name }} ~* 'helicopter' THEN 'Helicopter'
        WHEN {{ column_name }} ~* 'ship|boat|vessel' THEN 'Naval'
        ELSE 'Other'
    END
{% endmacro %}
