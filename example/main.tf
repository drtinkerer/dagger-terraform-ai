terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

# 1. Local File Creation (existing but expanded)
resource "local_file" "config_yaml" {
  content  = <<EOT
app_name: "demo-app"
log_level: "debug"
max_retries: 5
features:
  - analytics
  - dashboard
EOT
  filename = "${path.module}/config/app_config.yaml"
  file_permission = "0644"
}

# 2. Random Password Generation (Simulating sensitive data creation)
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "secrets_env" {
  content  = "DB_PASSWORD=${random_password.db_password.result}"
  filename = "${path.module}/.env.local"
  file_permission = "0600" # secure permission
}

# 3. HTTP Data Fetching (Simulating API calls)
data "http" "example_api" {
  url = "https://api.github.com/zen" # Returns a random zen string
  
  # Optional: request headers
  request_headers = {
    Accept = "text/plain"
    User-Agent = "Terraform-HTTP-Provider"
  }
}

# 4. Using the API response in another resource
resource "local_file" "zen_message" {
  content  = "Github Zen thought of the day: ${data.http.example_api.response_body}"
  filename = "${path.module}/zen.txt"
}

# 5. Random Pet Name (Just for fun/variety)
resource "random_pet" "server_name" {
  prefix = "web"
  length = 2
}

output "server_address" {
  value = "${random_pet.server_name.id}.example.com"
}
