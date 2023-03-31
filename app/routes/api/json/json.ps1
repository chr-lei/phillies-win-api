# Add an route for /json that returns a JSON response
Add-PodeRoute -Method Get -Path '/api/json' -ScriptBlock {
    $Results = Get-Games -TeamId $WebEvent.Query['Team'] `
        -GameDate $WebEvent.Query['Date'] `
        -Selector $WebEvent.Query['Selector']
    Write-PodeJsonResponse $Results
}

Add-PodeRoute -Method Get -Path '/api/json-debug' -ScriptBlock {
    $QueryInfo = @{
        Team = $WebEvent.Query['Team']
        Date = $WebEvent.Query['Date']
        Selector = $WebEvent.Query['Selector']
    }

    Write-PodeJsonResponse -Value ($QueryInfo | ConvertTo-Json)
}
