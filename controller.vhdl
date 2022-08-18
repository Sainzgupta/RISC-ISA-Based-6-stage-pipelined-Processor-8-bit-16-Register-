library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity controller is
port(
 mips_instruction: in std_logic_vector(15 downto 0); 
 my_count : in integer;
 carry_inp : in std_logic;
 zero_inp : in std_logic;
 cntrl_word : out std_logic_vector(38 downto 0) 
 );
end controller;

architecture Behavioral of controller is
signal control_word_temp : std_logic_vector ( 38 downto 0 );
begin

process( mips_instruction, my_count, carry_inp, zero_inp )

begin


case mips_instruction( 15 downto 12 ) is

	when "0001" =>
				control_word_temp <= "000000000000000000100000000000101010101";	--ADD
				if ( mips_instruction ( 1 downto 0 ) = "10" ) then					--ADC
					if ( carry_inp = '1' ) then
						control_word_temp(8) <= '1'; 
					else	
						control_word_temp(8) <= '0'; 
					end if;
				elsif ( mips_instruction ( 1 downto 0 ) = "01" ) then				--ADZ
					if ( zero_inp = '1' ) then
						control_word_temp(8) <= '1'; 
					else	
						control_word_temp(8) <= '0'; 
					end if;
				end if;
	
	when "0010" =>
				control_word_temp <= "000000000000000000100000000000101010101";	--NDU
				if ( mips_instruction ( 1 downto 0 ) = "10" ) then					--NDC
					if ( carry_inp = '1' ) then
						control_word_temp(8) <= '1'; 
					else	
						control_word_temp(8) <= '0'; 
					end if;
				elsif ( mips_instruction ( 1 downto 0 ) = "01" ) then				--NDZ
					if ( zero_inp = '1' ) then
						control_word_temp(8) <= '1'; 
					else	
						control_word_temp(8) <= '0'; 
					end if;
				end if;				
				
	
	when "0000" =>
				control_word_temp<="000000000000000000110001000000101010101";	--ADI
	
	when "0100" =>
				control_word_temp<="000000000000010100110000110100101010101";	--LW
				
	when "0101" =>
				control_word_temp<= "000000000000000010110000010100001010101";	--SW
	
	when "1000" =>
				control_word_temp<= "000000011000000000000000000000001010101";	--BEQ
				--control_word_temp <= "001000011000000000000000000000001010101";

	when "1001" =>
				control_word_temp <= "000000000001001000000000100000101010101";	--JAL
				--control_word_temp <= "001000000001001000000000100000101010101";
				
	when "1010" =>
				control_word_temp<="000000000000101000000000100000101010101";	--JLR
				--control_word_temp <= "001000000000101000000000100000101010101";

	when "1011" =>
				control_word_temp<="000000000101000000000000000000001010101";	--JRI
				--control_word_temp <= "001000000101000000000000000000001010101";

	when "1100" =>
				control_word_temp<="100101000000010100000001100000101010100";	--LM
				--if ( my_count /= 6 ) then
				--	control_word_temp(38) <= '1';
				--	control_word_temp(0) <= '0';
				if ( my_count = -1 ) then
					   control_word_temp(38)<='1';
					   control_word_temp(0) <='0';
					   if ( mips_instruction(7) = '1' )  then
						  control_word_temp(8) <= '1';
					   else
						  control_word_temp(8) <= '0';
					   end if;
					
				elsif ( my_count = 0 ) then
					   control_word_temp(38) <= '1';
					   control_word_temp(0) <= '0';
					   if ( mips_instruction(6) = '1' )  then
						   control_word_temp(8) <= '1';
					   else
						   control_word_temp(8) <= '0';
					   end if;

				elsif ( my_count = 1 ) then
						control_word_temp(38) <= '1';
						control_word_temp(0) <= '0';
						if ( mips_instruction(5) = '1' )  then
							control_word_temp(8) <= '1';
						else
							control_word_temp(8) <= '0';
						end if;
					
				elsif ( my_count = 2 ) then
						control_word_temp(38) <= '1';
						control_word_temp(0) <= '0';
						if ( mips_instruction(4) = '1' )  then
							control_word_temp(8) <= '1';
						else
							control_word_temp(8) <= '0';
						end if;

				elsif ( my_count = 3 ) then
						control_word_temp(38) <= '1';
						control_word_temp(0) <= '0';
						if ( mips_instruction(3) = '1' )  then
							control_word_temp(8) <= '1';
						else
							control_word_temp(8) <= '0';
					   end if;

				elsif ( my_count = 4 ) then
						control_word_temp(38) <= '1';
						control_word_temp(0) <= '0';
						if ( mips_instruction(2) = '1' )  then
							control_word_temp(8) <= '1';
						else
							control_word_temp(8) <= '0';
						end if;
					
				elsif ( my_count = 5 ) then
						control_word_temp(38) <= '1';
						control_word_temp(0) <= '0';
						if ( mips_instruction(1) = '1' )  then
							control_word_temp(8) <= '1';
						else
							control_word_temp(8) <= '0';
						end if;
					
				elsif ( my_count = 6 ) then
						control_word_temp(38) <= '0';
						control_word_temp(0) <= '1';
						control_word_temp(8) <= '0';
					end if;
				
	when "1110" =>
				control_word_temp <= "100101000000010100000001100000101010101";	--LA
				if ( my_count /= 6 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
				--if ( my_count = 0 ) then
				--	control_word_temp(38) <= '1';
				--	control_word_temp(0) <= '0';
				--	if ( 
				elsif ( my_count = 6 ) then
					control_word_temp(38) <= '0';
					control_word_temp(0) <= '1';
					control_word_temp(8) <= '0';
				end if;

	when "1111" =>
				control_word_temp <= "100101000000000010000000001000001010101";	--SA
				if ( my_count /= 6 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
				--if ( my_count = 0 ) then
				--	control_word_temp(38) <= '1';
				--	control_word_temp(0) <= '0';
				--	if ( 
				elsif ( my_count = 6 ) then
					control_word_temp(38) <= '0';
					control_word_temp(0) <= '1';
					control_word_temp(22) <= '1';
				--	control_word_temp(8) <= '0';
				end if;

	when "1101" =>
				control_word_temp <= "100101000000000010000000001000001010101";	--SM
				--if ( my_count /= 6 ) then
				--	control_word_temp(38) <= '1';
				--	control_word_temp(0) <= '0';
				if ( my_count = -1 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(7) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;
					
				elsif ( my_count = 0 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(6) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;

				elsif ( my_count = 1 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(5) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;
					
				elsif ( my_count = 2 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(4) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;

				elsif ( my_count = 3 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(3) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;

				elsif ( my_count = 4 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(2) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;
					
				elsif ( my_count = 5 ) then
					control_word_temp(38) <= '1';
					control_word_temp(0) <= '0';
					if ( mips_instruction(1) = '1' )  then
						control_word_temp(22) <= '1';
					else
						control_word_temp(22) <= '0';
					end if;
					
				elsif ( my_count = 6 ) then
					control_word_temp(38) <= '0';
					control_word_temp(0) <= '1';
					control_word_temp(22) <= '0';
					--control_word_temp(8) <= '0';
				end if;

	when "0011" =>
				control_word_temp <= "000000000000011000000000100000101010101";	--LHI
			
	when others => 
		control_word_temp <= ( others => 'U' ); 
 
 
end case;

end process;

cntrl_word <= control_word_temp;
	
end Behavioral;









--control word 
--IF_write , IF_reset	0,1
--ID_write , ID_reset	2,3
--EX_write , EX_reset	4,5
--MEM_write, MEM_reset	6,7

--regfile_writEn,	regfile_reset, 8,9

--sel_mux_regfile_A1, sel_mux_regfile_A0	10,11
--sel_mux_regfile_B1, sel_mux_regfile_B0	12,13
--sel_mux_regfile_Wr1, sel_mux_regfile_Wr0	14,15

--sel_mux_regfile_outA1, sel_mux_regfile_outA0 16,17
--sel_mux_regfile_outB1, sel_mux_regfile_outB0 18,19	

--CC_write, CC_reset	20,21	

--datamem_wr, datamem_rd	22.23
--sel_mux_WB1, sel_mux_WB0	24, 25

--sel_mux_PC1, sel_mux_PC0	26, 27
--sel_mux_jmp1, sel_mux_jmp0 	28, 29
--branch, sign_extend 		30, 31	

-- New LM
--sel_mux_reg_LM1, sel_mux_reg_LM0	32,33
--sel_mux_memaddress_LM1, sel_mux_memaddress_LM0 	34,35

--flush, stall 	36,37

--count_LM		38 