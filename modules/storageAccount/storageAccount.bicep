@allowed([
'nonprod'
'prod'
])
param environmentType string


param DBstorageAccountDetails object = {
    locations: (environmentType == 'prod') ? 'southeastasia' : 'eastasia'
    sku: (environmentType == 'prod') ? 'Standard_LRS' : 'Standard_GRS'
    kind: 'StorageV2'
    accesstier: 'Hot'
}


var resourceTags object = {
  createdBy: 'Rom John Awacay'
  purpose: 'Gods Plan'
}


resource DBstorageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = [ for i in range(0,2) :{
  name: 'std${environmentType}${uniqueString(resourceGroup().id)}${i}'
  location: DBstorageAccountDetails.locations
  sku: {
    name: DBstorageAccountDetails.sku
  }
  properties: {
    accessTier: DBstorageAccountDetails.accesstier
  }
  kind: DBstorageAccountDetails.kind
  tags: resourceTags
  }
]

resource regStorageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = [ for i in range(0,2) :{
  name: 'str${environmentType}${uniqueString(resourceGroup().id)}${i}'
  location: DBstorageAccountDetails.locations
  sku: {
    name: DBstorageAccountDetails.sku
  }
  properties: {
    accessTier: DBstorageAccountDetails.accesstier
  }
  kind: DBstorageAccountDetails.kind
  tags: resourceTags
  }
]
