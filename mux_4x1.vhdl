library ieee;
use ieee.std_logic_1164.all;
entity mux_4x1 is
  generic (
    nbits : integer := 3);

  port (
    inp0, inp1, inp2, inp3: in  std_logic_vector(nbits-1 downto 0);
    outp                        : out std_logic_vector(nbits-1 downto 0);
    sl1, sl0                    : in  std_logic);
end mux_4x1;

architecture behave  of mux_4x1 is
begin  -- behave 
 -- process(input0,input1,input2,input3,sel1,sel0)
 --   variable sel_var : std_logic_vector(1 downto 0);
--  begin
 --     sel_var(0) := sel0;
 --     sel_var(1) := sel1;
     
  ----    case sel_var is
  --      when "00" =>
  --        output <= input0 ;
  ----      when "01" =>
  --        output <= input1;
   --     when "10" =>
     ----     output <= input2;
     ----   when "11" =>
     --     output <= input3;
	--w-hen others =>
	 -- output <= ( others => 'Z' );
   --   end case;
 -- end process;
 
 outp<= inp0 when sl0='0' and sl1='0' else
          inp1 when sl0='1' and sl1='0' else
			 inp2 when sl0='0' and sl1='1' else
			 inp3 when sl0='1' and sl1='1' else
			 (others =>'Z');
end behave ;