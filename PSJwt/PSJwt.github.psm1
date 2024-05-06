$PSJwtModuleHome = 'https://raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt'

$scriptPaths = @(

    # private functions
    'Functions/Get-FilePermissions.ps1',
    'Functions/SecureTempFile.ps1',
    'Functions/New-SecureHexString.ps1',
    'Functions/Get-UnixTimestamp.ps1',

    # public functions
    'Functions/ConvertTo-Base64.ps1',
    'Functions/Invoke-CommandAndGetBinaryOutput.ps1',
    'Functions/ConvertTo-JwtUnsignToken.ps1'

)

foreach ($scriptPath in $scriptPaths) {
    try {
        # Loding function in memory
        $irmParams = @{
            Uri = "$PSJwtModuleHome/$scriptPath"
        }; if (![string]::IsNullOrWhiteSpace($env:HTTP_PROXY)) {
            $irmParams['Proxy'] = $env:HTTP_PROXY
        }; Invoke-RestMethod @irmParams | Invoke-Expression -EA Stop
    } catch {
        Write-Error "$($_.Exception.Message)" -ea 1
    }
}
