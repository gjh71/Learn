@description('The name of the environment. Choose from dev/test/prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentname string ='dev'

@description('The unique name of the solution. Used to ensure that resource names are unique')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the app-service-plan sku')
param appServicePlanSku object

@description('The Azure region into which the resources should be deployed')
param location string = 'westus3'

@description('Admin login')
@secure()
param sqlServerAdministratorLogin string

@description('The admin password')
@secure()
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL db')
param sqlDatabaseSku object

var appServicePlanName = '${environmentname}-${solutionName}-plan'
var appServiceAppName = '${environmentname}-${solutionName}-app'
var sqlServerName = '${environmentname}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' ={
  name: appServicePlanName
  location: location
  properties: {}
  sku:{
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2020-06-01'={
  name: appServiceAppName
  location: location
  properties:{
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties:{
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}
