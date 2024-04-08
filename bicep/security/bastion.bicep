param location string
param bastionName string
param sku string
param vnetName string
param bastionSubnetAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'AzureBastionSubnet'
  parent: virtualNetwork
  properties: {
    addressPrefix: bastionSubnetAddressPrefix
  }  
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'pip-${bastionName}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bast01 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: bastionName
  location: location
  sku: {
    name: sku
  }
  properties: (sku == 'Standard' || sku == 'Basic') ? {
    scaleUnits: 2
    enableTunneling: true
    ipConfigurations: [ {
      name:'pip-${bastionName}'
      properties: {
        subnet:  { id: subnet.id }
        publicIPAddress: { id: pip.id }
      }
    }]
  } : {

  }
}
