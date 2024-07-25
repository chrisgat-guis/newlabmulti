provider "azurerm" {
  features {}
  subscription_id = "d0d9fafe-a05d-4370-b02d-80ad27214fe6"
  client_id       = "26d7dee8-6955-45fc-9843-bfbd5fd7b261"
  client_secret   = "NQk8Q~2hgU5e5oa8wC9BjUE2fPj47fCkJ8QMLcIj"
  tenant_id       = "c2463e1c-f0be-495d-a3fe-08b347657032"
}

terraform {
backend "azurerm" {
resource_group_name = "Storage_RG"
storage_account_name = "chrisgstoracc2"
container_name = "christest"
key = "myterra33.tfstate"
  subscription_id = "d0d9fafe-a05d-4370-b02d-80ad27214fe6"
  client_id       = "26d7dee8-6955-45fc-9843-bfbd5fd7b261"
  client_secret   = "NQk8Q~2hgU5e5oa8wC9BjUE2fPj47fCkJ8QMLcIj"
  tenant_id       = "c2463e1c-f0be-495d-a3fe-08b347657032"
}
}