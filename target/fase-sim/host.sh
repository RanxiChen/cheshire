#!/usr/bin/env bash
set -euo pipefail
fase_host=$(realpath "${FASE_HOST:?Set FASE_HOST to the original fase-rv64 executable}")
hello_elf=$(realpath "${FASE_HELLO:?Set FASE_HELLO to the bring-up ELF}")
host_config=$(realpath "${FASE_CONFIG:?Set FASE_CONFIG to the KCU105 configuration file}")
cd "$(dirname "$0")/../.."
root=$PWD
if [ ! -x "$root/fase-validation/obj_dir/VFaseSim" ]; then
  echo 'Build the RTL simulator with bash target/fase-sim/run.sh first.' >&2
  exit 1
fi
run=$(mktemp -d "$root/fase-validation/host.XXXXXX")
printf '%s\n' "$run" > "$root/fase-validation/host-current"
cp "$host_config" "$run/host.ini"
cp "$root/hw/fase/fase_ctrl_microcode.mem" "$run/"
sha256sum "$fase_host" "$hello_elf" "$run/host.ini" > "$run/host-inputs.sha256"
cd "$run"
"$root/fase-validation/obj_dir/VFaseSim" --pty-file serial.txt > simulator.log 2>&1 &
simulator=$!
trap 'kill -TERM "$simulator" 2>/dev/null || true; wait "$simulator" || true' EXIT
for ((attempt=0; attempt<100; attempt++)); do
  test ! -s serial.txt || break
  kill -0 "$simulator"
  sleep 0.05
done
serial=$(cat serial.txt)
timeout --kill-after=5 1800 "$fase_host" serial -c host.ini -s "$serial" \
  -w "$hello_elf" > host.log 2>&1
grep -Fxq 'FASE_SPIKE_HOST_HELLO' host.log
grep -Fq 'All cores halted, exit' host.log
kill -TERM "$simulator"
wait "$simulator"
trap - EXIT
printf '%s\n' 'PASS original Host ELF/Sv39/write/exit against full Cheshire + CVA6 RTL' > PASS
