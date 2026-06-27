from flask import Flask, request
import logging
import os
import boto3
import uuid

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
s3 = boto3.client("s3")

app.logger.info("CloudDarkroom is starting")


@app.route("/")
def home():
    upload_bucket = os.environ.get("UPLOAD_BUCKET_NAME", "not set")
    processed_bucket = os.environ.get("PROCESSED_BUCKET_NAME", "not set")

    return f"""
    <h1>CloudDarkroom</h1>
    <p><strong>Upload Bucket:</strong> {upload_bucket}</p>
    <p><strong>Processed Bucket:</strong> {processed_bucket}</p>

    <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="image">
        <button type="submit">Upload</button>
    </form>
    """

@app.route("/upload", methods=["POST"])
def upload():
    file = request.files["image"]

    app.logger.info(f"Starting upload: {file.filename}")

    bucket = os.environ["UPLOAD_BUCKET_NAME"]
    key = f"{uuid.uuid4()}-{file.filename}"
    s3.upload_fileobj(
        file,
        bucket,
        key
    )
    app.logger.info(f"Finished upload: {file.filename}")
    return f"Uploaded {key} to {bucket}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)