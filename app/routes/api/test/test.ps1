Add-PodeRoute -Method Get -Path '/api/test' -ScriptBlock {
    Write-PodeTextResponse -Value "Pode is awake."
}