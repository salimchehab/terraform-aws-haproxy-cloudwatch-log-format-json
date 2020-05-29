{
   "widgets": [
   %{ for index, metric in metrics ~}
        {
            "type": "metric",
            "x": ${lookup(metric, "x_value")},
            "y": ${lookup(metric, "y_value")},
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "${lookup(metric, "namespace")}", "${lookup(metric, "name")}" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-central-1",
                "stat": "Sum",
                "period": 60
            }
        }%{ if index != length(metrics) - 1 },%{ endif }
   %{ endfor ~}
   ]
}
