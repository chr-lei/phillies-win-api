Add-PodeRoute -Method Get -Path '/test' -ScriptBlock {
    Write-PodeTextResponse -Value "Pode is awake."
}