transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/intelProjects/controller {E:/intelProjects/controller/controller.v}

vlog -vlog01compat -work work +incdir+E:/intelProjects/controller/simulation/modelsim {E:/intelProjects/controller/simulation/modelsim/controller.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  controller_vlg_tst

add wave *
view structure
view signals
run -all
