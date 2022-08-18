
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;


entity ALU is
port(
 x,y : in std_logic_vector(15 downto 0); 
 control_alu : in std_logic_vector(3 downto 0); 
 result_alu: out std_logic_vector(15 downto 0); 
 carry_inp : in std_logic;
 carry_outp: out std_logic; 
 zero_inp : in std_logic;
 zero_out: out std_logic 
 );
end ALU;

architecture Behavioral of ALU is
signal my_result, result_zero: std_logic_vector(16 downto 0) := ( others => '0' );
signal flag_carry, flag_zero : std_logic;

begin
process(control_alu,x,y,carry_inp,zero_inp)
variable result_34_bits : std_logic_vector ( 33 downto 0 );
variable sig: std_logic_vector(16 downto 0):=(1=>'1' , others=>'0');
begin

flag_carry <= '0'; -- Specifies the instruction in which we have to modify carry and zero flag 
flag_zero  <= '0';
result_zero <= ( others => '0' );

case control_alu is

	when "0000" =>
				my_result <=  ('0' & x)  + ('0' & y); -- ADD
				flag_carry <= '1';
				flag_zero  <= '1';
	
	when "0001" =>
				if ( carry_inp = '1' ) then
					my_result <= ('0'& x) +('0'& y); -- ADC
					--report "insiide";
					flag_carry <= '1';
					flag_zero  <= '1';
				end if;

	
	when "0010" =>
				if ( zero_inp = '1' ) then
					my_result <= ('0'& x) + ('0'& y); -- ADZ
					flag_carry <= '1';
					flag_zero  <= '1';				
				end if;

	
	when "0011" =>
				result_34_bits := ('0'& x) + (sig * ('0'& y));-- ( 16 downto 0 ) ; -- ADL
				my_result <= result_34_bits ( 16 downto 0 );
				flag_carry <= '1';
				flag_zero  <= '1';
				
	when "0100" =>
				my_result <= ( '0'& x ) + ('0' & y); -- ADI -- Sign extension
				flag_carry <= '1';
				flag_zero  <= '1';
				
	when "0101" =>		
				my_result <= ('0'& x) nand ('0'& y)  ;	--NDU
				flag_zero  <= '1';
	
	when "0110" =>
				if ( carry_inp = '1' ) then
				my_result <= ('0'& x) nand ('0'& y) ;	--NDC
				flag_zero  <= '1';				
				end if;

	
	when "0111" =>
				if ( zero_inp = '1' ) then
				my_result <= ('0'& x) nand ('0'& y) ;	--NDZ
				flag_zero  <= '1';
				end if;

	
	when "1000" =>
				my_result <= ( '0'& x ) + ('0' & y); -- LW
				flag_zero  <= '1'; -- Doubtful
	
	when "1001" =>
				my_result <= ( '0'& x ) + ('0' & y); -- SW
				
	when "1010" =>
				my_result <= ( '0'& x ) - ('0' & y); -- BEQ
				flag_zero  <= '1';
				-- flag_zero  updated 
	when others => 
		my_result <= ( others => 'Z' ); -- add
 
 
end case;

end process;


--zero_out <= '1' when  ( result = zero_result and flag_zero = '1' ) 
--		else zero_inp;
		
--carry_outp <= result (16) when  ( flag_carry = '1' ) 
--		else carry_inp;


zero: process ( flag_zero, my_result, result_zero )
begin
	if ( flag_zero = '1' ) then
		if ( my_result = result_zero ) then
			zero_out <= '1';
		else
			zero_out <= '0';
		end if;
	else
		zero_out <= zero_inp;
	end if;
end process;

carry: process ( flag_carry, my_result )
begin
	if ( flag_carry = '1' ) then
		carry_outp <= my_result(16);
	else
		carry_outp <= carry_inp;
	end if;
end process;
		
result_alu <= my_result( 15 downto 0 );
		

end Behavioral;