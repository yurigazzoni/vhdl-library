library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity regN is
	generic(n : natural := 4);
	port(Q : in std_logic_vector(n-1 downto 0);
		  CLK : in std_logic;
		  EN: in std_logic;
		  RST: in std_logic;
		  D : out std_logic_vector(n-1 downto 0)
		  );
end regN;

architecture circ of regN is

begin

regproc: process(CLK,RST,EN)
	begin
	if(RST = '1') then
		D <= (others => '0');
	elsif(CLK'event AND CLK = '1') then
		if(EN = '1') then
			D <= Q;
		end if;
	end if;
end process regproc;

end circ;