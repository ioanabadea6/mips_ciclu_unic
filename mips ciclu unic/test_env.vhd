----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 10:38:19 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component generator_monoimpuls is
    Port ( en : out STD_LOGIC;
       btn : in STD_LOGIC;
       clk : in STD_LOGIC);    
end component;

component ssd is
     Port ( clk: in std_logic;
          digits: in std_logic_vector( 15 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0);
          cat : out STD_LOGIC_VECTOR (6 downto 0));       
end component;


component instr_fetch is
       Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       en : in STD_LOGIC;
       j_adr : in STD_LOGIC_VECTOR (15 downto 0);
       b_adr : in STD_LOGIC_VECTOR (15 downto 0);
       pcSrc : in STD_LOGIC;
       jump: in STD_LOGIC;
       instr : out STD_LOGIC_VECTOR (15 downto 0);
       next_instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component mem is
     Port ( memWrite : in STD_LOGIC;
          aluRes : in STD_LOGIC_VECTOR (15 downto 0);
          rd2 : in STD_LOGIC_VECTOR (15 downto 0);
          clk : in STD_LOGIC;
          memData : out STD_LOGIC_VECTOR (15 downto 0);
          aluRes2 : out STD_LOGIC_VECTOR (15 downto 0);
          en : in STD_LOGIC);
end component;

component uc is
     Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
          regDst : out STD_LOGIC ;
          extOp : out STD_LOGIC ;
          ALUSrc : out STD_LOGIC;
          branch : out STD_LOGIC;
          jump : out STD_LOGIC;
          ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
          memWrite : out STD_LOGIC;
          memToReg : out STD_LOGIC;
          regWrite : out STD_LOGIC);
end component;

component id is
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
end component;

component unit_ex is
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
end component;

signal en: STD_LOGIC;    
signal rst: STD_LOGIC;	  
signal branch_address:std_logic_vector(15 downto 0);  	   
signal jmp_address:std_logic_vector(15 downto 0); 		   
signal data : std_logic_vector(15 downto 0):=X"0000";  
signal next_instr: std_logic_vector(15 downto 0);			    
signal instr: std_logic_vector(15 downto 0);			   
signal aluRes: std_logic_vector(15 downto 0);			   
signal zero: std_logic;										
signal rd1: std_logic_vector(15 downto 0);					
signal rd2: std_logic_vector(15 downto 0);					
signal ext_imm : std_logic_vector(15 downto 0);				
signal func :std_logic_vector(2 downto 0);					
signal sa : std_logic;												
signal memData: std_logic_vector(15 downto 0);				
signal aluRes2: std_logic_vector(15 downto 0);			
signal wd: std_logic_vector(15 downto 0);		
signal PCSrc:std_logic;	
signal jump: std_logic;
signal branch: std_logic;
signal regDst: std_logic;
signal extOp: std_logic;
signal aluSrc: std_logic;
signal aluOp: std_logic_vector(2 downto 0);
signal memWrite: std_logic;
signal memtoReg: std_logic;
signal regWrite: std_logic;

begin
   
    enable: generator_monoimpuls port map (en, btn(0), clk); --en
    enable2: generator_monoimpuls port map (rst, btn(1), clk); --rst

    c1: instr_fetch port map(clk, rst, en, jmp_address, branch_address, PCsrc, jump, instr, next_instr);
    c2: id port map(regWrite, instr(12 downto 0), regDst, wd, clk, extOp, en, rd1, rd2, ext_imm, func, sa);
    c3: unit_ex port map (next_instr, rd1, rd2, ext_imm, func, sa, aluOp, aluSRC, zero, aluRes, branch_address);
    c4: mem port map(memWrite, aluRes, rd2, clk, memData,  aluRes2, en);
    c5: uc port map(instr, regDst, extOp, aluSrc, branch, jump, aluOp, memWrite, memToReg, regWrite);
    c6: ssd port map(clk, data,  an, cat);

    --ssd   
    
    process(memToReg, aluRes2, memData)
    begin
        case(memToReg) is
            when '0' => wd <= aluRes2;
            when others => wd <= memData;
        end case;
    end process;
    
    pcSrc<=zero and branch;
    
    jmp_address <= next_instr(15 downto 13) & instr(12 downto 0);
    
    --ssd mux
    process(next_instr, instr, rd1, rd2, ext_imm, aluRes, memData, wd, sw)
    begin
        case(sw(7 downto 5)) is
            when "000"=> data<=instr;            -----AFISARE INSTROUT-----
            when "001"=> data<=next_instr;                -----AFISARE PCOUT-----
            when "010"=> data<=rd1;                -----AFISARE ReadData1-----
            when "011"=> data<=rd2;                -----AFISARE ReadData2-----
            when "100"=> data<=ext_imm;            -----AFISARE EXT_IMM-----
            when "101" => data<=aluRes;            -----AFISARE ALUres-----        
            when "110"=> data<=memData;            -----AFISARE MemData-----
            when "111"=> data<=wd; 
            when others => data<=x"0000";   -----AFISARE WriteData - RegisterFile-----
        end case;
    end process;
    


    
   led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;  
    
end Behavioral;
