library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISC_components.all;

entity IITB_RISC_22 is
	port (
    clk	: in  std_logic ;
	
    custom_in : in std_logic; 	
    TestA : in std_logic_vector(15 downto 0);	
    TestB : in std_logic_vector(15 downto 0)	;
	input_pc_rst : in std_logic
   
    );
end IITB_RISC_22;

architecture Behavioral of IITB_RISC_22 is 
 
 signal inc_pc,pc_output:std_logic_vector(15 downto 0) ;
 signal pc_input:std_logic_vector(15 downto 0):=(others =>'0');
 signal current_instr:std_logic_vector(15 downto 0);
 signal write_pc,pc_rst:std_logic;
 signal dummy_3:std_logic_vector(2 downto 0);
 signal dummy_16:std_logic_vector(15 downto 0);
 signal IF_reg_inp,IF_reg_outp,ID_reg_inp,ID_reg_outp,EX_reg_inp,EX_reg_outp,MEM_reg_inp,MEM_reg_outp,WB_reg_inp,WB_reg_outp:std_logic_vector(300 downto 0);	
 signal IF_write,IF_rst,ID_write,ID_rst,EX_write,EX_rst,MEM_write,MEM_rst,WB_write,WB_rst:std_logic; 
 signal regfile_rst,regfile_write_En:std_logic; 
 signal regfile_read_A,regfile_read_B,regfile_write_Add:std_logic_vector(2 downto 0);
 signal regfile_data_A,regfile_data_B,regfile_data_Inp:std_logic_vector(15 downto 0);
 signal sel_mux_A1_regfile,sel_mux_A0_regfile,sel_mux_regfile_B1,sel_mux_regfile_B0,sel_mux_regfile_Wr1,sel_mux_regfile_Wr0:std_logic;
 signal sel_mux_regfile_outA1,sel_mux_regfile_outA0,sel_mux_outB1_regfile,sel_mux_outB0_regfile,sel_WB1_mux,sel_WB0_mux:std_logic;
 signal outp_alu_control:std_logic_vector(3 downto 0);
 signal alu_A,alu_B,result_alu,actual_alu_result:std_logic_vector(15 downto 0); 
 signal CC_input,CC_output:std_logic_vector(1 downto 0);
 signal CC_wr,CC_rst:std_logic; 
 signal data_mem_wr,data_mem_rd:std_logic;
 signal data_mem_inp,data_mem_addr:std_logic_vector(15 downto 0);
 signal WB_mux_outp,jmp_mux_result:std_logic_vector(15 downto 0);
 signal Cntrl_Word,Cntrl_Word_Stall,Cntrl_Word_Orig,Cntrl_Word_Orig2,Cntrl_Word_Execute,Cntrl_Word_Flush:std_logic_vector(38 downto 0); 
 signal Addr_A,Addr_B,Addr_Result:std_logic_vector(15 downto 0);
 signal Sel_PC1_Mux,Sel_PC0_Mux,Sel_Jmp1_Mux,Sel_Jmp0_Mux:std_logic;
 signal Branch_Mux_Result:std_logic_vector(1 downto 0);
 signal Sel_branch_Mux,Sel_Signext_Mux:std_logic;
 signal Result_Signext_Mux:std_logic_vector(15 downto 0);
 signal Addr_LM,Addrs_LM_Result,Init_LM_Addrs,New_Current_Instr:std_logic_vector(15 downto 0);
 signal Sel_Reg_LM1_Mux,Sel_Reg_LM0_Mux,Sel_Mem_Addrs_LM1_Mux,Sel_Mem_Addrs_LM0_Mux,LM_Count,Cntrl_0,Sel_Hazard_Cntrl_Mux:std_logic;
 signal Count,Count_SM,Count_Jump,Count_Branch:integer:= -1;
 signal Count_Std:std_logic_vector(2 downto 0);
 signal LHI_Result:std_logic_vector(15 downto 0);
 signal Sel_line_OutA, Sel_line_OutB:std_logic_vector(1 downto 0);
 signal Reg_WR_Check,Mem_WR_Check,StallBit,FlushBit,FlushBitBranch,CntrlJmp,CntrlBranch:std_logic;
 
 
begin

--Instruction_Fetch started
inst_mem:instr_mem port map(pc_output,current_instr);

PC_reg:reg generic map(16) port map(clk,write_pc,pc_rst,pc_input,pc_output);-- 
PC_inc:pc_incr port map(pc_output,inc_pc);--
mux_PC:mux_4x1 generic map(16) port map(inc_pc,EX_reg_outp(215 downto 200),EX_reg_outp(47 downto 32),dummy_16,pc_input,Sel_PC1_Mux,Sel_PC0_Mux);	--adder_result_on_2

