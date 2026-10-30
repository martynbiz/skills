<#
Link skills from this repo into Claude Code's skills directory (Windows).

Usage:
  .\install.ps1                 Install all skills
  .\install.ps1 grill-me ...    Install only the named skills
  .\install.ps1 -u [names...]   Uninstall (remove links) for all or named skills
  .\install.ps1 -l              List skills and whether they are installed

Set $env:CLAUDE_DIR to target somewhere other than ~\.claude.
Uses directory junctions, so no admin rights or Developer Mode are needed.
#>

[CmdletBinding()]
param(
  [Alias('u')][switch]$Uninstall,
  [Alias('l')][switch]$List,
  [Alias('h')][switch]$Help,
  [Parameter(Position = 0, ValueFromRemainingArguments = $true)][string[]]$Names
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# Symbols as char codes so the script stays ASCII (PS 5.1 misreads BOM-less UTF-8)
$OK = [char]0x2713; $FAIL = [char]0x2717; $RELINK = [char]0x21BB; $SKIP = [char]0x00B7

if ($Help) {
  (Get-Content $PSCommandPath -TotalCount 12 | Select-Object -Skip 1 -First 10) -join "`n"
  exit 0
}

$SrcDir = Join-Path $PSScriptRoot 'skills'
$ClaudeDir = if ($env:CLAUDE_DIR) { $env:CLAUDE_DIR } else { Join-Path $HOME '.claude' }
$DestDir = Join-Path $ClaudeDir 'skills'

function Normalize([string]$path) {
  [IO.Path]::GetFullPath($path).TrimEnd('\', '/')
}

# Target of a junction/symlink at $path, or $null if it isn't a link
function Get-LinkTarget([string]$path) {
  $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
  if ($item -and $item.LinkType -in 'Junction', 'SymbolicLink') {
    return Normalize (@($item.Target)[0])
  }
  return $null
}

function Fail([string]$msg) {
  $host.UI.WriteErrorLine($msg)
  $script:status = 1
}

# Skills to act on: named args, or every folder under skills\ with a SKILL.md
if (-not $Names) {
  $Names = @(Get-ChildItem -LiteralPath $SrcDir -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
    ForEach-Object Name)
}

if (-not $Names) {
  "No skills found in $SrcDir"
  exit 0
}

New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
$status = 0

foreach ($name in $Names) {
  $src = Normalize (Join-Path $SrcDir $name)
  $dest = Join-Path $DestDir $name

  if (-not (Test-Path (Join-Path $src 'SKILL.md'))) {
    Fail "$FAIL ${name}: no such skill in $SrcDir"
    continue
  }

  $target = Get-LinkTarget $dest
  $exists = Test-Path -LiteralPath $dest

  if ($Uninstall) {
    if ($target -eq $src) {
      # Delete the link itself, never recurse into the target
      [IO.Directory]::Delete($dest)
      "$OK ${name}: removed"
    } elseif ($target -or $exists) {
      Fail "$FAIL ${name}: $dest is not a link to this repo - leaving it"
    } else {
      "$SKIP ${name}: not installed"
    }
  } elseif ($List) {
    if ($target -eq $src) { "$OK $name" } else { "  $name" }
  } else {
    if ($target -eq $src) {
      "$SKIP ${name}: already installed"
    } elseif ($target) {
      [IO.Directory]::Delete($dest)
      New-Item -ItemType Junction -Path $dest -Target $src | Out-Null
      "$RELINK ${name}: relinked (was $target)"
    } elseif ($exists) {
      Fail "$FAIL ${name}: $dest exists and is not a link - skipping"
    } else {
      New-Item -ItemType Junction -Path $dest -Target $src | Out-Null
      "$OK ${name}: installed"
    }
  }
}

exit $status
