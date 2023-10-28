output "get_deployment_invoke_url" {
  description = "Get Deployment invoke url"
  value       = "${aws_api_gateway_deployment.getdeployment.invoke_url}getapiresource?"
}

output "post_deployment_invoke_url" {
  description = "Post Deployment invoke url"
  value       = "${aws_api_gateway_deployment.postdeployment.invoke_url}postapiresource?"
}
