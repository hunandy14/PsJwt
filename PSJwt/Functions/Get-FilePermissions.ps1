# 獲取檔案權限表
function Get-FilePermissions {
     [CmdletBinding(DefaultParameterSetName = "")]
     param(
         [Parameter(Position = 0, ParameterSetName = "", Mandatory)]
         [string]$Path,
         [Parameter(Position = 1, ParameterSetName = "")]
         [string]$Identity
     )

     # 確認指定的路徑是否存在
     if (!(Test-Path $Path)) {
         Write-Error "Cannot find path '$Path' because it does not exist." -ErrorAction Stop
     }

     # 取得指定路徑的存取控制清單 (ACL)
     $acl = Get-Acl $Path

     # 定義需要檢查的權限列表
     $permissions = @('FullControl', 'Modify', 'ReadAndExecute', 'Read', 'Write')

     # 初始化一個字典來儲存每個使用者的權限狀態
     $permissionDict = @{}

     # 遍歷存取控制規則
     foreach ($accessRule in $acl.Access) {
         # 取得使用者名稱
         $user = $accessRule.IdentityReference.Value
        
         # 如果字典尚未包含目前用戶，則新增一個條目
         if (-not $permissionDict.ContainsKey($user)) {
             # 動態建立權限字段
             $userPermissions = [ordered]@{ Identity = $user }
             foreach ($permission in $permissions) {
                 $userPermissions[$permission] = ''
             }
             $permissionDict[$user] = $userPermissions
         }

         # 更新權限狀態，拒絕權限優先
         foreach ($permission in $permissions) {
             if ($accessRule.FileSystemRights -like "*$permission*") {
                 $state = $accessRule.AccessControlType.ToString()
                 if ($permissionDict[$user][$permission] -ne 'Deny') {
                     $permissionDict[$user][$permission] = $state
                 }
             }
         }
     }

     # 將字典中的值轉換為物件數組
     if ($Identity) {
         $permission = [PSCustomObject]($permissionDict[$Identity])
     } else {
         $permission = $permissionDict.Values | ForEach-Object { [PSCustomObject]$_ }
     }

     # 傳回產生的權限表格
     return $permission
}

# Get-FilePermissions "Z:\test.txt"|Format-Table|Out-String
# Get-FilePermissions "Z:\test.txt" -Identity 'BUILTIN\Administrators'
