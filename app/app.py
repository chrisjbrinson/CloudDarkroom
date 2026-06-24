from flask import Flask
import logging

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

app.logger.info("CloudDarkroom is starting")


@app.route("/")
def home():
    return "CloudDarkroom is running v2"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)