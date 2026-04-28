library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture Behavioral of tb is

    component top is
        Port ( clk_i      : in STD_LOGIC;
               rst_i      : in STD_LOGIC;
               RXD_i      : in STD_LOGIC;
               led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
               led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal clk_i      : std_logic := '0';
    signal rst_i      : std_logic := '1';
    signal RXD_i      : std_logic := '1';
    signal led7_an_o  : std_logic_vector(3 downto 0);
    signal led7_seg_o : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz clock

    -- Transmission periods
    constant NOMINAL_PERIOD : time := 104167 ns; -- 1/9600 sec
    constant SLOW_PERIOD    : time := 108507 ns; -- 1/(9600 * 0.96) sec => 1/9216 sec
    constant FAST_PERIOD    : time := 100160 ns; -- 1/(9600 * 1.04) sec => 1/9984 sec

    -- Procedure to send one byte via UART
    procedure send_byte(
        data : std_logic_vector(7 downto 0);
        bit_time : time;
        signal rxd : out std_logic
    ) is
    begin
        -- Start bit
        rxd <= '0';
        wait for bit_time;
        
        -- Data bits (LSB first)
        for i in 0 to 7 loop
            rxd <= data(i);
            wait for bit_time;
        end loop;
        
        -- Stop bit
        rxd <= '1';
        wait for bit_time;
        
        -- Wait a bit before next transmission
        wait for bit_time * 2;
    end procedure;

begin

    UUT: top
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            RXD_i      => RXD_i,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );

    -- Clock generation
    clk_process: process
    begin
        clk_i <= '0';
        wait for CLK_PERIOD / 2;
        clk_i <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- 1. Reset na poczatku symulacji
        rst_i <= '1';
        RXD_i <= '1';
        wait for 100 ns;
        rst_i <= '0';
        
        wait for 1 us;

        -- Wyslanie danej z przykladu (Rys. 1) -> 01010011 (od MSB do LSB, czyli "01010011")
        -- LSB idzie jako pierwsze: 1, 1, 0, 0, 1, 0, 1, 0 (jak na rysunku: D0=1, D1=1, D2=0...)
        
        -- 2. Pierwszy raz z predkoscia nominalna (9600 bps)
        report "Transmisja 1: Predkosc nominalna (9600 bps)";
        send_byte("01010011", NOMINAL_PERIOD, RXD_i);
        
        -- Czekamy pelny cykl wyswietlacza (4x 1ms = 4ms) + 1ms zapasu
        wait for 5 ms;
        
        -- Czyszczenie stanu przed nastepna ramka
        rst_i <= '1';
        wait for 100 ns;
        rst_i <= '0';
        wait for 1 us;
        
        -- 3. Drugi raz z predkoscia mniejsza o 4% (9216 bps)
        report "Transmisja 2: Predkosc mniejsza o 4% (9216 bps)";
        send_byte("01010011", SLOW_PERIOD, RXD_i);
        
        -- Czekamy pelny cykl wyswietlacza
        wait for 5 ms;
        
        -- Czyszczenie stanu przed nastepna ramka
        rst_i <= '1';
        wait for 100 ns;
        rst_i <= '0';
        wait for 1 us;
        
        -- 4. Trzeci raz z predkoscia wieksza o 4% (9984 bps)
        report "Transmisja 3: Predkosc wieksza o 4% (9984 bps)";
        send_byte("01010011", FAST_PERIOD, RXD_i);
        
        -- Czekamy pelny cykl wyswietlacza na sam koniec
        wait for 5 ms;

        report "Symulacja zakonczona pomyslnie.";
        wait;
    end process;

end Behavioral;
