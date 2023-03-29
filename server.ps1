function Get-PhilliesResult {
    # Set parameters needed for the Statsapi query
    $endpoint = "https://statsapi.mlb.com/api/v1/schedule"
    $gamedate = Get-Date -Format "yyyy-MM-dd"
    $teamid = 143
    $sportid = 1

    $uri = "$endpoint`?sportId=$sportid&teamid=$teamid&date=$gamedate"
    $response = Invoke-RestMethod -Uri $uri -Method Get

    # Parse the JSON response from Statsapi and find a Phillies game if they played.
    $gamefound = $false
    foreach ($game in $response.dates.games) {
        if ($game.teams.home.team.id -eq $teamid -or $game.teams.away.team.id -eq $teamid) {
            # We found a Phillies game. What happened?
            $gamefound = $true
            $gameresult = $null
            
            if ($game.teams.home.isWinner) {
                $winner = $game.teams.home.team.id
            }
            if ($game.teams.away.isWinner) {
                $winner = $game.teams.home.team.id
            }

            if ($winner -eq $teamid) {
                $gameresult = @{
                    outcome = 'W'
                    mood = 'Elated'
                    date = $gamedate
                }
            }
            else {
                $gameresult = @{
                    outcome = 'L'
                    mood = 'Miserable'
                    date = $gamedate
                }
            }
            Write-PodeJsonResponse -Value (ConvertTo-Json -InputObject $gameresult)
        }
    }

    if (-not $gamefound) {
        # We didn't find a Phillies game.
        $gameresult = @{
            outcome = 0
            mood = 'Confused'
            date = $gamedate
        }
        Write-PodeJsonResponse -Value (ConvertTo-Json -InputObject $gameresult)
    }

}

Start-PodeServer {
    # Add a plain HTTP endpoint
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http

    # Log to the terminal for debugging
    # New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging

    # Add an route for /json that returns a JSON response
    Add-PodeRoute -Method Get -Path '/json' -ScriptBlock {
        Get-PhilliesResult
    }

}
