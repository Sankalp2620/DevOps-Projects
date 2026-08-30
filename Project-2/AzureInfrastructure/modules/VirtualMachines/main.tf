resource "azurerm_public_ip" "vm_public_ip" {
  for_each = { for name, cfg in var.vm_configs : name => cfg if cfg.enabled && cfg.public_ip }

  name                = "${each.key}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "vm_nsg" {
  for_each = { for name, cfg in var.vm_configs : name => cfg if cfg.enabled }

  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.allow_ssh ? [1] : []
    content {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = each.value.allow_http ? [1] : []
    content {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_interface" "vm_nic" {
  for_each = { 
    for name, cfg in var.vm_configs : name => cfg if cfg.enabled 
  }
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_ids[each.value.subnet_key]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip ? azurerm_public_ip.vm_public_ip[each.key].id : null
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nic_association" {
  for_each = { 
    for name, cfg in var.vm_configs : name => cfg if cfg.enabled 
  }

  network_interface_id      = azurerm_network_interface.vm_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.vm_nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = { 
    for name, cfg in var.vm_configs : name => cfg if cfg.enabled 
  }

  name                            = each.key
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = each.value.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.vm_nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Environment = "Dev"
    Role        = each.key
  }
}
