Describe "New-JwtClaimsString" {
    
    Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop
    
    It "Given valid parameters, it should generate the correct JWT claims string" {
        
        # 預期的 JWT 字符串，用於驗證測試結果
        $expectedJwtString = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvcmRhbkBleGFtcGxlLmNvbSJ9'
        
        # 生成 JWT 聲明字符串
        $header = @{
            alg = "RS512"
            typ = "JWT"
        } | ConvertTo-Json -Compress

        $payload = @{
            email = "jordan@example.com"
        } | ConvertTo-Json -Compress

        $jwtClaimsString = New-JwtClaimsString -HeaderString $header -PayloadString $payload
        
        # 比較實際生成的 JWT 字符串與預期的字符串是否相符
        $jwtClaimsString | Should -Be $expectedJwtString
        
    }
    
}
