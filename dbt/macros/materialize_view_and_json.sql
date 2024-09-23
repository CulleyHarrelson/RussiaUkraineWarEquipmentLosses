{% materialization view_and_json, adapter='postgres' %}
  {%- set identifier = model['alias'] -%}
  {%- set target_relation = api.Relation.create(identifier=identifier,
                                                schema=model.schema,
                                                database=model.database,
                                                type='view') -%}
  {%- set existing_relation = load_relation(target_relation) -%}

  -- Build the view
  {% call statement('main') -%}
    {{ create_view_as(target_relation, sql) }}
  {%- endcall %}

  -- Execute the query and store results
  {% set results = run_query(sql) %}

  -- Use dbt's Python capabilities to write JSON file
  {% do log("Writing JSON file...", info=True) %}
  {% set json_data = results.rows %}
  {% do write_json(json_data, target.path ~ '/' ~ identifier ~ '.json') %}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}
