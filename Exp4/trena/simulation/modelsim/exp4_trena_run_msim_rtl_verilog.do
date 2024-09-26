transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/tx_serial_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/tx_serial_7O1_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/tx_serial_7O1.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/trena_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/trena_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/registrador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/mux_4x1_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/interface_hcsr04_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/interface_hcsr04_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/interface_hcsr04.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/hexa7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/gerador_pulso.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/exp4_trena.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/edge_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/deslocador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/contador_m.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/contador_cm_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/contador_cm_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/contador_cm.v}
vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/contador_bcd_3digitos.v}

vlog -vlog01compat -work work +incdir+C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena {C:/Users/tatit/OneDrive/Documentos/USP/pcs3645/Exp4/trena/exp4_trena_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  exp4_trena_tb

add wave *
view structure
view signals
run -all
