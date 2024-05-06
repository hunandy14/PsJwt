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
