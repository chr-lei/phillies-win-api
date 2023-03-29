# Add an route for /json that returns a JSON response
Add-PodeRoute -Method Get -Path '/json' -ScriptBlock {
    $json = Get-Games -TeamId $WebEvent.Query['Team'] -GameDate $WebEvent.Query['Date']
    if ($json -ne $null) {
        Write-PodeJsonResponse $json
    }
    else {
        Write-PodeTextResponse -Value "I didn't find any games. Bullshit."
    }
}

Add-PodeRoute -Method Get -Path '/json-debug' -ScriptBlock {
    $QueryInfo = @{
        Team = $WebEvent.Query['Team']
        Date = $WebEvent.Query['Date']
    }

    Write-PodeJsonResponse -Value ($QueryInfo | ConvertTo-Json)
}
