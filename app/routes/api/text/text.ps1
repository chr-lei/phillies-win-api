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
    
    # Generate a text response and write as a PodeTextResponse

    $TextResponse = New-WinnerTextResponse -TeamId $WebEvent.Query['Team'] `
        -Sarcasm $Sarcasm `
        -ResultData $Results.GameResults
    Write-PodeTextResponse -Value $TextResponse
}