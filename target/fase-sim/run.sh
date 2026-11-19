#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
root=$PWD
out=$root/fase-validation
mkdir -p "$out"
bender=${BENDER:-bender}
export BENDER_GIT_SUBMODULES=${BENDER_GIT_SUBMODULES:-true}
make -j4 "BENDER=$bender" hw-all
cp "$root/hw/fase/fase_ctrl_microcode.mem" "$out/"
"$bender" script verilator -t rtl -t cva6 \
  -t cv64a6_imafdchsclic_sv39_wb -t fase_fsm > "$out/sources.f"
cd "$out"
riscv64-linux-gnu-gcc -nostdlib -static -march=rv64imafdc -mabi=lp64d \
  -Wl,--build-id=none -Wl,-Ttext=0x80001000 "$root/target/fase-sim/stress.S" -o stress.elf
riscv64-linux-gnu-objcopy -O binary -j .text stress.elf stress.bin
verilator +define+SYNTHESIS --assert --cc --exe --build -j 6 -Wno-fatal -Wno-BLKANDNBLK --top-module FaseSim \
  -CFLAGS '-O1' -f sources.f "$root/target/fase-sim/FaseSim.sv" \
  "$root/target/fase-sim/main.cpp" > build.log 2>&1
./obj_dir/VFaseSim > run.log 2>&1
./obj_dir/VFaseSim --fault > fault.log 2>&1
