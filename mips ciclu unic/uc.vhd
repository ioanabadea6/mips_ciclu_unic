----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 07:20:59 PM
-- Design Name: 
-- Module Name: uc - Behavioral
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

entity uc is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           regDst : out STD_LOGIC;
           extOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           memWrite : out STD_LOGIC;
           memToReg : out STD_LOGIC;
           regWrite : out STD_LOGIC);
end uc;

architecture Behavioral of uc is

begin

process(instr)
begin

    regDst <= '0';
    extOp <= '0';
    ALUSrc <= '0';
    branch <= '0';
    jump <= '0';
    ALUOp <= "000";
    memWrite <= '0';
    memToReg <= '0';
    regWrite <= '0';

    case(instr(15 downto 13)) is
        --tip R
        when "000" => regDst <= '1';
                      ALUOp <= "000";
                      regWrite <= '1';
        --addi
        when "001" => extOp <= '1';
                      ALUOp <= "001";
                      regWrite <= '1';
                      ALUSrc <= '1';
        --lw
        when "010" => ExtOp <= '1';
                        ALUSrc <= '1';
                        MemtoReg <= '1';
                        RegWrite <= '1';
                        ALUOp <= "010";
        --sw
        when "011" =>  ExtOp <= '1';
                       ALUSrc <= '1';
                       MemWrite <= '1';
                       ALUOp <= "011";
        --beq
        when "100" => extOp <= '1';
                      ALUOp <= "100";
                      branch <= '1';
        --andi
        when "101" => 
                      ALUOp <= "101";
                      aluSrc <= '1';
                      regWrite<='1';
        --bne
        when "110" => extOp <= '1';
                      ALUOp <= "110";
                      branch <= '1';
        --jump
        when "111" => jump <= '1';
        when others => regDst <= '0';
                   extOp <= '0';
                   ALUSrc <= '0';
                   branch <= '0';
                   jump <= '0';
                   ALUOp <= "000";
                   memWrite <= '0';
                   memToReg <= '0';
                   regWrite <= '0';
    end case;
end process;

end Behavioral;
