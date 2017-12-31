function sudo() {

    [CmdletBinding()]
    Param
    (
        [parameter(mandatory=$false, position=0, ValueFromRemainingArguments=$true)]$Remaining
    )

    $cwd = $(Get-Location).Path
    $file = [System.IO.Path]::GetTempFileName()

    $processInfo = new-object System.Diagnostics.ProcessStartInfo "powershell"
    $processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $processInfo.WorkingDirectory = $(Get-Location).Path
    $processInfo.Arguments = "-NonInteractive -NoLogo -Command Set-Location $cwd; $Remaining | Tee-Object -FilePath $file"
    $processInfo.Verb = 'runas'

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo

    $process.Start() | Out-Null
    $process.WaitForExit()

    $stdout = [System.IO.File]::ReadAllText($file)

    [System.IO.File]::Delete($file)
    Write-Output $stdout    
}

function amiadmin() {
    $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
    return $myWindowsPrincipal.IsInRole($adminRole)
}
