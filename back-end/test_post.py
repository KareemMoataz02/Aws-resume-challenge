import json
import pytest
from moto import mock_dynamodb # Change to mock_dynamodb2
import boto3
from botocore.exceptions import NoCredentialsError
from post import increment_visitor_count  # Import your Lambda function

@pytest.fixture
def dynamodb_table():
    with mock_dynamodb():
        client = boto3.client("dynamodb", region_name="us-east-1")
        client.create_table(
            TableName="visit-counter",
            KeySchema=[{"AttributeName": "site_id", "KeyType": "HASH"}],
            AttributeDefinitions=[{"AttributeName": "site_id", "AttributeType": "S"}],
            ProvisionedThroughput={"ReadCapacityUnits": 5, "WriteCapacityUnits": 5},
        )
        yield

@pytest.fixture
def lambda_event():
    # Replace this with your Lambda event input
    return {
        "queryStringParameters": {"site_id": "example_site"},
    }

def test_increment_visitor_count(dynamodb_table, lambda_event):
    try:
        response = increment_visitor_count(lambda_event, None)

        # Check the response
        assert response["statusCode"] == 200
        data = json.loads(response["body"])
        assert "count" in data
        assert data["count"] == 1  # Change this to your expected count
    except NoCredentialsError:
        print("AWS credentials not found. Make sure you have valid credentials for local testing.")

# Run the tests
if __name__ == "__main__":
    pytest.main()
