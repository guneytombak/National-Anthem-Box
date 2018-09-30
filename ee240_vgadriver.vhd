-- Frequency Divider

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;

entity freq_div is 
port (rst : in std_logic; 
		clk_in : in std_logic;
		clk_out : out std_logic);
end freq_div;

architecture Behavioral of freq_div is

signal count: std_logic := '0';
signal temp : std_logic := '0';

begin
	process (clk_in, rst) begin
		if (rst = '1') then -- COULD BE 1, since it is /reset
			temp <= '0';
			count <= '0';
		elsif rising_edge(clk_in) then
			if (count = '1') then
				temp <= not(temp);
				count <= not(count);
			else
				count <= not(count);
			end if;
		end if;
	end process;

	clk_out <= temp;

end Behavioral;

-- Vertical Sync Generator

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity ver_sync is
port (rst : in std_logic;
		clk : in std_logic;
		ver: out std_logic;
		vsyn: out std_logic;
		vcount: out integer);
end ver_sync;

architecture Behavioral of ver_sync is

	constant VTs		: integer := 416799;
	constant VTdisp 	: integer := 384000;
	constant VTfp		: integer := 8000;
	constant VTpw		: integer := 1599;
	constant VTbp		: integer := 23200;

	signal verco		: integer range 0 to 416799 := 0;


begin

-- Counter System

process (clk,rst)
	begin
	if (rst = '1') then 
		verco <= 0;
	elsif (rising_edge(clk)) then
		if (verco = VTs) then
			verco <= 0;
		else
			verco <= verco + 1;
		end if;
		if ((verco > (VTpw + VTbp)) and (verco < (VTs - VTfp))) then -- Enabler for Display 
			ver <= '1';
		else 
			ver <= '0';
		end if;
		if (VTpw < verco) then
			vsyn <= '1';
			else
			vsyn <= '0';
		end if;
	end if;
	vcount<=verco;
end process;


end Behavioral;

-- Horizontal Sync Generator

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity hor_sync is
port (rst : in std_logic;
		clk : in std_logic;
		hor: out std_logic;
		hsyn: out std_logic;
		hstr: out std_logic;
		hcount: out integer);
end hor_sync;

architecture Behavioral of hor_sync is

	constant HTs		: integer := 799;
	constant HTdisp 	: integer := 640;
	constant HTfp		: integer := 16;
	constant HTpw		: integer := 95;
	constant HTbp		: integer := 48;

	signal horco		: integer range 0 to 799 := 0;
	
begin

-- Counter System

process (clk,rst)
	begin
	if (rst = '1') then 
		horco <= 0;
	elsif (rising_edge(clk)) then
		if (horco = HTs) then
			horco <= 0;
		else
			horco <= horco + 1;
		end if;
		if ((horco > (HTpw + HTbp)) and (horco < (HTs - HTfp))) then -- Enabler for Display 
			hor <= '1';
		else 
			hor <= '0';
		end if;
		if (HTpw < horco) then
			hsyn <= '1';
			else
			hsyn <= '0';
		end if;
		if (horco = (HTbp + HTpw + 1)) then
			hstr <= '1';
			else
			hstr <= '0';
		end if;
	end if;
hcount<=horco;
end process;

end Behavioral;

-- Synthesizable Simple VGA Driver to Display All Possible Colors
-- EE240 class Bogazici University
-- Implemented on Xilinx Spartan VI FPGA chip

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity ee240_vgadriver is
	port (
		switches: in std_logic_vector(1 downto 0);
		nreset: in std_logic;
		board_clk: in std_logic;
		vsync: out std_logic;
		hsync: out std_logic;
		red: out std_logic_vector(2 downto 0);
		green: out std_logic_vector(2 downto 0);
		blue: out std_logic_vector(1 downto 0));
	end;

architecture arch_vga_driver of ee240_vgadriver is

-- Components

-- Frequency Divider
component freq_div 
port (
		rst  : in std_logic;
		clk_in : in std_logic;
		clk_out : out std_logic);
end component;

component ver_sync 
port (rst : in std_logic;
		clk : in std_logic;
		ver: out std_logic;
		vsyn: out std_logic;
		vcount: out integer);
end component;

component hor_sync
port (rst : in std_logic;
		clk : in std_logic;
		hor: out std_logic;
		hsyn: out std_logic;
		hstr: out std_logic;
		hcount: out integer);
end component;

-- Signals

signal vga_clk, v, h, str, dispen, ze: std_logic; 
signal rgb, a1, a2, a3, b1, b2, b3, c1, c2, c3 : std_logic_vector (7 downto 0); 
signal vc, hc: integer;
signal sw: std_logic_vector(1 downto 0);

-- Begin
begin

MHz25_clk : freq_div port map (nreset, board_clk, vga_clk);
Versync : ver_sync port map (nreset, vga_clk, v, vsync, vc);
Horsync : hor_sync port map (nreset, vga_clk, h, hsync, str, hc);

sw<=switches;
dispen <= (h and v);
ze <= (rgb(0) and rgb(1) and rgb(2) and rgb(3) and rgb(4) and rgb(5) and rgb(6) and rgb(7)) or str;

process (vga_clk)
begin
	if (rising_edge(vga_clk)) then
		if (nreset = '1') then
			rgb <= "00000000";
		elsif (dispen = '1') then
			if sw="01" then
				a1<="00000000";
				a2<="00000000";
				a3<="00000000";
				b1<="11100000";
				b2<="11100000";
				b3<="11100000";
				c1<="11111100";
				c2<="11111100";
				c3<="11111100";
			elsif sw="11" then
				a1<="00000011";
				a2<="11111100";
				a3<="11100000";
				b1<="00000011";
				b2<="11111100";
				b3<="11100000";
				c1<="00000011";
				c2<="11111100";
				c3<="11100000";
			elsif sw="10" then
				a1<="11111111";
				a2<="11111111";
				a3<="11111111";
				b1<="00000011";
				b2<="00000011";
				b3<="00000011";
				c1<="11100000";
				c2<="11100000";
				c3<="11100000";
			else
				a1<="00000011";
				a2<="11111111";
				a3<="10100000";
				b1<="00000011";
				b2<="11111111";
				b3<="10100000";
				c1<="00000011";
				c2<="11111111";
				c3<="10100000";
			end if;
			
			if vc>280799 then
				if hc>570 then
					rgb<=c3;
				elsif hc>357 then
					rgb<=c2;
				else
					rgb<=c1;
				end if;
			elsif vc>152799 then
				if hc>570 then
					rgb<=b3;
				elsif hc>357 then
					rgb<=b2;
				else
					rgb<=b1;
				end if;
			else
				if hc>570 then
					rgb<=a3;
				elsif hc>357 then
					rgb<=a2;
				else
					rgb<=a1;
				end if;
			end if;
			
		elsif (dispen = '0') then
			rgb <= "00000000";
		end if;	
	end if;
end process;

red(2 downto 0) 	<= rgb(7 downto 5);
green(2 downto 0) <= rgb(4 downto 2);
blue(1 downto 0) 	<= rgb(1 downto 0);

end arch_vga_driver;

