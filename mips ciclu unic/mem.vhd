----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 11:28:33 AM
-- Design Name: 
-- Module Name: mem - Behavioral
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

entity mem is
    Port ( memWrite : in STD_LOGIC;
           aluRes : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           memData : out STD_LOGIC_VECTOR (15 downto 0);
           aluRes2 : out STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC);
end mem;

architecture Behavioral of mem is

type memorie is array (0 to 60) of std_logic_vector (15 downto 0);
signal date: memorie :=(
10=>x"000A", --10
11=>x"0010", --16
12=>x"0002", --2
13=>x"0004", --4
14=>x"0008", --8
15=>x"0007", --7
16=>x"000B", --11
17=>x"0012", --18
18=>x"0005", --5
others => x"0000");

begin

    memData <= date(conv_integer(aluRes(7 downto 0)));
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and memWrite ='1' then
                date(conv_integer(aluRes(7 downto 0))) <= rd2;
            end if;
        end if;
    end process;
    aluRes2 <= aluRes;
end Behavioral;
