from datadog_lambda.wrapper import datadog_lambda_wrapper
import logging
import os
from io import BytesIO

import boto3
from PIL import Image

from common.db import get_connection

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")


def lambda_handler(event, context):
    logger.info("Lambda deployment test!!!")

    upload_bucket = os.environ["UPLOAD_BUCKET_NAME"]
    processed_bucket = os.environ["PROCESSED_BUCKET_NAME"]

    record = event["Records"][0]

    source_bucket = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    logger.info(f"Source bucket: {source_bucket}")
    logger.info(f"Object key: {key}")

    logger.info("Downloading image from S3...")
    # Download the uploaded image
    response = s3.get_object(
        Bucket=upload_bucket,
        Key=key
    )
    logger.info("Reading image bytes...")

    image_bytes = response["Body"].read()

    logger.info(f"Downloaded {len(image_bytes)} bytes")

    # Open the image with Pillow
    image = Image.open(BytesIO(image_bytes))

    logger.info(f"Original size: {image.size}")

    # Resize while preserving aspect ratio
    image.thumbnail((800, 800))

    logger.info(f"Resized image: {image.size}")

    width, height = image.size

    # Convert to grayscale
    image = image.convert("L")

    # Save the processed image into memory
    output = BytesIO()

    image.save(
        output,
        format="JPEG"
    )

    output.seek(0)

    # Create a new filename
    filename = os.path.splitext(key)[0]
    processed_key = f"{filename}-processed.jpg"

    # Upload to the processed bucket
    s3.put_object(
        Bucket=processed_bucket,
        Key=processed_key,
        Body=output,
        ContentType="image/jpeg"
    )

    logger.info(f"Uploaded processed image: {processed_key}")

    # Store metadata in PostgreSQL
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO images (
                    original_filename,
                    original_bucket,
                    original_key,
                    processed_bucket,
                    processed_key,
                    status,
                    width,
                    height,
                    processed_at
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW())
                """,
                (
                    os.path.basename(key),
                    source_bucket,
                    key,
                    processed_bucket,
                    processed_key,
                    "processed",
                    width,
                    height,
                ),
            )

        conn.commit()

    logger.info("Inserted image metadata into PostgreSQL.")

    return {
        "statusCode": 200,
        "body": "Image processed successfully"
    }

lambda_handler = datadog_lambda_wrapper(lambda_handler)