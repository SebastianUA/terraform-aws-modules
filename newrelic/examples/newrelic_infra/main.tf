#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
  required_version = "~> 0.13"
}

provider "newrelic" {
  api_key    = "api_key"
  account_id = "account_id"
}

module "newrelic_alert" {
  source = "../../modules/newrelic_alert"

  # vars for newrelic_alert_policy
  alert_policy = true
  #alert_policy_name                                  = "new-relic-policy-PER_CONDITION"
  alert_policy_incident_preference = "PER_CONDITION"
  alert_policy_simple_default      = true

  alert_channel = true
  #
  alert_channel_slack = true
  #alert_channel_slack_configuration_channel           = "new-relic"
  #alert_channel_slack_configuration_url               = "https://hooks.slack.com/services/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666"
  #
  alert_condition           = true
  alert_condition_policy_id = element(module.newrelic_alert.alert_policy_id, 0)
  #alert_condition_policy_id                           = element(module.newrelic_alert.simple_default_alert_policy_id, 0)
  alert_condition_type     = "apm_app_metric"
  alert_condition_entities = ["PHP Application"]

  alert_policy_channel = false
}

module "newrelic_infra" {
  source = "../../modules/newrelic_infra"

  infra_alert_condition                      = true
  infra_alert_condition_policy_id            = element(module.newrelic_alert.alert_policy_id, 0)
  infra_alert_condition_type                 = "infra_metric"
  infra_alert_condition_event                = "StorageSample"
  infra_alert_condition_select               = "diskUsedPercent"
  infra_alert_condition_comparison           = "equal"
  infra_alert_condition_where                = "(`hostname` LIKE '%frontend%')"
  infra_alert_condition_integration_provider = ""

  #
  infra_alert_condition_with_warning = true
}
