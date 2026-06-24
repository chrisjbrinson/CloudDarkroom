from flask import Flask
import logging
import os

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

app.logger.info("CloudDarkroom is starting")


@app.route("/")
def home():
    bucket = os.environ.get("S3_BUCKET_NAME", "not set")
    return f"CloudDarkroom is running <br>Bucket: {bucket}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)