import os
import json
import psycopg2
import pandas as pd
from dotenv import load_dotenv
import hvplot.pandas
import holoviews as hv
from holoviews import render
import bokeh.io

# Load environment variables from .env file
load_dotenv()

# Database connection parameters
db_params = {
    "dbname": "dbt_equipment_losses",
    "user": os.getenv("DBT_USER"),
    "password": os.getenv("DBT_PASS"),
    "host": "localhost",
    "port": 5432,
}


def create_json_artifact(model_name):
    """
    Create a JSON artifact for the given model.
    """
    try:
        with psycopg2.connect(**db_params) as conn:
            with conn.cursor() as cur:
                cur.execute(f"SELECT json_agg(t) FROM {model_name} t;")
                result = cur.fetchone()[0]

        if result:
            artifact_path = f"../artifacts/{model_name}.json"
            with open(artifact_path, "w") as f:
                json.dump(result, f, indent=2)
            print(
                f"Completed {model_name}. Formatted JSON file saved as {artifact_path}"
            )
        else:
            print(f"Error: No data retrieved for {model_name}.")
    except Exception as e:
        print(f"Error processing {model_name}: {str(e)}")


def create_cumulative_losses_plot():
    """
    Create the cumulative losses plot and save as HTML.
    """
    with psycopg2.connect(**db_params) as conn:
        cur = conn.cursor()
        cur.execute(
            "SELECT * FROM public.cumulative_losses ORDER BY predicted_category, date_recorded"
        )
        rows = cur.fetchall()
        column_names = [desc[0] for desc in cur.description]

    df = pd.DataFrame(rows, columns=column_names)

    df["date_recorded"] = pd.to_datetime(df["date_recorded"])
    df["cumulative_loss_count"] = pd.to_numeric(
        df["cumulative_loss_count"], errors="coerce"
    )
    df["cumulative_loss_count"] = (
        df["cumulative_loss_count"].fillna(method="ffill").fillna(0)
    )
    df = df.dropna().drop_duplicates()

    def plot_category(category_df, category_name):
        return category_df.hvplot.line(
            x="date_recorded",
            y="cumulative_loss_count",
            by="country",
            title=f"Cumulative Losses for {category_name}",
            xlabel="Date",
            ylabel="Cumulative Loss Count",
            width=800,
            height=400,
            legend="right",
        )

    category_plots = [
        plot_category(df[df["predicted_category"] == category], category)
        for category in df["predicted_category"].unique()
    ]

    combined_plot = hv.Layout(category_plots).cols(2)

    bokeh.io.output_file("../artifacts/cumulative_losses.html")
    bokeh.io.save(hv.render(combined_plot))
    print("Cumulative losses plot saved as ../artifacts/cumulative_losses.html")


def main():
    # Ensure artifacts directory exists
    os.makedirs("../artifacts", exist_ok=True)

    # Models to convert to JSON
    models = ["system_category"]

    # Create JSON artifacts
    for model in models:
        create_json_artifact(model)

    # Create cumulative losses plot
    create_cumulative_losses_plot()

    print("All artifacts created successfully.")


if __name__ == "__main__":
    main()
