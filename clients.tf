variable "client_count" {
  default = "4"
}

resource "packet_device" "as_client" {
  hostname = "as-client-${count.index+1}"
  facility = "ewr1"
  plan = "baremetal_1"
  os = "debian_8"
  tags = ["aerospike", "client"]
  user_data = "${file("client_init.sh")}"
  project_id = "${var.packet_project_id}"

  count = "${var.client_count}"

  provisioner "local-exec" {
    command = "sed -i -e '/${self.ipv4_address}/ d' $HOME/.ssh/known_hosts"
  }
}

output "client_pub_ips" {
  value = "${join(" ", packet_device.as_client.*.ipv4_address)}"
}
