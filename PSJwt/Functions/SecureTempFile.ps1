# 生成 SecureTempFile
function New-SecureTempFile {
    [CmdletBinding(DefaultParameterSetName = "DirectoryPath")]
    param(
        [Parameter(Position = 0, ParameterSetName = "DirectoryPath", ValueFromPipeline)]
        [string]$DirectoryPath,
        [Parameter(ParameterSetName = "CurrentDirectory")]
        [switch]$CurrentDirectory
    )
    [IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))

    # 預設值
    if (!$DirectoryPath) {
        $DirectoryPath = if ($CurrentDirectory) { Get-Location } else { $env:tmp }
    }

    # 檢查路徑
    if(Test-Path $DirectoryPath -PathType Leaf){
        Write-Host "The path '$DirectoryPath' is not a valid directory." -EA 0
    } else {
        $DirectoryPath = [IO.Path]::GetFullPath($DirectoryPath)
        if(!(Test-Path $DirectoryPath -PathType Container)) {
            New-Item -ItemType Directory $DirectoryPath -EA 0 | Out-Null
        }
     }

    # 生成隨機的 8.3 檔案
    $randomFileName = [System.IO.Path]::GetRandomFileName()
    $fullFilePath = Join-Path -Path $DirectoryPath -ChildPath $randomFileName
    $null | Out-File -FilePath $fullFilePath -NoNewline

    # 使用 icacls 設置檔案權限，清除繼承並僅賦予當前用戶讀取權限
    $icaclsOutput = icacls.exe "$fullFilePath" /inheritance:r /grant:r "$($env:USERNAME):F" /grant:r "Administrators:F"
    if ($LASTEXITCODE -ne 0) { Write-Error "Error setting permissions with icacls: $icaclsOutput" -EA 0 }

    # 將檔案信息添加到全域哈希表
    if (!($script:__IsSecureTempFile__)) { $script:__IsSecureTempFile__ = @{} }
    $script:__IsSecureTempFile__[$fullFilePath] = $true

    # 返回檔案
    return $fullFilePath
} # New-SecureTempFile -CurrentDirectory



# 刪除指定的 SecureTempFile
function Remove-SecureTempFile {
    [CmdletBinding(DefaultParameterSetName = "Path")]
    param(
        [Parameter(Position = 0, ParameterSetName = "Path", Mandatory, ValueFromPipeline)]
        [string]$Path,
        [Parameter(ParameterSetName = "AllFile")]
        [switch]$AllFile
    )

    if ($AllFile) {
        # 刪除清單中所有的站存檔案
        if ($script:__IsSecureTempFile__) {
            # 複製哈西表
            $hash = $script:__IsSecureTempFile__.Clone()
            # 循環刪除
            foreach ($item in $hash.GetEnumerator()) {
                $key, $value = $item.Key, $item.Value
                if ($value) { Remove-SecureTempFile $key }
            }
        }
    } else {
        # 檢查文件是否由 New-SecureTempFile 創建且未被刪除
        if ( $script:__IsSecureTempFile__.ContainsKey($Path) -and
            $script:__IsSecureTempFile__[$Path] -and
            (Test-Path -PathType Leaf $Path)
        ) {
            # 刪除文件
            Remove-Item -Path $Path -Force -EA 0
            if (Test-Path $Path) {
                Write-Warning "Failed to delete file: $Path"
            } else {
                # Write-Host "File deleted successfully: $Path"
                $script:__IsSecureTempFile__[$Path] = $false
            }
        } else {
            Write-Warning "File is not marked for deletion by New-SecureTempFile or already deleted: $Path"
            if ($script:__IsSecureTempFile__.ContainsKey($Path) -and $script:__IsSecureTempFile__[$Path]) {
                $script:__IsSecureTempFile__[$Path] = $false
            }
        }
    }

} # Remove-SecureTempFile -AllFile



function Get-SecureTempFileList {
    [CmdletBinding(DefaultParameterSetName = "")]
    param(
        [switch]$HashTable
    )

    # 檢測目標是否存在
    if ($script:__IsSecureTempFile__) {
        $hash = $script:__IsSecureTempFile__
    } else {
        return $null
    }

    # 返回目標物
    if ($HashTable) {
        $hash
    } else {
        $hash.GetEnumerator() | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.Key
                IsExist = $_.Value
            }
        }
    }
} # Get-SecureTempFileList



function Get-SecureTempFileStatus {
    [CmdletBinding(DefaultParameterSetName = "")]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Path
    )

    $hash = Get-SecureTempFileList -HashTable
    if ($hash) {
        return $hash[$Path]
    } else { return $null }

} # Get-SecureTempFileStatus $tmp
