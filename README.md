# terraform-aci-access_policy

Manages ACI Access Policy

- VLAN
- Physical domain
- Link level policy
- CDP policy
- LLDP policy
- LACP policy
- AAEP
- Leaf access policy group
- Access port selector
- Leaf profile
- Leaf interface profile

## How to use

### Example 

```hcl
module "access_policy" {
  source  = "insobi/access_policy/aci"
  version = "0.1.0"

  vlan_pools = {
    vlan1 = { vlan_name = "demo-vlan", alloc_mode = "static" }
  }
  
  vlan_pools_ranges = {
    range1 = { vlan_pool_name = "demo-vlan", from = "vlan_2500", to = "vlan_2600", alloc_mode = "static" }
  }
  
  physical_domains = {
    dom1 = { name = "demo_dom", vlan_pool = "demo-vlan" }
  }
  
  link_level_policies = {
    pol1 = { name = "auto_nego", auto_neg = "on" },
    pol2 = { name = "demo_1G", auto_neg = "off", speed = "1G" },
    pol3 = { name = "demo_10G", auto_neg = "off", speed = "10G" }
  }
  
  cdp_policies = {
    pol1 = { name = "cdp_enable", admin_st = "enabled" },
    pol2 = { name = "cdp_disable", admin_st = "disabled" }
  }
  
  lldp_policies = {
    pol1 = { name = "lldp_disable", receive_state = "disabled", trans_state = "disabled" }
  }
  
  lacp_policies = {
    pol1 = { name = "lacp_active", mode = "active" }
  }
  
  aaeps = {
    aaep1 = { name = "demo_aep", physical_domains = ["demo_dom"] }
  }
  
  leaf_access_policy_groups = {
    grp1 = { name = "lf_auto", cdp_policy = "cdp_disable", aaep = "demo_aep", lldp_policy = "lldp_disable", link_level_policy = "auto_nego" }
    grp2 = { name = "lf_1G", cdp_policy = "cdp_disable", aaep = "demo_aep", lldp_policy = "lldp_disable", link_level_policy = "demo_1G" }
    grp3 = { name = "lf_10G", cdp_policy = "cdp_disable", aaep = "demo_aep", lldp_policy = "lldp_disable", link_level_policy = "demo_10G" }
  }
  
  access_port_selectors = {
    sel1 = { intf_prof = "demo_prof", name = "port_sel_1_41", intf_policy = "lf_1G", from_port = 1, to_port = 41 }
  }
  
  leaf_profiles = {
    prof1 = { name = "leaf103", leaf_interface_profile = ["demo_prof"], leaf_selectors = ["leaf103_sel"] },
    prof2 = { name = "leaf104", leaf_interface_profile = ["demo_prof"], leaf_selectors = ["leaf104_sel"] },
    prof3 = { name = "leaf105", leaf_interface_profile = ["demo_prof"], leaf_selectors = ["leaf105_sel"] }
  }
  
  leaf_selectors = {
    sel1 = { name = "leaf103_sel", leaf_profile = "leaf103", switch_association_type = "range", block = "103", from = "103", to = "103" },
    sel2 = { name = "leaf104_sel", leaf_profile = "leaf104", switch_association_type = "range", block = "104", from = "104", to = "104" },
    sel3 = { name = "leaf105_sel", leaf_profile = "leaf105", switch_association_type = "range", block = "105", from = "105", to = "105" }
  }
  
  leaf_interface_profiles = {
    prof1 = { name = "demo_prof" }
  }
}
```