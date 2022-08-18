library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package RISC_components is 

component ALU_control_logic is
port(
  ALUOup : in std_logic_vector(3 downto 0);
  ALU_Function : in std_logic_vector(2 downto 0);
  control_alu_out: out std_logic_vector(3 downto 0)
);
end component ALU_control_logic;

component ALU is
port(
 x,y : in std_logic_vector(15 downto 0); 
 control_alu : in std_logic_vector(3 downto 0); 
 result_alu: out std_logic_vector(15 downto 0); 
 carry_inp : in std_logic;
 carry_outp: out std_logic; 
 zero_inp : in std_logic;
 zero_out: out std_logic 
 );
end component ALU;

component data_mem is
  port (
    clock	: in  std_logic;                      -- clock
    write	: in  std_logic;			-- write to the memory
    read	: in  std_logic;			-- read from the memory
    address	: in  std_logic_vector(15 downto 0);	-- address of the memory being read
    data_in	: in  std_logic_vector(15 downto 0);  -- data input
    data_out	: out  std_logic_vector(15 downto 0)  -- data output
    );
end component data_mem;


component instr_mem is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end component instr_mem;


component mux_2x1 is
  generic (
    nbits : integer:= 3 );

  port (
    inp0 : in  std_logic_vector(nbits-1 downto 0);
    inp1 : in  std_logic_vector(nbits-1 downto 0);
    outp : out std_logic_vector(nbits-1 downto 0);
    sl    : in  std_logic);

end component mux_2x1;



component mux_4x1 is
  generic (
    nbits : integer := 3);

  port (
    inp0, inp1, inp2, inp3: in  std_logic_vector(nbits-1 downto 0);
    outp                        : out std_logic_vector(nbits-1 downto 0);
    sl1, sl0                    : in  std_logic);
end component mux_4x1;



component mux8to1 is
  generic (
    nbits : integer := 3 );

  port (
    input0, input1, input2, input3, input4, input5, input6, input7 : in  std_logic_vector(nbits-1 downto 0);
    output                                                   	   : out std_logic_vector(nbits-1 downto 0);
    sel2, sel0, sel1                       	                   : in  std_logic);
end component mux8to1;



component pc_incr is
  port (
    pc_current	: in  std_logic_vector(15 downto 0);  -- data input
    pc_incr	: out  std_logic_vector(15 downto 0)  -- data output
    );
end component pc_incr;


component reg is
generic (
    reg_width : integer := 8);

  port (
	 clk	: in  std_logic;			-- clock signal
    write_reg	: in  std_logic;			-- write enable signal
    reset_reg	: in  std_logic;				-- reset signal
    input	: in  std_logic_vector(reg_width-1 downto 0);	-- register input
    output	: out std_logic_vector(reg_width-1 downto 0)	-- register output
    );
end component reg;


component regfile is 
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

  end component regfile;
  
  
component sign_extension is
  generic (
    input_data_width	: integer := 6			-- number of bits in input 
    );
  port (
    input	: in  std_logic_vector(input_data_width-1 downto 0);  -- data input
    output	: out  std_logic_vector(15 downto 0)  -- data output
    );
end component sign_extension;

component adder is
  generic (
    n	: integer := 16			-- number of input std_logics
    );
  port (
    a	: in  std_logic_vector( n-1 downto 0);  -- data input
    b	: in  std_logic_vector( n-1 downto 0);  -- data input
    result	: out  std_logic_vector(n-1 downto 0)  -- data output
    );
end component adder;

component controller is
port(
 mips_instruction: in std_logic_vector(15 downto 0); 
 my_count : in integer;
 carry_inp : in std_logic;
 zero_inp : in std_logic;
 cntrl_word : out std_logic_vector(38 downto 0) 
 );
end component controller;

component load_higher_immediate is
  port (
    mips_instruction	: in  std_logic_vector( 15 downto 0);  
    result_out	: out  std_logic_vector(15 downto 0)  
    );
end component load_higher_immediate;

component hazard_detection is 
	port ( --ID_EX_MemRead : in std_logic ;
			ID_regout_opcode : std_logic_vector ( 3 downto 0 );
			ID_Reg_RA , IF_Reg_RA , IF_Reg_RB : in std_logic_vector(2 downto 0);
			--IF_ID_Write , PC_Write , 
			Control_Mux_sel : out std_logic
	);
end component hazard_detection;

component forwarding_unit is 
	port( EX_opcode, MEM_opcode : in std_logic_vector(3 downto 0) ;
			EX_RegC , MEM_RegC , ID_RegA , ID_RegB : in std_logic_vector(2 downto 0);
			sel_outA : out std_logic_vector(1 downto 0);
			sel_outB : out std_logic_vector(1 downto 0)
		);
end component forwarding_unit;

end package RISC_components;