library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  generic (
    n	: integer := 16			-- number of input std_logics
    );
  port (
    a	: in  std_logic_vector( n-1 downto 0);  -- data input
    b	: in  std_logic_vector( n-1 downto 0);  -- data input
    result	: out  std_logic_vector(n-1 downto 0)  -- data output
    );
end adder;

architecture behavioral of adder is

begin

	result <= std_logic_vector( unsigned(a) + unsigned(b) );	-- resize the vector and pass it out

end architecture behavioral;