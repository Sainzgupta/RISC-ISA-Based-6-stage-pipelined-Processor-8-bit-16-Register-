library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity load_higher_immediate is
  port (
    mips_instruction	: in  std_logic_vector( 15 downto 0);  
    result_out	: out  std_logic_vector(15 downto 0)  
    );
end load_higher_immediate;

architecture behavioral of load_higher_immediate is
signal result_temp : std_logic_vector ( 15 downto 0 );
begin
	
	result_temp  <= mips_instruction ( 8 downto 0 ) & "0000000";
	
	
	result_out <= result_temp;

end architecture behavioral;