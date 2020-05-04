variable "haproxy_log_len" {
  description = "The allowed length of the log file entry to override the default global settings of 1024 chars."
  type        = number
  default     = 4096
}

variable "haproxy_log_format" {
  description = "The HAProxy log format."
  type        = string
  default     = "\"%ci:%cp [%tr] %ft %b/%s %TR/%Tw/%Tc/%Tr/%Ta %ST %B %CC %CS %tsc %ac/%fc/%bc/%sc/%rc %sq/%bq %hr %hs %%{+Q}r\""
}
