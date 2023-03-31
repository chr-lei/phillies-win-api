function New-WinnerTextResponse {
    param(
        [Parameter()]$ResultData,
        [Parameter(Mandatory)][bool]$Sarcasm,
        [Parameter(Mandatory)][Int]$TeamId
    )

    # If we get empty result data, there wasn't a game today.
    if ($null -eq $ResultData.Status) {
        $MainString = "There don't seem to be any games scheduled for today."
        $SarcasmString = "Wipe the cheese off your fingers and try again."
        if ($Sarcasm) {
            return ($MainString + " " +$SarcasmString)
        }
        else { return $MainString }       
    }

    # If the game isn't in Final status and starts in the future, decline to answer.
    if ($ResultData.Status -ne 'F' -and $ResultData.StartDateTime -gt (Get-Date)) {
        $MainString = "They didn't even play yet. I'm not Gray's Sports Almanac."
        $SarcasmString = "Go butter your cup and then ask me again."
        if ($Sarcasm) {
            return ($MainString + " " + $SarcasmString)
        }
        else { return $MainString }
    }
 
    # If the selected team didn't win
    if ($ResultData.WinnerID -ne $TeamId) {
        $MainString = "The $($ResultData.LoserName) lost to the $($ResultData.WinnerName), $($ResultData.WinnerScore) - $($ResultData.LoserScore)."
        $SarcasmString = "Angel Hernandez did this, man."
        if ($Sarcasm) {
            return ($MainString + " " + $SarcasmString)
        }
        else { return $MainString }
    }

    # If the selected team did win
    if ($ResultData.WinnerID -eq $TeamId) {
        $MainString = "The $($ResultData.WinnerName) won! They beat the $($ResultData.LoserName), $($ResultData.WinnerScore) - $($ResultData.LoserScore)."
        $SarcasmString = "Which, of course they did. Why are you even asking? Get a job."
        if ($Sarcasm) {
            return ($MainString + " " + $SarcasmString)
        }
        else { return $MainString }
    }
}
