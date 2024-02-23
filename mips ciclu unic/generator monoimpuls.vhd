----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 10:59:14 AM
-- Design Name: 
-- Module Name: generator monoimpuls - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generator_monoimpuls is
    Port ( en : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
           
end generator_monoimpuls;

architecture Behavioral of generator_monoimpuls is

signal count_int: std_logic_vector(15 downto 0):=x"0000";
signal Q1:std_logic :='0';
signal Q2:std_logic:='0';
signal Q3:std_logic:='0';

begin

    en <= Q2 AND (not Q3);

    process(clk)
    begin
        if rising_edge(clk) then
            count_int <= count_int + 1;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if count_int(15 downto 0)="1111111111111111" then
                Q1 <= btn;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;

end Behavioral;
