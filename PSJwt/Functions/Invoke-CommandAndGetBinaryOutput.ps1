function Invoke-CommandAndGetBinaryOutput {
    [CmdletBinding(DefaultParameterSetName = "")]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [string]$CommandLine,
        [Parameter(ParameterSetName = "", ValueFromPipeline)]
        [string]$InputData
    )

    Begin {
        # 用空白分割命令行，並分配文件名與參數
        $fileName, $arguments = $CommandLine -split ' ', 2

        # 建立 ProcessStartInfo 對象並配置
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo -Property @{
            FileName = $fileName
            Arguments = $arguments
            RedirectStandardOutput = $true
            RedirectStandardError = $true
            RedirectStandardInput = $true
            UseShellExecute = $false
            CreateNoWindow = $true
        }

        # 開始進程
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        $process.Start() | Out-Null
    }

    Process {
        # 將字符串轉換為字節數組
        $encoder = [System.Text.Encoding]::UTF8
        $bytes = $encoder.GetBytes($InputData)

        # 直接將二進制數據寫入到進程的標準輸入
        $process.StandardInput.BaseStream.Write($bytes, 0, $bytes.Length)
        $process.StandardInput.BaseStream.Flush()  # 確保數據完全寫入
    }

    End {
        # 關閉標準輸入以告訴進程所有輸入已結束
        $process.StandardInput.Close()

        # 使用 MemoryStream 讀取二進制數據
        $memoryStream = New-Object System.IO.MemoryStream
        try {
            $process.StandardOutput.BaseStream.CopyTo($memoryStream)
            $binaryOutput = $memoryStream.ToArray()

            # 返回二進制數據
            return $binaryOutput
        } finally {
            $memoryStream.Dispose()
            $process.Dispose()
        }
    }
    
} # Write-Host (Invoke-CommandAndGetBinaryOutput "openssl rand -out - 4")
