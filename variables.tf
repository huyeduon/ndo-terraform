#  Define variables (can also put this block in a file named terraform.tfvars)
#  Default values can be defined here, which can be overwritten by values defined in terraform.tfvars
#  You can also create a overwrite.tf file where you can keep confidential values

variable "creds" {
  type = map(any)
  default = {
    username = "someuser"
    password = "something"
    url      = "someurl"
    #domain   = "remoteuserRadius" # comment out if using local ND user instead of remote user
  }
}


# Site names as seen on Nexus Dashboard

variable "site1" {
  type    = string
  default = "POD1 ACI"
}

variable "site2" {
  type    = string
  default = "POD2 ACI"
}


# Tenant
variable "tenant" {
  type = map(any)
  default = {
    tenant_name  = "somename"
    display_name = "somename"
    description  = "somename"
  }
}

# Template & Schema
variable "template1" {
  type = map(any)
  default = {
    name         = "something"
    display_name = "something"
  }
}

variable "schema_name" {
  type    = string
  default = "somename"
}

variable "vrf_name" {
  type    = string
  default = "something"
}

# BD related
variable "bd_name" {
  type    = string
  default = "bd1"
}

variable "bd_name2" {
  type    = string
  default = "bd2"
}

variable "bd_subnet" {
  type    = string
  default = "somevalue"
}

variable "bd_subnet2" {
  type    = string
  default = "somevalue"
}


# App
variable "anp_name" {
  type    = string
  default = "some value"
}

variable "epg_name" {
  type    = string
  default = "some value"
}


variable "epg_name2" {
  type    = string
  default = "some value"
}

# VMM information
variable "vmmDom1" {
  description = "Name of VMM domain in ACI Site 1"
}

variable "vmmDom2" {
  description = "Name of VMM domain in ACI Site 2"
}


