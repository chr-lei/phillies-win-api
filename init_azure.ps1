Param (
   [Parameter(ValueFromPipelineByPropertyName)]
   [string] $Location = "eastus"
)

$RESOURCE_GROUP_NAME='tfstate'
$STORAGE_ACCOUNT_NAME="tfstate$(Get-Random)"
$CONTAINER_NAME='tfstate'
$LOCATION=$Location

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME 

echo @"
$RESOURCE_GROUP_NAME
$STORAGE_ACCOUNT_NAME
$CONTAINER_NAME
$LOCATION
"@

$subscription_id=$(Get-AzSubscription).id

az ad sp create-for-rbac --name "Did-Phillies-Win" --role contributor `
--scopes "/subscriptions/$subscription_id" `
--sdk-auth > AZURE_CREDNTIALS.json

cat AZURE_CREDNTIALS.json