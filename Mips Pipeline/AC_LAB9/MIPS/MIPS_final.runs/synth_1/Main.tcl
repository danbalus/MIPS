# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.cache/wt [current_project]
set_property parent.project_path C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/RF.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/IFetch.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/ID.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/UControl.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/SSD.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/MPG.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/MEM.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/EX.vhd
  C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/sources_1/new/test_env.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/constrs_1/imports/Desktop/Basys3_test_env1.xdc
set_property used_in_implementation false [get_files C:/Users/DanB/Desktop/AC_LAB9/AC_LAB9/MIPS/MIPS_final.srcs/constrs_1/imports/Desktop/Basys3_test_env1.xdc]


synth_design -top Main -part xc7a35tcpg236-1


write_checkpoint -force -noxdef Main.dcp

catch { report_utilization -file Main_utilization_synth.rpt -pb Main_utilization_synth.pb }
