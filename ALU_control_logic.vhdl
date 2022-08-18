
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_control_logic is
port(
  ALUOup : in std_logic_vector(3 downto 0);
  ALU_Function : in std_logic_vector(2 downto 0);
  control_alu_out: out std_logic_vector(3 downto 0)
);
end ALU_control_logic;

architecture Behavioral of ALU_control_logic is
begin

	process(ALUOup,ALU_Function)
	begin
		case ( ALUOup )  is
			
			when "0001" => 
						if( ALU_Function = "000" ) then 
							control_alu_out <= "0000";		-- ADD
						elsif( ALU_Function = "010" ) then 
							control_alu_out <= "0001";		-- ADC
						elsif( ALU_Function = "001" ) then 
							control_alu_out<= "0010";		-- ADZ
						elsif( ALU_Function = "011" ) then 
							control_alu_out <= "0011";		-- ADL						
						end if;

			when "0000" =>
							control_alu_out <= "0100";		-- ADI
			
			when "0010" => 
						if( ALU_Function = "000" ) then 
							control_alu_out <= "0101";		-- NDU
						elsif( ALU_Function = "010" ) then 
							control_alu_out <= "0110";		-- NDC
						elsif( ALU_Function = "001" ) then 
							control_alu_out <= "0111";		-- NDZ
						end if;

			when "0100" =>
							control_alu_out <= "1000";		-- LW

			when "0101" =>
							control_alu_out <= "1001";		-- SW

			when "1000" =>
							control_alu_out <= "1010";		-- BEQ	
			
			when others => 
							control_alu_out <= "XXXX";
		end case;

	end process;
	
	
	--control_alu_out <= ALUOup & ALU_Function(1 downto 0);
	
end Behavioral;





-- 0 And , 1 NAND 

-- alu control  		function
--	0000				ADD
-- 	0001				ADC
--  0010				ADZ
--	0011				ADL
--	0100				ADI
--	0101				NDU
--	0110				NDC
--	0111				NDZ
--	1000				LW
--	1001				SW
-- 	1010				BEQ

