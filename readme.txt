-----------------------------------
course_project_v1 folder cointains 5 stage pipelined RISC processor
course_project_v1_6STAGE cointains equivalent 6 stage pipelined RISC processor

Open course_project_v1 or course_project_v1_6STAGE folder ----------->

Open Quartus software -> Open QPF file -> Analysis and synthesis the design

Open modelsim from Quartus

Wait for the compilation of design units 

Copy the below code (between the <> brackets) and paste it into transcript

<
vsim work.iitb_risc_22_tb
add wave -position insertpoint sim:/iitb_risc_22_tb/*
add wave -position insertpoint sim:/iitb_risc_22_tb/dut/*
add wave -position insertpoint sim:/iitb_risc_22_tb/dut/Reg_file/*
add wave -position insertpoint sim:/iitb_risc_22_tb/dut/Data_memory/*
add wave -position insertpoint sim:/iitb_risc_22_tb/dut/inst_mem/*
>

Press Enter

Run the simulation


