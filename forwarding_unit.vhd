library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is 
	port( 	EX_opcode, MEM_opcode : in std_logic_vector(3 downto 0) ;
			EX_RegC , MEM_RegC , ID_RegA , ID_RegB : in std_logic_vector(2 downto 0);
			sel_outA : out std_logic_vector(1 downto 0);
			sel_outB : out std_logic_vector(1 downto 0)
		);
end forwarding_unit;

architecture beh of forwarding_unit is 
--signal frwdA : std_logic_vector(1 downto 0);

begin


process(EX_opcode,MEM_opcode,EX_RegC,MEM_RegC,ID_RegA,ID_RegB)
	begin
		
		if ( ( EX_opcode = "0001" or EX_opcode = "0010" ) and (EX_RegC = ID_RegA) ) then
			sel_outA <= "10" ; 	sel_outB <= "00";
		elsif ( ( EX_opcode = "0001" or EX_opcode = "0010" ) and (EX_RegC = ID_RegB) ) then	
			sel_outB <= "10";	sel_outA <= "00"; 	
		elsif ( ( MEM_opcode = "0001" or MEM_opcode = "0010" ) and (MEM_RegC = ID_RegA) ) then	
			sel_outA <= "11";	sel_outB <= "00";
		elsif ( ( MEM_opcode = "0001" or MEM_opcode = "0010" ) and (MEM_RegC = ID_RegB) ) then
			sel_outB <= "11";	sel_outA <= "00";
		else
			sel_outA <= "00"; sel_outB <= "00";
		end if;
		
	end process;
	
end beh;
