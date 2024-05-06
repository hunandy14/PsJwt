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
    $params = @{ Uri = "$PSJwtModuleHome/$scriptPath" }
    # 檢查 Proxy 環境變數是否設置並且非空
    if (![string]::IsNullOrWhiteSpace($env:HTTP_PROXY)) {
        $params['Proxy'] = $env:HTTP_PROXY
    }
    Invoke-RestMethod @params -EA Stop| Invoke-Expression -EA Stop
}
