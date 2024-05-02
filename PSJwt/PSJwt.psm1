$PSJwtModuleHome = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

# private functions
. "$PSJwtModuleHome\Functions\SecureTempFile.ps1"
. "$PSJwtModuleHome\Functions\Convert-ToBase64.ps1"
. "$PSJwtModuleHome\Functions\Invoke-CommandAndGetBinaryOutput.ps1"

# public functions
. "$PSJwtModuleHome\Functions\New-JwtClaimsString.ps1"
