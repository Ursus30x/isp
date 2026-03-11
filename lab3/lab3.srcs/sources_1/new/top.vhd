library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is

    Port ( clk_i : in STD_LOGIC;
           btn_i : in STD_LOGIC_VECTOR (3 downto 0);
           sw_i : in STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));

end top;

architecture Behavioral of top is

    component display is
        generic (
            DIVIDER_MAX : integer := 100000 
        );
        Port ( clk_i      : in  STD_LOGIC;
               rst_i      : in  STD_LOGIC;
               digit_i    : in  STD_LOGIC_VECTOR (31 downto 0);
               led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
               led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component encoder_and_memory is
        Port ( clk_i    : in STD_LOGIC;
               btn_i    : in STD_LOGIC_VECTOR (3 downto 0);
               sw_i     : in STD_LOGIC_VECTOR (7 downto 0);
               digit_o  : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
      
    
    signal display_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '1');
begin
        Display_Inst: display
        generic map (
            DIVIDER_MAX => 100000 -- Leave as 100000 for hardware, change to 5 for Testbenches!
        )
        port map (
            clk_i      => clk_i,             -- Connects main board clock to component clock
            rst_i      => '0',          
            digit_i    => display_data,      -- Connects our internal 32-bit wire to the display
            led7_an_o  => led7_an_o,         -- Connects component output straight to the board pins
            led7_seg_o => led7_seg_o
        );
        
        Encoder_And_Memory_Inst: encoder_and_memory
        port map (
            clk_i      => clk_i,
            btn_i      => btn_i,
            sw_i       => sw_i,
            digit_o    => display_data
        );
            
end Behavioral;
