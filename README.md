# terraform-aci-access_policy

Manages ACI Access Policy

```
module "access_policy" {
  source = "app.terraform.io/insobi/access_policy/aci"

  vlan_pools = {
    DEMO-SVR-VLAN = { vlan_name = "DEMO-SVR-VLAN", alloc_mode = "static" },
  }

  vlan_pools_ranges = {
    DEMO-SVR-VLAN = { vlan_pool_name = "DEMO-SVR-VLAN", from = "vlan-1", to = "vlan-4000", alloc_mode = "static" },
  }

  physical_domains = {
    DEMO-SVR-ERD = { name = "DEMO-SVR-ERD", vlan_pool = "DEMO-SVR-VLAN" }
  }

  link_level_policies = {
    AUTO_NEGO  = { name = "AUTO_NEGO", auto_neg = "on" },
    LL_1G-SVR  = { name = "1G-SVR", auto_neg = "off", speed = "1G" },
    LL_10G-SVR = { name = "10G-SVR", auto_neg = "off", speed = "10G" }
  }

  cdp_policies = {
    CDP_ENABLE = { cdp_policy_name = "CDP_ENABLE", adminSt = "enabled" }
    CDP_DISABLE = { cdp_policy_name = "CDP_DISABLE", adminSt = "disabled"
    }
  }

  lldp_policies = {
    LLDP_DISABLE = { name = "LLDP_DISABLE", receive_state = "disabled", trans_state = "disabled" }
  }

  lacp_policies = {
    LACP-ACTIVE = { name = "LACP-ACTIVE", mode = "active" }
  }

  aaeps = {
    DEMO-AEP = { aaep_name = "DEMO-AEP", physical_domains = ["DEMO-SVR-ERD"] }
  }

  leaf_access_policy_groups = {
    LF-AUTO-SVR = { name = "LF-AUTO-SVR", cdp_policy = "CDP_DISABLE", aaep = "DEMO-AEP", lldp_policy = "LLDP_DISABLE", link_level_policy = "AUTO_NEGO" }
    LF-1G-SVR   = { name = "LF-1G-SVR", cdp_policy = "CDP_DISABLE", aaep = "DEMO-AEP", lldp_policy = "LLDP_DISABLE", link_level_policy = "LL_1G-SVR" }
    LF-10G-SVR  = { name = "LF-10G-SVR", cdp_policy = "CDP_DISABLE", aaep = "DEMO-AEP", lldp_policy = "LLDP_DISABLE", link_level_policy = "LL_10G-SVR" }
  }

  access_port_selectors = {
    Leaf1-1-1  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-1", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 1 },
    Leaf1-1-2  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-2", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 2 },
    Leaf1-1-3  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-3", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 3 },
    Leaf1-1-4  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-4", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 4 },
    Leaf1-1-5  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-5", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 5 },
    Leaf1-1-6  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-6", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 6 },
    Leaf1-1-7  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-7", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 7 },
    Leaf1-1-8  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-8", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 8 },
    Leaf1-1-9  = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-9", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 9 },
    Leaf1-1-10 = { leaf_interface_profile = "Leaf1_Intp", name = "Leaf1-1-10", access_port_selector_type = "range", intf_policy = "LF-1G-SVR", port = 10 },
  }

  leaf_profiles = {
    Leaf1 = { name = "Leaf1", leaf_interface_profile = ["Leaf1_Intp"], leaf_selectors = ["Leaf1_sel"] }
  }

  leaf_selectors = {
    Leaf1_sel = { leaf_profile = "Leaf1", name = "Leaf1_sel", switch_association_type = "range", block = "1" }
  }

  leaf_interface_profiles = {
    Leaf1_Intp = { name = "Leaf1_Intp" }
  }
}
```