#  Define data sources

data "mso_site" "site1" {
  name = var.site1
}

data "mso_site" "site2" {
  name = var.site2
}


# Define Tenant

resource "mso_tenant" "tenant" {
  name         = var.tenant.tenant_name
  display_name = var.tenant.display_name
  description  = var.tenant.description

  site_associations {
    site_id = data.mso_site.site1.id
  }
  site_associations {
    site_id = data.mso_site.site2.id
  }

}

# Define schema and template

resource "mso_schema" "schema1" {
  name = var.schema_name
  template {
    name         = var.template1.name
    display_name = var.template1.name
    tenant_id    = mso_tenant.tenant.id
  }
}

output "TN0" {
  value = tolist(mso_schema.schema1.template)[0]
}


resource "mso_schema_site" "site1" {
  schema_id           = mso_schema.schema1.id
  template_name       = tolist(mso_schema.schema1.template)[0].name
  site_id             = data.mso_site.site1.id
  undeploy_on_destroy = true
}

resource "mso_schema_site" "site2" {
  schema_id           = mso_schema.schema1.id
  template_name       = tolist(mso_schema.schema1.template)[0].name
  site_id             = data.mso_site.site2.id
  undeploy_on_destroy = true
}


# Create Stretched VRF
resource "mso_schema_template_vrf" "vrf1" {
  schema_id              = mso_schema.schema1.id
  template               = var.template1.name
  name         = try(var.vrf_name)
  display_name = try(var.vrf_name)
  ip_data_plane_learning = "enabled"
  preferred_group        = true
}

# bd related
resource "mso_schema_template_bd" "bridge_domain" {
  schema_id              = mso_schema.schema1.id
  template_name          = var.template1.name
  name                   = var.bd_name
  display_name           = var.bd_name
  vrf_name               = mso_schema_template_vrf.vrf1.name
  layer2_unknown_unicast = "proxy"
  layer2_stretch         = true
  unicast_routing        = true
}


resource "mso_schema_template_bd_subnet" "sub1" {
  schema_id          = mso_schema.schema1.id
  template_name      = var.template1.name
  bd_name            = mso_schema_template_bd.bridge_domain.name
  ip                 = var.bd_subnet
  description        = var.bd_subnet
  shared             = true
  scope              = "public"
  querier            = true
  no_default_gateway = false
}

resource "mso_schema_template_bd" "bridge_domain2" {
  schema_id              = mso_schema.schema1.id
  template_name          = var.template1.name
  name                   = var.bd_name2
  display_name           = var.bd_name2
  vrf_name               = mso_schema_template_vrf.vrf1.name
  layer2_unknown_unicast = "proxy"
  layer2_stretch         = true
  unicast_routing        = true
}


resource "mso_schema_template_bd_subnet" "sub2" {
  schema_id          = mso_schema.schema1.id
  template_name      = var.template1.name
  bd_name            = mso_schema_template_bd.bridge_domain2.name
  ip                 = var.bd_subnet2
  description        = var.bd_subnet2
  shared             = true
  scope              = "public"
  querier            = true
  no_default_gateway = false
}

## create ANP
resource "mso_schema_template_anp" "anp1" {
  schema_id    = mso_schema.schema1.id
  template     =  var.template1.name
  name         = var.anp_name
  display_name = var.anp_name
}


## create EPG
resource "mso_schema_template_anp_epg" "anp_epg" {
  schema_id                  = mso_schema.schema1.id
  template_name              = var.template1.name
  anp_name                   = mso_schema_template_anp.anp1.name
  name                       = var.epg_name
  display_name               = var.epg_name
  bd_name                    = mso_schema_template_bd.bridge_domain.name
  vrf_name                   = mso_schema_template_vrf.vrf1.name
  preferred_group            = true
}

resource "mso_schema_template_anp_epg" "anp_epg2" {
  schema_id                  = mso_schema.schema1.id
  template_name              = var.template1.name
  anp_name                   = mso_schema_template_anp.anp1.name
  name                       = var.epg_name2
  display_name               = var.epg_name2
  bd_name                    = mso_schema_template_bd.bridge_domain2.name
  vrf_name                   = mso_schema_template_vrf.vrf1.name
  preferred_group            = true
}


# Assign EPG to VMM Domain Site 1
resource "mso_schema_site_anp_epg_domain" "epg_site1_domain" {
  schema_id                = mso_schema.schema1.id
  template_name            = var.template1.name
  site_id                  = data.mso_site.site1.id
  anp_name                 = mso_schema_template_anp.anp1.name
  epg_name                 = mso_schema_template_anp_epg.anp_epg.name
  domain_dn                = "uni/vmmp-VMware/dom-POD1_ACI_DS"
  deploy_immediacy         = "immediate"
  resolution_immediacy     = "immediate"
}

resource "mso_schema_site_anp_epg_domain" "epg_site1_domain2" {
  schema_id                = mso_schema.schema1.id
  template_name            = var.template1.name
  site_id                  = data.mso_site.site1.id
  anp_name                 = mso_schema_template_anp.anp1.name
  epg_name                 = mso_schema_template_anp_epg.anp_epg2.name
  domain_dn                = "uni/vmmp-VMware/dom-POD1_ACI_DS"
  deploy_immediacy         = "immediate"
  resolution_immediacy     = "immediate"
}


# Assign EPG to VMM Domain Site 2
resource "mso_schema_site_anp_epg_domain" "epg_site2_domain" {
  schema_id                = mso_schema.schema1.id
  template_name            = var.template1.name
  site_id                  = data.mso_site.site2.id
  anp_name                 = mso_schema_template_anp.anp1.name
  epg_name                 = mso_schema_template_anp_epg.anp_epg.name
  domain_dn                = var.vmmDom2
  deploy_immediacy         = "immediate"
  resolution_immediacy     = "immediate"
}

resource "mso_schema_site_anp_epg_domain" "epg_site2_domain2" {
  schema_id                = mso_schema.schema1.id
  template_name            = var.template1.name
  site_id                  = data.mso_site.site2.id
  anp_name                 = mso_schema_template_anp.anp1.name
  epg_name                 = mso_schema_template_anp_epg.anp_epg2.name
  domain_dn                = var.vmmDom2
  deploy_immediacy         = "immediate"
  resolution_immediacy     = "immediate"
}
