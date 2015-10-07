variable "packet_api_key" {}
variable "packet_project_id" {}

variable "packet_facility" {
  default = "ewr1"
}

provider "packet" {
  api_key = "${var.packet_api_key}"
}
