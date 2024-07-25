variable "vms" {
  description = "List of VM configurations"
  type = list(object({
    name          = string
    vm_size       = string
    admin_username = string
    admin_password = string
  }))
  default = [
    {
      name          = "vm1"
      vm_size       = "Standard_DS1_v2"
      admin_username = "adminuser1"
      admin_password = "Password1234!"
    },
    {
      name          = "vm2"
      vm_size       = "Standard_DS1_v2"
      admin_username = "adminuser2"
      admin_password = "Password1234!"
    },
    {
      name          = "vm3"
      vm_size       = "Standard_DS1_v2"
      admin_username = "adminuser3"
      admin_password = "Password1234!"
    }
  ]
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_virtual_network.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  for_each            = { for vm in var.vms : vm.name => vm }
  name                = "${each.key}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  for_each                = { for vm in var.vms : vm.name => vm }
  name                    = each.key
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  network_interface_ids   = [azurerm_network_interface.example[each.key].id]
  vm_size                 = each.value.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${each.key}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = each.key
    admin_username = each.value.admin_username
    admin_password = each.value.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name = each.key
  }
}
