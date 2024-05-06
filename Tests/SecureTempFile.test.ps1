Describe "SecureTempFile.test" {

    # Import the necessary module
    Import-Module (Join-Path $PSScriptRoot "..\PSJwt\PSJwt.psm1") -Force -ErrorAction Stop

    BeforeAll {

    }

    AfterAll {

    }

    Context "New-SecureTempFile" {

        It "Create Temp File2" {

            # 生成安全暫存檔案1
            $tmp = New-SecureTempFile
            $tmp | Should -Exist
            $tmp | Remove-SecureTempFile

            # 生成安全暫存檔案2
            $tmp = New-SecureTempFile -CurrentDirectory
            $tmp | Should -Exist
            $tmp | Split-Path | Should -Be ([string](Get-Location))
            $tmp | Remove-SecureTempFile

            # 生成安全暫存檔案3
            $tmp = New-SecureTempFile -DirectoryPath ([string](Get-Location))
            $tmp | Should -Exist
            $tmp | Split-Path | Should -Be ([string](Get-Location))
            $tmp | Remove-SecureTempFile

        }

        It "Check file permissions" {

            # 生成安全暫存檔案
            $tmp = New-SecureTempFile
            $tmp | Should -Exist

            # 確認檔案狀態
            $list = Get-SecureTempFileList -HashTable
            $list[$tmp] | Should -Be $true

            # 確認檔案權限
            $permission = Get-FilePermissions $tmp
            $permission.Count     | Should -Be 2
            $admin = $permission|Where-Object { $_.Identity -eq 'BUILTIN\Administrators' }
            $admin.FullControl    | Should -Be 'Allow'
            $admin.Modify         | Should -Be ''
            $admin.ReadAndExecute | Should -Be ''
            $admin.Read           | Should -Be ''
            $admin.Write          | Should -Be ''
            $user = $permission|Where-Object { $_.Identity -eq "$($env:COMPUTERNAME)\$($env:USERNAME)" }
            $user.FullControl     | Should -Be ''
            $user.Modify          | Should -Be ''
            $user.ReadAndExecute  | Should -Be ''
            $user.Read            | Should -Be 'Allow'
            $user.Write           | Should -Be 'Allow'

            # 刪除檔案
            $tmp | Remove-SecureTempFile

        }

    }

    Context "Remove-SecureTempFile" {

        It "Remove temp file" {

            # 刪除安全暫存檔案1
            $tmp = New-SecureTempFile
            $tmp | Should -Exist
            (Get-SecureTempFileList -HashTable)[$tmp] | Should -Be $true
            $tmp | Remove-SecureTempFile
            $tmp | Should -Exist -Not
            (Get-SecureTempFileList -HashTable)[$tmp] | Should -Be $false

            # 刪除安全暫存檔案2
            $tmp1 = New-SecureTempFile
            $tmp2 = New-SecureTempFile
            $tmp1 | Should -Exist
            $tmp2 | Should -Exist
            (Get-SecureTempFileList -HashTable)[$tmp1] | Should -Be $true
            (Get-SecureTempFileList -HashTable)[$tmp2] | Should -Be $true
            Remove-SecureTempFile -AllFile
            $tmp1 | Should -Exist -Not
            $tmp2 | Should -Exist -Not
            (Get-SecureTempFileList -HashTable)[$tmp1] | Should -Be $false
            (Get-SecureTempFileList -HashTable)[$tmp2] | Should -Be $false

        }

    }

    Context "Get-SecureTempFileStatus" {

        It "Get temp file status" {

            # 生成安全暫存檔案
            $tmp = New-SecureTempFile
            $tmp | Should -Exist
            (Get-SecureTempFileList -HashTable)[$tmp] | Should -Be $true

            # 獲取狀態
            Get-SecureTempFileStatus $tmp | Should -Be $true

            # 刪除安全暫存檔案
            $tmp | Remove-SecureTempFile
            $tmp | Should -Exist -Not
            (Get-SecureTempFileList -HashTable)[$tmp] | Should -Be $false

            # 獲取狀態
            Get-SecureTempFileStatus $tmp | Should -Be $false

        }

    }

}
