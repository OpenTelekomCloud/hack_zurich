provider "openstack" { 
    user_id     = "${var.userid}"
    password    = "${var.password}"
    tenant_id   = "${var.tenantid}"
    auth_url    = "${var.endpoint}"
}
