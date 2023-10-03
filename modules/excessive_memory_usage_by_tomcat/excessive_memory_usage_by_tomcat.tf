resource "shoreline_notebook" "excessive_memory_usage_by_tomcat" {
  name       = "excessive_memory_usage_by_tomcat"
  data       = file("${path.module}/data/excessive_memory_usage_by_tomcat.json")
  depends_on = [shoreline_action.invoke_increase_tomcat_memory,shoreline_action.invoke_tomcat_config_edit]
}

resource "shoreline_file" "increase_tomcat_memory" {
  name             = "increase_tomcat_memory"
  input_file       = "${path.module}/data/increase_tomcat_memory.sh"
  md5              = filemd5("${path.module}/data/increase_tomcat_memory.sh")
  description      = "Increase the memory allocation for the Tomcat server."
  destination_path = "/agent/scripts/increase_tomcat_memory.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tomcat_config_edit" {
  name             = "tomcat_config_edit"
  input_file       = "${path.module}/data/tomcat_config_edit.sh"
  md5              = filemd5("${path.module}/data/tomcat_config_edit.sh")
  description      = "Reduce the number of threads used by Tomcat."
  destination_path = "/agent/scripts/tomcat_config_edit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_increase_tomcat_memory" {
  name        = "invoke_increase_tomcat_memory"
  description = "Increase the memory allocation for the Tomcat server."
  command     = "`chmod +x /agent/scripts/increase_tomcat_memory.sh && /agent/scripts/increase_tomcat_memory.sh`"
  params      = ["OLD_MEMORY_LIMIT","NEW_MEMORY_LIMIT"]
  file_deps   = ["increase_tomcat_memory"]
  enabled     = true
  depends_on  = [shoreline_file.increase_tomcat_memory]
}

resource "shoreline_action" "invoke_tomcat_config_edit" {
  name        = "invoke_tomcat_config_edit"
  description = "Reduce the number of threads used by Tomcat."
  command     = "`chmod +x /agent/scripts/tomcat_config_edit.sh && /agent/scripts/tomcat_config_edit.sh`"
  params      = ["TOMCAT_CONFIG_DIR","NEW_THREAD_COUNT","TOMCAT_GROUP","TOMCAT_USER"]
  file_deps   = ["tomcat_config_edit"]
  enabled     = true
  depends_on  = [shoreline_file.tomcat_config_edit]
}

