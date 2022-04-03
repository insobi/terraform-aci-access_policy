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
    range1 = { vlan_pool_name = "demo-vlan", from = "vlan-2500", to = "vlan-2600", alloc_mode = "static" }
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.4 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.1.0 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vlan_pools"></a> [vlan_pools](#input\_vlan_pools) | VLAN Pools | <pre>map(object({<br> name        = string,<br> alloc_mode  = string<br>}))</pre> | `{}` | no |
| <a name="input_vlan_pools_ranges"></a> [vlan_pools_ranges](#input\_vlan_pools_ranges) | VLAN pool ranges | <pre>map(object({<br> vlan_pool_name = string,<br> from           = string,<br> to             = string,<br> alloc_mode     = string<br>}))</pre> | `{}` | no |
| <a name="input_physical_domains"></a> [physical_domains](#input\_physical_domains) | Physical domains | <pre>map(object({<br> name       = string,<br> vlan_pool  = string<br>}))</pre> | `{}` | no |
| <a name="input_cdp_policies"></a> [cdp_policies](#input\_cdp_policies) | CDP policies | <pre>map(object({<br> name     = string,<br> admin_st = string<br>}))</pre> | `{}` | no |
| <a name="input_lldp_policies"></a> [lldp_policies](#input\_lldp_policies) | LLDP policies | <pre>map(object({<br> name          = string,<br> receive_state = string,<br> trans_state   = string<br>}))</pre> | `{}` | no |
| <a name="input_lacp_policies"></a> [lacp_policies](#input\_lacp_policies) | LACP policies | <pre>map(object({<br> name = string,<br> mode = string<br>}))</pre> | `{}` | no |
| <a name="input_link_level_policies"></a> [link_level_policies](#input\_link_level_policies) | Link level policies | <pre>map(object({<br> name     = string,<br> auto_neg = string,<br> speed    = string<br>}))</pre> | `{}` | no |
| <a name="input_aaeps"></a> [aaeps](#input\_aaeps) | AAEPs | <pre>map(object({<br> name             = string,<br> physical_domains = list(string)<br>}))</pre> | `{}` | no |
| <a name="input_leaf_access_policy_groups"></a> [leaf_access_policy_groups](#input\_leaf_access_policy_groups) | Leaf access policy groups | <pre>map(object({<br> name              = string,<br> cdp_policy        = string,<br> aaep              = string,<br> lldp_policy       = string,<br> link_level_policy = string<br>}))</pre> | `{}` | no |
| <a name="input_leaf_interface_profiles"></a> [leaf_interface_profiles](#input\_leaf_interface_profiles) | Leaf interface profiles | <pre>map(object({<br> name = string<br>}))</pre> | `{}` | no |
| <a name="input_access_port_selectors"></a> [access_port_selectors](#input\_access_port_selectors) | Access port selectors | <pre>map(object({<br> name        = string,<br> intf_prof   = string,<br> intf_policy = string,<br> from_port   = string,<br> to_port     = string<br>}))</pre> | `{}` | no |
| <a name="input_leaf_profiles"></a> [leaf_profiles](#input\_leaf_profiles) | Leaf profiles | <pre>map(object({<br> name                   = string,<br> leaf_interface_profile = list(string),<br> leaf_selectors         = list(string)<br>}))</pre> | `{}` | no |
| <a name="input_leaf_selectors"></a> [leaf_selectors](#input\_leaf_selectors) | Leaf selectors | <pre>map(object({<br> name                    = string,<br> leaf_profile            = string,<br> switch_association_type = string,<br> block                   = string,<br> from                    = string,<br> to                      = string<br>}))</pre> | `{}` | no |


## Outputs
TBD

## Resources

| Name | Type |
|------|------|
| [aci_access_port_block.aci_access_port_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_block) | resource |
| [aci_access_port_selector.aci_access_port_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_selector) | resource |
| [aci_attachable_access_entity_profile.aci_aaeps](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/attachable_access_entity_profile) | resource |
| [aci_cdp_interface_policy.aci_cdp_interface_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/cdp_interface_policy) | resource |
| [aci_fabric_if_pol.link_level_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_if_pol) | resource |
| [aci_lacp_policy.lacp_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lacp_policy) | resource |
| [aci_leaf_access_port_policy_group.aci_leaf_access_port_policy_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_port_policy_group) | resource |
| [aci_leaf_interface_profile.aci_leaf_interface_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_interface_profile) | resource |
| [aci_leaf_profile.aci_leaf_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_profile) | resource |
| [aci_leaf_selector.leaf_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_selector) | resource |
| [aci_lldp_interface_policy.aci_lldp_policies](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lldp_interface_policy) | resource |
| [aci_node_block.node_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/node_block) | resource |
| [aci_physical_domain.aci_physical_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/physical_domain) | resource |
| [aci_ranges.aci_vlan_pools_ranges](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/ranges) | resource |
| [aci_vlan_pool.aci_vlan_pools](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vlan_pool) | resource |