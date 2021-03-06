resource "aci_vlan_pool" "aci_vlan_pools" {
  for_each    = var.vlan_pools
  name        = each.value.vlan_name
  alloc_mode  = contains(keys(each.value), "alloc_mode") ? each.value.alloc_mode : null
  annotation  = contains(keys(each.value), "annotation") ? each.value.annotation : null
  name_alias  = contains(keys(each.value), "name_alias") ? each.value.name_alias : null
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_ranges" "aci_vlan_pools_ranges" {
  for_each     = var.vlan_pools_ranges
  vlan_pool_dn = element([for item in aci_vlan_pool.aci_vlan_pools : item.id if item.name == each.value.vlan_pool_name], 0)
  from         = contains(keys(each.value), "from") ? each.value.from : null
  to           = contains(keys(each.value), "to") ? each.value.to : null
  alloc_mode   = contains(keys(each.value), "alloc_mode") ? each.value.alloc_mode : null
  role         = contains(keys(each.value), "role") ? each.value.role : null
  description  = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_physical_domain" "aci_physical_domains" {
  for_each                  = var.physical_domains
  name                      = each.value.name
  relation_infra_rs_vlan_ns = contains(keys(each.value), "vlan_pool") ? element([for item in aci_vlan_pool.aci_vlan_pools : item.id if item.name == each.value.vlan_pool], 0) : null
}

resource "aci_fabric_if_pol" "link_level_policies" {
  for_each    = var.link_level_policies
  name        = each.value.name
  auto_neg    = contains(keys(each.value), "auto_neg") ? each.value.auto_neg : null
  fec_mode    = contains(keys(each.value), "fec_mode") ? each.value.fec_mode : null
  speed       = contains(keys(each.value), "speed") ? each.value.speed : null
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_cdp_interface_policy" "aci_cdp_interface_policies" {
  for_each    = var.cdp_policies
  name        = each.value.name
  admin_st    = each.value.admin_st
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_lldp_interface_policy" "aci_lldp_policies" {
  for_each    = var.lldp_policies
  name        = each.value.name
  admin_rx_st = each.value.receive_state
  admin_tx_st = each.value.trans_state
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_lacp_policy" "lacp_policies" {
  for_each    = var.lacp_policies
  name        = each.value.name
  mode        = each.value.mode
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_attachable_access_entity_profile" "aci_aaeps" {
  for_each                = var.aaeps
  name                    = each.value.name
  relation_infra_rs_dom_p = [for domain in each.value.physical_domains : element([for item in aci_physical_domain.aci_physical_domains : item.id if item.name == domain], 0)]
  description             = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_access_port_selector" "aci_access_port_selectors" {
  for_each                       = var.access_port_selectors
  leaf_interface_profile_dn      = element([for item in aci_leaf_interface_profile.aci_leaf_interface_profiles : item.id if item.name == each.value.intf_prof], 0)
  name                           = each.value.name
  access_port_selector_type      = contains(keys(each.value), "access_port_selector_type") ? each.value.access_port_selector_type : "range"
  relation_infra_rs_acc_base_grp = contains(keys(each.value), "intf_policy") ? element([for item in aci_leaf_access_port_policy_group.aci_leaf_access_port_policy_groups : item.id if item.name == each.value.intf_policy], 0) : null
  description                    = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_access_port_block" "aci_access_port_blocks" {
  for_each                = var.access_port_selectors
  access_port_selector_dn = aci_access_port_selector.aci_access_port_selectors[each.key].id
  from_card               = contains(keys(each.value), "from_card") ? each.value.from_card : null
  to_card                 = contains(keys(each.value), "from_card") ? each.value.from_card : null
  from_port               = contains(keys(each.value), "from_port") ? each.value.from_port : null
  to_port                 = contains(keys(each.value), "to_port") ? each.value.to_port : null
  description             = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_leaf_access_port_policy_group" "aci_leaf_access_port_policy_groups" {
  for_each                      = var.leaf_access_policy_groups
  name                          = each.value.name
  relation_infra_rs_att_ent_p   = contains(keys(each.value), "aaep") ? element([for item in aci_attachable_access_entity_profile.aci_aaeps : item.id if item.name == each.value.aaep], 0) : null
  relation_infra_rs_cdp_if_pol  = contains(keys(each.value), "cdp_policy") ? element([for item in aci_cdp_interface_policy.aci_cdp_interface_policies : item.id if item.name == each.value.cdp_policy], 0) : null
  relation_infra_rs_lldp_if_pol = contains(keys(each.value), "lldp_policy") ? element([for item in aci_lldp_interface_policy.aci_lldp_policies : item.id if item.name == each.value.lldp_policy], 0) : null
  relation_infra_rs_h_if_pol    = contains(keys(each.value), "link_level_policy") ? element([for item in aci_fabric_if_pol.link_level_policies : item.id if item.name == each.value.link_level_policy], 0) : null
  description                   = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_leaf_interface_profile" "aci_leaf_interface_profiles" {
  for_each    = var.leaf_interface_profiles
  name        = each.value.name
  description = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_leaf_profile" "aci_leaf_profiles" {
  for_each                     = var.leaf_profiles
  name                         = each.value.name
  relation_infra_rs_acc_port_p = [for profile in each.value.leaf_interface_profile : element([for item in aci_leaf_interface_profile.aci_leaf_interface_profiles : item.id if item.name == profile], 0)]
  description                  = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_leaf_selector" "leaf_selectors" {
  for_each                = var.leaf_selectors
  leaf_profile_dn         = element([for item in aci_leaf_profile.aci_leaf_profiles : item.id if item.name == each.value.leaf_profile], 0)
  name                    = each.value.name
  switch_association_type = each.value.switch_association_type
  description             = contains(keys(each.value), "desc") ? each.value.desc : null
}

resource "aci_node_block" "node_blocks" {
  for_each              = var.leaf_selectors
  switch_association_dn = element([for item in aci_leaf_selector.leaf_selectors : item.id if item.name == each.value.name], 0)
  name                  = each.value.block
  from_                 = each.value.from
  to_                   = each.value.to
  description           = contains(keys(each.value), "desc") ? each.value.desc : null
}