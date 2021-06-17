import os
import boto3
import decimal
import json
import logging
from decimal import Decimal
from pprint import pprint
from botocore.exceptions import ClientError


logger = logging.getLogger()
logging.basicConfig(level=logging.INFO)  # To see output in local console
logger.setLevel(logging.INFO)  # To see output in Lambda
dynamodb = boto3.client('dynamodb', region_name='us-east-1')   
#table_name = 'siteVisits'
table_name = dynamodb.Table('siteVisits')

# Helper class to convert a DynamoDB item to JSON.
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

# Variables
website = 'anhtran.co.uk'
#counter = 0  

def lambda_handler(event, context):
     try:
            print("event ->" + str(event))
            payload = json.loads(event["body"])
            print("payload ->" + str(payload))
            table = boto3.resource('dynamodb').Table('siteVisits')

            response = table.update_item(
                Key={
                    'Website': website
                    #'Counter': counter
                },
                UpdateExpression="SET #ts = #ts + :val1",
                ExpressionAttributeNames={
                    "#ts": "UpdatedCounter"
                },
                ExpressionAttributeValues={
                    ':val1': Decimal(1)
                },
                ReturnValues="UPDATED_NEW"
            )
            return {
                'statusCode': 201,
                'body': '{ "counter" : UpdatedCounter }'
            }
     except ClientError as e:
         logging.error(e)
         return {
            'statusCode' : 500,
            'body' : '{"status":"Server error"}'
         }
         print("Counter succeeded:")
         print(json.dumps(response, indent=4, cls=DecimalEncoder))