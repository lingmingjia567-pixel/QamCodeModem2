transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/nco.vo}
vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/QamCodeModem.v}
vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/CodeMap.v}
vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/DeCodeMap.v}
vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/CarrierModulator.v}
vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem {D:/Quartus13.1/altera/program/QamCodeModem/FilterWrapper.v}

vlog -vlog01compat -work work +incdir+D:/Quartus13.1/altera/program/QamCodeModem/simulation/modelsim {D:/Quartus13.1/altera/program/QamCodeModem/simulation/modelsim/QamCodeModem.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  QamCodeModem_vlg_tst

add wave *
view structure
view signals
run -all
