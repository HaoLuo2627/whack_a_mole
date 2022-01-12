transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/whack_a_mole_sim.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/buzzer.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/controller.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/fsm.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/getrandom.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/led_88.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/time_divider.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/timer.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/decoder.v}
vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim {E:/intelProjects/whack_a_mole_sim/keyboard_scan.v}

vlog -vlog01compat -work work +incdir+E:/intelProjects/whack_a_mole_sim/simulation/modelsim {E:/intelProjects/whack_a_mole_sim/simulation/modelsim/whack_a_mole_sim.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  whack_a_mole_sim_vlg_tst

add wave *
view structure
view signals
run -all