pc_rst<=input_pc_rst;

-- pipeline register defined
IF_reg_inp(15 downto 0)<=current_instr; 
IF_reg_inp(165 downto 150)<=pc_output;		--
IF_reg_inp(181 downto 166)<=inc_pc;	--  
IF_pipeline_reg : reg generic map(301)port map(clk,IF_write,IF_rst,IF_reg_inp,IF_reg_outp);--IF_Pipeline_register


with EX_reg_outp(126)select
Sel_PC1_Mux <= '0' when '0',
				'1' when '1',
				'0' when others;

with EX_reg_outp(127)select	
Sel_PC0_Mux<='0' when '0',
				'1' when '1',
				'0' when others;

				   
-- End of Instruction_Fetch stage



-- Decodeing_stage
ID_reg_inp(15 downto 0)<=IF_reg_outp(15 downto 0);
ID_pipeline_reg:reg generic map(301) port map(clk,ID_write,ID_rst,ID_reg_inp,ID_reg_outp); 		--ID Pipeline register

--ALU control logic datapath
ALUcontrol:ALU_control_logic  port map(IF_reg_outp(15 downto 12),IF_reg_outp(2 downto 0),outp_alu_control);

--sign extension datapath
sign_ext6:sign_extension  generic map(6) port map(IF_reg_outp(5 downto 0),ID_reg_inp(98 downto 83));
sign_ext9:sign_extension generic map(9)port map(IF_reg_outp(8 downto 0),ID_reg_inp(197 downto 182));--

--register file and corresponding input mux
Reg_file:regfile  port map(custom_in,TestA,TestB,pc_output,clk,regfile_rst,regfile_read_A,regfile_read_B,regfile_data_A,regfile_data_B,regfile_data_Inp,regfile_write_En,regfile_write_Add);	-- Register file 
mux_regfile_A:mux_4x1 generic map(3) port map(IF_reg_outp(11 downto 9),IF_reg_outp(8 downto 6),dummy_3,dummy_3,regfile_read_A,sel_mux_A1_regfile,sel_mux_A0_regfile);	-- MUX
mux_regfile_B:mux_4x1 generic map(3) port map(IF_reg_outp(8 downto 6),IF_reg_outp(11 downto 9),Count_Std,dummy_3,regfile_read_B,sel_mux_regfile_B1,sel_mux_regfile_B0);
mux_regfile_Wr:mux_4x1 generic map(3) port map(MEM_reg_outp(5 downto 3),MEM_reg_outp(8 downto 6),MEM_reg_outp(11 downto 9),MEM_reg_outp(234 downto 232),regfile_write_Add,sel_mux_regfile_Wr1,sel_mux_regfile_Wr0);


-- Instruction decode register inputs update
ID_reg_inp(31 downto 16)<=regfile_data_A;
ID_reg_inp(47 downto 32)<=regfile_data_B;
ID_reg_inp(51 downto 48)<=outp_alu_control;
ID_reg_inp(138 downto 100)<=Cntrl_Word;
ID_reg_inp(15 downto 0)<=IF_reg_outp(15 downto 0);
ID_reg_inp(165 downto 150)<=IF_reg_outp(165 downto 150);--pc
ID_reg_inp( 181 downto 166 )<=IF_reg_outp(181 downto 166); 	--inc_pc
 

 --controller block
Control_component:controller port map(IF_reg_outp(15 downto 0),Count,CC_input(1),CC_input(0),Cntrl_Word_Orig);
	

  
IF_rst<='0';

with Cntrl_Word(0) select
IF_write <= '0' when '0',
				'1' when '1',
				'1' when others;

ID_write<=Cntrl_Word(2);
EX_write<=Cntrl_Word(4);EX_rst<=Cntrl_Word(5);
MEM_write<=Cntrl_Word(6);MEM_rst<=Cntrl_Word(7);

 
regfile_rst<=Cntrl_Word(9);
sel_mux_A1_regfile<=Cntrl_Word(10);sel_mux_A0_regfile<=Cntrl_Word(11);
sel_mux_regfile_B1<=Cntrl_Word(12);sel_mux_regfile_B0<=Cntrl_Word(13);


Reg_WR_Check<=Cntrl_Word(8); 
Mem_WR_Check<=Cntrl_Word(22);

