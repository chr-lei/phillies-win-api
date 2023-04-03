# Add an route for /json that returns a JSON response
Add-PodeRoute -Method Get -Path '/api/text' -ScriptBlock {
    # Set the sarcasm parameter if specified in the query string
    if ($WebEvent.Query['Sarcasm'] -eq 'True') { $Sarcasm = $True}
    else { $Sarcasm = $False }
    
    # Set the game selector to 'latest'
    # TODO - support text responses for multiple games
    $Selector = 'latest'

    # Get a game result for the latest game
    $Results = Get-Games -TeamId $WebEvent.Query['Team'] `
        -GameDate $WebEvent.Query['Date'] `
        -Selector $Selector

    # If there isn't a final or in-progress game on the given date, look back one day and retry
    if ($Results.GameResults.Status -notin @("I","F")) {
        $OneDayTimespan = New-TimeSpan -Days 1
        $OriginalDate = (($WebEvent.Query['Date']) | Get-Date)
        $NewDate = ($OriginalDate.Subtract($OneDayTimespan)).ToString('yyyy-MM-dd')

        $Results = Get-Games -TeamId $WebEvent.Query['Team'] `
        -GameDate $NewDate `
        -Selector $Selector

        # If we still didn't find a final or in-progress game, 
        #give up for now and return the original result.
        if ($Results.GameResults.Status -notin @("I","F")) {
            $Results = Get-Games -TeamId $WebEvent.Query['Team'] `
            -GameDate $WebEvent.Query['Date'] `
            -Selector $Selector
        }
    }
    
    # Generate a text response and write as a PodeTextResponse

    $TextResponse = New-WinnerTextResponse -TeamId $WebEvent.Query['Team'] `
        -Sarcasm $Sarcasm `
        -ResultData $Results.GameResults
    Write-PodeTextResponse -Value $TextResponse
}