----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:41:42 05/30/2017 
-- Design Name: 
-- Module Name:    national_anthem_box - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity national_anthem_box is
port (sw_m: in std_logic_vector(1 downto 0);
		nreset_m: in std_logic;
		board_clk_m: in std_logic;
		vsync_m: out std_logic;
		hsync_m: out std_logic;
		red_m: out std_logic_vector(2 downto 0);
		green_m: out std_logic_vector(2 downto 0);
		blue_m: out std_logic_vector(1 downto 0);
		tone_m: out std_logic;
		rth_m: out std_logic);
end national_anthem_box;

architecture Behavioral of national_anthem_box is

component ee240_vgadriver
port (switches: in std_logic_vector(1 downto 0);
		nreset: in std_logic;
		board_clk: in std_logic;
		vsync: out std_logic;
		hsync: out std_logic;
		red: out std_logic_vector(2 downto 0);
		green: out std_logic_vector(2 downto 0);
		blue: out std_logic_vector(1 downto 0));
end component;

component note_sys
port (nreset: in std_logic;
		board_clk: in std_logic;
		sct: in std_logic_vector (1 downto 0);
		tone: out std_logic;
		rth: out std_logic);
end component;

begin

VGA 	: ee240_vgadriver port map (sw_m, nreset_m, board_clk_m, vsync_m, hsync_m, red_m, green_m, blue_m);
MUSIC	: note_sys port map (nreset_m, board_clk_m, sw_m, tone_m, rth_m);


end Behavioral;

