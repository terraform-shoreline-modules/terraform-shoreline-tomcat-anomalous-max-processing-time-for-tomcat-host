terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "anomalous_max_processing_time_for_tomcat_host" {
  source    = "./modules/anomalous_max_processing_time_for_tomcat_host"

  providers = {
    shoreline = shoreline
  }
}