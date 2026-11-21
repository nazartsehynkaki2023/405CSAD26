param([string]$SuitePath = '')
$ErrorActionPreference = 'Stop'
if ($SuitePath) {
  $suite = (Resolve-Path -LiteralPath $SuitePath).Path
  $env:PATH = "$suite/bin;$suite/lib;" + $env:PATH
}
Push-Location $PSScriptRoot
try {
  New-Item -ItemType Directory -Force results | Out-Null
  foreach ($tool in @('iverilog','vvp','yosys','nextpnr-ice40')) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
      throw "Missing $tool. Pass -SuitePath with the extracted oss-cad-suite folder."
    }
  }
  # Never reuse an old compiled file after a failed compilation.
  if (Test-Path results/tb.vvp) { Remove-Item -LiteralPath results/tb.vvp }
  & iverilog -g2012 -s tb_i2c -o results/tb.vvp rtl/i2c_tx.v rtl/i2c_rx.v rtl/i2c_master.v rtl/i2c_top.v tb/tb_i2c.v
  $compileCode = $LASTEXITCODE
  "iverilog_exit=$compileCode" | Out-File results/tool_status.log
  if ($compileCode -ne 0) {
    if ($compileCode -eq -1073741819 -and (Test-Path results/tb.vvp)) {
      Write-Warning 'Icarus Windows crash after writing output. Validating the new file with vvp and all 13 scenarios.'
    } else { throw 'Compilation failed' }
  }
  & vvp results/tb.vvp 2>&1 | Tee-Object results/simulation.log
  if ($LASTEXITCODE -ne 0) { throw 'Simulation failed' }
  if (!(Select-String -LiteralPath results/simulation.log -SimpleMatch 'ALL PASS: 13 scenarios')) {
    throw 'The complete test suite did not pass'
  }
  'vvp_exit=0; all_13_scenarios_passed=true' | Out-File results/tool_status.log -Append
  & yosys -Q -l results/synthesis.log -p 'read_verilog rtl/i2c_tx.v rtl/i2c_rx.v rtl/i2c_master.v rtl/i2c_top.v; synth_ice40 -top i2c_top -json results/i2c.json; stat' > results/synthesis_console.log
  if ($LASTEXITCODE -ne 0) { throw 'Synthesis failed' }
  $savedErrorPreference = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  & nextpnr-ice40 --hx8k --package ct256 --json results/i2c.json --asc results/i2c.asc --freq 50 --seed 1 --report results/timing.json --log results/place_route.log 2>&1 | Out-File results/place_route_console.log
  $pnrExitCode = $LASTEXITCODE
  $ErrorActionPreference = $savedErrorPreference
  if ($pnrExitCode -ne 0) { throw "Place and route failed (exit $pnrExitCode). See results/place_route.log" }
  Write-Host 'Simulation and synthesis completed. See results/.'
} finally { Pop-Location }
