Describe "New-JwtClaimsString" {

    # Import the necessary module
    Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop

    # Initialize common variables using BeforeAll
    BeforeAll {
        $expectedJwtString |Out-Null

        # 預期的 JWT 字符串，用於驗證測試結果
        [string] $expectedJwtString = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvcmRhbkBleGFtcGxlLmNvbSJ9'
    }

    Context "Generate the JWT claims string" {

        # 測試提供正確參數時，是否能正確生成 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string" {

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
            $jwtClaimsString | Should -Be $expectedJwtString

            # 使用 JSON 文字生成 JWT 聲明字符串 (測試省略輸入參數)
            $jwtClaimsString = New-JwtClaimsString $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }

        # 測試提供正確參數但 JSON 格式包含多餘空白時，是否能生成相同的 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string, even with additional whitespace in the JSON format" {

            # 生成 JWT 用的 JSON 文字 (去除多餘空白)
            $header = @{
                alg = "RS512"
                typ = "JWT"
            } | ConvertTo-Json
            $payload = @{
                email = "jordan@example.com"
            } | ConvertTo-Json

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = New-JwtClaimsString -HeaderString $header -PayloadString $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }
        
        # 測試提供正確參數時，是否能正確從哈希表生成 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string from hashtable" {

            # 生成 JWT 用的 JSON 文字 (包含換行)
            $header = @{
                alg = "RS512"
                typ = "JWT"
            }
            $payload = @{
                email = "jordan@example.com"
            }

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = New-JwtClaimsString $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

            # 使用 JSON 文字生成 JWT 聲明字符串 (測試省略輸入參數)
            $jwtClaimsString = New-JwtClaimsString $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }

    }

}
