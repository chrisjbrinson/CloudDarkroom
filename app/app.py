from flask import Flask, request
import logging
import os
import boto3
import uuid
from common.db import get_connection

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
s3 = boto3.client("s3")

app.logger.info("CloudDarkroom is starting!!!")


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




@app.get("/images")
def get_images():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    id,
                    original_filename,
                    original_bucket,
                    original_key,
                    processed_bucket,
                    processed_key,
                    status,
                    width,
                    height,
                    created_at,
                    processed_at
                FROM images
                ORDER BY id DESC;
            """)

            rows = cur.fetchall()

    images = []

    for row in rows:
        images.append({
            "id": row[0],
            "original_filename": row[1],
            "original_bucket": row[2],
            "original_key": row[3],
            "processed_bucket": row[4],
            "processed_key": row[5],
            "status": row[6],
            "width": row[7],
            "height": row[8],
            "created_at": row[9].isoformat(),
            "processed_at": row[10].isoformat() if row[10] else None
        })

    return images

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)