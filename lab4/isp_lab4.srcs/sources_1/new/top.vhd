library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           RXD_i : in STD_LOGIC;
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is

    component display is
        generic (
            DIVIDER_MAX : integer := 100000 
        );
        Port ( clk_i : in STD_LOGIC;
               rst_i : in STD_LOGIC;
               digit_i : in STD_LOGIC_VECTOR (31 downto 0);
               led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
               led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component rs232_rx is
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
    end component;

    component encoder_and_memory is
        Port ( clk_i    : in STD_LOGIC;
               btn_i    : in STD_LOGIC_VECTOR (3 downto 0);
               sw_i     : in STD_LOGIC_VECTOR (7 downto 0);
               digit_o  : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal rx_data     : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_data_rdy : STD_LOGIC;
    
    signal display_data  : STD_LOGIC_VECTOR(31 downto 0);
    
    signal sw_internal  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal btn_internal : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    
    type state_type is (IDLE, WRITE_LOW, WAIT_LOW, WRITE_HIGH, WAIT_HIGH);
    signal state : state_type := IDLE;
    signal captured_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

    Display_Inst: display
    generic map (
        DIVIDER_MAX => 100000 
    )
    port map (
        clk_i      => clk_i,
        rst_i      => rst_i,
        digit_i    => display_data,
        led7_an_o  => led7_an_o,
        led7_seg_o => led7_seg_o
    );

    RS232_Inst: rs232_rx
    generic map (
        CLK_FREQ  => 100000000,
        BAUD_RATE => 9600
    )
    port map (
        clk_i      => clk_i,
        rst_i      => rst_i,
        rxd_i      => RXD_i,
        data_o     => rx_data,
        data_rdy_o => rx_data_rdy
    );

    Encoder_And_Memory_Inst: encoder_and_memory
    port map (
        clk_i      => clk_i,
        btn_i      => btn_internal,
        sw_i       => sw_internal,
        digit_o    => display_data
    );

    -- State machine to feed RS232 data into encoder_and_memory
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state <= IDLE;
            btn_internal <= (others => '0');
            sw_internal <= (others => '0');
        elsif rising_edge(clk_i) then
            case state is
                when IDLE =>
                    btn_internal <= "0000";
                    if rx_data_rdy = '1' then
                        captured_data <= rx_data;
                        sw_internal(3 downto 0) <= rx_data(3 downto 0);
                        state <= WRITE_LOW;
                    end if;
                
                when WRITE_LOW =>
                    btn_internal <= "0001"; -- Pulse button 0 to save lower nibble
                    state <= WAIT_LOW;
                
                when WAIT_LOW =>
                    btn_internal <= "0000";
                    sw_internal(3 downto 0) <= captured_data(7 downto 4);
                    state <= WRITE_HIGH;
                
                when WRITE_HIGH =>
                    btn_internal <= "0010"; -- Pulse button 1 to save upper nibble
                    state <= WAIT_HIGH;
                
                when WAIT_HIGH =>
                    btn_internal <= "0000";
                    state <= IDLE;
                    
            end case;
        end if;
    end process;

end Behavioral;
