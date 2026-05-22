@allowed([
  'prod'
  'nonprod'
])

param environmentType string

param appServicePlanProperties object = {
  tier: 'basic'
  capacity: '1'
  kind: 'app' //regular webapp
}

param resourceTags object = {
  createdBy: 'Rom John Awacay'
  purpose: 'Gods Plan'
}

param locations array = [
  'southeastasia'
  'eastasia'
  'westeurope'
]

var webAppPlanName string = 'toyplan-${environmentType}'
var appServiceName string = 'toy-web-${environmentType}'
var webAppPlansku string = (environmentType == 'prod') ? 'F1' : 'B1'

resource webAppPlan 'Microsoft.Web/serverfarms@2025-03-01' = [ for (location, i) in locations: {
  name: '${webAppPlanName}-${location}'
  location: location
  sku: {
    capacity: appServicePlanProperties.capacity
    tier: appServicePlanProperties.tier
    name: webAppPlansku
    }
  kind: appServicePlanProperties.kind
  tags: resourceTags
  }
]

resource appService 'Microsoft.Web/sites@2025-03-01' = [ for (location, i) in locations: {
  name: '${appServiceName}-${location}' 
  location: location
  properties: {
    serverFarmId: webAppPlan[i].id
    httpsOnly: true
    }
  }
]

output appServiceDetails array = [ for i in range (0, length(locations)): {
  defaulthostname: appService[i].properties.defaultHostName
  location: appService[i].location
  }
]
