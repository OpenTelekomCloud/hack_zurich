resource "openstack_networking_floatingip_v2" "fip" {
  count = "${var.jumphost_count}"
  pool  = "${var.external_network}"
}
resource "openstack_networking_floatingip_v2" "fip_lb" {
  count   = "${var.lamp_count}"
  pool    = "${var.external_network}"
  port_id = "${openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id}"
}
