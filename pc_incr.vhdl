library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_incr is

  port (
    pc_current	: in  std_logic_vector(15 downto 0);  -- data input
    pc_incr	: out  std_logic_vector(15 downto 0)  -- data output
    );
end pc_incr;

architecture arch_pc_increment of pc_incr is

begin

	pc_incr <= std_logic_vector( unsigned(pc_current) + 1 );	-- resize the vector and pass it out

end architecture arch_pc_increment;