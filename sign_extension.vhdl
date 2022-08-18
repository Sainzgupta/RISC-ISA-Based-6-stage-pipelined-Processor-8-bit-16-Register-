--MSB is appended to form 16 bit number

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extension is
  generic (
    input_data_width	: integer := 6			-- number of bits in input 
    );
  port (
    input	: in  std_logic_vector(input_data_width-1 downto 0);  -- data input
    output	: out  std_logic_vector(15 downto 0)  -- data output
    );
end sign_extension;

architecture behavioural of sign_extension is
	constant append0: std_logic_vector(15-input_data_width downto 0) := (others => '0');
	constant append1: std_logic_vector(15-input_data_width downto 0) := (others => '1');
begin

	process(input)
	begin
		if input(input_data_width - 1) = '1' then
			output <= append1 & input;
		else
			output <= append0 & input;
		end if;
		
	end process;
	
end architecture behavioural;