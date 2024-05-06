# 轉換到 Base64
function ConvertTo-Base64 {
    [CmdletBinding(DefaultParameterSetName = "String")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "String", Mandatory, ValueFromPipeline)]
        [string]$InputString,
        [Parameter(Position = 0, ParameterSetName = "Bytes", Mandatory, ValueFromPipeline)]
        [byte[]]$InputBytes,
        [Parameter(ParameterSetName = "")]
        [switch]$Base64Url
    )
    
    Process {
        # 智能選取參數
        if ($PSCmdlet.ParameterSetName -eq "String") {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
        }
        elseif ($PSCmdlet.ParameterSetName -eq "Bytes") {
            $bytes = $InputBytes
        }
        
        # 轉換到 base64
        $base64 = [System.Convert]::ToBase64String($bytes)
        if ($Base64Url) { $base64 = $base64 -replace '\+', '-' -replace '/', '_' -replace '=' }
        
        return $base64
    }
    
} # ConvertTo-Base64 "0000"

# 轉換到 Base64Url
function ConvertTo-Base64Url {
    [CmdletBinding(DefaultParameterSetName = "String")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "String", Mandatory, ValueFromPipeline)]
        [string]$InputString,
        [Parameter(Position = 0, ParameterSetName = "Bytes", Mandatory, ValueFromPipeline)]
        [byte[]]$InputBytes
    )
    
    Process {
        if ($PSCmdlet.ParameterSetName -eq "String") {
            $base64url = ConvertTo-Base64 $InputString -Base64Url
        }
        elseif ($PSCmdlet.ParameterSetName -eq "Bytes") {
            $base64url = ConvertTo-Base64 $InputBytes -Base64Url
        }
        return $base64url
    }
    
} # ConvertTo-Base64Url "0000"
