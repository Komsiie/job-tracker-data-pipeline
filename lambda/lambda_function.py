import http.client
from urllib.parse import urlencode
import json
import boto3
import os
from datetime import datetime, timezone

API_KEY = os.environ["API_KEY"]
queries = os.environ["QUERIES"].split("|")
BUCKET_NAME = os.environ["BUCKET_NAME"]
s3 = boto3.client(
    "s3")

def lambda_handler(event, context):
    uploaded_files = []
    for query in queries:
        params = urlencode({
            "query": query,
            "page": 1,
            "num_pages": 5,
            "date_posted": "month",
            "country": "us",
            "language": "en"
        })

        conn = http.client.HTTPSConnection("api.openwebninja.com")

        headers = {"Accept": "application/json",
        "x-api-key": API_KEY
        }


        conn.request(
            "GET",
            f"/realtime-jobs-data/google-jobs/search?{params}",
            headers=headers
        )

        res = conn.getresponse()
        raw_response=res.read().decode("utf-8")
        conn.close()

        if res.status != 200:
            raise Exception(f"API returned {res.status}: {raw_response}")

        #Add ingesttimestamp into json file
        source_ingest_timestamp = datetime.now(timezone.utc).isoformat()
        jobs = json.loads(raw_response)
        
        jobs["metadata"] = {"source_ingest_timestamp": source_ingest_timestamp,
                            "source": "OpenWebNinja","api_name": "google-jobs"}
        raw_response = json.dumps(jobs)
    
        
        #Create an S3 key
        today = datetime.utcnow().strftime("%Y-%m-%d")
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")
        query_name = query.replace(" ", "_").lower()
        
        s3_key = (
        f"raw/jobs/"
        f"ingest_date={today}/"
        f"{query_name}_{timestamp}.json")
        
        # Upload raw JSON
        s3.put_object(
        Bucket=BUCKET_NAME,
        Key=s3_key,
        Body=raw_response,
        ContentType="application/json")

        uploaded_files.append(s3_key)
        
        print(f"Uploaded {s3_key}")
        
    return{

        'statusCode': 200,
        'body': json.dumps({
            "message": "Ingestion complete",
            "files_uploaded": len(uploaded_files),
            "objects": uploaded_files})
    
    }

