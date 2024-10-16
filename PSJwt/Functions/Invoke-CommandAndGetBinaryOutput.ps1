function Invoke-CommandAndGetBinaryOutput {
    [CmdletBinding()] [OutputType([byte[]])] [Alias("icb")]
    Param(
        [Alias("CommandLine")]
        [Parameter(Position = 0, Mandatory)]
        [string]$FileName,
        [Parameter(Position = 1, ValueFromRemainingArguments)]
        [string[]]$Arguments,
        [Parameter(ValueFromPipeline)]
        [string]$InputData
    )

    Begin {
        # 同步 .Net 環境工作目錄
        [IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))

        # 用空白分割命令行，並分配文件名與參數
        $FileName, $arg = $FileName -split ' ', 2
        if ($arg) { $Arguments = @($arg -split ' ') + $Arguments }

        # 驗證是否存在該指令
        try { Get-Command $FileName -ErrorAction Stop |Out-Null } catch {
            Write-Error ($_.Exception.Message) -ErrorAction Stop
        }

        # 建立 ProcessStartInfo 對象並配置
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo -Property @{
            FileName = $FileName
            Arguments = $Arguments
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

        # 等待進程結束
        $process.WaitForExit()

        # 檢查是否有錯誤輸出
        if ($process.StandardError.Peek() -ne -1) {
            $errMsg = $process.StandardError.ReadToEnd()
            Write-Error $errMsg -ErrorAction Stop
        }

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
