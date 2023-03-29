function Get-Games {
    <#
    .SYNOPSIS
        Retrieves an array of game objects for a specified date,
        in JSON format.

    .PARAMETER GameDate
        The calendar date (in string form) to query for game data
    
    .PARAMETER TeamId
        Required. The numerical ID number of a team whose games
        should be returned.

    #>
    param (
        [Parameter()][string]$GameDate = (Get-Date -Format "yyyy-MM-dd"),
        [Parameter(Mandatory)][Int32]$TeamId
    )
}
function Get-PhilliesResult {
    param (
        [Parameter()][string]$gamedate = (Get-Date -Format "yyyy-MM-dd")
    )

    # Set parameters needed for the Statsapi query
    $endpoint = "https://statsapi.mlb.com/api/v1/schedule" 
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
                    text = 'The Phillies won!'
                    date = $gamedate
                }
            }
            else {
                $gameresult = @{
                    outcome = 'L'
                    text = 'The Phillies lost. This is bullshit.'
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
            text = "The Phillies didn't play today. The hell goin' on?"
            date = $gamedate
        }
        Write-PodeJsonResponse -Value (ConvertTo-Json -InputObject $gameresult)
    }

}