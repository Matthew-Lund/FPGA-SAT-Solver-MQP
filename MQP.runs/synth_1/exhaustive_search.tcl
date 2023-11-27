# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/mtlun/Documents/MQP/MQP/MQP.runs/synth_1/exhaustive_search.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_msg_config  -id {Synth 8-439}  -string {{ERROR: [Synth 8-439] module 'clk_wiz_1' not found}}  -suppress 
set_msg_config  -id {Common 17-69}  -string {{ERROR: [Common 17-69] Command failed: Synthesis failed - please see the console or run log file for details}}  -suppress 
set_msg_config  -id {IP_Flow 19-4739}  -string {{CRITICAL WARNING: [IP_Flow 19-4739] Writing uncustomized BOM file 'c:/Users/Matthew/Documents/GitHub/FPGA-top-level/mqp_board.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xml'}}  -suppress 
set_msg_config  -id {IP_Flow 19-4739}  -string {{CRITICAL WARNING: [IP_Flow 19-4739] Writing uncustomized BOM file 'c:/Users/Matthew/Documents/GitHub/FPGA-top-level/mqp_board.gen/sources_1/ip/clk_wiz_1/clk_wiz_1.xml'}}  -suppress 
set_msg_config  -id {Synth 8-6895}  -string {{CRITICAL WARNING: [Synth 8-6895] The reference checkpoint C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/utils_1/imports/synth_1/FSM_Exhaustive.dcp is not suitable for use with incremental synthesis for this design. Please regenerate the checkpoint for this design with -incremental_synth switch in the same Vivado session that synth_design has been run. Synthesis will continue with the default flow}}  -suppress 
set_msg_config  -id {Synth 8-9887}  -string {{WARNING: [Synth 8-9887] parameter declaration becomes local in 'lfsr16' with formal parameter declaration list [C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/sources_1/new/lfsr16.sv:31]}}  -suppress 
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a200tsbg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/mtlun/Documents/MQP/MQP/MQP.cache/wt [current_project]
set_property parent.project_path C:/Users/mtlun/Documents/MQP/MQP/MQP.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/mtlun/Documents/MQP/MQP/MQP.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
read_verilog -library xil_defaultlib -sv C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/sources_1/new/exhaustive_search.sv
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/constrs_1/new/Nexys_Board.xdc
set_property used_in_implementation false [get_files C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/constrs_1/new/Nexys_Board.xdc]

set_param ips.enableIPCacheLiteLoad 1

read_checkpoint -auto_incremental -incremental C:/Users/mtlun/Documents/MQP/MQP/MQP.srcs/utils_1/imports/synth_1/FSM_Exhaustive.dcp
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top exhaustive_search -part xc7a200tsbg484-1 -incremental_mode quick
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef exhaustive_search.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file exhaustive_search_utilization_synth.rpt -pb exhaustive_search_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
