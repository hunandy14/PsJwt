function Get-UnixTimestamp {
    <#
    .SYNOPSIS
    Calculates the Unix timestamp for the current time plus an optional number of seconds.

    .DESCRIPTION
    This function returns the Unix timestamp after adding a specified number of seconds
    to the current time. By default, it returns the current Unix timestamp.

    .PARAMETER AddSecond
    The number of seconds to add to the current time before calculating the timestamp.

    .EXAMPLE
    Get-UnixTimestamp -AddSecond 45
    # Returns the Unix timestamp for 45 seconds in the future from now.

    .NOTES
    This function is designed for use in PowerShell 7 and above.
    #>

    [CmdletBinding(DefaultParameterSetName = "")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "")]
        [int]$AddSecond = 0
    )

    # Define the Unix epoch start time
    $epochStartTime = Get-Date '1970-01-01 00:00:00'

    # Get the current date and time in UTC, adding the specified seconds
    $currentTimeUTC = (Get-Date).ToUniversalTime().AddSeconds($AddSecond)

    # Calculate the total seconds between now and the Unix epoch
    $totalSecondsSinceEpoch = ($currentTimeUTC - $epochStartTime).TotalSeconds

    # Round the total seconds to the nearest whole number and cast to an integer
    $roundedSeconds = [int][Math]::Round($totalSecondsSinceEpoch)

    return $roundedSeconds
} # Get-UnixTimestamp -AddSecond 45
