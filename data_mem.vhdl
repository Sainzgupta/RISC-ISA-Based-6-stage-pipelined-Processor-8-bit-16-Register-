library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
  port (
    clock	: in  std_logic;                      -- clock
    write	: in  std_logic;			-- write to the memory
    read	: in  std_logic;			-- read from the memory
    address	: in  std_logic_vector(15 downto 0);	-- address of the memory being read
    data_in	: in  std_logic_vector(15 downto 0);  -- data input
    data_out	: out  std_logic_vector(15 downto 0)  -- data output
    );
end data_mem;

architecture RAM of data_mem is

type mem_type is array (31 downto 0) of std_logic_vector(15 downto 0);	-- the size of the memory in use
-- signal mem	: mem_type;
signal mem	: mem_type
        := (    X"0000" , 
                X"0000" , 
                X"0000" ,
                X"0000" ,
                X"0000" ,
                X"0000" ,
                X"0000" ,
                X"0000" ,
                X"0000" ,
                X"0000" , 
                X"0000" , 
                X"0000" , 
                X"0000" , 
                X"0000" ,
                X"0000" ,
                X"0000" ,
				
			    X"0000" , 
                X"0000" , 
                X"0000" ,
                X"0000" ,
                X"0000" ,	
                X"000B" ,
                X"000A" ,
                X"0009" ,
                X"0008" ,
                X"0007" , 
                X"000B" , 
                X"0017" , 
                X"0004" , 
                X"0009" ,
                X"0005" ,
                X"0002" 
			);
begin


  
data_out <= mem(to_integer(unsigned(address))) when ( (read = '1') and  ( address < x"0020" ) ) else (others => 'Z'); -- give the memory content as the output



------------------- writing the data to the register ------------------------------------
Memory_Write : process(clock)
begin
   if (rising_edge(clock)) then
      if ( write = '1' and ( address < x"0020" ) ) then
          mem (to_integer(unsigned(address))) <= data_in  ;	-- write the input data on the corresponding location
      end if;
   end if;
end process Memory_Write;
-----------------------------------------------------------------------------------------

end architecture RAM;