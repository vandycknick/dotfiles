Set-Alias -Name uptime -Value Get-Uptime

function Get-Uptime() {
    [CmdletBinding()]
    Param(
        [switch]$Pretty
    )

    $lastBootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $uptimeSpan = (Get-Date) - $lastBootTime

    if ($Pretty)
    {
        $daysUp = $uptimeSpan.Days
        $hoursUp = $uptimeSpan.Hours
        $minutesUp = $uptimeSpan.Minutes
        $daysMessage = @{$true="day"; $false="days"}[$daysUp -eq 1]
        $hoursMessage = @{$true="hour"; $false="hours"}[$hoursUp -eq 1]
        $minuteMessage = @{$true="minute"; $false="minutes"}[$minutesUp -eq 1]

        return "up $daysUp $daysMessage, $hoursUp $hoursMessage, $minutesUp $minuteMessage"
    }
    else
    {
        return $uptimeSpan
    }
}
