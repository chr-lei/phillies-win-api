# Add an route for /json that returns a JSON response
Add-PodeRoute -Method Get -Path '/json' -ScriptBlock {
    if ($WebEvent.Query['Date'] -eq $null) {
        Get-PhilliesResult
    }
    else {
        Get-PhilliesResult -GameDate $WebEvent.Query['Date']
    }
    
}

