library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CPAn is
	generic(n : natural := 4);
	port(A : in std_logic_vector(n-1 downto 0);
		  B : in std_logic_vector(n-1 downto 0);
		  S : out std_logic_vector(n downto 0)
		  );
end CPAn;

architecture adder of CPAn is

component fulladder is port
	(A : in STD_LOGIC;
	B : in STD_LOGIC;
	Cin : in STD_LOGIC;
	S : out STD_LOGIC;
	Cout : out STD_LOGIC);
end component;

signal c_intermed: std_logic_vector(n downto 0);

begin

FA_Structure: for i in A'range generate
	FAi: fulladder port map(A(i),B(i),c_intermed(i),S(i),c_intermed(i+1));
end generate FA_Structure;

c_intermed(0) <= '0';
S(n) <= c_intermed(n);

end adder;