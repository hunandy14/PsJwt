PSJwt
===

快速使用1
```ps1
& {
    irm 'raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt/PSJwt.github.psm1' |iex
    $priKey = Get-Item ".\private_key.pem" -EA 1
    $jwtClaims = New-JwtClaimsString @{alg="RS512";typ="JWT"} @{email="jordan@example.com"}
    $signature = Convert-ToBase64Url($jwtClaims |ivc "OpenSSL dgst -sha512 -sign `"$priKey`"")
    Write-Host "$jwtClaims.$signature" -ForegroundColor DarkGreen
}
```

> 關於 OpenSSL  
> 1. 第三方編譯的安裝檔案 : https://slproweb.com/products/Win32OpenSSL.html  
> 2. 第三方 choco 快速安裝: `choco install -y openssl`  



<br><br><br>

線上載入
```ps1
irm 'raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt/PSJwt.github.psm1' |iex
```

本地檔案
```ps1
Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop
```

快速使用2
```ps1
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
$jwtClaimsString = New-JwtClaimsString -HeaderString $header -PayloadString $payload

# 對 JWT 聲明字符串簽名
$cmdString = "OpenSSL dgst -sha512 -binary -sign `"$privatekeyPath`""
$byte = $jwtClaimsString | Invoke-CommandAndGetBinaryOutput -CommandLine $cmdString
$signature = Convert-ToBase64Url($byte)

# 組合成最終的 JWT
$jwt = "$jwtClaimsString.$signature"
Write-Host $jwt -ForegroundColor DarkGreen

```



<br><br><br>

## 測試
簽名測試測試用網站: https://jwt.io/
> 進入之後把下面JWT跟公鑰填入，可以看到左下角有個 `Signature Verified` 就是驗證功過了  
> 也可以填入私鑰後直接修改右邊的 PAYLOAD 網站會自動生成正確的 JWT 字串  

<br>

快速使用範例預期產出的 JWT 結果

```txt
eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvcmRhbkBleGFtcGxlLmNvbSJ9.Sh6zZXY_q-CZiDOIaxQEraqIh0gQr24jhsTRZ2OWv7NpxOzdECJzV2Lbw_sSngOkjMtMuw5pztixoBNIwxli1aFIE5pxTEgOZ2faIQQ7iCVmBERNGvoLxvfF0ClhMxHGnrPam8Q_hRcDsgl-uGC4-snMrx7-b5eDLJC14cHEfpkgIbzA65JGxqpycF-oy757t3B5DQcZQkE-XjeJk-qlxiX4Qq_Ez8hxUxRiy4ysAxYgHIOhukYivvmsVdghCpU5wD_gEEjO6NeTuwLCqtl9k5XP-LByIo8eXermD2BmsLYkSh4mYk68FqwnoEGYFIknVdKJPZ5n5GAjd1vD0lssmw
```

<br>

測試用公鑰 `public_key.pem`

```pem
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyo8/5NIZNSF8LvXUbzrG
nyKEolcVMsieWmdX+oLwQl2zPb5s86J031Z2qRwuVFHDIUyih9YJaV1gFjy0QC+0
ISYIdDGvmyetAVXNIEagGuNkvL+YecX3vVH7+gARh9ao17sNuwquDF6gO6n5kKrE
3FAWbExB2R9QOeXnYb8TeYjZNce1JKHEHe4+GG5oJODY7zk9OKCuhOC+SrA05rBJ
CE3CeNxPIliZeJ/eIoxvjF82qBWKHIzlIcY7i5ndZqVtPk/ycBWIOXmnBLPyGRDX
mIgbiQ7Pt4P1fdgx2I6bctuWGbxlN0SDAIjcNvIgZylBVaL8/WQ5eCNegFNxFc8w
OQIDAQAB
-----END PUBLIC KEY-----
```

<br>

測試用私鑰 `private_key.pem`

