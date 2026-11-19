"""Rebuild the KCU105 CVA6/FASE microcode FPGA image from pinned sources."""

from pathlib import Path
import datetime
import json
import os
import shutil
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
env = dict(os.environ, BENDER_GIT_SUBMODULES="false")
bender = shutil.which(env.get("BENDER", "bender"))
vivado = shutil.which(env.get("VIVADO", "vivado"))
if bender is None or vivado is None:
    sys.exit("Add Bender and Vivado 2022.2 to PATH or set BENDER and VIVADO.")
bender = str(Path(bender).absolute())
vivado = str(Path(vivado).absolute())

subprocess.run(["make", "-j4", f"BENDER={bender}", "hw-all"],
               cwd=root, env=env, check=True)

now = datetime.datetime.now(datetime.timezone.utc)
run = root / "runs" / now.strftime("%Y%m%dT%H%M%SZ")
run.mkdir(parents=True)
(root / "handoff/current-run.txt").write_text(str(run) + "\n")
args = [bender, "-d", str(root), "script", "vivado", "-t", "fpga", "-t", "xilinx",
        "-t", "kcu105", "-t", "bscane", "-t", "rtl", "-t", "cva6",
        "-t", "cv64a6_imafdchsclic_sv39_wb", "-t", "fase_fsm"]
sources_file = run / "sources.tcl"
with sources_file.open("w") as out:
    subprocess.run(args, stdout=out, env=env, check=True)
sources = sources_file.read_text()
if "dmi_bscane_tap.sv" not in sources or "/src/dmi_jtag_tap.sv" in sources:
    sys.exit("Bender did not select the KCU105 BSCAN DMI source.")

cva6 = subprocess.check_output([bender, "-d", str(root), "path", "cva6"],
                               env=env, text=True).strip()
cva6_revision = subprocess.check_output(["git", "-C", cva6, "rev-parse", "HEAD"],
                                        text=True).strip()
head = subprocess.check_output(["git", "-C", str(root), "rev-parse", "HEAD"],
                               text=True).strip()
subprocess.run(["tar", "-czf", str(run / "source-inputs.tar.gz"), "Bender.yml",
                "Bender.lock", "hw", "target/xilinx/src", "target/xilinx/scripts",
                "target/xilinx/constraints"], cwd=root, check=True)
(run / "source.patch").write_bytes(subprocess.check_output(
    ["git", "-C", str(root), "diff", "--binary"]))
cmd = [vivado, "-mode", "batch", "-source",
       str(root / "target/xilinx/scripts/build_board_shell.tcl"),
       "-log", str(run / "vivado.log"), "-journal", str(run / "vivado.jou"),
       "-tclargs", str(root), str(run)]
(run / "command.json").write_text(json.dumps({
    "cwd": str(root), "command": cmd, "bender": args, "cheshire_revision": head,
    "cva6_revision": cva6_revision, "started_utc": now.isoformat(),
    "project_generation_only": env.get("CVA6_BD_ONLY") == "1",
}, indent=2) + "\n")
print(run, flush=True)
with (run / "console.log").open("w") as out:
    result = subprocess.run(cmd, cwd=run, env=env, stdout=out, stderr=subprocess.STDOUT)
(run / "build.exit").write_text(str(result.returncode) + "\n")
print("BUILD_EXIT", result.returncode, flush=True)
sys.exit(result.returncode)
