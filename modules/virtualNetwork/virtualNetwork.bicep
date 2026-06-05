@description('vnet deployment')

param vnetlist array = [
  {
    name: 'toy'
    location: 'southeastasia'
    addressSpace: '10.0.0.0/16'
    environmentType: 'prod'
    subnet: [
      {
        name: 'VM'
        ipAddressRange: '10.0.1.0/24'
      }
      {
        name: 'VMSS'
        ipAddressRange: '10.0.2.0/24'
      }
      {
        name: 'Database'
        ipAddressRange: '10.0.3.0/24'
      }
      {
        name: 'AzureFirewallSubnet'
        ipAddresRange: '10.0.4.0/24'
      }
    ]
  }
  {
    name: 'toy'
    location: 'eastasia'
    addressSpace: '10.1.0.0/16'
    environmentType: 'nonprod'
    subnet: [
      {
        name: 'VM-nonprod'
        ipAddressRange: '10.1.1.0/24'
      }
      {
        name: 'VMSS-nonprd'
        ipAddressRange: '10.1.2.0/24'
      }
      {
        name: 'Database-nonprod'
        ipAddressRange: '10.1.3.0/24'
      }
      {
        name: 'AzureFirewallSubnet'
        ipAddressRange: '10.1.4.0/24'
      }
    ]
  }
]


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = [ for vnet in vnetlist: {
  name: '${vnet.name}${vnet.environmentType}'
  location: vnet.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet.addressSpace
      ]
    }
    subnets: [ for subnet in vnet.subnet: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.ipAddressRange
          }
        }
      ]
    }
  }
]



output vnetOutput array = [ for i in range(0, length(vnetlist)): {
  name: virtualNetwork[i].name
  location: virtualNetwork[i].location
  id: virtualNetwork[i].id
  vnetaddress: virtualNetwork[i].properties.addressSpace
  subnet: virtualNetwork[i].properties.subnets
}]
