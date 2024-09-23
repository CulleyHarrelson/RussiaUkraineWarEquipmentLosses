
## Panel dashboard

My first pass through the dataset resulted in the panel dashboard, leveraging pandas for the analysis.  The dbt sub-project is doing similar work with dbt.


This dashboard uses [panel by holoviz](https://panel.holoviz.org/) and the [hvPlot](https://hvplot.holoviz.org/) [pandas](https://pandas.pydata.org/) extension.

To start the dashboard, open your terminal, navigate to a good folder and
execute these commands:

    git clone https://github.com/CulleyHarrelson/RussiaUkraineWarEquipmentLosses.git
    cd RussiaUkraineWarEquipmentLosses
    python3 -m venv .venv
    source .venv/bin/activate
    pip3 install -r requirements.txt
    panel serve --show --autoreload RussiaUkraineWar.py
