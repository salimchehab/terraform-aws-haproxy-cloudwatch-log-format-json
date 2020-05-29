# ----------------------------------------------------------------------------------------------------------------------
# Create the local variables for the CloudWatch log metric filters
# ----------------------------------------------------------------------------------------------------------------------
locals {
  log_metric_filters_default_value = "0"
  log_metric_filters_namespace     = "LogMetrics"
  log_metric_filters_timers = [
    {
      name : "Total time to get client request.",
      pattern : "{$.timers.TR = *}",
      name_short : "TR",
      value : "$.timers.TR",
    },
    {
      name : "Total time spent in queues waiting for a connection slot.",
      pattern : "{$.timers.Tw = *}",
      name_short : "Tw",
      value : "$.timers.Tw",
    },
    {
      name : "Total time to establish the TCP connection to the server.",
      pattern : "{$.timers.Tc = *}",
      name_short : "Tc",
      value : "$.timers.Tc",
    },
    {
      name : "Total active time for the HTTP request.",
      pattern : "{$.timers.Ta = *}",
      name_short : "Ta",
      value : "$.timers.Ta",
    },
    {
      name : "Total TCP session duration time (from proxy accept till both ends were closed).",
      pattern : "{$.timers.Tt = *}",
      name_short : "Tt",
      value : "$.timers.Tt",
    },
  ]
  log_metric_filters_http_method = [
    {
      name : "GET HTTP requests.",
      pattern : "{$.http.method = GET}",
      name_short : "GET",
      value : "1",
    },
    {
      name : "POST HTTP requests.",
      pattern : "{$.http.method = POST}",
      name_short : "POST",
      value : "1",
    },
    {
      name : "PUT HTTP requests.",
      pattern : "{$.http.method = PUT}",
      name_short : "PUT",
      value : "1",
    },
    {
      name : "DELETE HTTP requests.",
      pattern : "{$.http.method = DELETE}",
      name_short : "DELETE",
      value : "1",
    },
  ]
  dashboard_values = {
    metrics = [
      {
        x_value   = 0,
        y_value   = 0,
        name      = "GET",
        namespace = local.log_metric_filters_namespace
      },
      {
        x_value   = 6,
        y_value   = 0,
        name      = "POST",
        namespace = local.log_metric_filters_namespace
      },
      {
        x_value   = 12,
        y_value   = 0,
        name      = "DELETE",
        namespace = local.log_metric_filters_namespace
      }
    ]
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Generate HAProxy config from template cfg file
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "haproxy" {
  template = file("./templates/haproxy.cfg.tpl")
  vars = {
    log_len = var.haproxy_log_len
    #log_format     = var.haproxy_log_format
    log_format     = file("${path.module}/haproxy-log-format.txt")
    ca_file        = "/home/ubuntu/EC2CA.pem"
    crt            = "/home/ubuntu/flask.local.app.pem"
    maxconn        = 64
    backend_port   = 5000
    backend_server = "backend-1.local.app"
  }
}

resource "null_resource" "update_haproxy_cfg" {
  triggers = {
    template = data.template_file.haproxy.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.haproxy.rendered}' > haproxy.cfg"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create a new CloudWatch Log Group and Log Stream for HAProxy
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "haproxy" {
  name              = "/var/log/haproxy.log"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "haproxy" {
  name           = data.aws_instance.haproxy.instance_id
  log_group_name = aws_cloudwatch_log_group.haproxy.name
}

# ----------------------------------------------------------------------------------------------------------------------
# Create CloudWatch Metric Filters for the HAProxy Timers
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "timers" {
  count = length(local.log_metric_filters_timers)

  name           = local.log_metric_filters_timers[count.index].name
  pattern        = local.log_metric_filters_timers[count.index].pattern
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = local.log_metric_filters_timers[count.index].name_short
    namespace     = local.log_metric_filters_namespace
    value         = local.log_metric_filters_timers[count.index].value
    default_value = local.log_metric_filters_default_value
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create CloudWatch Metric Filters for the HTTP Requests
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "http_method" {
  count = length(local.log_metric_filters_http_method)

  name           = local.log_metric_filters_http_method[count.index].name
  pattern        = local.log_metric_filters_http_method[count.index].pattern
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = local.log_metric_filters_http_method[count.index].name_short
    namespace     = local.log_metric_filters_namespace
    value         = local.log_metric_filters_http_method[count.index].value
    default_value = local.log_metric_filters_default_value
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create CloudWatch Dashboard for the HTTP Requests
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_dashboard" "http_method" {
  dashboard_name = "HTTP_METHODS_PER_MINUTE"
  dashboard_body = templatefile("${path.module}/templates/dashboard.tpl", local.dashboard_values)
}
