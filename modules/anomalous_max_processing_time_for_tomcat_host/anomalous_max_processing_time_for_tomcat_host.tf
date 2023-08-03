resource "shoreline_notebook" "anomalous_max_processing_time_for_tomcat_host" {
  name       = "anomalous_max_processing_time_for_tomcat_host"
  data       = file("${path.module}/data/anomalous_max_processing_time_for_tomcat_host.json")
  depends_on = [shoreline_action.invoke_tail_logs,shoreline_action.invoke_cpu_mem_net_usage_check,shoreline_action.invoke_tomcat_mem_adjust]
}

resource "shoreline_file" "tail_logs" {
  name             = "tail_logs"
  input_file       = "${path.module}/data/tail_logs.sh"
  md5              = filemd5("${path.module}/data/tail_logs.sh")
  description      = "Check the Tomcat access and error logs for any relevant messages"
  destination_path = "/agent/scripts/tail_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_mem_net_usage_check" {
  name             = "cpu_mem_net_usage_check"
  input_file       = "${path.module}/data/cpu_mem_net_usage_check.sh"
  md5              = filemd5("${path.module}/data/cpu_mem_net_usage_check.sh")
  description      = "The server may be experiencing a high load of requests, causing the Tomcat max processing time to spike."
  destination_path = "/agent/scripts/cpu_mem_net_usage_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tomcat_mem_adjust" {
  name             = "tomcat_mem_adjust"
  input_file       = "${path.module}/data/tomcat_mem_adjust.sh"
  md5              = filemd5("${path.module}/data/tomcat_mem_adjust.sh")
  description      = "Increase the resources allocated to the Tomcat server, such as CPU, memory, or network bandwidth."
  destination_path = "/agent/scripts/tomcat_mem_adjust.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tail_logs" {
  name        = "invoke_tail_logs"
  description = "Check the Tomcat access and error logs for any relevant messages"
  command     = "`chmod +x /agent/scripts/tail_logs.sh && /agent/scripts/tail_logs.sh`"
  params      = []
  file_deps   = ["tail_logs"]
  enabled     = true
  depends_on  = [shoreline_file.tail_logs]
}

resource "shoreline_action" "invoke_cpu_mem_net_usage_check" {
  name        = "invoke_cpu_mem_net_usage_check"
  description = "The server may be experiencing a high load of requests, causing the Tomcat max processing time to spike."
  command     = "`chmod +x /agent/scripts/cpu_mem_net_usage_check.sh && /agent/scripts/cpu_mem_net_usage_check.sh`"
  params      = ["DESIRED_MEMORY_THRESHOLD","DESIRED_NETWORK_THRESHOLD"]
  file_deps   = ["cpu_mem_net_usage_check"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_mem_net_usage_check]
}

resource "shoreline_action" "invoke_tomcat_mem_adjust" {
  name        = "invoke_tomcat_mem_adjust"
  description = "Increase the resources allocated to the Tomcat server, such as CPU, memory, or network bandwidth."
  command     = "`chmod +x /agent/scripts/tomcat_mem_adjust.sh && /agent/scripts/tomcat_mem_adjust.sh`"
  params      = []
  file_deps   = ["tomcat_mem_adjust"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_mem_adjust]
}

