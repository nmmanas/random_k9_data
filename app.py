import json
import os
import random

from flask import Flask, jsonify

flask_app = Flask(__name__)

# Load the data from the JSON file
with open(os.path.join("resources", "source_data.json"), "r") as file:
    data = json.load(file)

batch_size = 50


@flask_app.route("/api/data", methods=["GET"])
def get_random_data():
    random_data = random.sample(data, batch_size)
    return jsonify(random_data)


@flask_app.route("/health", methods=["GET"])
def health_check():
    return 'OK'


if __name__ == "__main__":
    flask_app.run(host="0.0.0.0", port=5000)
