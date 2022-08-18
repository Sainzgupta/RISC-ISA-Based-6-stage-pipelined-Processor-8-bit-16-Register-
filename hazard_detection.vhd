library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection is 
	port ( 
			ID_regout_opcode : std_logic_vector ( 3 downto 0 );
			ID_Reg_RA , IF_Reg_RA , IF_Reg_RB : in std_logic_vector(2 downto 0);
			
			Control_Mux_sel : out std_logic
	);
	end hazard_detection;
	
architecture behave of hazard_detection is 

begin
	process( ID_regout_opcode, ID_Reg_RA, IF_Reg_RA, IF_Reg_RB )
	begin 
		if ( ID_regout_opcode = "0100" and ((ID_Reg_RA = IF_Reg_RA) or (ID_Reg_RA = IF_Reg_RB)) ) then
				--PC_Write <= '0' ;
				--IF_ID_Write <= '0';
			Control_Mux_sel <= '1' ;
		else
			Control_Mux_sel <= '0' ;
		end if;
	end process;
end behave;
