-----------------------------------------------------------
-- Project: Addtree (CPA)
-- File: addtree.vhd
-- Description: Adder tree with CPAs (parametrized)
-- Author: Yuri Gazzoni Rezende
-----------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity addtree is
	generic(n : natural := 4);
	port(A : in std_logic_vector(n-1 downto 0);
		  B : in std_logic_vector(n-1 downto 0);
		  C : in std_logic_vector(n-1 downto 0);
		  D : in std_logic_vector(n-1 downto 0);
		  E : in std_logic_vector(n-1 downto 0);
		  F : in std_logic_vector(n-1 downto 0);
		  G : in std_logic_vector(n-1 downto 0);
		  H : in std_logic_vector(n-1 downto 0);
		  CLK:in std_logic;
		  EN: in std_logic;
		  RST:in std_logic;
		  S : out std_logic_vector(n+2 downto 0)
		  );
end addtree;

architecture tree of addtree is 

component CPAn is generic(n : natural := 4);
	port(A : in std_logic_vector(n-1 downto 0);
		  B : in std_logic_vector(n-1 downto 0);
		  S : out std_logic_vector(n downto 0)
		  );
end component;

component regN is
	generic(n : natural := 4);
	port(Q : in std_logic_vector(n-1 downto 0);
		  CLK : in std_logic;
		  EN: in std_logic;
		  RST: in std_logic;
		  D : out std_logic_vector(n-1 downto 0)
		  );
end component;

signal cpa1_out,cpa2_out,cpa3_out,cpa4_out: std_logic_vector(n downto 0);
signal cpa5_out,cpa6_out: std_logic_vector(n+1 downto 0);
signal cpa7_out: std_logic_vector(n+2 downto 0);

signal deep1_in,deep1_out: std_logic_vector(4*(n+1)-1 downto 0);
signal deep2_in,deep2_out: std_logic_vector(2*(n+2)-1 downto 0);

begin

CPA1: CPAn generic map(n) port map(A,B,cpa1_out);
CPA2: CPAn generic map(n) port map(C,D,cpa2_out);
CPA3: CPAn generic map(n) port map(E,F,cpa3_out);
CPA4: CPAn generic map(n) port map(G,H,cpa4_out);

deep1_in <= cpa1_out & cpa2_out & cpa3_out & cpa4_out;

Reg1: regN generic map(n+1) port map(deep1_in(4*(n+1)-1 downto 3*(n+1)),CLK,EN,RST,deep1_out(4*(n+1)-1 downto 3*(n+1)));
Reg2: regN generic map(n+1) port map(deep1_in(3*(n+1)-1 downto 2*(n+1)),CLK,EN,RST,deep1_out(3*(n+1)-1 downto 2*(n+1)));
Reg3: regN generic map(n+1) port map(deep1_in(2*(n+1)-1 downto (n+1)),CLK,EN,RST,deep1_out(2*(n+1)-1 downto (n+1)));
Reg4: regN generic map(n+1) port map(deep1_in(n downto 0),CLK,EN,RST,deep1_out(n downto 0));

CPA5: CPAn generic map(n+1) port map(deep1_out(4*(n+1)-1 downto 3*(n+1)),deep1_out(3*(n+1)-1 downto 2*(n+1)),cpa5_out);
CPA6: CPAn generic map(n+1) port map(deep1_out(2*(n+1)-1 downto (n+1)),deep1_out(n downto 0),cpa6_out);

deep2_in <= cpa5_out & cpa6_out;

Reg5: regN generic map(n+2) port map(deep2_in(2*(n+2)-1 downto (n+2)),CLK,EN,RST,deep2_out(2*(n+2)-1 downto (n+2)));
Reg6: regN generic map(n+2) port map(deep2_in(n+1 downto 0),CLK,EN,RST,deep2_out(n+1 downto 0));

CPA7: CPAn generic map(n+2) port map(deep2_out(2*(n+2)-1 downto (n+2)),deep2_out(n+1 downto 0),cpa7_out);

S <= cpa7_out;

end tree;