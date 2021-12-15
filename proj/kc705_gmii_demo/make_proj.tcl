set proj_name "kc705_gmii"

set IPBUS_SRC_DIR "../../src/ipbus-firmware"


source source/src_files.tcl
source constraints/constrains.tcl

# src_err : source file not found
# ips_srr : xilinx ips file not found
# xdc_err : timing constraint file not found
if {(${src_err}||${ips_err}||${xdc_err})} {
  exit;
} 

create_project ${proj_name} . -part xc7k325tffg900-2 -force
set_property ip_repo_paths {} [current_project]

if {[string equal [get_filesets -quiet constrs_1] ""]} {create_fileset -constrset constrs_1}
if {[string equal [get_filesets -quiet sources_1] ""]} {create_fileset -srcset sources_1}

source ${IPBUS_SRC_DIR}/boards/kc705/common/firmware/cfg/settings_v7.tcl

add_files -norecurse -fileset sources_1 "${src_file_list}"
add_files -norecurse -fileset constrs_1 "${timing_constraints}"

set_property USED_IN implementation [get_files [string trim "${timing_constraints}"]]

import_files -norecurse -fileset sources_1 "${xilinx_ips}"

set_property top top [current_fileset]
set_property "steps.synth_design.args.flatten_hierarchy" "none" [get_runs synth_1]

foreach index ${xilinx_ips} {
  set IP [file rootname [file tail ${index}]]
  upgrade_ip [get_ips ${IP}]
}
foreach index ${xilinx_ips} {
  set IP [file rootname [file tail ${index}]]
  create_ip_run [get_ips ${IP}]
}

launch_runs synth_1 -jobs 35
wait_on_run synth_1 -timeout 1

launch_runs impl_1 -jobs 35
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 30

close_project

exit