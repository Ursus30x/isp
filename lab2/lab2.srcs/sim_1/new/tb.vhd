----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2026 23:00:23
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

component top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           led_o : out STD_LOGIC_VECTOR (2 downto 0));
end component;

signal clk_i : STD_LOGIC := '0';
signal rst_i : STD_LOGIC := '0';
signal led_o : STD_LOGIC_VECTOR (2 downto 0);

begin

    dut: top port map(
        clk_i => clk_i,
        rst_i => rst_i,
        led_o => led_o
    );


    stim: process
    begin
        -- TEST 1: Stable clock incrementation and overflow
        rst_i <= '1';
        wait for 100 ms;
        rst_i <= '0';
  
        for i in 0 to 8 loop
            clk_i <= '1';
            wait for 10 ms;
            clk_i <= '0';
            wait for 90 ms;
        end loop;
        
        -- TEST 2: Stable clock and reset in the middle
        
        for i in 0 to 4 loop
            clk_i <= '1';
            wait for 10 ms;
            clk_i <= '0';
            wait for 90 ms;
        end loop;
        
        -- Assuming we click reset in the middle of the clk_i = 1 pulse
        clk_i <= '1';
        wait for 5 ms;  
        
        rst_i <= '1';   
        
        wait for 5 ms;
        clk_i <= '0';
        wait for 90 ms;
        
        rst_i <= '0';   
        -- Registers should be reseted
        
        for i in 0 to 4 loop
            clk_i <= '1';
            wait for 10 ms;
            clk_i <= '0';
            wait for 90 ms;
        end loop;
        
        -- TEST 3: Bouncing clock
        
        
        for i in 0 to 8 loop
            -- Simulate bouncing
            for j in 0 to 50 loop
                clk_i <= '1';
                wait for 10 us;
                clk_i <= '0';
                wait for 10 us;
            end loop;
            clk_i <= '1'; -- Stabilisation
            wait for 5 ms;
            
            clk_i <= '0';
            wait for 90 ms;
        end loop;
        
        wait;
    end process;


end Behavioral;
