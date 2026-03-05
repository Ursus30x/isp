----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2026 10:18:57
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( sw_i : in STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
    signal parity : std_logic;
    
begin
    -- Process for setting parity bit
    process(sw_i)
        variable temp_parity : std_logic;
    begin
        temp_parity := sw_i(0);
        
        -- xor remaining switch bits
        for i in 1 to 7 loop
            temp_parity := temp_parity xor sw_i(i);
        end loop;
        
        -- set parity
        parity <= temp_parity;
    end process;
    
    -- Process for setting led display 
    process(parity)
    begin
        if parity = '0' then
            led7_seg_o <= "01100001";
        else
            led7_seg_o <= "00000011";
        end if;
    end process;
    
    -- Choosing led display
    led7_an_o <= "0111"; 

end Behavioral;