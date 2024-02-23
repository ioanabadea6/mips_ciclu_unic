----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 10:57:05 AM
-- Design Name: 
-- Module Name: unit_ex - Behavioral
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

entity unit_ex is
    Port ( pcNext : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           aluOp : in STD_LOGIC_VECTOR (2 downto 0);
           aluSrc : in STD_LOGIC;
           zero : out STD_LOGIC;
           aluRes : out STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : out STD_LOGIC_VECTOR(15 downto 0));
end unit_ex;

architecture Behavioral of unit_ex is

signal ALUCtrl: std_logic_vector(2 downto 0) := (others =>'0');
signal rd2Final: std_logic_vector(15 downto 0);
signal zeroSignal: std_logic;
signal aluRes2: std_logic_vector( 15 downto 0);

begin

branchAddress<=pcNext+ext_imm;
 --aluSrc
with ALUSrc select
	rd2Final<=RD2 when '0',
			  ext_imm when '1',
			  (others => '0') when others;
			  
--alu control
process(ALUOp,Func)
begin
	case (ALUOp) is
	--r type
		when "000"=>
				case (Func) is
					when "000"=> ALUCtrl<="000"; 	-----ADD-----
					when "001"=> ALUCtrl<="001";		-----SUB-----
					when "010"=> ALUCtrl<="010";		-----SLL-----
					when "011"=> ALUCtrl<="011";		-----SRL-----
					when "100"=> ALUCtrl<="100";		-----AND-----
					when "101"=> ALUCtrl<="101";		-----OR-----
					when "110"=> ALUCtrl<="110";		-----XOR-----
					when "111"=> ALUCtrl<="111";		-----NOR-----
					when others=> ALUCtrl<="000";	-----OTHERS-----
				end case;
		when "001"=> ALUCtrl<="000";		--+
		when "010"=> ALUCtrl<="000";		-- +
		when "011"=> ALUCtrl<="000";		--+
		when "100" => ALUCtrl <="001";      -- -
		when "101"=> ALUCtrl<="010";		-- &
		when "110"=> ALUCtrl<="001";		-- -
		--when "111"=> ALUCtrl<="101";		-- -
		when others=> ALUCtrl<="000";	
	end case;
end process;

--proces alu
process(ALUCtrl, rd1, rd2Final, sa, aluRes2, rd2)
begin
	case(ALUCtrl) is
		when "000" => aluRes2 <= RD1 + rd2Final;   -----ADD-----
					
		when "001" => aluRes2<=RD1-rd2Final;	  -----SUB-----
								
		when "010" => 				-----SLL-----
					case (SA) is
						when '1' => aluRes2<=rd2Final(14 downto 0) & "0";
						when others => aluRes2<=rd2Final;	
						--when others => aluRes2 <= (others => '0');
					end case;
								
		when "011" => 				-----SRL-----
					case (SA) is
						when '1' => aluRes2<="0" & rd2Final(15 downto 1);
						when others => aluRes2<=rd2Final;
						--when others => aluRes2 <= (others => '0');
					end case;
								
		when "100" => aluRes2<=RD1 and rd2Final;		-----AND-----
								
		when "101" => aluRes2<=RD1 or rd2Final;		-----OR-----
		
		
										
		when "110" => aluRes2<=RD1 xor rd2Final;		-----XOR-----
							
		when "111" => aluRes2 <=rd1 nor rd2Final;  -----NOR-----
					
					
		when others => aluRes2<=X"0000";		-----JUMP-----
	end case;

	case (aluRes2) is					-----ZERO SIGNAL-----
		when X"0000" => zeroSignal<='1';
		when others => zeroSignal<='0';
	end case;

end process;

zero<=zeroSignal;			-----ZERO_OUT-----

ALURes<=aluRes2;


end Behavioral;
