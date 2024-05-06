# Import PSJwt Moudle
try {
    $irmParams = @{
         Uri = 'raw.githubusercontent.com/hunandy14/PsJwt/main/PSJwt/PSJwt.github.psm1'
    }; if (![string]::IsNullOrWhiteSpace($env:HTTP_PROXY)) {
        $irmParams['Proxy'] = $env:HTTP_PROXY
    }; Invoke-RestMethod @irmParams |Invoke-Expression -ea 1
} catch { Write-Error $PSItem.Exception.Message -ea 1 }

# Get-BoxAccessToken
function Get-BoxAccessToken {
    [CmdletBinding(DefaultParameterSetName = "")]
    param (
        [Parameter(Position = 0, ParameterSetName = "", Mandatory, ValueFromPipeline)]
        [string]$Path
    )

    # Load JSON configuration
    $config = Get-Content $Path -ea 1| ConvertFrom-Json -ea 1

    # Prepare header
    $header = [ordered]@{
        alg = "RS512"
        kid = $config.boxAppSettings.appAuth.publicKeyID
        typ = "JWT"
    }

    # Prepare claims
    $payload = [ordered]@{
        iss = $config.boxAppSettings.clientID
        sub = $config.enterpriseID
        box_sub_type = "enterprise"
        aud = 'https://api.box.com/oauth2/token'
        jti = New-SecureHexString # openssl rand -hex 64
        exp = Get-UnixTimestamp 45
    }

    # Generate JWT Token
    $tokenData = ConvertTo-JwtUnsignToken $header $payload
    $privateKey = $config.boxAppSettings.appAuth.privateKey
    $passphrase = $config.boxAppSettings.appAuth.passphrase
    $prikeyPath = New-SecureTempFile -CurrentDirectory
    $privateKey | openssl pkcs8 -inform PEM -passin pass:$passphrase -outform PEM | Set-Content $prikeyPath -Encoding UTF8
    $algorithm = '-sha512'
    $cmdString = "OpenSSL dgst $algorithm -sign `"$prikeyPath`""
    $signature = ConvertTo-Base64Url($tokenData |icb $cmdString)
    Remove-SecureTempFile $prikeyPath

    # Generate BoxToken Request
    $irmParams = @{
        Uri = 'https://api.box.com/oauth2/token'
        Method = 'Post'
        Body = @{
            grant_type = 'urn:ietf:params:oauth:grant-type:jwt-bearer'
            assertion = "$tokenData.$signature"
            client_id = $config.boxAppSettings.clientID
            client_secret = $config.boxAppSettings.clientSecret
        }
        ContentType = 'application/x-www-form-urlencoded'
    }; if ($env:HTTP_PROXY) { $irmParams['Proxy'] = $env:HTTP_PROXY }

    # Request AccessToken
    try {
        $response = Invoke-RestMethod @irmParams
    } catch {
        Write-Error $PSItem.Exception.Message -ea 1
    }

    # Check AccessToken
    $response
} # Get-BoxAccessToken 'C:\Box\config.json'
