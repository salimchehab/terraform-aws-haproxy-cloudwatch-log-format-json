output "http_method_metric_filters" {
  description = "The names of the http method metric filters."
  value       = aws_cloudwatch_log_metric_filter.http_method.*.id
}

output "timers_metric_filters" {
  description = "The names of the timers metric filters."
  value       = aws_cloudwatch_log_metric_filter.timers.*.id
}