```pem
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDKjz/k0hk1IXwu
9dRvOsafIoSiVxUyyJ5aZ1f6gvBCXbM9vmzzonTfVnapHC5UUcMhTKKH1glpXWAW
PLRAL7QhJgh0Ma+bJ60BVc0gRqAa42S8v5h5xfe9Ufv6ABGH1qjXuw27Cq4MXqA7
qfmQqsTcUBZsTEHZH1A55edhvxN5iNk1x7UkocQd7j4Ybmgk4NjvOT04oK6E4L5K
sDTmsEkITcJ43E8iWJl4n94ijG+MXzaoFYocjOUhxjuLmd1mpW0+T/JwFYg5eacE
s/IZENeYiBuJDs+3g/V92DHYjpty25YZvGU3RIMAiNw28iBnKUFVovz9ZDl4I16A
U3EVzzA5AgMBAAECggEAJLHBJSJjYyLbBIXPk0vOPfdKmD8WzcGWoDFu+Gh+fkNL
rHCB+7vPGMNo0RdUFD3Qj8h6fAmL4GzEMpsSGzuZEdU6PFRg58ZO+rowo/tvVxeh
AOljhZHVoJQIxd/7zQQXx6bw5JSZdY+xzsUquuiYq4GNolZJKnxX8/kgSq6K6F3N
ozTHRBbE4QEb1bhUlGB4lMJILALpV9rWFwSgOFsIGNf9eRCpSxG/2uFLoC7Cejnm
INTtsbzIk7gEiAsS6UcUvS+zN0zWX8YTGjvzThXe3xzdFkc814457YpJyq0n8lG8
etMtstt6RaPkvncq9GAnjh7H66t9ZpOPiVEM1oVKlQKBgQD1FeZYPLIqBIqFMMSb
Xg36HWUwvIWykyDvbLj9xvXX7MGLbutsyKxN1kuHA/Bu5lGAYbzpARz+lp/CVrrG
FKqNfFuOCK6v2ggI+rAd84p++rIOl34oTUzSBpM2P+7tUD2j++gaeYCwDT+534Br
5Wedps63xSczvwg8M2djEFkIzQKBgQDTlIgvTwnDiYLtYGPsnt3YyE+uW0Cm+xZm
gt5dRkQ6zd2TYteDWvtn6priF8ViNzOQO54REEHaA/Wv+vepuYOsjmIH42oFoCOU
Gk34yrxg19iUc9iupJcM9ZMm4msg+WwqsjuAkR18MIPsJtUgvwko2tOO1L/HN1om
KxPH84H1HQKBgQDdIhFf9APdHZPOcR40AT0jO3qd6rvHUDEbVkHj2KzhUmGfaUlK
MhYldQFYpRk/Nti6uXU11ydOHqGvO4nyR5tLZbVGBld3m4Y8c9SMcb24rIIT4GSY
AIcbyYryG+V8gjXby+K0YITYVFv3Xc4FjEtdV7CU53Jjoi3QA6F5JLrw0QKBgGhA
c6n74++5Pg4AxLu+u8kpSjm7NOwSJEN2kGKdUNk4vsj0lwRePCpD6vUkiVmPoZSc
C5KU1B28fb6shoPWqQ7JSXxhjcgf0+gR3gGMw61kLY9YVZgX+WWlS1CJmAezXpzb
HX6IAmNC9H3T1IhCGR1MVZm3MpfSqlTMPP70+T/xAoGBAKdHB2Bo8PA50XZsve5L
iuCoqTE87MnV5YoIqErzMuZRiCJoT+k+u1br5SAahD82hUSGNgIoQykGF3RssOfu
6n3Qj81wSxOVUW7gUIGw+WhtoG6NLSvvZ7fQNiZoeI5mFTxy9yLnr2q2N9FHewkT
bXcNURy8SSmuP7m77jn3DR7v
-----END PRIVATE KEY-----
```
