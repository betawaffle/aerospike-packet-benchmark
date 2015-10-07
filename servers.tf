variable "server_count" {
  default = "1"
}

resource "packet_device" "as_server" {
  hostname = "as-server-${count.index+1}"
  facility = "${var.packet_facility}"
  plan = "baremetal_3"
  os = "debian_8"
  tags = ["aerospike", "server"]
  user_data = "${template_file.as_server_init.rendered}"
  project_id = "${var.packet_project_id}"

  count = "${var.server_count}"

  provisioner "local-exec" {
    command = "sed -i -e '/${self.ipv4_address}/ d' ~/.ssh/known_hosts"
  }
}

resource "template_file" "as_server_init" {
  filename = "server_init.sh"
  vars {
    config = "${file("aerospike.conf")}"
  }
  count = "${var.server_count}"
}

output "server_prv_ips" {
  value = "${join(" ", packet_device.as_server.*.ipv4_address_private)}"
}

output "server_pub_ips" {
  value = "${join(" ", packet_device.as_server.*.ipv4_address)}"
}
