transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {getrandom.vo}

vlog -vlog01compat -work work +incdir+E:/intelProjects/getrandom/simulation/modelsim {E:/intelProjects/getrandom/simulation/modelsim/getrandom.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L maxii_ver -L gate_work -L work -voptargs="+acc"  getrandom_vlg_tst

add wave *
view structure
view signals
run -all