--Hazarding unit
Hazarding_unit:hazard_detection  port map(ID_reg_outp(15 downto 12),ID_reg_outp(11 downto 9),IF_reg_outp(11 downto 9),IF_reg_outp(8 downto 6),Sel_Hazard_Cntrl_Mux); 
mux_Hazard_control:mux_2x1 generic map(39) port map(Cntrl_Word_Orig,Cntrl_Word_Stall,Cntrl_Word_Orig2,Sel_Hazard_Cntrl_Mux);

Cntrl_Word_Stall<="010000000000000000000000000000001010100";
StallBit<=Cntrl_Word(37);
ID_reg_inp(284)<=Sel_Hazard_Cntrl_Mux;
EX_reg_inp(284)<=ID_reg_outp(284);

mux_control:mux_2x1 generic map(39) port map(Cntrl_Word_Orig2,Cntrl_Word_Flush,Cntrl_Word,FlushBit );
Cntrl_Word_Flush<="001000000000000000000000000000001010101";

FlushBit<='1' when(Count_Jump /= -1) 
	else '0';
Control_jump_process:process(New_Current_Instr)
variable opcode:std_logic_vector(3 downto 0);
begin
	opcode:=New_Current_Instr(15 downto 12);
	if ( opcode="1001" or opcode="1010" or opcode="1011")then
		CntrlJmp<='1';
	else
		CntrlJmp<='0';
	end if;

end process Control_jump_process;
Count_jump_process:process(clk)
begin
	if(rising_edge(clk))then
		if(Count_Jump=2)then
			Count_Jump <= -1;	
		elsif(CntrlJmp='1' or FlushBit='1')then
			Count_Jump<=Count_Jump + 1; 	
		end if;
	end if;
end process Count_jump_process;
--End of Decoding Stage

--Start of Execution stage
mux_regfile_outA:mux_4x1 generic map(16) port map(ID_reg_outp(31 downto 16),MEM_reg_outp(83 downto 68),actual_alu_result,MEM_reg_outp(67 downto 52),alu_A,sel_mux_regfile_outA1,sel_mux_regfile_outA0);
mux_regfile_outB:mux_4x1 generic map(16) port map(ID_reg_outp(47 downto 32),ID_reg_outp(98 downto 83),actual_alu_result,MEM_reg_outp(67 downto 52),alu_B,sel_mux_outB1_regfile,sel_mux_outB0_regfile);


-- control signals for mux
sel_mux_regfile_outA:process(EX_reg_outp(284),Sel_line_OutA )
begin
		if(EX_reg_outp(284)='1')then
			sel_mux_regfile_outA1<='0';sel_mux_regfile_outA0<='1';
		elsif(Sel_line_OutA="10")then
			sel_mux_regfile_outA1<='1';sel_mux_regfile_outA0<='0';
		elsif(Sel_line_OutA="11")then
			sel_mux_regfile_outA1<='1';sel_mux_regfile_outA0<='1';
		else
			sel_mux_regfile_outA1<='0';sel_mux_regfile_outA0<='0';
		end if;
end process;

sel_mux_regfile_outB:process(ID_reg_outp(118),ID_reg_outp(119),Sel_line_OutB)
begin
		if( ID_reg_outp(118)='0' and ID_reg_outp(119)='1')then
			sel_mux_outB1_regfile<='0';sel_mux_outB0_regfile<='1';
		elsif(Sel_line_OutB="10")then
			sel_mux_outB1_regfile<='1';sel_mux_outB0_regfile<='0';
		elsif (Sel_line_OutB="11")then
			sel_mux_outB1_regfile<='1';sel_mux_outB0_regfile<='1';
		else
			sel_mux_outB1_regfile<='0';sel_mux_outB0_regfile<='0';
		end if;
end process;


--ALU and CC reg datapath
ALUmain:ALU port map(alu_A,alu_B,ID_reg_outp(51 downto 48),result_alu,CC_output(1),CC_input(1),CC_output(0),CC_input(0));
Condition_code_register:reg generic map( 2 ) port map(clk,CC_wr,CC_rst,CC_input,CC_output); 
CC_wr<=ID_reg_outp(120);CC_rst<=ID_reg_outp(121);

EX_reg_inp(47 downto 32)<=ID_reg_outp(47 downto 32);
EX_reg_inp(67 downto 52)<=result_alu ;


Cntrl_Word_Execute (25 downto 0)<=ID_reg_outp(125 downto 100);
Cntrl_Word_Execute(38 downto 28)<=ID_reg_outp(138 downto 128);
Cntrl_Word_Execute(27 downto 26)<=Branch_Mux_Result;


