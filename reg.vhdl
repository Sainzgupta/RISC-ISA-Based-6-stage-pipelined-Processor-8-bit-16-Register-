library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is

generic (
    reg_width : integer := 8);

  port (
	 clk	: in  std_logic;			-- clock signal
    write_reg	: in  std_logic;			-- write enable signal
    reset_reg	: in  std_logic;				-- reset signal
    input	: in  std_logic_vector(reg_width-1 downto 0);	-- register input
    output	: out std_logic_vector(reg_width-1 downto 0)	-- register output
    );
end reg;

architecture behavioural of reg is

begin 

	process(clk,reset_reg)
	begin 
	  if clk'event and clk = '1' then	
	    if reset_reg = '1' then
	      output <= (others => '0');	-- reset the register
	    elsif write_reg = '1' then
	      output <= input;		-- store the input
	    end if;
	  end if;
	end process;

end behavioural;
