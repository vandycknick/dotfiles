<#
.SYNOPSIS 
My personal powershell profile settings

.DESCRIPTION
Functions and settings configure pwsh to become even more amazing

- Needs a solarized theme via ColorTool
- Depends on posh-get >= 1.0.0

.LINK
https://github.com/Microsoft/console

.LINK
https://github.com/dahlbyk/posh-git#customizing-the-posh-git-prompt

#>

if (Get-Module -ListAvailable -Name "PSReadline") {
    $readLineOptions = Get-PSReadlineOption

    Set-PSReadLineOption -BellStyle Visual
    Set-PSReadLineOption -ViModeIndicator Cursor

    $readLineOptions.CommentColor = "$([char]0x001b)[34m"
    $readLineOptions.DefaultTokenColor = "$([char]0x001b)[1m"
    $readLineOptions.EmphasisColor = "$([char]0x001b)[1m"
    $readLineOptions.ErrorColor = "$([char]0x001b)[1;31m"
    $readLineOptions.KeywordColor = "$([char]0x001b)[34m"
    $readLineOptions.MemberColor = "$([char]0x001b)[1m"
    $readLineOptions.OperatorColor = "$([char]0x001b)[1;30m"
    $readLineOptions.CommandColor = "$([char]0x001b)[33m"
    $readLineOptions.StringColor = "$([char]0x001b)[32m"
    $readLineOptions.ContinuationPromptColor = "$([char]0x001b)[34m"
    $readLineOptions.NumberColor = "$([char]0x001b)[35m"
    $readLineOptions.ParameterColor = "$([char]0x001b)[35m"
    $readLineOptions.TypeColor = "$([char]0x001b)[35m"
    $readLineOptions.VariableColor = "$([char]0x001b)[1;35m"
    $readLineOptions.EmphasisColor = "$([char]0x001b)[46m"
    $readLineOptions.SelectionColor = "$([char]0x001b)[46m"
}

function prompt {
    $origLastExitCode = $LASTEXITCODE
    
    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~")

    $prompt = ""

    $prompt += Write-Prompt "$([char]0x001b)[38;5;166m$([Environment]::UserName)"
    $prompt += Write-Prompt "$([char]0x001b)[1m@"
    $prompt += Write-Prompt "$([char]0x001b)[38;5;136m$([System.Net.Dns]::GetHostName().ToLower())"
    $prompt += Write-Prompt "$([char]0x001b)[1m(win): "
    $prompt += Write-Prompt "$([char]0x001b)[38;5;64m$curPath$([char]0x001b)[0m"
    $prompt += Write-VcsStatus
    $prompt += "`n"
    $prompt += "$([char]0x001b)[1m$('$' * ($nestedPromptLevel + 1)) $([char]0x001b)[0m"

    $LASTEXITCODE = $origLastExitCode
    $prompt
}

Import-Module z
Import-Module posh-git

if ($Global:GitPromptSettings)
{
    $Global:GitPromptSettings.BranchColor.ForegroundColor = "$([char]0x001b)[36m"
    $Global:GitPromptSettings.BranchIdenticalStatusSymbol.ForegroundColor = "$([char]0x001b)[36m"
    $Global:GitPromptSettings.LocalStagedStatusSymbol.ForegroundColor = "$([char]0x001b)[36m"
    $Global:GitPromptSettings.BranchAheadStatusSymbol.ForegroundColor = "$([char]0x001b)[32m"
    $Global:GitPromptSettings.BeforeStatus.ForegroundColor = "$([char]0x001b)[33m"
    $Global:GitPromptSettings.DelimStatus.ForegroundColor = "$([char]0x001b)[33m"
    $Global:GitPromptSettings.AfterStatus.ForegroundColor = "$([char]0x001b)[33m"
    $Global:GitPromptSettings.BranchBehindAndAheadStatusSymbol.ForegroundColor = "$([char]0x001b)[33m"
}

New-PSDrive -Name Projects -PSProvider FileSystem -Root D:\Projects\ -Description "My personal hobby projects." | Out-Null
New-PSDrive -Name Work -PSProvider FileSystem -Root D:\Work\ -Description "Everything work related." | Out-Null

Set-Alias g git
Set-Alias which Get-Command
Set-Alias uptime Get-Uptime
