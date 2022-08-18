library ieee;
use ieee.std_logic_1164.all;
entity mux_2x1 is
  generic (
    nbits : integer:= 3 );

  port (
    inp0 : in  std_logic_vector(nbits-1 downto 0);
    inp1 : in  std_logic_vector(nbits-1 downto 0);
    outp : out std_logic_vector(nbits-1 downto 0);
    sl    : in  std_logic);

end mux_2x1;

architecture behave of mux_2x1 is

begin  
  
	outp<= inp0 when sl ='0' else
	         inp1 when sl ='1' else
				(others =>'Z');
end behave;

