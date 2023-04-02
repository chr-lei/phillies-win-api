class GameResult {
    [String]$Status
    [Int]$WinnerId
    [String]$WinnerName
    [Int]$WinnerScore
    [String]$LoserName
    [Int]$LoserScore
    [String]$StartDateTime
    [String]$OfficialDate
}

function New-GameResult {
    <#
    .SYNOPSIS
        Takes game data from the stats API for a particular game
        and reports on the winner and scores.
    
    .PARAMETER GameData
        Game data in JSON format from the Stats API
    #>

    param(
        [Parameter(Mandatory)][PSCustomObject]$GameData
    )

    # Instantiate a GameResult object to hold our findings
    $GameResultObject = [GameResult]::new()

    $GameResultObject.StartDateTime = ($GameData.gameDate)

    # Check to see if the game is a Tie
    # Only needed during Spring Training - come back to this later
    #if ($GameData.isTie) {
    #    $GameResultObject.Result = 'T'
    #}
    
    # Check to see if the game is final
    $IsFinal = ($GameData.status.codedGameState -eq 'F')

    # If the game is final, then look for a winner.
    if ($IsFinal) {
        # Set the game status to (F)inal
        $GameResultObject.Status = 'F'
        # Check if the home team was the winner
        if ($GameData.teams.home.isWinner) {
            # If the home team won, update the GameResult object
            $GameResultObject.WinnerId = $GameData.teams.home.team.id
            $GameResultObject.WinnerName = $GameData.teams.home.team.name
            $GameResultObject.WinnerScore = $GameData.teams.home.score
            $GameResultObject.LoserName = $GameData.teams.away.team.name
            $GameResultObject.LoserScore = $GameData.teams.away.score
        }
        
        # Otherwise, the away team won, so update the object accordingly
        else {
            $GameResultObject.WinnerId = $GameData.teams.away.team.id
            $GameResultObject.WinnerName = $GameData.teams.away.team.name
            $GameResultObject.WinnerScore = $GameData.teams.away.score
            $GameResultObject.LoserName = $GameData.teams.home.team.name
            $GameResultObject.LoserScore = $GameData.teams.home.score
        }
    }
    # Otherwise, update the status to Incomplete; and there's no winners.
    else { $GameResultObject.Status = 'I' }

    return ($GameResultObject)
}

function Get-Games {
    <#
    .SYNOPSIS
        Retrieves an object with game results for the selected date.

    .PARAMETER GameDate
        The calendar date (in string form) to query for game data.
        If not specified, defaults to today's date.
    
    .PARAMETER TeamId
        Required. The numerical ID number of a team whose games
        should be returned.

    .PARAMETER Selector
        Text string used to indicate if the response should include
        all of the team's games on a date (e.g., both games of a doubleheader),
        or only return data from the latest completed game.

    #>
    param (
        [Parameter()][string]$GameDate = (Get-Date -Format 'yyyy-MM-dd'),
        [Parameter(Mandatory)][string]$TeamId,
        [ValidateSet('latest','all')]
        [Parameter()][string]$Selector = 'latest'
    )

    # Specify the MLB Stats API endpoint
    $statsendpoint = "https://statsapi.mlb.com/api/v1/schedule"
    # SportID will always be 1, for MLB
    $sportid = 1

    # Craft a URI based on input data
    $uri = "$statsendpoint`?sportId=$sportid&teamId=$teamid&date=$GameDate"

    # Query the API for games matching the date and team
    $statsresponse = Invoke-RestMethod -Uri $uri -Method Get
    
    # Define an array of JSON objects that we'll ultimately return
    $results = @()

    # Init a counter to tag each game with a sequential number
    $GameCounter = 0

    # If there is only one game scheduled, analyze that game and include
    # it in the results object
    if ($statsresponse.totalGames -eq 1) {
        $GameCounter++
        $results += New-GameResult $statsresponse.dates.games
    }

    # TODO - Implement logic for multiple games

    $ResultsObject = @{
        NumberOfGames = $GameCounter
        GameResults = $results
    }
    return ($ResultsObject)
}
