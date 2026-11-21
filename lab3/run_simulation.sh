#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
mkdir -p results
iverilog -g2012 -s tb_i2c -o results/tb.vvp \
  rtl/i2c_tx.v rtl/i2c_rx.v rtl/i2c_master.v rtl/i2c_top.v tb/tb_i2c.v
vvp results/tb.vvp > results/simulation.log
cat results/simulation.log
grep -q '^ALL PASS: 13 scenarios$' results/simulation.log
