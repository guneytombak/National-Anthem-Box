-- Frequency Divider

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;

entity tempHz8 is 
port (rst 	 : in std_logic;
		clk_in : in std_logic;
		Hz8	 : out std_logic);
end tempHz8;

architecture Behavioral of tempHz8 is

signal count: integer range 0 to 6249999 := 0;
signal temp : std_logic := '0';

begin
    process (clk_in, rst) 
		  begin
		  if rising_edge(clk_in) then
				if (rst = '1') then
					temp <= '0';
					count <= 0;
            elsif (count = 6249999) then
                temp <= NOT(temp);
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    Hz8 <= temp;
end Behavioral;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;

entity gen_note is 
port (clk_in : in std_logic;
		div	 : in std_logic_vector (19 downto 0);
		note   : out std_logic);
end gen_note;

architecture Behavioral of gen_note is

signal count: std_logic_vector (19 downto 0) := x"00000";
signal temp : std_logic := '0';

begin
    process (clk_in) 
		  begin
		  if rising_edge(clk_in) then
            if (count = div) then
                temp <= NOT(temp);
                count <= x"00000";
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    note <= temp;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_signed.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;


entity note_sys is
port (nreset: in std_logic;
		board_clk: in std_logic;
		sct: in std_logic_vector (1 downto 0);
		tone: out std_logic;
		rth: out std_logic);
end note_sys;

architecture Behavioral of note_sys is

component tempHz8 
port (rst	 : in std_logic;
		clk_in : in std_logic;
		Hz8	 : out std_logic);
end component;

component gen_note 
port (clk_in : in std_logic;
		div	 : in std_logic_vector (19 downto 0);
		note   : out std_logic);
end component;

signal n, c, d, ef, e, f, gf, g, af, a, b, co, do : std_logic;
signal t, ze, cobze : std_logic;
signal cob : std_logic_vector (5 downto 0);
signal play: std_logic_vector (11 downto 0);

begin

-- rhythm 
Rhythm: tempHz8 port map (nreset, board_clk, t);

-- note creation
--n <= '0'; -- Null, for pause note.

Ut 	: gen_note port map (board_clk, x"2EA85",c);
Re		: gen_note port map (board_clk, x"29918",d);
Miflat: gen_note port map (board_clk, x"273C0",ef);
Mi		: gen_note port map (board_clk, x"25084",e);
Fa		: gen_note port map (board_clk, x"22F43",f);
Solflt: gen_note port map (board_clk, x"20FDE",gf);
Sol	: gen_note port map (board_clk, x"1F23E",g);
Laflat: gen_note port map (board_clk, x"1D64A",af);
La		: gen_note port map (board_clk, x"1BBE3",a);
Si		: gen_note port map (board_clk, x"18B76",b);
Doktav: gen_note port map (board_clk, x"17544",co);
Rektav: gen_note port map (board_clk, x"14C8A",do);



ze <= ((cob(0) and cob(1) and cob(2) and cob(3) and cob(4) and cob(5)) or nreset);
cobze <= (cob(0) or cob(1) or cob(2) or cob(3) or cob(4) or cob(5));

rth <= t;

-- play <= "100000100000"; -- c/g

-- Maybe we should use integer rather then std_vector????

process (t)
	begin
	if (rising_edge(t)) then
		-- Counter Part
		if (ze = '1') then
			cob <= "000000"; -- Could be a problem.
		else
			cob <= cob + 1;
		end if;
		if (cobze = '0') then
			play <= "000000000000";
		end if;
		-- 00: French Anthem
		if ((sct(0) or sct(1)) = '0') then
			if (cob < 8) and (0 < cob) then
				play <= "000000100000"; -- g
			elsif (cob < 16) then
				play <= "000000001000"; -- a
			elsif (cob < 22) then
				play <= "000000000001"; -- do
			elsif (cob < 24) then
				play <= "000000000100"; -- b
			elsif (cob < 28) then
				play <= "000000100000"; -- g
			elsif (cob < 30) then
				play <= "000000000100"; -- b
			elsif (cob < 32) then
				play <= "000000100000"; -- g
			elsif (cob < 36) then
				play <= "000100000000"; -- e
			elsif (cob < 44) then
				play <= "000000000010"; -- co
			elsif (cob < 46) then
				play <= "000000001000"; -- a
			elsif (cob < 48) then
				play <= "000000000100"; -- b
			elsif (cob < 64) then
				play <= "000000100000"; -- g
			end if;
		end if;
		-- 01: German Anthem
		if ((not(sct(0)) or (sct(1))) = '0') then --
			if (cob < 12) and (0 < cob) then
				play <= "001000000000"; -- ef
			elsif (cob < 16) then
				play <= "000010000000"; -- f
			elsif (cob < 24) then
				play <= "000000100000"; -- g
			elsif (cob < 32) then
				play <= "000010000000"; -- f
			elsif (cob < 40) then
				play <= "000000010000"; -- af
			elsif (cob < 48) then
				play <= "000000100000"; -- g
			elsif (cob < 54) then
				play <= "000010000000"; -- f
			elsif (cob < 56) then
				play <= "010000000000"; -- d
			elsif (cob < 64) then
				play <= "001000000000"; -- ef
			end if;
		end if;
		-- 10: Russian Anthem
		if ((sct(0) or not(sct(1))) = '0') then 
			if (cob < 4) and (0 < cob) then
				play <= "000000100000"; -- g
			elsif (cob < 12) then
				play <= "000000000010"; -- co
			elsif (cob < 16) then
				play <= "000000100000"; -- g
			elsif (cob < 20) then
				play <= "000000001000"; -- a
			elsif (cob < 28) then
				play <= "000000000100"; -- b
			elsif (cob < 44) then
				play <= "000100000000"; -- e
			elsif (cob < 48) then
				play <= "000000100000"; -- g
			elsif (cob < 52) then
				play <= "000010000000"; -- f
			elsif (cob < 60) then
				play <= "000000100000"; -- g
			elsif (cob < 64) then
				play <= "100000000000"; -- g
			end if;
		end if;
		-- 11: Romanian Anthem
		if ((sct(0) and (sct(1))) = '1') then 
			if (cob < 6) and (0 < cob) then
				play <= "000100000000"; -- e
			elsif (cob < 8) then
				play <= "000001000000"; -- gf
			elsif (cob < 12) then
				play <= "000000100000"; -- g
			elsif (cob < 16) then
				play <= "000000001000"; -- a
			elsif (cob < 24) then
				play <= "000000000100"; -- b
			elsif (cob < 32) then
				play <= "000100000000"; -- e
			elsif (cob < 38) then
				play <= "000000000010"; -- co
			elsif (cob < 40) then
				play <= "000000000100"; -- b
			elsif (cob < 48) then
				play <= "000000001000"; -- a
			elsif (cob < 54) then
				play <= "000000000001"; -- do
			elsif (cob < 56) then
				play <= "000000000010"; -- co
			elsif (cob < 64) then
				play <= "000000000100"; -- b
			end if;
		end if;
	end if;
end process;

tone <= 
(c and play(11)) or (d and play(10)) or (ef and play(9)) or (e and play(8)) or (f and play(7))
or (gf and play(6)) or (g and play(5)) or (af and play(4)) or (a and play(3)) or (b and play(2)) 
or (co and play(1)) or (do and play(0)); 

end Behavioral;