EX_reg_inp(15 downto 0)<=ID_reg_outp(15 downto 0);
EX_reg_inp(181 downto 166)<=ID_reg_outp(181 downto 166);  
Ex_pipeline_reg:reg generic map( 301 ) port map(clk,EX_write,EX_rst,EX_reg_inp,EX_reg_outp); 		--EX Pipeline register

mux_jmp:mux_4x1 generic map( 16 ) port map( ID_reg_outp(165 downto 150),ID_reg_outp(31 downto 16),dummy_16,dummy_16,jmp_mux_result,Sel_Jmp1_Mux,Sel_Jmp0_Mux);
Sel_Jmp1_Mux<=ID_reg_outp(128); Sel_Jmp0_Mux<=ID_reg_outp(129);

mux_signext:mux_2x1 generic map( 16 ) port map(ID_reg_outp( 197 downto 182),ID_reg_outp(98 downto 83),Result_Signext_Mux,Sel_Signext_Mux);
Addr_A<=jmp_mux_result;
Addr_B<=Result_Signext_Mux;
adder_jmp:adder generic map( 16 ) port map( Addr_A,Addr_B ,Addr_Result);
EX_reg_inp(215 downto 200)<=Addr_Result;  

mux_branch:mux_2x1 generic map( 2 ) port map( ID_reg_outp(127 downto 126),"10",Branch_Mux_Result,Sel_branch_Mux);
Sel_branch_Mux<=ID_reg_outp(130) and CC_input(0);
Sel_Signext_Mux<=ID_reg_outp(131);

adder_LM:adder generic map( 16 ) port map(Addr_LM,X"0001",Addrs_LM_Result); 
Addr_LM <= ID_reg_outp( 231 downto 216 );
Init_LM_Addrs <= ID_reg_inp( 231 downto 216 );

mux_reg_LM:mux_4x1 generic map( 16 ) port map(regfile_data_A,Addrs_LM_Result,dummy_16,dummy_16,ID_reg_inp( 231 downto 216 ),Sel_Reg_LM1_Mux,Sel_Reg_LM0_Mux );

	with ID_reg_outp( 132 ) select
	Sel_Reg_LM1_Mux<='0' when '0',
				   '1' when '1',
				   '0' when others;

	with ID_reg_outp( 133 )select	
	Sel_Reg_LM0_Mux<='0' when '0',
				   '1' when '1',
				   '0' when others;

EX_reg_inp(231 downto 216 )<=Addr_LM;
EX_reg_inp(234 downto 232 )<=std_logic_vector(to_unsigned(Count, 3));
Count_SM<=Count + 1;
Count_Std<=std_logic_vector(to_unsigned(Count_SM, 3));

 

Counter_process:process(clk)
begin
	if (rising_edge(clk))then
		if ( Count = 6 )then
			Count <= -1;	
		elsif ( Cntrl_Word( 38 ) = '1')then
			Count <= Count + 1; 	
		end if;
	end if;
end process Counter_process;

write_pc <= '0' when ( ( Cntrl_Word( 38 ) = '1' ) or ( Cntrl_Word ( 37 ) = '1' ) )
                else '1';

LM_Count<=ID_reg_outp( 138 );
New_Current_Instr<=IF_reg_outp( 15 downto 0 );	
Cntrl_0<=ID_reg_outp( 100 );

LHI_block:load_higher_immediate port map(ID_reg_outp( 15 downto 0 ),LHI_Result );
EX_reg_inp ( 300 downto 285 ) <= LHI_Result;

Forward_Unit:forwarding_unit port map(EX_reg_outp(15 downto 12),MEM_reg_outp(15 downto 12),EX_reg_outp(5 downto 3),MEM_reg_outp(5 downto 3),ID_reg_outp( 11 downto 9 ),ID_reg_outp(8 downto 6),Sel_line_OutA,Sel_line_OutB);
mux_branch_flush:mux_2x1 generic map( 39 ) port map( Cntrl_Word_Execute,Cntrl_Word_Flush,EX_reg_inp(138 downto 100),FlushBitBranch);

FlushBitBranch <='1' when( Count_Branch /= -1 ) else '0';
Control_branch_process:process(ID_reg_outp( 15 downto 0 ),CC_input)
variable opcode:std_logic_vector( 3 downto 0 );
begin
	
	opcode := ID_reg_outp ( 15 downto 12 );
	if ( opcode = "1000" and CC_input(0) = '1' ) then
		CntrlBranch <= '1';
	else
		CntrlBranch <= '0';
	end if;

