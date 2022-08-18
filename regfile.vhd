

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  entity regfile is 
    port (
   test_in : in std_logic; 	--
   test_A : in std_logic_vector(15 downto 0);	--
   test_B : in std_logic_vector(15 downto 0);	--
   pc_current : in std_logic_vector(15 downto 0); --
   clk  : in std_logic;
   reset  : in std_logic;
   address_A    : in std_logic_vector(2 downto 0); --address for selecting A 
   address_B    : in std_logic_vector(2 downto 0); --address for selecting B 
   data_A  : out std_logic_vector(15 downto 0); --read the data into reg A
   data_B  : out std_logic_vector(15 downto 0);--read the data into reg B 
   data_input : in std_logic_vector(15 downto 0);---data to be written into the register
   Write_enable : in std_logic; 			---enable for writing
   Write_address : in std_logic_vector(2 downto 0) --to select the destination register
);

  end regfile;
 
----------------------end entity----------------------------

-----------------------description of architecture----------
architecture behavioural of regfile is 
type array_of_reg is array (7 downto 0) of std_logic_vector(15 downto 0);
signal reg: array_of_reg;
begin

---------------------------------------------------------------
 ---------------------process for read-------------------------

data_A <= reg(to_integer(unsigned(address_A)));
data_B <= reg(to_integer(unsigned(address_B))); 
 

---------------------------------------------------

reg(7) <= pc_current;


write: process(clk, test_in)
	
	begin
if ( test_in = '0' ) then		--
	if clk'event and clk='1' then 
		if reset ='1' then 
			 reg(0)<= X"0000";
			 reg(1)<= X"0000";
			 reg(2)<= X"0000";
			 reg(3)<= X"0000";
			 reg(4)<= X"0000";
			 reg(5)<= X"0000";
			 reg(6)<= X"0000";
		else 
			if write_enable = '1' then
				case write_address is 
					when "000" => 	reg(0)<= data_input;
					when "001" =>  reg(1)<= data_input;
		         when "010" => 	reg(2)<= data_input;
					when "011" =>  reg(3)<= data_input;
				   when "100" =>  reg(4)<= data_input;
			      when "101" => 	reg(5)<= data_input;
					when "110" =>  reg(6)<= data_input;
					--when "111" =>   reg(7) <= pc_current;	--
					when others =>
				       reg(0)<= reg(0);
             end case;      
			end if;
		end if;
	end if;
elsif ( test_in = '1' ) then 	--
	 reg(0)<= X"0000";
	 reg(1)<= X"0000";
	 reg(2)<= X"0000";
	 reg(3)<= X"0000";
	 reg(4)<= X"0000";
	 reg(5)<= X"0000";
	 reg(6)<= X"0000";
	
end if;			--	
end process write;


end behavioural;