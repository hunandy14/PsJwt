Describe "Convert-ToBase64" {

    # Import the necessary module
    Import-Module (Join-Path $PSScriptRoot "../PSJwt/PSJwt.psm1") -Force -ErrorAction Stop

    # Initialize common variables using BeforeAll
    BeforeAll {
        $base64_string, $base64_bytes, $base64_verify, $base64url_verify |Out-Null
        [string] $base64_string = '4K>SL?Vb'
        [byte[]] $base64_bytes = @(52, 75, 62, 83, 76, 63, 86, 98)
        [string] $base64_verify = 'NEs+U0w/VmI='
        [string] $base64url_verify = 'NEs-U0w_VmI'
    }

    Context "Converting strings and byte arrays to Base64" {

        # 轉換字符串到 Base64
        It "Given a string, it should generate the correct Base64 encoded result" {
            $result = Convert-ToBase64 -InputString $base64_string
            $result | Should -Be $base64_verify
            $result = Convert-ToBase64 $base64_string
            $result | Should -Be $base64_verify
        }

        # 轉換字節數組到 Base64
        It "Given a byte array, it should generate the correct Base64 encoded result" {
            $result = Convert-ToBase64 -InputBytes $base64_bytes
            $result | Should -Be $base64_verify
            $result = Convert-ToBase64 $base64_bytes
            $result | Should -Be $base64_verify
        }

        # 轉換字符串到 Base64Url
        It "Given a string with Base64Url flag, it should generate the correct Base64Url encoded result" {
            $result = Convert-ToBase64 -InputString $base64_string -Base64Url
            $result | Should -Be $base64url_verify
        }

        # 轉換字節數組到 Base64Url
        It "Given a byte array with Base64Url flag, it should generate the correct Base64Url encoded result" {
            $result = Convert-ToBase64 -InputBytes $base64_bytes -Base64Url
            $result | Should -Be $base64url_verify
        }

        # 通過管道轉換字符串到 Base64
        It "Given a string piped to the cmdlet with the InputBytes flag, it should generate the correct Base64 encoded result" {
            $result = $base64_string | Convert-ToBase64
            $result | Should -Be $base64_verify
        }

        # 通過管道轉換字節數組到 Base64
        It "Given a byte array piped to the cmdlet with the InputBytes flag, it should generate the correct Base64 encoded result" {
            $result = ,$base64_bytes | Convert-ToBase64
            $result | Should -Be $base64_verify
        }

        # 通過管道轉換字符串數組到 Base64
        It "Given an array of strings piped to the cmdlet, it should generate the correct Base64 encoded results for each string" {
            $result = $base64_string,$base64_string | Convert-ToBase64
            $result | Should -Be $base64_verify,$base64_verify
        }

        # 通過管道轉換字節數組到 Base64
        It "Given an array of byte arrays piped to the cmdlet, it should generate the correct Base64 encoded results for each array" {
            $result = $base64_bytes,$base64_bytes | Convert-ToBase64
            $result | Should -Be $base64_verify,$base64_verify
        }

        # 通過管道轉換字符串到 Base64Url
        It "Given a string piped to the cmdlet with the InputBytes flag, it should generate the correct Base64Url encoded result" {
            $result = $base64_string | Convert-ToBase64 -Base64Url
            $result | Should -Be $base64url_verify
        }

        # 通過管道轉換字節數組到 Base64Url
        It "Given a byte array piped to the cmdlet with the InputBytes flag, it should generate the correct Base64Url encoded result" {
            $result = ,$base64_bytes | Convert-ToBase64 -Base64Url
            $result | Should -Be $base64url_verify
        }

    }

    Context "Converting strings and byte arrays to Base64Url" {

        # 轉換字符串到 Base64Url
        It "Given a string, it should generate the correct Base64Url encoded result" {
            $result = Convert-ToBase64Url -InputString $base64_string
            $result | Should -Be $Base64url_verify
            $result = Convert-ToBase64Url $base64_string
            $result | Should -Be $Base64url_verify
        }

        # 轉換字節數組到 Base64Url
        It "Given a byte array, it should generate the correct Base64Url encoded result" {
            $result = Convert-ToBase64Url -InputBytes $base64_bytes
            $result | Should -Be $Base64url_verify
            $result = Convert-ToBase64Url $base64_bytes
            $result | Should -Be $Base64url_verify
        }

        # 通過管道轉換字符串到 Base64Url
        It "Given a string piped to the cmdlet, it should generate the correct Base64Url encoded result" {
            $result = $base64_string | Convert-ToBase64Url
            $result | Should -Be $Base64url_verify
        }

        # 通過管道轉換字節數組到 Base64Url
        It "Given a byte array piped to the cmdlet, it should generate the correct Base64Url encoded result" {
            $result = ,$base64_bytes | Convert-ToBase64Url
            $result | Should -Be $Base64url_verify
        }

        # 通過管道轉換字符串數組到 Base64Url
        It "Given an array of strings piped to the cmdlet, it should generate the correct Base64Url encoded results for each string" {
            $result = $base64_string,$base64_string | Convert-ToBase64Url
            $result | Should -Be $Base64url_verify,$Base64url_verify
        }

        # 通過管道轉換字節數組數組到 Base64Url
        It "Given an array of byte arrays piped to the cmdlet, it should generate the correct Base64Url encoded results for each array" {
            $result = $base64_bytes,$base64_bytes | Convert-ToBase64Url
            $result | Should -Be $Base64url_verify,$Base64url_verify
        }

    }

}
