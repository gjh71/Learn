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
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free' 
}
@description('The Azure region into which the resources should be deployed')
param location string = 'westus3'

var appServicePlanName = '${environmentname}-${solutionName}-plan'
var appServiceAppName = '${environmentname}-${solutionName}-app'

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
