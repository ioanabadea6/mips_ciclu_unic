----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2023 10:35:14 AM
-- Design Name: 
-- Module Name: instr_fetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_fetch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           j_adr : in STD_LOGIC_VECTOR (15 downto 0);
           b_adr : in STD_LOGIC_VECTOR (15 downto 0);
           pcSrc : in STD_LOGIC;
           jump: in STD_LOGIC;
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           next_instr : out STD_LOGIC_VECTOR (15 downto 0));
end instr_fetch;

architecture Behavioral of instr_fetch is

type memorie is array (0 to 255) of std_logic_vector (15 downto 0);
signal mem: memorie := (
0=> b"000_000_000_001_1_000",    -- add $1, $0, $0  #0018
1=> b"001_000_100_0001000",      --addi $4, $0, 8   #2208
2=> b"000_000_000_010_1_000",    -- add $2, $0, $0  #0028
3=> b"000_000_000_101_1_000",    -- add $5, $0, $0  #0058
4=> b"100_100_001_0000111",      -- beq $1, $4, 7   #9087
5=> b"010_010_011_0001010",      -- lw $3, 10($2)   #498A
6=> b"000_000_011_011_1_010",    -- sll $3, $3, 1   #0CBA
7=> b"011_010_011_0001010",      --sw $3, 10($2)    #698A
8=> b"000_101_011_101_1_000",    --add $5, $5, $3   #15D8
9=> b"001_010_010_0000001",      --addi $2, $2, 1   #2901
10=> b"001_001_001_0000001",     --addi $1, $1, 1   #2481
11=> b"111_0000000000100",       --j 4              #E004
12=> b"011_000_101_0010010",     --sw $5, 18($0)     #6292
others => x"0000"
);

signal pc:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal nextadr:STD_LOGIC_VECTOR(15 downto 0):=x"0000"; 
signal aux:STD_LOGIC_VECTOR(15 downto 0):=x"0000"; 
signal aux2:STD_LOGIC_VECTOR(15 downto 0):=x"0000"; 

begin

    process(en,rst,clk)
    begin
       if rising_edge(clk) then
            if rst = '1' then
                pc <= x"0000";
            elsif en='1' then
                pc<=nextadr;
            end if;
       end if;
    end process;


instr <= mem(conv_integer(pc(7 downto 0)));



aux <= pc+1;
next_instr <= aux;

    process(PCSrc, aux, b_adr)
begin
    case PCSrc is 
        when '1' => aux2 <= b_adr;
        when others => aux2 <= aux;
    end case;
end process;    

 -- MUX Jump
process(Jump, Aux2, j_adr)
begin
    case Jump is
        when '1' => nextadr <= j_adr;
        when others => nextadr <= Aux2;
    end case;
end process;


end Behavioral;
