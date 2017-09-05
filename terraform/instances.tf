resource "openstack_compute_instance_v2" "jumphost" {
  count           = "${var.jumphost_count}"
  name            = "${var.project}-jumphost${format("%02d", count.index+1)}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = [
    "${openstack_compute_secgroup_v2.secgrp_jmp.name}"
  ]

  network {
    uuid = "${openstack_networking_network_v2.network.id}"
    access_network = true
  }
}

resource "null_resource" "provision" {
  depends_on = ["openstack_compute_floatingip_associate_v2.fip_1"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${openstack_networking_floatingip_v2.fip.address}"
    private_key = "${file("sshkeys/id_rsa.${var.user_no}")}"
  }

  provisioner "file" {
    source      = "credentials/.ostackrc.${var.user_no}"
    destination = "/home/ubuntu/.ostackrc"
  }

  provisioner "file" {
    source      = "credentials/.s3rc.${var.user_no}"
    destination = "/home/ubuntu/.s3rc"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  count       = "${var.jumphost_count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.fip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.jumphost.*.id, count.index)}"
}
