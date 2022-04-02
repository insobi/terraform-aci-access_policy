# terraform-aci-access_policy

Manages ACI Access Policy

```
module "access_policy" {
  source = "app.terraform.io/insobi/access_policy/aci"

  vlan_pools = {
    test_vlan = { vlan_name = "test_vlan", alloc_mode = "static" }
  }

  vlan_pools_ranges = {
    test_vlan = { vlan_pool_name = "test_vlan", from = "vlan_1", to = "vlan_4000", alloc_mode = "static" }
  }

  physical_domains = {
    test_erd = { name = "test_erd", vlan_pool = "test_vlan" }
  }

  link_level_policies = {
    auto_nego = { name = "auto_nego", auto_neg = "on" },
    ll_1G     = { name = "test_1G", auto_neg = "off", speed = "1G" },
    ll_10G    = { name = "test_10G", auto_neg = "off", speed = "10G" }
  }

  cdp_policies = {
    cdp_enable  = { cdp_policy_name = "cdp_enable", admin_st = "enabled" },
    cdp_disable = { cdp_policy_name = "cdp_disable", admin_st = "disabled" }
  }

  lldp_policies = {
    lldp_disable = { name = "lldp_disable", receive_state = "disabled", trans_state = "disabled" }
  }

  lacp_policies = {
    lacp_active = { name = "lacp_active", mode = "active" }
  }

  aaeps = {
    test_aep = { aaep_name = "test_aep", physical_domains = ["test_erd"] }
  }

  leaf_access_policy_groups = {
    lf_auto = { name = "lf_auto", cdp_policy = "cdp_disable", aaep = "test_aep", lldp_policy = "lldp_disable", link_level_policy = "auto_nego" }
    lf_1G   = { name = "lf_1G", cdp_policy = "cdp_disable", aaep = "test_aep", lldp_policy = "lldp_disable", link_level_policy = "ll_1G" }
    lf_10G  = { name = "lf_10G", cdp_policy = "cdp_disable", aaep = "test_aep", lldp_policy = "lldp_disable", link_level_policy = "ll_10G" }
  }

  access_port_selectors = {
    port_sel_1_41 = { intf_prof = "intfprof1", name = "port_sel_1_41", intf_policy = "lf_1G", from_port = 1, to_port = 41 }
  }

  leaf_profiles = {
    leaf103 = { name = "leaf103", leaf_interface_profile = ["intfprof1"], leaf_selectors = ["leaf103_sel"] },
    leaf104 = { name = "leaf104", leaf_interface_profile = ["intfprof1"], leaf_selectors = ["leaf104_sel"] },
    leaf105 = { name = "leaf105", leaf_interface_profile = ["intfprof1"], leaf_selectors = ["leaf105_sel"] }
  }

  leaf_selectors = {
    leaf103_sel = { name = "leaf103_sel", leaf_profile = "leaf103", switch_association_type = "range", block = "103", from = "103", to = "103" },
    leaf104_sel = { name = "leaf104_sel", leaf_profile = "leaf104", switch_association_type = "range", block = "104", from = "104", to = "104" },
    leaf105_sel = { name = "leaf105_sel", leaf_profile = "leaf105", switch_association_type = "range", block = "105", from = "105", to = "105" }
  }

  leaf_interface_profiles = {
    intfprof1 = { name = "test_intp" }
  }
}
```