end process Control_branch_process;

Count_branch_process:process(clk)
begin
	if (rising_edge(clk)) then
		if ( Count_Branch = 2 ) then
			Count_Branch <= -1;	
		elsif (CntrlBranch = '1' or FlushBitBranch = '1')then
			Count_Branch<=Count_Branch + 1; 	
		end if;
	end if;
end process Count_branch_process;
-- End of Execution Stage

--Start of Memory Stage
Data_memory  : data_mem port map ( clk, data_mem_wr , data_mem_rd, data_mem_addr, data_mem_inp, MEM_reg_inp ( 83 downto 68 ) );
MEM_pipeline_reg : reg generic map( 301 ) port map(clk, MEM_write,MEM_rst,MEM_reg_inp,MEM_reg_outp);--MEMory_Pipeline_register
MEM_reg_inp(138 downto 100)<=EX_reg_outp(138 downto 100);
MEM_reg_inp(15 downto 0)<=EX_reg_outp ( 15 downto 0 );
MEM_reg_inp(67 downto 52)<=EX_reg_outp ( 67 downto 52 );
MEM_reg_inp( 181 downto 166 )<=EX_reg_outp ( 181 downto 166  );  
MEM_reg_inp( 300 downto 285 )<=EX_reg_outp( 300 downto 285 );
MEM_reg_inp( 234 downto 232 )<=EX_reg_outp( 234 downto 232 );
actual_alu_result<=EX_reg_outp( 67 downto 52 );
data_mem_wr<=EX_reg_outp(122);data_mem_rd<=EX_reg_outp(123);data_mem_inp<=EX_reg_outp(47 downto 32);--data_memory_address<=actual_alu_result;

mux_memaddress_LM:mux_4x1 generic map ( 16 ) port map (actual_alu_result,EX_reg_outp(231 downto 216),dummy_16,dummy_16,data_mem_addr,Sel_Mem_Addrs_LM1_Mux,Sel_Mem_Addrs_LM0_Mux);
Sel_Mem_Addrs_LM1_Mux<=ID_reg_outp( 134 );Sel_Mem_Addrs_LM0_Mux <= ID_reg_outp( 135 );
--End_Mem_Stage

--Write_Back_stage 
mux_WB  : mux_4x1 generic map( 16 ) port map( MEM_reg_outp( 67 downto 52 ),MEM_reg_outp ( 83 downto 68 ),MEM_reg_outp( 181 downto 166 ),MEM_reg_outp( 300 downto 285),WB_mux_outp,sel_WB1_mux,sel_WB0_mux);
sel_WB1_mux <= MEM_reg_outp(124);sel_WB0_mux <= MEM_reg_outp(125);
regfile_write_En <= MEM_reg_outp(108);
regfile_data_Inp<=WB_mux_outp;
sel_mux_regfile_Wr1 <= MEM_reg_outp(114);sel_mux_regfile_Wr0<=MEM_reg_outp(115);
--End_Wrtie_Back_stage


end architecture;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_RISC_22_tb is end entity;

architecture stim of IITB_RISC_22_tb is 
component IITB_RISC_22 is
	port (
    clk	: in  std_logic ;
    custom_in : in std_logic; 
    TestA : in std_logic_vector(15 downto 0);
    TestB : in std_logic_vector(15 downto 0);
	 input_pc_rst : in std_logic);
end component;
signal TB_Clk,TB_inp_pc_rst:std_logic;

signal TB_Custom_inp:std_logic;--testing_custum_inpt
signal TB_testA:std_logic_vector(15 downto 0);--TB_testA_inptut_signal
signal TB_testB:std_logic_vector(15 downto 0);--TB_testB_input_signal
begin

	dut:IITB_RISC_22 port map ( TB_Clk, TB_Custom_inp, TB_testA, TB_testB, TB_inp_pc_rst );
	
	clk:process 
	begin
	TB_Clk<='0';
	for i in 0 to 200 loop
		
		wait for 50ps;
		TB_Clk <=not TB_Clk;
		wait for 50ps;
		TB_Clk <=not TB_Clk;	
		
	end loop;
	wait;
	end process;
	
	go_now:process 
	begin
	

	TB_Custom_inp <= '1'; TB_inp_pc_rst <= '1';  wait for 100ps; 
	TB_Custom_inp <= '0'; TB_inp_pc_rst <= '0'; wait for 100ps;
	
	
	wait;
	end process;

end architecture;

