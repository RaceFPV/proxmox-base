provider "proxmox" {
  pm_api_url = var.PROX_URL
  pm_api_token_id = var.PROX_ID
  pm_api_token_secret = var.PROX_SECRET
}