from ddtrace import patch_all

patch_all()

from flask import Flask, request, redirect, url_for, flash, get_flashed_messages
import logging
import os
import boto3
import uuid
from common.db import get_connection

logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
app.secret_key = "supersecret"
s3 = boto3.client("s3")

app.logger.info("CloudDarkroom is starting!!!")



@app.route("/")
def home():
    upload_bucket = os.environ.get("UPLOAD_BUCKET_NAME", "not set")
    processed_bucket = os.environ.get("PROCESSED_BUCKET_NAME", "not set")

    messages = get_flashed_messages()

    message_html = ""

    if messages:
        message_html = f"""
        <div style="
            background:#d4edda;
            color:#155724;
            border:1px solid #c3e6cb;
            padding:10px;
            margin-bottom:20px;
            border-radius:5px;
        ">
            ✅ {messages[0]}
        </div>
        """

    return f"""
    {message_html}

    <h1>CloudDarkroom</h1>

    <p><strong>Upload Bucket:</strong> {upload_bucket}</p>
    <p><strong>Processed Bucket:</strong> {processed_bucket}</p>

    <h2>Upload Image</h2>

    <form action="/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="image">
        <button type="submit">Upload</button>
    </form>

    <br>

    <form action="/images" method="get">
        <button type="submit">View Image Metadata</button>
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
    flash(f"Successfully uploaded {file.filename}")
    return redirect(url_for("home"))




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