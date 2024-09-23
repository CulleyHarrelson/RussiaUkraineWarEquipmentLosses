import json
import os


def write_json(data, filename):
    directory = os.path.dirname(filename)
    if not os.path.exists(directory):
        os.makedirs(directory)

    with open(filename, "w") as f:
        json.dump(data, f, indent=2)
