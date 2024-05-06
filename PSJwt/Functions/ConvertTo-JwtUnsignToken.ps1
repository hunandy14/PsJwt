# 構造 JWT 聲明字串
function ConvertTo-JwtUnsignToken {
    [CmdletBinding(DefaultParameterSetName = "String")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "String", Mandatory)]
        [string]$HeaderString,
        [Parameter(Position = 1, ParameterSetName = "String", Mandatory)]
        [string]$PayloadString,
        [Parameter(Position = 0, ParameterSetName = "Hash", Mandatory)]
        [System.Collections.Hashtable]$HeaderHash,
        [Parameter(Position = 1, ParameterSetName = "Hash", Mandatory)]
        [System.Collections.Hashtable]$PayloadHash
    )

    if ($PSCmdlet.ParameterSetName -eq "String") {

        # 構造 JWT Header
        $base64urlHeader = $HeaderString | ConvertFrom-Json | ConvertTo-Json -Compress | ConvertTo-Base64Url
        # 構造 JWT Payload
        $base64urlPayload = $PayloadString | ConvertFrom-Json | ConvertTo-Json -Compress | ConvertTo-Base64Url

    } elseif ($PSCmdlet.ParameterSetName -eq "Hash") {

        # 構造 JWT Header
        $base64urlHeader = $HeaderHash | ConvertTo-Json -Compress | ConvertTo-Base64Url
        # 構造 JWT Payload
        $base64urlPayload = $PayloadHash | ConvertTo-Json -Compress | ConvertTo-Base64Url

    }

    # 構造 JWT 未簽名字串
    $jwtUnsignToken = "$base64urlHeader.$base64urlPayload"

    return $jwtUnsignToken
} # ConvertTo-JwtUnsignToken '{"alg":"RS512","typ":"JWT"}' '{"email":"jordan@example.com"}'
