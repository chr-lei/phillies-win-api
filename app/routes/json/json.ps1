# Add an route for /json that returns a JSON response
Add-PodeRoute -Method Get -Path '/json' -ScriptBlock {
    if ($WebEvent.Query['Date'] -eq $null) {
        Get-Games -TeamId $WebEvent.Query['Team']
    }
    else {
        Get-Games -TeamId $WebEvent.Query['Team'] -GameDate $WebEvent.Query['Date']
    }
    
}
