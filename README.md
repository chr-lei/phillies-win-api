# Phillies Win API

This is a very basic, proof on concept API that will query Major League Baseball's Stats API to see if the Phillies won today or on a specified date, and return a result in JSON format.

## Code Sucks Disclaimer
The main goal for this project was to get practice with building containers and deploying to Azure Container Apps. Some parts of the project Powershell code are rough, could be modularized, etc., in a production world but were left rough in the name of quickly impelementing the app logic to allow me to focus on the "new" skills related to container deployment. Don't steal this and use it in CompSci 101, you'll fail.

Also - no attempt was made to handle weird baseball things like doubleheaders, suspended games, etc. No idea how it'll react to those, but the intent wasn't to reimplement the entire Stats API here.

TL;DR: I know the backend logic is incomplete and rough and not "good code," and it'll break if you try to break it.

## Public Endpoint
The public endpoint for the API is currently currently [https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json](https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json).

## API Usage
The API is very simple right now - you can call the [endpoint](https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json) without any query parameters to have the API check to see if the Phillies won today.

Alternatively, you can specify a date in yyyy-MM-dd format to check the outcome of the game on a particular date. For example, to check to see if the Phillies won on July 22, 2022, you could call:
[https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json?date=2022-07-22](https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json?date=2022-07-22).

## To-Do's
Next steps for this learning exercise are to:
- Refactor the code to extract the Powershell function into a module.
- Move the logic, routes, and (eventually) tasks into subdirectories, to keep the server.ps1 file clean.
- Implement some CI/CD actions to deploy the ACA infra (using Terraform) and to allow for rapid deployment of new container images when changes are pushed to the repo.