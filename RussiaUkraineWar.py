import pandas as pd
import bokeh
import hvplot.pandas
import panel as pn
import os
import datetime

pn.extension()
local_path = "oryx.csv"


def download_data():
    """Download and merge csv files"""
    classes_url = "https://raw.githubusercontent.com/leedrake5/Russia-Ukraine/main/data/classes.csv"
    classes = pd.read_csv(classes_url)

    totals_by_systems_url = "https://raw.githubusercontent.com/scarnecchia/oryx_data/main/totals_by_system.csv"
    totals_by_systems = pd.read_csv(totals_by_systems_url)
    return pd.merge(
        totals_by_systems, classes, how="inner", left_on="system", right_on="system"
    )


# create a local copy of the data no more than once a day
if os.path.exists(local_path):
    file_age = datetime.datetime.now() - datetime.datetime.fromtimestamp(
        os.path.getmtime(local_path)
    )
    if file_age > datetime.timedelta(days=1):
        oryx = download_data()
        oryx.to_csv(local_path, index=False)
    else:
        oryx = pd.read_csv(local_path)
else:
    oryx = download_data()
    oryx.to_csv(local_path, index=False)

oryx["date_recorded"] = pd.to_datetime(oryx["date_recorded"])
oryx["class"] = oryx["class"].astype("category")
oryx["country_x"] = oryx["country_x"].astype("category")
oryx["system"] = oryx["system"].astype("category")
oryx["origin"] = oryx["origin"].astype("category")
oryx.rename(columns={"country_y": "Country"}, inplace=True)
oryx.interactive()
UKRAINE_COLOR = "#b94d4d"
RUSSIA_COLOR = "#0057b7"


# overall plot
def overall_plot(df):
    """Return horizontal bar plot plot grouped by equipment class"""
    classes = df.groupby(["class", "Country"]).agg(count=("url", "count"))
    return classes.hvplot(
        kind="barh",
        stacked=True,
        height=600,
        width=920,
        legend="bottom_right",
        title="Overall Equipment Losses",
        color=[UKRAINE_COLOR, RUSSIA_COLOR],
    )


def cumulative_losses_plot(oryx):
    """Return cumulative losses plot for the whole dataset"""
    step_one = oryx.groupby(["date_recorded", "Country"], as_index=False).count()
    step_two = pd.pivot_table(
        step_one, values="country_x", index="date_recorded", columns="Country"
    )
    return step_two.cumsum().hvplot.line(
        x="date_recorded",
        y=["Ukraine", "Russia"],
        # value_label='Equipment Lost',
        legend="top",
        height=600,
        width=920,
        xlabel="Date Recorded",
        ylabel="Equipment Lost",
        title="Cumulative Losses",
        color=[UKRAINE_COLOR, RUSSIA_COLOR],
    )


def cumulative_losses_by_class_plot(oryx, equipment_class):
    """Return cumulative losses plot for a given equipment class"""
    step_one = (
        oryx[oryx["class"] == equipment_class]
        .groupby(["date_recorded", "Country"], as_index=False)
        .count()
    )
    step_two = pd.pivot_table(
        # step_one[step_one["class"] == "tanks"],
        step_one,
        values="country_x",
        index="date_recorded",
        columns="Country",
    )
    return step_two.cumsum().hvplot.line(
        x="date_recorded",
        y=["Ukraine", "Russia"],
        legend="top",
        height=600,
        width=920,
        xlabel="Date Recorded",
        ylabel="{} Lost".format(equipment_class),
        title="Cumulative Losses: {}".format(equipment_class),
        color=[UKRAINE_COLOR, RUSSIA_COLOR],
    )


overall_plot = overall_plot(oryx)
cumulative_losses_plot = cumulative_losses_plot(oryx)
initial_plot = cumulative_losses_by_class_plot(oryx, "Tanks")
cl_class_plot_panel = pn.pane.HoloViews(initial_plot)

equipment_class_select = pn.widgets.Select(
    name="Equipment Class", options=oryx["class"].unique().tolist(), value="Tanks"
)


# Function to update the plots based on the selected equipment class
def update_plots(event):
    selected_class = event.new
    new_plot = cumulative_losses_by_class_plot(oryx, selected_class)
    cl_class_plot_panel.object = new_plot


equipment_class_select.param.watch(update_plots, "value")


# bootstrap = pn.template.BootstrapTemplate(title='Minecraft Summary Stats')
bootstrap = pn.template.BootstrapTemplate(
    title="Russia-Ukraine War Equipment Loss Statistics",
    theme=pn.template.bootstrap.BootstrapDarkTheme,
)

sidebar_md = pn.pane.Markdown(
    """
This dashboard tracks equipment lost during the Russia-Ukraine War. 
Data for this project is ultimately sourced from [oryx](https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html).
From the oryx website:

*This list only includes destroyed vehicles and equipment of which photo or videographic evidence is available. Therefore, the amount of equipment destroyed is significantly higher than recorded here. Loitering munitions, drones used as unmanned bait, civilian vehicles and derelict equipment are not included in this list. All possible effort has gone into avoiding duplicate entries and discerning the status of equipment between captured or abandoned. Many of the entries listed as ‘abandoned’ will likely end up captured or destroyed. Similarly, some of the captured equipment might be destroyed if it can’t be recovered. When a vehicle is captured and then lost in service with its new owners, it is only added as a loss of the original operator to avoid double listings. When the origin of a piece of equipment can’t be established, it’s not included in the list. The Soviet flag is used when the equipment in question was produced prior to 1991. This list is constantly updated as additional footage becomes available.*


The CSV screen scrape from [scarnecchia's](https://github.com/scarnecchia) [Scrape Oryx](https://github.com/scarnecchia/scrape_oryx) project 
is merged with the class data from
[leedrake5's](https://github.com/leedrake5) [Russia-Ukraine](https://github.com/leedrake5/Russia-Ukraine) project.  


This dashboard uses [panel by holoviz](https://panel.holoviz.org/) and the hvPlot [pandas](https://pandas.pydata.org/) extension.

Visit the [GitHub page](https://github.com/CulleyHarrelson/RussiaUkraineWarEquipmentLosses) to
review and extend the source code.

"""
)

useage_md = pn.pane.Markdown(
    """
Plots in the above accordion use the entire oryx dataset - click the triangles to
view the graphs.  Use the dropdown list below to adjust the plots blow for the 
selected equipment class.
"""
)
useage_md.width = 920
useage_md.margin = 10

bootstrap.sidebar.append(pn.Spacer(height=20))
bootstrap.sidebar.append(sidebar_md)
accordion = pn.Accordion(
    (
        "High-level line chart visualizing the growth of equipment losses over time.",
        cumulative_losses_plot,
    ),
    (
        "Bar chart summarizing equipment losses by equipment category.",
        overall_plot,
    ),
)

accordion.width = 920
# accordion.active = [0]
bootstrap.main.append(accordion)
bootstrap.main.append(useage_md)
bootstrap.main.append(equipment_class_select)
bootstrap.main.append(cl_class_plot_panel)
bootstrap.servable()
