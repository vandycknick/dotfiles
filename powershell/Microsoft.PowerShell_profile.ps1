# Use Color tool to install soarized theme: https://github.com/Microsoft/console/tree/master/tools/ColorTool
# Host Foreground
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.WarningForegroundColor = 'Yellow'
$Host.PrivateData.DebugForegroundColor = 'Green'
$Host.PrivateData.VerboseForegroundColor = 'Blue'
$Host.PrivateData.ProgressForegroundColor = 'White'

# Host Background
$Host.PrivateData.ErrorBackgroundColor = 'DarkGray'
$Host.PrivateData.WarningBackgroundColor = 'DarkGray'
$Host.PrivateData.DebugBackgroundColor = 'DarkGray'
$Host.PrivateData.VerboseBackgroundColor = 'DarkGray'
$Host.PrivateData.ProgressBackgroundColor = 'DarkCyan'

# Check for PSReadline
if (Get-Module -ListAvailable -Name "PSReadline") {
    $readLineOptions = Get-PSReadlineOption

    # Foreground
    $readLineOptions.CommandForegroundColor = 'DarkYellow'
    $readLineOptions.ContinuationPromptForegroundColor = 'DarkBlue'
    $readLineOptions.DefaultTokenForegroundColor = 'DarkBlue'
    $readLineOptions.EmphasisForegroundColor = 'White'
    $readLineOptions.ErrorForegroundColor = 'Red'
    $readLineOptions.KeywordForegroundColor = 'DarkGreen'
    $readLineOptions.MemberForegroundColor = 'DarkCyan'
    $readLineOptions.NumberForegroundColor = 'DarkCyan'
    $readLineOptions.OperatorForegroundColor = 'DarkGreen'
    $readLineOptions.ParameterForegroundColor = 'DarkGreen'
    $readLineOptions.StringForegroundColor = 'DarkBlue'
    $readLineOptions.TypeForegroundColor = 'DarkYellow'
    $readLineOptions.VariableForegroundColor = 'DarkMagenta'

    # Background
    $readLineOptions.CommandBackgroundColor = 'Black'
    $readLineOptions.ContinuationPromptBackgroundColor = 'Black'
    $readLineOptions.DefaultTokenBackgroundColor = 'Black'
    $readLineOptions.EmphasisBackgroundColor = 'Black'
    $readLineOptions.ErrorBackgroundColor = 'Black'
    $readLineOptions.KeywordBackgroundColor = 'Black'
    $readLineOptions.MemberBackgroundColor = 'Black'
    $readLineOptions.NumberBackgroundColor = 'Black'
    $readLineOptions.OperatorBackgroundColor = 'Black'
    $readLineOptions.ParameterBackgroundColor = 'Black'
    $readLineOptions.StringBackgroundColor = 'Black'
    $readLineOptions.TypeBackgroundColor = 'Black'
    $readLineOptions.VariableBackgroundColor = 'Black'
}

function prompt {
    $origLastExitCode = $LASTEXITCODE
    
    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    $curPath = $curPath.Replace($HOME, "~")
    
    Write-Host "$([Environment]::UserName)" -ForegroundColor DarkCyan -NoNewline
    Write-Host "@" -ForegroundColor White -NoNewline
    Write-Host "$([System.Net.Dns]::GetHostName().ToLower())" -ForegroundColor DarkGreen -NoNewline
    Write-Host "(win): " -ForegroundColor White -NoNewline
    Write-Host $curPath -ForegroundColor DarkBlue -NoNewline
    Write-VcsStatus
    Write-Host ""
    $LASTEXITCODE = $origLastExitCode
    "$('$' * ($nestedPromptLevel + 1)) "
}

Import-Module z
Import-Module posh-git

$env:SSH_AGENT_PID = $null
$env:SSH_AUTH_SOCK = $null

$global:GitPromptSettings.BranchAheadStatusForegroundColor = [System.ConsoleColor]::Cyan
$global:GitPromptSettings.BeforeForegroundColor = [System.ConsoleColor]::White
$global:GitPromptSettings.BeforeText = ' on '
$global:GitPromptSettings.AfterText = ''

New-PSDrive -Name Projects -PSProvider FileSystem -Root D:\Projects\ -Description "My personal hobby projects." | Out-Null
New-PSDrive -Name Work -PSProvider FileSystem -Root D:\Work\ -Description "Everything work related." | Out-Null

Set-Alias g git
Set-Alias which Get-Command

# Functions
$PROFILEPATH = ($PROFILE | Split-Path)
# . $PROFILEPATH/sudo.ps1
. $PROFILEPATH/Get-Uptime.ps1