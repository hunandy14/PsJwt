# 構造 JWT 聲明字串
function New-JwtClaimsString {
    [CmdletBinding(DefaultParameterSetName = "String")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "String", Mandatory)]
        [string]$HeaderString,
        [Parameter(Position = 1, ParameterSetName = "String", Mandatory)]
        [string]$PayloadString
    )

    # 構造 JWT Header
    $base64urlHeader = $HeaderString | ConvertFrom-Json | ConvertTo-Json -Compress | Convert-ToBase64Url
    # 構造 JWT Payload
    $base64urlPayload = $PayloadString | ConvertFrom-Json | ConvertTo-Json -Compress | Convert-ToBase64Url

    # 構造 JWT 聲明字串
    $base64urlClaims = "$base64urlHeader.$base64urlPayload"
    
    return $base64urlClaims
} # New-JwtClaimsString '{"alg":"RS512","typ":"JWT"}' '{"email":"jordan@example.com"}'
