library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity display is
    generic (
        DIVIDER_MAX : integer := 100000 
    );
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           digit_i : in STD_LOGIC_VECTOR (31 downto 0);
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));

end display;

architecture Behavioral of display is

    signal active_digit : unsigned(1 downto 0) := "00";
    signal tick_cnt : integer range 0 to DIVIDER_MAX := 0;

begin
    Mem_Block: process(clk_i, rst_i)
    begin 
        if rst_i = '1' then
            active_digit    <= "00";
            tick_cnt        <= 0;
        elsif rising_edge(clk_i) then
            if tick_cnt = DIVIDER_MAX then
                tick_cnt <= 0;
                active_digit <= active_digit + 1;
            else
                tick_cnt <= tick_cnt + 1;
            end if;
        end if;
    end process;
    
    Route_Block: process(active_digit, digit_i, rst_i)
    begin
        if rst_i = '1' then
            led7_an_o  <= "0000"; 
            led7_seg_o <= "00000000"; 
        else 
            case active_digit is
                when "00" =>
                    led7_an_o <= "1110"; 
                    led7_seg_o <= digit_i(7 downto 0);    
                when "01" =>
                    led7_an_o <= "1101";
                    led7_seg_o <= digit_i(15 downto 8);   
                when "10" =>
                    led7_an_o <= "1011";
                    led7_seg_o <= digit_i(23 downto 16); 
                when "11" =>
                    led7_an_o <= "0111";
                    led7_seg_o <= digit_i(31 downto 24);
                when others =>
                    led7_an_o <= "1111";
                    led7_seg_o <= "11111111";
                end case; 
          end if;
    end process;


end Behavioral;
