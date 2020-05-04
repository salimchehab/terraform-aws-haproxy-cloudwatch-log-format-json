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
resource "aws_cloudwatch_log_metric_filter" "time_get_client_request" {
  name           = "Total time to get client request."
  pattern        = "{$.timers.TR = *}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "TR"
    namespace     = "LogMetrics"
    value         = "$.timers.TR"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "time_in_queues" {
  name           = "Total time spent in queues waiting for a connection slot."
  pattern        = "{$.timers.Tw = *}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "Tw"
    namespace     = "LogMetrics"
    value         = "$.timers.Tw"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "time_server_connection" {
  name           = "Total time to establish the TCP connection to the server."
  pattern        = "{$.timers.Tc = *}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "Tc"
    namespace     = "LogMetrics"
    value         = "$.timers.Tc"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "time_active_http_request" {
  name           = "Total active time for the HTTP request."
  pattern        = "{$.timers.Ta = *}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "Ta"
    namespace     = "LogMetrics"
    value         = "$.timers.Ta"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "time_tcp_session" {
  name           = "Total TCP session duration time (from proxy accept till both ends were closed)."
  pattern        = "{$.timers.Tt = *}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "Tt"
    namespace     = "LogMetrics"
    value         = "$.timers.Tt"
    default_value = "0"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Create CloudWatch Metric Filters for the HTTP Requests
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "http_method_get" {
  name           = "GET HTTP requests."
  pattern        = "{$.http.method = GET}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "GET"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "http_method_post" {
  name           = "POST HTTP requests."
  pattern        = "{$.http.method = POST}"
  log_group_name = aws_cloudwatch_log_group.haproxy.name
  metric_transformation {
    name          = "POST"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}
