library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axistr_master_tb is
end entity;

architecture Behavioral of axistr_master_tb is

    constant PERIOD  : time   := 20 ns;
  
	signal endSim    : boolean := false;
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal enable     : std_logic := '0';
    signal tvalid    : std_logic;
    signal tready  : std_logic;
    signal frame_size : std_logic_vector(31 downto 0);

    component axi_streamer_v1_0 is
        port (
            enable          : in std_logic;
            frame_size      : in STD_LOGIC_VECTOR ( 31 downto 0 );
            m_axis_aclk    : in std_logic;
            m_axis_aresetn    : in std_logic;
            m_axis_tvalid    : out std_logic;
            m_axis_tdata    : out std_logic_vector(31 downto 0);
            m_axis_tstrb    : out std_logic_vector(3 downto 0);
            m_axis_tlast    : out std_logic;
            m_axis_tready    : in std_logic
        );
    end component;

begin
    clk     <= not clk after PERIOD/2;

	-- Main simulation process
	main_pr : process 
	begin
	    reset <= '0';
	    frame_size <= x"00000015";
        wait until (rising_edge(clk));
		wait until (rising_edge(clk));
		wait until (rising_edge(clk));
		reset <= '1';
		wait until (rising_edge(clk));
        wait until (rising_edge(clk));
        wait until (rising_edge(clk));
		enable	<= '1';
		for i in 0 to 100 loop wait until (rising_edge(clk)); end loop;
        tready <= '1';
		for i in 0 to 5 loop
  		    wait until (rising_edge(clk));
        end loop;
        tready <= '0';
        for i in 0 to 6 loop
            wait until (rising_edge(clk));
        end loop;
        tready <= '1';
        for i in 0 to 15 loop
            wait until (rising_edge(clk));
        end loop;
		enable	<= '0';
		for i in 0 to 20 loop wait until (rising_edge(clk)); end loop;
		enable	<= '1';
		for i in 0 to 10 loop
            wait until (rising_edge(clk));
        end loop;
        
		endSim  <= true;
        wait until (rising_edge(clk));
	end process;	
		
	-- End the simulation
	process 
	begin
        if (endSim) then
            --assert false 
            --report "End of simulation." 
            --severity failure; 
        end if;
		wait until (rising_edge(clk));
	end process;	

   DUT : axi_streamer_v1_0
        port map (
            frame_size      => frame_size   ,
            enable           => enable      ,
            
            m_axis_aclk      => clk          ,
            m_axis_aresetn   => reset        ,
            
            m_axis_tvalid   => tvalid       ,
            m_axis_tdata    => open         ,
            m_axis_tstrb    => open         ,
            m_axis_tlast    => open         ,
            m_axis_tready   => tready       
      );

end Behavioral;
