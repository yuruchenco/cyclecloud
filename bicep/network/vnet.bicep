param location string = resourceGroup().location
param tags object = {}

param vnetName string
param vnetAddressPrefix string = ''

resource vnet 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

output vnet object = vnet
output vnetId string = vnet.id
output vnetName string = vnet.name
