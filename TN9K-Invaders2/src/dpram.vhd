-------------------------------------------------------------------------------
-- $Id: dpram.vhd,v 1.1 2006/02/23 21:46:45 arnim Exp $
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
-------------------------------------------------------------------------------
entity dpram is

generic (
	 addr_width_g : integer := 8;
	 data_width_g : integer := 8
);

port (
	clock_a  : in  std_logic;
	clock_b  : in  std_logic;
	enable_a   : in  std_logic:= '1';
	enable_b   : in  std_logic:= '1';
	wren_a     : in  std_logic:= '0';
	wren_b     : in  std_logic:= '0';
	address_a : in  std_logic_vector(addr_width_g-1 downto 0);
	address_b : in  std_logic_vector(addr_width_g-1 downto 0);
	data_a : in  std_logic_vector(data_width_g-1 downto 0);
	data_b : IN STD_LOGIC_VECTOR (data_width_g-1 DOWNTO 0) := (others => '0');
	q_a : out std_logic_vector(data_width_g-1 downto 0);
	q_b : out std_logic_vector(data_width_g-1 downto 0)
);

end dpram;
-------------------------------------------------------------------------------

architecture rtl of dpram is

  type   ram_t is array (natural range 2**addr_width_g-1 downto 0) of std_logic_vector(data_width_g-1 downto 0);
  signal ram_q : ram_t;

begin

  mem_a: process (clock_a)
  begin
    if rising_edge(clock_a) then
      if wren_a = '1' and enable_a = '1' then
        ram_q(to_integer(unsigned(address_a))) <= data_a;
		  q_a <= data_a;
		else
		  q_a <= ram_q(to_integer(unsigned(address_a)));
      end if;
    end if;
  end process mem_a;

  mem_b: process (clock_b)
  begin
    if rising_edge(clock_b) then
		q_b <= ram_q(to_integer(unsigned(address_b)));
    end if;
  end process mem_b;
-----------------------------------------------------------------------------
end rtl;
