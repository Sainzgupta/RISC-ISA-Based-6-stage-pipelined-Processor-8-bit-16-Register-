
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity instr_mem is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end instr_mem ;

architecture Behavioral of instr_mem is
signal instruction_tmp : std_logic_vector (15 downto 0) ;
signal rom_addr: std_logic_vector(3 downto 0);
 
 type ROM_type is array (0 to 15 ) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   "1100001011100100",
   "0001000010011000",
   "0001011001110000",
   "1000011101000010",
   "0001011010100000",
   "0010010001100000",
   "0000101000000111",
  "1100110010000010",
   "1001001000000010",
   "0001010011000000",
   "0100100110000000",
   "0100101110000001",
   "0001001110110000",
   "1101000010101010",
   "0000000000000000",
   "0000000000000000"
  );
begin

 rom_addr <= pc(3 downto 0);	-- confusion for 3 downto 0
--  instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0020" else x"0000";	--"XXXXXXXXXXXXXXXX";	-- x"0000";

process ( rom_addr, pc )
begin
	
	if ( rom_addr = "UUUU" or  rom_addr = "XXXX" ) then
		instruction_tmp <= "XXXXXXXXXXXXXXXX" ;
	elsif ( pc < x"0020" ) then
		instruction_tmp <= rom_data(to_integer(unsigned(rom_addr)));
	else
		instruction_tmp <=  x"0000";
	end if;
	
end process;

instruction <= instruction_tmp;

end Behavioral;