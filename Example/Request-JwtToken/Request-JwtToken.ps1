# 載入 PSJwt 模組
try {
    $irmParams = @{
         Uri = 'raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt/PSJwt.github.psm1'
    }; if (![string]::IsNullOrWhiteSpace($env:HTTP_PROXY)) {
        $irmParams['Proxy'] = $env:HTTP_PROXY
    }; Invoke-RestMethod @irmParams |Invoke-Expression -ea 1
} catch { Write-Error $PSItem.Exception.Message -ea 1 }



# 簽名用私鑰
$privatekeyPath = '.\key\private_key.pem'

# 生成 JWT 用的 JSON 文字 (包含換行)
$header = @{
    alg = "RS512"
    typ = "JWT"
} | ConvertTo-Json -Compress
$payload = @{
    email = "jordan@example.com"
} | ConvertTo-Json -Compress

# 使用 JSON 文字生成 JWT 聲明字符串
$jwtDataToken = ConvertTo-JwtUnsignToken -HeaderString $header -PayloadString $payload

# 對 JWT 聲明字符串簽名
$cmdString = "OpenSSL dgst -sha512 -binary -sign `"$privatekeyPath`""
$byte = $jwtDataToken | Invoke-CommandAndGetBinaryOutput -CommandLine $cmdString
$signature = ConvertTo-Base64Url($byte)

# 組合成最終的 JWT
$jwt = "$jwtDataToken.$signature"
# Write-Host $jwt -ForegroundColor DarkGreen



# 使用 $irmParams 哈希表發送 GET 請求
$irmParams = @{
    Uri     = "https://httpbin.org/get"
    Method  = "Get"
    Headers = @{
        Authorization = "Bearer $jwt"
    }
}; try {
    $response = Invoke-RestMethod @irmParams
} catch {
    Write-Error $PSItem.Exception.Message -ea 1   
}

# 查看響應值
$response
