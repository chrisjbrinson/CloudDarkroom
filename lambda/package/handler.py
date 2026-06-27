import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    upload_bucket = os.environ["UPLOAD_BUCKET_NAME"]
    processed_bucket = os.environ["PROCESSED_BUCKET_NAME"]

    logger.info("Lambda invoked")
    logger.info(f"Upload bucket: {upload_bucket}")
    logger.info(f"Processed bucket: {processed_bucket}")
    logger.info(f"Event: {json.dumps(event)}")

    return {
        "statusCode": 200,
        "body": "Lambda executed successfully"
    }