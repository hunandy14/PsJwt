$PSJwtModuleHome = 'https://raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt'

# private functions
Invoke-RestMethod "$PSJwtModuleHome/Functions/Convert-ToBase64.ps1" |Invoke-Expression

# public functions
Invoke-RestMethod "$PSJwtModuleHome/Functions/Invoke-CommandAndGetBinaryOutput.ps1" |Invoke-Expression
Invoke-RestMethod "$PSJwtModuleHome/Functions/New-JwtClaimsString.ps1" |Invoke-Expression
