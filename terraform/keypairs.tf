resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.project}-pubkey"
  public_key = "${file("${var.ssh_pub_key}")}"
}
