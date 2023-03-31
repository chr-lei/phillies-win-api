Start-PodeServer {
    # Add a plain HTTP endpoint
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http

    # Log to the terminal for debugging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging

    Use-PodeRoutes -Path ./routes
    Import-PodeModule -Path ./modules/gameresults/gameresults.psm1
    Import-PodeModule -Path ./modules/textresponses/textresponses.psm1
}
