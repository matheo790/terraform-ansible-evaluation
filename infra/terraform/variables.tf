variable "app_env" {
  type        = string
  description = "Environment for the app (APP_ENV)"
  default     = "prod"
}

variable "app_port" {
  type        = number
  description = "Internal port used by the app container"
  default     = 5000
}

variable "public_port" {
  type        = number
  description = "Public port exposed by nginx on localhost"
  default     = 8080
}
