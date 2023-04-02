$subscription_id=$(Get-AzSubscription).id

az ad sp create-for-rbac --name "Did-Phillies-Win" --role contributor `
--scopes "/subscriptions/$subscription_id" `
--sdk-auth > AZURE_CREDNTIALS.json
