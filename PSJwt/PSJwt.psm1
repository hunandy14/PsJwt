$PSJwtModuleHome = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

$scriptPaths = @(
    
    # private functions
    'Functions/Get-FilePermissions.ps1',
    'Functions/SecureTempFile.ps1',
    'Functions/New-SecureHexString.ps1',
    
    # public functions
    'Functions/ConvertTo-Base64.ps1',
    'Functions/Invoke-CommandAndGetBinaryOutput.ps1',
    
    # public functions
    'Functions/ConvertTo-JwtUnsignToken.ps1'
    
)

foreach ($scriptPath in $scriptPaths) {
    . "$PSJwtModuleHome/$scriptPath"
}
