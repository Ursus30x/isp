----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2026 20:37:21
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
use ieee.numeric_std.all;

entity top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           led_o : out STD_LOGIC_VECTOR (2 downto 0));
end top;

architecture Behavioral of top is
    signal count_reg : unsigned(2 downto 0);
    signal grey : STD_LOGIC_VECTOR (2 downto 0);
begin
    process(clk_i,rst_i)
    begin
        -- Reset state
        if rst_i = '1' then
            count_reg <= "000";
        -- Incerement counter
        elsif rising_edge(clk_i) then
            count_reg <= count_reg + 1;
        end if;
    end process;
    
    -- Convert MSB to Grey code and assing to led outputs
    grey(2) <= count_reg(2);
    grey(1) <= count_reg(1) xor count_reg(2);
    grey(0) <= count_reg(0) xor count_reg(1);
    
    -- Convert MSB to Grey code and assing to led outputs
    led_o(2) <= grey(2);
    led_o(1) <= grey(1);
    led_o(0) <= grey(0);
    
end Behavioral;
