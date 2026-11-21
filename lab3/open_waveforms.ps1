param([string]$SuitePath = '')
$ErrorActionPreference = 'Stop'
if (!$SuitePath) { throw 'Pass -SuitePath with the OSS CAD Suite folder (for example R:\).' }
$suite = (Resolve-Path -LiteralPath $SuitePath).Path
$env:PATH = "$suite/bin;$suite/lib;" + $env:PATH
$viewer = Join-Path $suite 'bin/gtkwave.exe'
$vcd = Join-Path $PSScriptRoot 'results/i2c.vcd'
$save = Join-Path $PSScriptRoot 'results/signals.gtkw'
if (!(Test-Path -LiteralPath $viewer)) { throw 'GTKWave was not found in the selected suite.' }
if (!(Test-Path -LiteralPath $vcd)) { throw 'Run run_all.ps1 before opening waveforms.' }
# Visible window is intentional: the student examines it and takes screenshots.
Start-Process -FilePath $viewer -WorkingDirectory (Join-Path $PSScriptRoot 'results') -ArgumentList @('"'+$vcd+'"','"'+$save+'"')
