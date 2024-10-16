Describe "Invoke-CommandAndGetBinaryOutput" {

    # Import the necessary module
    Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop

    # Initialize common variables using BeforeAll
    BeforeAll {
        # 簽名用的私鑰路徑
        [string] $privatekeyPath = 'key\private_key.pem'
        # 預期的 JWT 簽名字符串，用於驗證測試結果
        [string] $jwtVerify = 'eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvcmRhbkBleGFtcGxlLmNvbSJ9.Sh6zZXY_q-CZiDOIaxQEraqIh0gQr24jhsTRZ2OWv7NpxOzdECJzV2Lbw_sSngOkjMtMuw5pztixoBNIwxli1aFIE5pxTEgOZ2faIQQ7iCVmBERNGvoLxvfF0ClhMxHGnrPam8Q_hRcDsgl-uGC4-snMrx7-b5eDLJC14cHEfpkgIbzA65JGxqpycF-oy757t3B5DQcZQkE-XjeJk-qlxiX4Qq_Ez8hxUxRiy4ysAxYgHIOhukYivvmsVdghCpU5wD_gEEjO6NeTuwLCqtl9k5XP-LByIo8eXermD2BmsLYkSh4mYk68FqwnoEGYFIknVdKJPZ5n5GAjd1vD0lssmw'
        
        $privatekeyPath, $jwtVerify |Out-Null
    }
    
    AfterAll {
        Write-Host "All tests completed"
    }
    
    Context "New-SecureTempFile" {

        It "Create Temp File" {

            # 生成 JWT 用的 JSON 文字 (包含換行)
            $header = @{
                alg = "RS512"
                typ = "JWT"
            } | ConvertTo-Json -Compress
            $payload = @{
                email = "jordan@example.com"
            } | ConvertTo-Json -Compress

            # 使用 JSON 文字生成 JWT 聲明字符串
            $jwtClaimsString = ConvertTo-JwtUnsignToken -HeaderString $header -PayloadString $payload
            Write-Host $jwtClaimsString
            
            # 對 JWT 聲明字符串簽名
            $byte = $jwtClaimsString | Invoke-CommandAndGetBinaryOutput OpenSSL dgst -sha512 -binary -sign $privatekeyPath
            $signature = ConvertTo-Base64Url($byte)
            
            # 組合成最終的 JWT
            $jwt = "$jwtClaimsString.$signature"
            $jwt | Should -Be $jwtVerify
            
        }

    }

}
