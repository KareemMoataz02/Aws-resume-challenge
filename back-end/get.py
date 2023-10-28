import json
import boto3

dynamodb = boto3.resource('dynamodb')
table_name = 'visit-counter'

def get_visitor_count(event, context):
    # Parse the query parameters from the API Gateway event
    query_parameters = event.get('queryStringParameters')

    if not query_parameters:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Query parameters are missing in the request'})
        }

    site_id = query_parameters.get('site_id')

    if not site_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'site_id parameter is missing in the query string'})
        }

    # Get the DynamoDB table
    table = dynamodb.Table(table_name)
    
    # Retrieve the item from DynamoDB
    response = table.get_item(
        Key={
            'site_id': site_id
        }
    )
    
    item = response.get('Item', {})

    # Get the visitor count or initialize to 0 if it doesn't exist
    count = item.get('count', 0)

    # Convert the Decimal count to an int
    count = int(count)

    # Create a response with CORS headers
    response = {
        'statusCode': 200,
        'body': json.dumps({'count': count}),
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': '*',  # Adjust the allowed HTTP methods as needed
            'Access-Control-Allow-Headers': '*',  # Allow all headers or specify specific ones
        }
    }

    return response

# This is the AWS Lambda entry point
def lambda_handler(event, context):
    return get_visitor_count(event, context)
