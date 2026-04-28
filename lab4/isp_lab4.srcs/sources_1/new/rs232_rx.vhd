library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rs232_rx is
    Generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    Port ( 
        clk_i      : in  STD_LOGIC;
        rst_i      : in  STD_LOGIC;
        rxd_i      : in  STD_LOGIC;
        data_o     : out STD_LOGIC_VECTOR (7 downto 0);
        data_rdy_o : out STD_LOGIC
    );
end rs232_rx;

architecture Behavioral of rs232_rx is
    constant BIT_PERIOD : integer := CLK_FREQ / BAUD_RATE;
    constant HALF_PERIOD : integer := BIT_PERIOD / 2;
    
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;
    
    signal rxd_sync1 : std_logic := '1';
    signal rxd_sync2 : std_logic := '1';
    
    signal clk_cnt : integer range 0 to BIT_PERIOD - 1 := 0;
    signal bit_cnt : integer range 0 to 7 := 0;
    
    signal shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    
begin

    -- Synchronizer for RXD
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            rxd_sync1 <= '1';
            rxd_sync2 <= '1';
        elsif rising_edge(clk_i) then
            rxd_sync1 <= rxd_i;
            rxd_sync2 <= rxd_sync1;
        end if;
    end process;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state <= IDLE;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= (others => '0');
            data_o <= (others => '0');
            data_rdy_o <= '0';
        elsif rising_edge(clk_i) then
            data_rdy_o <= '0'; -- default
            
            case state is
                when IDLE =>
                    if rxd_sync2 = '0' then
                        state <= START_BIT;
                        clk_cnt <= 0;
                    end if;
                    
                when START_BIT =>
                    if clk_cnt = HALF_PERIOD - 1 then
                        if rxd_sync2 = '0' then
                            state <= DATA_BITS;
                            clk_cnt <= 0;
                            bit_cnt <= 0;
                        else
                            state <= IDLE;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                    
                when DATA_BITS =>
                    if clk_cnt = BIT_PERIOD - 1 then
                        clk_cnt <= 0;
                        shift_reg(bit_cnt) <= rxd_sync2;
                        if bit_cnt = 7 then
                            state <= STOP_BIT;
                        else
                            bit_cnt <= bit_cnt + 1;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                    
                when STOP_BIT =>
                    if clk_cnt = BIT_PERIOD - 1 then
                        state <= IDLE;
                        data_o <= shift_reg;
                        data_rdy_o <= '1';
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;
