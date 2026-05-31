@allowed([
  'nonprod'
  'prod'
])

param environmentType string

@secure()
param sqlServerAdministratorPassword string

@secure()
param sqlServerAdministratorUsername string

param location string = (environmentType == 'prod') ? 'southeastasia' : 'eastasia'

param auditStorageAccountName string

var AuditingEnabled = environmentType == 'prod'



resource sqlServer 'Microsoft.Sql/servers@2025-02-01-preview' = {
  name: '$toy-sql-${environmentType}'
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorUsername
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}


resource sqlDatabase 'Microsoft.Sql/servers/databases@2025-02-01-preview' = {
  parent: sqlServer
  name: 'toyDB'
  location: location
  sku: {
    name: environmentType == 'prod' ? 'Standard' : 'Basic'
    tier: environmentType == 'prod' ? 'Standard' : 'Basic'
  }
}


resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' existing = if (AuditingEnabled) {
  name: auditStorageAccountName
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2025-02-01-preview' = {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentType == 'prod' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentType == 'prod' ? auditStorageAccount.listKeys().keys[0].value : ''
  }
}


output SQLprimaryEndpoints string = sqlServerAudit.properties.storageEndpoint
output SQLserverAuditname string = sqlServerAudit.name
