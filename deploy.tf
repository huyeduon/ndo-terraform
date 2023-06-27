# Deploy Template

resource "mso_schema_template_deploy_ndo" "template1_deployer" {
  schema_id     = mso_schema.schema1.id
  template_name = var.template1.name
  depends_on = [
    mso_tenant.tenant,
    mso_schema.schema1,
    mso_schema_site.site1,
    mso_schema_site.site2,
    mso_schema_template_vrf.vrf1,
    mso_schema_template_anp.anp1,
    mso_schema_template_bd.bridge_domain,
    mso_schema_template_bd.bridge_domain2,
    mso_schema_template_bd_subnet.sub1,
    mso_schema_template_bd_subnet.sub2,
    mso_schema_template_anp_epg.anp_epg,
    mso_schema_site_anp_epg_domain.epg_site1_domain,
    mso_schema_site_anp_epg_domain.epg_site1_domain2,
    mso_schema_site_anp_epg_domain.epg_site2_domain,
    mso_schema_site_anp_epg_domain.epg_site2_domain2
  ]
  re_deploy = true
}

