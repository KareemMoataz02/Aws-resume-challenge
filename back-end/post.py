import json
import boto3

dynamodb = boto3.resource('dynamodb')
# Consider using an environment variable for the table name
table_name = 'visit-counter'


def increment_visitor_count(event, context):
    # Parse the query parameters from the API Gateway event
    site_id = event['queryStringParameters'].get('site_id')

    if not site_id:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'site_id parameter is missing in the query string'})
        }

    try:
        # Get the DynamoDB table
        table = dynamodb.Table(table_name)

        # Define an expression attribute name for the reserved keyword "count"
        expression_attribute_names = {'#count': 'count'}

        # Update the DynamoDB item with an increment operation or create if it doesn't exist
        update_expression = "SET #count = if_not_exists(#count, :init) + :c"

        table.update_item(
            Key={
                'site_id': site_id
            },
            UpdateExpression=update_expression,
            # Increment by 1, initialize to 0 if it doesn't exist
            ExpressionAttributeValues={':c': 1, ':init': 0},
            # Use the defined expression attribute names
            ExpressionAttributeNames=expression_attribute_names
        )

        # Retrieve the updated count after the increment
        response = table.get_item(
            Key={
                'site_id': site_id
            }
        )

        updated_count = response.get('Item', {}).get('count', 0)

        # Convert the updated count to an integer
        updated_count = int(updated_count)

        # Create a response with CORS headers
        response = {
            'statusCode': 200,
            'body': json.dumps({'count': updated_count}),
            'headers': {
                'Access-Control-Allow-Origin': '*',
                # Adjust the allowed HTTP methods as needed
                'Access-Control-Allow-Methods': 'GET, POST',
                'Access-Control-Allow-Headers': 'Content-Type',  # Specify allowed headers
            }
        }

        return response
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

# This is the AWS Lambda entry point


def lambda_handler(event, context):
    return increment_visitor_count(event, context)
