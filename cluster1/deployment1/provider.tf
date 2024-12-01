provider "proxmox" {
  pm_api_url = var.PROX_URL
  pm_api_token_id = var.PROX_ID
  pm_api_token_secret = var.PROX_SECRET
}

provider "powerdns" {
  server_url = "http://10.0.0.10:8081"
  insecure_https = true
  api_key = var.PDNS_SECRET
}