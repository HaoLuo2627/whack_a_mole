transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/intelProjects/led_88 {E:/intelProjects/led_88/led_88.v}

vlog -vlog01compat -work work +incdir+E:/intelProjects/led_88/simulation/modelsim {E:/intelProjects/led_88/simulation/modelsim/led_88.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  led_88_vlg_tst

add wave *
view structure
view signals
run -all
