## 安裝測試模組 Pester 指令
這東西其實 Windows 有自帶舊版本不過不好使，當前我的測試版本是裝了 5.5.0 版

```ps1
Get-Module -Name Pester -ListAvailable
```

安裝最新版本到使用者目錄

```ps1
Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck
```

裝完需要重新啟動一下終端機然後可以用這個測試

```ps1
Describe 'Notepad' {
    It 'Exists in Windows folder' {
        'C:\Windows\notepad.exe' | Should -Exist
    }
}
```

這個能過就是裝好了，詳細細節可以參考官方網站  
https://github.com/pester/Pester
