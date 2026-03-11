library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
-- Testbench entity is always empty
end tb;

architecture Behavioral of tb is

    -- 1. Declare the Top module as a component
    component top is
        Port ( clk_i      : in STD_LOGIC;
               btn_i      : in STD_LOGIC_VECTOR (3 downto 0);
               sw_i       : in STD_LOGIC_VECTOR (7 downto 0);
               led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
               led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    -- 2. Internal signals to connect to the DUT (Device Under Test)
    -- Initialize inputs to '0' so the simulation doesn't start with 'U' (Unknown)
    signal clk_i      : STD_LOGIC := '0';
    signal btn_i      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal sw_i       : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    
    signal led7_an_o  : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal led7_seg_o : STD_LOGIC_VECTOR(7 downto 0) := "11111111";

    -- 100 MHz clock period is 10 ns (5 ns high, 5 ns low)
    constant clk_period : time := 10 ns;

begin

    -- 3. Instantiate the Top module
    DUT: top port map (
        clk_i      => clk_i,
        btn_i      => btn_i,
        sw_i       => sw_i,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    -- 4. Clock Generation Process
    -- This runs continuously in the background
    clk_process: process
    begin
        clk_i <= '0';
        wait for clk_period / 2;
        clk_i <= '1';
        wait for clk_period / 2;
    end process;

    -- 5. The Main Stimulus Process (Matching Lab Instructions)
    stimulus: process
    begin
        -- Wait a tiny bit after power-up before doing anything
        wait for 100 us;

        -- =========================================================
        -- TEST 1: Write '5' to Digit 0 (Rightmost digit)
        -- =========================================================
        -- sw_i(3 downto 0) = "0101" (Hex 5)
        -- sw_i(4) = '0' (Decimal point OFF)
        sw_i <= "00000101"; 
        wait for 10 us; -- Small delay to simulate human reaching for button
        
        btn_i(0) <= '1';  -- Press button
        wait for 1 ms;    -- "Czas trzymania przycisku powinien wynosić 1ms"
        
        btn_i(0) <= '0';  -- Release button
        wait for 2 ms;    -- "Czas zwolnienia 2 ms"

        -- =========================================================
        -- TEST 2: Write 'A' (with Dot) to Digit 1
        -- =========================================================
        -- sw_i(3 downto 0) = "1010" (Hex A)
        -- sw_i(5) = '1' (Decimal point ON)
        sw_i <= "00101010"; 
        wait for 10 us; 
        
        btn_i(1) <= '1';
        wait for 1 ms;
        
        btn_i(1) <= '0';
        wait for 2 ms;

        -- =========================================================
        -- TEST 3: Write 'C' to Digit 2
        -- =========================================================
        -- sw_i(3 downto 0) = "1100" (Hex C)
        sw_i <= "00001100"; 
        wait for 10 us;
        
        btn_i(2) <= '1';
        wait for 1 ms;
        
        btn_i(2) <= '0';
        wait for 2 ms;

        -- =========================================================
        -- TEST 4: Write 'F' (with Dot) to Digit 3 (Leftmost digit)
        -- =========================================================
        -- sw_i(3 downto 0) = "1111" (Hex F)
        -- sw_i(7) = '1' (Decimal point ON)
        sw_i <= "10001111"; 
        wait for 10 us;
        
        btn_i(3) <= '1';
        wait for 1 ms;
        
        btn_i(3) <= '0';
        wait for 2 ms;
        
        -- =========================================================
        -- FINISH: Wait a few more milliseconds to observe multiplexing
        -- =========================================================
        wait for 5 ms;

        -- End the simulation
        wait;
    end process;

end Behavioral;