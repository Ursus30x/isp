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

    signal segments : STD_LOGIC_VECTOR(6 downto 0);
    signal stored_digits : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');

begin

SetValue: process(sw_i)
    variable value : unsigned(3 downto 0);
begin
    value := unsigned(sw_i(3 downto 0));

    case value is
        when x"0" => segments <= "0000001"; -- 0
        when x"1" => segments <= "1001111"; -- 1
        when x"2" => segments <= "0010010"; -- 2
        when x"3" => segments <= "0000110"; -- 3
        when x"4" => segments <= "1001100"; -- 4
        when x"5" => segments <= "0100100"; -- 5
        when x"6" => segments <= "0100000"; -- 6
        when x"7" => segments <= "0001111"; -- 7
        when x"8" => segments <= "0000000"; -- 8
        when x"9" => segments <= "0000100"; -- 9
        when x"A" => segments <= "0001000"; -- A
        when x"B" => segments <= "1100000"; -- b
        when x"C" => segments <= "0110001"; -- C
        when x"D" => segments <= "1000010"; -- d
        when x"E" => segments <= "0110000"; -- E
        when x"F" => segments <= "0111000"; -- F
        when others => segments <= "1111111"; -- Blank
    end case;

end process;

OutputDigits: process(clk_i)
begin
    if rising_edge(clk_i) then
        if btn_i(0) = '1' then
            stored_digits(7 downto 1)  <= segments;
        end if;

        if btn_i(1) = '1' then
            stored_digits(15 downto 9) <= segments;
        end if;

        if btn_i(2) = '1' then
            stored_digits(23 downto 17) <= segments;
        end if;

        if btn_i(3) = '1' then
            stored_digits(31 downto 25) <= segments;
        end if;
     end if;
end process;

digit_o(7 downto 1)   <= stored_digits(7 downto 1);
digit_o(0)            <= not sw_i(4);

digit_o(15 downto 9)  <= stored_digits(15 downto 9);
digit_o(8)            <= not sw_i(5);

digit_o(23 downto 17) <= stored_digits(23 downto 17);
digit_o(16)           <= not sw_i(6);

digit_o(31 downto 25) <= stored_digits(31 downto 25);
digit_o(24)           <= not sw_i(7);

end Behavioral;
