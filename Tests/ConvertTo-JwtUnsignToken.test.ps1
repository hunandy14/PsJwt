Describe "ConvertTo-JwtUnsignToken" {

    # Import the necessary module
    Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop

    # Initialize common variables using BeforeAll
    BeforeAll {

        # 預期的 JWT 字符串，用於驗證測試結果
        [string] $expectedJwtString = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvcmRhbkBleGFtcGxlLmNvbSJ9'

        # 生成 JWT Header 用的 HashTable
        [hashtable] $headerHash = [ordered] @{
            alg = "RS512"
            typ = "JWT"
        }

        # 生成 JWT Payload 用的 HashTable
        [hashtable] $payloadHash = [ordered] @{
            email = "jordan@example.com"
        }

        # 消除警告的無用行
        $expectedJwtString, $headerHash, $payloadHash |Out-Null

    }

    Context "Generate the JWT claims string" {

        # 測試提供正確參數時，是否能正確生成 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string" {

            # 生成 JWT 用的 JSON 文字 (包含換行)
            $header = $headerHash | ConvertTo-Json -Compress
            $payload = $payloadHash | ConvertTo-Json -Compress

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = ConvertTo-JwtUnsignToken -HeaderString $header -PayloadString $payload
            $jwtClaimsString | Should -Be $expectedJwtString

            # 使用 JSON 文字生成 JWT 聲明字符串 (測試省略輸入參數)
            $jwtClaimsString = ConvertTo-JwtUnsignToken $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }

        # 測試提供正確參數但 JSON 格式包含空白與換行時，是否能生成相同的 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string, even with additional whitespace in the JSON format" {

            # 生成 JWT 用的 JSON 文字 (未去除多餘字符包含空白與換行)
            $header = $headerHash | ConvertTo-Json
            $payload = $payloadHash | ConvertTo-Json

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = ConvertTo-JwtUnsignToken -HeaderString $header -PayloadString $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }

        # 測試提供正確參數時，是否能正確從哈希表生成 JWT 聲明字符串
        It "Given valid parameters, it should generate the correct JWT claims string from hashtable" {

            # 生成 JWT 用的 HashTable
            $header = $headerHash
            $payload = $payloadHash

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = ConvertTo-JwtUnsignToken $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

            # 使用 JSON 文字生成 JWT 聲明字符串 (測試省略輸入參數)
            $jwtClaimsString = ConvertTo-JwtUnsignToken $header $payload
            $jwtClaimsString | Should -Be $expectedJwtString

        }

    }

}
