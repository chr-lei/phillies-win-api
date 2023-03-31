# Did They Win API

This is a very basic, proof on concept API that will query Major League Baseball's Stats API to see if a Major League Baseball team won today or on a specified date, and return a result in JSON format.

It originally only cared about the Phillies, but now it'll look up any team.

## Code Sucks Disclaimer
The main goal for this project was to get practice with building containers and deploying to Azure Container Apps. Some parts of the project Powershell code are rough, could be modularized, etc., in a production world but were left rough in the name of quickly impelementing the app logic to allow me to focus on the "new" skills related to container deployment. Don't steal this and use it in CompSci 101, you'll fail.

Also - minimal attempt was made to handle weird baseball things like doubleheaders, suspended games, etc. No idea how it'll react to those, but the intent wasn't to reimplement the entire Stats API here.

TL;DR: I know the backend logic is incomplete and rough and not "good code," and it'll break if you try to break it.

## API Usage
The API is very simple right now - you can call the endpoint with a TeamID parameter to check the schedule for today's games for that team. For example, to see if the Phillies won today, you could use [https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json?team=143](https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/api/json?team=143).

Alternatively, you can also specify a date in yyyy-MM-dd format to check the outcome of the game on a particular date. For example, to check to see if the Phillies won on July 22, 2022, you could call:
[https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/json?date=2022-07-22&team=143](https://phillies-prod.thankfulbush-cea20cfa.eastus2.azurecontainerapps.io/api/json?date=2022-07-22&team=143).

## To-Do's
Next steps for this learning exercise are to:
- Refactor the code to extract the Powershell function into a separate module/file.
- Move the logic, routes, and (eventually) tasks into subdirectories, to keep the server.ps1 file clean.
- Implement some CI/CD actions to deploy the ACA infra (using Terraform) and to allow for rapid deployment of new container images when changes are pushed to the repo.

## Team IDs
To save you the hassle of figuring out the structure of the Stats API, whose documentation is behind lock and key, here's a table with team ID's (current as of 3/29/23).
| Team Name | Team ID |
| --- | --- |
| Arizona Diamondbacks | 109 |
| Atlanta Braves | 144 |
| Baltimore Orioles | 110 |
| Boston Red Sox | 111 |
| Chicago Cubs | 112 |
| Chicago White Sox | 145 |
| Cincinnati Reds | 113 |
| Cleveland Guardians | 114 |
| Colorado Rockies | 115 |
| Detroit Tigers | 116 |
| Houston Astros | 117 |
| Kansas City Royals | 118 |
| Los Angeles Angels | 108 |
| Los Angeles Dodgers | 119 |
| Miami Marlins | 146 |
| Milwaukee Brewers | 158 |
| Minnesota Twins | 142 |
| New York Mets | 121 |
| New York Yankees | 147 |
| Oakland Athletics | 133 |
| Philadelphia Phillies | 143 |
| Pittsburgh Pirates | 134 |
| San Diego Padres | 135 |
| San Francisco Giants | 137 |
| Seattle Mariners | 136 |
| St. Louis Cardinals | 138 |
| Tampa Bay Rays | 139 |
| Texas Rangers | 140 |
| Toronto Blue Jays | 141 |
| Washington Nationals | 120 |