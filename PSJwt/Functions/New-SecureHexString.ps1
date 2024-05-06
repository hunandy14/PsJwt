function New-SecureHexString {
    [CmdletBinding(DefaultParameterSetName = "")]
    param(
        [int]$Length = 64
    )
    $bytes = New-Object byte[] $length
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    $hex = [BitConverter]::ToString($bytes).Replace('-','').ToLower()
    return $hex
} # New-SecureHexString
