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
    logger.info("Lambda deployment test!!")
    upload_bucket = os.environ["UPLOAD_BUCKET_NAME"]
    processed_bucket = os.environ["PROCESSED_BUCKET_NAME"]

    record = event["Records"][0]

    source_bucket = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    logger.info(f"Source bucket: {source_bucket}")
    logger.info(f"Object key: {key}")

    # Download the uploaded image
    response = s3.get_object(
        Bucket=upload_bucket,
        Key=key
    )

    image_bytes = response["Body"].read()

    logger.info(f"Downloaded {len(image_bytes)} bytes")

    # Open the image with Pillow
    image = Image.open(BytesIO(image_bytes))

    logger.info(f"Original size: {image.size}")

    # Resize while preserving aspect ratio
    image.thumbnail((800, 800))

    logger.info(f"Resized image: {image.size}")

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

    return {
        "statusCode": 200,
        "body": "Image processed successfully"
    }