----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2023 10:23:51 AM
-- Design Name: 
-- Module Name: id - Behavioral
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

entity id is
    Port ( regWrite : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (12 downto 0);
           regDst : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           extOp : in STD_LOGIC;
           en: in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR(15 downto 0);
           func : out STD_LOGIC_VECTOR(2 downto 0);
           sa : out STD_LOGIC);     
end id;

architecture Behavioral of id is

signal wa: std_logic_vector(2 downto 0):="000";
signal extImm: std_logic_vector(15 downto 0);

type registru is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg: registru := (others=> x"0000");

begin


    with regDst select
        wa <= Instr(6 downto 4) when '1', -- rd
              Instr(9 downto 7) when '0', -- rt
              (others => '0') when others;  

    
    process(clk)			
    begin
        if rising_edge(clk) then
            if en = '1' and RegWrite = '1' then
                reg(conv_integer(wa)) <= wd;		
            end if;
        end if;
    end process;
    
    ext_imm(6 downto 0) <= instr(6 downto 0);
    
    with extOp select
            ext_imm(15 downto 7) <= (others => instr(6)) when '1',
                                    (others => '0') when '0',
                                    (others => '0') when others;
    
    rd1 <= reg(conv_integer(instr(12 downto 10))); --rs
    rd2 <= reg(conv_integer(instr(9 downto 7))); --rt

    func <= instr(2 downto 0);
    sa <= instr(3);

end Behavioral;
