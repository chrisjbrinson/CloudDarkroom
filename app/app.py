from flask import Flask, request
import logging
import os

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

app.logger.info("CloudDarkroom is starting")


@app.route("/")
def home():
    bucket = os.environ.get("S3_BUCKET_NAME", "not set")

    return f"""
    <h1>CloudDarkroom</h1>
    <p>Bucket: {bucket}</p>

    <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="image">
        <button type="submit">Upload</button>
    </form>
    """

@app.route("/upload", methods=["POST"])
def upload():
    file = request.files["image"]

    return f"Received file: {file.filename}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)