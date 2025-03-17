terraform {
  required_providers {
    flagsmith = {
      source = "Flagsmith/flagsmith"
      version = "0.9.1"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-e5652a1"
    key    = "feature-flags/terraform.tfstate"
    region = "eu-west-2"
  }
}

# Flagsmith resources
resource "flagsmith_project" "acme_dot_com" {
  name                                = "acme.com"
  organisation_id                     = 16379
}

resource "flagsmith_environment" "production" {
  name                                   = "Production"
  project_id                             = flagsmith_project.acme_dot_com.id
}

resource "flagsmith_feature" "new_homepage_ui" {
  feature_name    = "new_homepage_ui"
  project_uuid    = flagsmith_project.acme_dot_com.uuid
  description     = ""
}

resource "flagsmith_segment" "homepage_rollout" {
  name          = "homepage_rollout"
  project_uuid  = flagsmith_project.acme_dot_com.uuid
  feature_id    = flagsmith_feature.new_homepage_ui.id

  rules = [
    {
      "rules": [{
        "conditions": [{
          "operator": "PERCENTAGE_SPLIT",
          "property": "",
          "value": 10
        }],
        "type": "ANY"
      }],
      "type": "ALL"
    }
  ]
}

resource "flagsmith_feature_state" "homepage_rollout" {
  enabled         = true
  environment_key = flagsmith_environment.production.api_key
  feature_id      = flagsmith_feature.new_homepage_ui.id

  segment_id        = flagsmith_segment.homepage_rollout.id
  segment_priority  = 0

  feature_state_value = {
    string_value  = ""
    type          = "unicode"
  }
}
