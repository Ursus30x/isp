library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity encoder_and_memory is
    Port ( clk_i    : in STD_LOGIC;
           btn_i    : in STD_LOGIC_VECTOR (3 downto 0);
           sw_i     : in STD_LOGIC_VECTOR (7 downto 0);
           digit_o  : out STD_LOGIC_VECTOR (31 downto 0));
end encoder_and_memory;

architecture Behavioral of encoder_and_memory is

    signal segments : STD_LOGIC_VECTOR(6 downto 0); -- only 7 bits needed since dot is set by switches    
    signal stored_digits : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
    
begin
   
SetValue: process(sw_i)
    variable value : unsigned(3 downto 0);
begin
    value := unsigned(sw_i(3 downto 0));
    
    case value is
        when x"0" => segments <= "1000000"; -- 0
        when x"1" => segments <= "1111001"; -- 1
        when x"2" => segments <= "0100100"; -- 2
        when x"3" => segments <= "0110000"; -- 3
        when x"4" => segments <= "0011001"; -- 4
        when x"5" => segments <= "0010010"; -- 5
        when x"6" => segments <= "0000010"; -- 6
        when x"7" => segments <= "1111000"; -- 7
        when x"8" => segments <= "0000000"; -- 8
        when x"9" => segments <= "0010000"; -- 9
        when x"A" => segments <= "0001000"; -- A
        when x"B" => segments <= "0000011"; -- b
        when x"C" => segments <= "1000110"; -- C
        when x"D" => segments <= "0100001"; -- d
        when x"E" => segments <= "0000110"; -- E
        when x"F" => segments <= "0001110"; -- F
        when others => segments <= "1111111"; -- Blank
    end case;
    
end process;

OutputDigits: process(clk_i)
begin 
    if rising_edge(clk_i) then 
        if btn_i(0) = '1' then
            stored_digits(6  downto 0)  <= segments;
        end if;
        
        if btn_i(1) = '1' then
            stored_digits(14 downto 8)  <= segments;
        end if;
        
        if btn_i(2) = '1' then
            stored_digits(22 downto 16) <= segments;
        end if;
          
        if btn_i(3) = '1' then
            stored_digits(30 downto 24) <= segments;
        end if;
     end if;
end process;

digit_o(6 downto 0)   <= stored_digits(6 downto 0);
digit_o(7)            <= not sw_i(4); 

digit_o(14 downto 8)  <= stored_digits(14 downto 8);
digit_o(15)           <= not sw_i(5);

digit_o(22 downto 16) <= stored_digits(22 downto 16);
digit_o(23)           <= not sw_i(6);

digit_o(30 downto 24) <= stored_digits(30 downto 24);
digit_o(31)           <= not sw_i(7);

end Behavioral;
