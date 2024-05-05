OpenSSL
===

## 免安裝
編譯好的檔案載點:  
https://github.com/hunandy14/PsJwt/raw/main/OpenSSL/OpenSSL-Win64.zip  

> 該 zip 是來自 [slproweb](https://slproweb.com/products/Win32OpenSSL.html) 的檔案 (版本 3.3.0.0 )  
> 免安裝檔載下來直接加到環境變數就能用了  

快速安裝

```ps1
$OpenSSLPath = "C:\OpenSSL-Win64"

# 下載到C曹
(New-Object Net.WebClient).DownloadFile('https://github.com/hunandy14/PsJwt/raw/main/OpenSSL/OpenSSL-Win64.zip', "$($env:temp)\OpenSSL-Win64.zip")
Expand-Archive "$($env:temp)\OpenSSL-Win64.zip" $OpenSSLPath -Force -ErrorAction Stop

# 新增到臨時變數
$env:Path = "$OpenSSLPath;$($env:Path)"

# 測試指令
Get-Command openssl

```

永久新增到環境變數 (擇1使用即可)

```ps1
# 新增到永久變數(使用者)
[Environment]::SetEnvironmentVariable("Path", "$OpenSSLPath;$([Environment]::GetEnvironmentVariable('Path', 'User'))", 'User');

# 新增到永久變數(系統)
[Environment]::SetEnvironmentVariable("Path", "$OpenSSLPath;$([Environment]::GetEnvironmentVariable('Path', 'Machine'))", 'Machine');

```

<br>

## 自行編譯  

如果要自行編譯安裝可以參考下面指令  
(注意choco是自動化編譯過程，會在電腦上下載不少編譯用軟體)  

```ps1
Set-ExecutionPolicy Bypass -S:Process -F
irm chocolatey.org/install.ps1|iex
choco install -y openssl
```
