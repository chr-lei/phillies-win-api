function Get-Games {
    <#
    .SYNOPSIS
        Retrieves an array of game objects for a specified date,
        in JSON format.

    .PARAMETER GameDate
        The calendar date (in string form) to query for game data.
        If not specified, defaults to today's date.
    
    .PARAMETER TeamId
        Required. The numerical ID number of a team whose games
        should be returned.

    #>
    param (
        [Parameter()][string]$GameDate = (Get-Date -Format "yyyy-MM-dd"),
        [Parameter(Mandatory)][string]$TeamId
    )

    # Specify the MLB Stats API endpoitn
    $statsendpoint = "https://statsapi.mlb.com/api/v1/schedule"
    # SportID will always be 1, for MLB
    $sportid = 1

    # Craft a URI based on input data
    $uri = "$statsendpoint`?sportId=$sportid&teamId=$teamid&date=$gamedate"

    # Query the API for games matching the date and team
    $statsresponse = Invoke-RestMethod -Uri $uri -Method Get
    
    # Define an array of JSON objects that we'll ultimately return
    $results = @()

    # Init a counter to tag each game with a sequential number
    $gamecounter = 0

    foreach ($game in $statsresponse.dates.games) {
        $gamecounter++

        # Check for ties (Spring Training) first
        if ($game.isTie -eq $True) {
            $winnerid = 0
        }
        # Check if the home team was a winner
        elseif ($game.teams.home.isWinner) {
            $winnerid = $game.teams.home.team.id
            $winnername = $game.teams.home.team.name
            $losername = $game.teams.away.team.name
        }
        # If it's not a tie and not a home team win, away won.
        else {
            $winnerid = $game.teams.away.team.id
            $winnername = $game.teams.away.team.name
            $losername = $game.teams.home.team.name
        }

        # Now build a result object
        # First check for a tie
        if ($winnerid -eq 0) {
            $resultobj = @{
                Outcome = "Tie"
                Date = $GameDate
                GameNumber = $gamecounter
                TextResult = "The game between $($game.teams.away.team.name) and $($game.teams.home.team.name) ended in a tie."
            }
            $results += $resultobj
        }
        # If the specified team won
        elseif ($winnerid -eq $teamid) {
            $resultobj = @{
                Outcome = "Win"
                Date = $GameDate
                GameNumber = $gamecounter
                TextResult = "The $($winnername) beat the $($losername)! Grease the damn light poles!"
            }
            $results += $resultobj
        }

        # If the bad guys won
        elseif ($winnerid -ne $TeamId) {
            $resultobj = @{
                Outcome = "Loss"
                Date = $GameDate
                GameNumber = $gamecounter
                TextResult = "Damnit, the $($winnername) won."
            }
            $results += $resultobj
        }
        
    }

    return ($results | ConvertTo-Json)
}
