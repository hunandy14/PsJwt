Get-BoxAccessToken
===

加載函式

```ps1
irm 'raw.githubusercontent.com/hunandy14/PsJwt/main/Example/Get-BoxToken/Get-BoxToken.ps1' |iex
```

加載函式 Proxy

```ps1
irm 'raw.githubusercontent.com/hunandy14/PsJwt/main/Example/Get-BoxToken/Get-BoxToken.ps1' -Proxy $env:HTTP_PROXY |iex
```

快速使用

```ps1
Get-BoxAccessToken 'C:\Box\config.json'
```



<br><br><br>

### 使用 BoxAccessToken 連接

```ps1
& {
    # 加載函式
    irm 'raw.githubusercontent.com/hunandy14/PsJwt/main/Example/Get-BoxToken/Get-BoxToken.ps1' -Proxy $env:HTTP_PROXY |iex

    # 設置 API 請求參數
    $irmParams = @{
        Uri     = 'https://api.box.com/2.0/users/me'
        Method  = 'Get'
        Headers = @{ Authorization = "Bearer $((Get-BoxAccessToken $args[0]).access_token)" }
        Proxy   = $env:HTTP_PROXY
    }

    # 發送 HTTP GET 請求
    try {
        $response = Invoke-RestMethod @irmParams
        Write-Host "Response received successfully" -BackgroundColor DarkGreen
    } catch { Write-Error "Failed to get response: $($_.Exception.Message)" -ea 1 }

    # 輸出用戶資訊
    Write-Host "Authenticated as: $($response.name)"
} .\config.json

```
