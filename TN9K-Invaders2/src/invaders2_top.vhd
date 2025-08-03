-------------------------------------------------------------------------------
--                     Space Invaders Part II - Tang Nano 9k
--                     For Original Code   (see notes below)
--
--                         Modified for Tang Nano 9k 
--                            by pinballwiz.org 
--                               03/08/2025
-------------------------------------------------------------------------------
-- Space Invaders top level for
-- ps/2 keyboard interface with sound and scan doubler MikeJ
--
-- Version : 0300
--
-- Copyright (c) 2002 Daniel Wallner (jesus@opencores.org)
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.
--
-- The latest version of this file can be found at:
--      http://www.fpgaarcade.com
--
-- Limitations :
--
-- File history :
--
--      0241 : First release
--
--      0242 : Moved the PS/2 interface to ps2kbd.vhd, added the ROM from mw8080.vhd
--
--      0300 : MikeJ tidy up for audio release
------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
------------------------------------------------------------------------------
entity invaders2_top is
	port(
		Clock_27          : in    std_logic;
		I_RESET           : in    std_logic;
        ps2_clk           : in    std_logic;
        ps2_dat           : inout std_logic;
		O_VIDEO_R         : out   std_logic;
		O_VIDEO_G         : out   std_logic;
		O_VIDEO_B         : out   std_logic;
		O_HSYNC           : out   std_logic;
		O_VSYNC           : out   std_logic;
		O_AUDIO_L         : out   std_logic;
		O_AUDIO_R         : out   std_logic;
        led               : out    std_logic_vector(5 downto 0)
		);
end invaders2_top;
------------------------------------------------------------------------------
architecture rtl of invaders2_top is

	signal clock_20        : std_logic;
	signal clock_10        : std_logic;
	signal reset           : std_logic;
	signal Rst_n_s         : std_logic;
    --
	signal RWE_n           : std_logic;
	signal Video           : std_logic;
	signal VideoRGB        : std_logic_vector(2 downto 0);
	signal VideoMUX        : std_logic_vector(2 downto 0);
	signal HSync           : std_logic;
	signal VSync           : std_logic;
	signal CSync           : std_logic;
	signal CSync0          : std_logic;
	signal VideoRGB_x2     : std_logic_vector(7 downto 0);
	signal HSync_x2        : std_logic;
	signal VSync_x2        : std_logic;
	signal scanlines       : std_logic;	
    --	
	signal AD              : std_logic_vector(15 downto 0);
	signal RAB             : std_logic_vector(12 downto 0);
	signal RDB             : std_logic_vector(7 downto 0);
	signal RWD             : std_logic_vector(7 downto 0);
	signal IB              : std_logic_vector(7 downto 0);
	signal SoundCtrl3      : std_logic_vector(5 downto 0);
	signal SoundCtrl5      : std_logic_vector(5 downto 0);
    --
	signal Tick1us         : std_logic;
    --
	signal rom_data_0      : std_logic_vector(7 downto 0);
	signal rom_data_1      : std_logic_vector(7 downto 0);
	signal rom_data_2      : std_logic_vector(7 downto 0);
	signal rom_data_3      : std_logic_vector(7 downto 0);
	signal rom_data_4      : std_logic_vector(7 downto 0);
	signal rom_data_5      : std_logic_vector(7 downto 0);
	signal ram_we          : std_logic;
	--
	signal HCnt            : std_logic_vector(11 downto 0);
	signal VCnt            : std_logic_vector(11 downto 0);
	signal HSync_t1        : std_logic;
	signal hblank          : std_logic;
	signal vblank          : std_logic;
	signal blank           : std_logic;
	signal Overlay_R1      : boolean;
	signal Overlay_G1      : boolean;
	signal Overlay_B1      : boolean;
	signal Overlay_A1      : boolean;
	signal Overlay_C1      : boolean;
	signal Overlay_M1      : boolean;
    --  
    signal kbd_intr        : std_logic;
    signal kbd_scancode    : std_logic_vector(7 downto 0);
    signal joyHBCPPFRLDU   : std_logic_vector(9 downto 0);
    --
	signal GDB0         : std_logic_vector(7 downto 0);
	signal GDB1         : std_logic_vector(7 downto 0);
	signal GDB2         : std_logic_vector(7 downto 0);
    --
	signal Audio 		     : std_logic_vector(7 downto 0);
	signal AudioPWM        : std_logic;
    --
    constant CLOCK_FREQ    : integer := 27E6;
    signal counter_clk     : std_logic_vector(25 downto 0);
    signal clock_4hz       : std_logic;
    signal pll_locked      : std_logic;
---------------------------------------------------------------------------------------------
component Gowin_rPLL
    port (
        clkout: out std_logic;
        lock: out std_logic;
        clkoutd: out std_logic;
        clkin: in std_logic
    );
end component;
----------------------------------------------------------------------------------------------
    begin

    reset <= not I_RESET;
    pll_locked <= '1';
----------------------------------------------------------------------------------------------
clocks: Gowin_rPLL
    port map (
        clkout => clock_20,
        lock => pll_locked,
        clkoutd => clock_10,
        clkin => clock_27
    );
----------------------------------------------------------------------------------------------
	core : entity work.invaderst
		port map(
			Rst_n      => I_RESET,
			Clk        => Clock_10,
			GDB0	   => GDB0,
			GDB1	   => GDB1,
			GDB2	   => GDB2,
			RDB        => RDB,
			IB         => IB,
			RWD        => RWD,
			RAB        => RAB,
			AD         => AD,
			SoundCtrl3 => SoundCtrl3,
			SoundCtrl5 => SoundCtrl5,
			Rst_n_s    => Rst_n_s,
			RWE_n      => RWE_n,
			Video      => Video,
			HSync      => HSync,
			VSync      => VSync
			);
----------------------------------------------------------------------------------------------
-- Roms

	u_rom_h : entity work.INVADERS_ROM_H
	  port map (
		CLK         => Clock_10,
		ADDR        => AD(10 downto 0),
		DATA        => rom_data_0
		);
	--
	u_rom_g : entity work.INVADERS_ROM_G
	  port map (
		CLK         => Clock_10,
		ADDR        => AD(10 downto 0),
		DATA        => rom_data_1
		);
	--
	u_rom_f : entity work.INVADERS_ROM_F
	  port map (
		CLK         => Clock_10,
		ADDR        => AD(10 downto 0),
		DATA        => rom_data_2
		);
	--
	u_rom_e : entity work.INVADERS_ROM_E
	  port map (
		CLK         => Clock_10,
		ADDR        => AD(10 downto 0),
		DATA        => rom_data_3
		);
	--
	u_rom_d : entity work.INVADERS_ROM_D
	  port map (
		CLK         => Clock_10,
		ADDR        => AD(10 downto 0),
		DATA        => rom_data_4
		);
	--
	p_rom_data : process(AD, rom_data_0, rom_data_1, rom_data_2, rom_data_3)
	begin
	  IB <= (others => '0');
	  if  AD(14) = '0' then
	   case AD(12 downto 11) is
	 	 when "00" => IB <= rom_data_0;
		 when "01" => IB <= rom_data_1;
		 when "10" => IB <= rom_data_2;
		 when "11" => IB <= rom_data_3;
		 when others => null;
	   end case;
	  else
     	IB <= rom_data_4;
     end if;	  	  
	end process;
----------------------------------------------------------------------------------------------
-- Ram

	ram_we <= not RWE_n;

	rams : for i in 0 to 3 generate

u_ram : entity work.gen_ram generic map (2,13)
port map (
		q   => RDB((i*2)+1 downto (i*2)),
		addr => RAB,
		clk  => Clock_10,
		d   => RWD((i*2)+1 downto (i*2)),
		we   => ram_we   
);
	end generate;
---------------------------------------------------------------------------------------------
-- Glue

	process (Rst_n_s, Clock_10)
		variable cnt : unsigned(3 downto 0);
	begin
		if Rst_n_s = '0' then
			cnt := "0000";
			Tick1us <= '0';
		elsif Clock_10'event and Clock_10 = '1' then
			Tick1us <= '0';
			if cnt = 9 then
				Tick1us <= '1';
				cnt := "0000";
			else
				cnt := cnt + 1;
			end if;
		end if;
	end process;
-----------------------------------------------------------------------------------------
-- scanlines control

	process (Rst_n_s, Clock_10)
       begin
        if joyHBCPPFRLDU(0) = '1' then scanlines <= '0'; end if; --up arrow
        if joyHBCPPFRLDU(1) = '1' then scanlines <= '1'; end if; --down arrow
	end process;
--------------------------------------------------------------------------------------------	
  p_overlay : process(Rst_n_s, Clock_10)
	variable HStart : boolean;
  begin
	if Rst_n_s = '0' then
	  HCnt <= (others => '0');
	  VCnt <= (others => '0');
	  HSync_t1 <= '0';
	elsif Clock_10'event and Clock_10 = '1' then
	  HSync_t1 <= HSync;
	  HStart := (HSync_t1 = '0') and (HSync = '1');-- rising

	  if HStart then
		HCnt <= (others => '0');
	  else
		HCnt <= HCnt + "1";
	  end if;

	  if (VSync = '0') then
		VCnt <= (others => '0');
	  elsif HStart then
		VCnt <= VCnt + "1";
	  end if;
	  
	--blank
	  if    (HCnt = x"14")  then vblank <= '0'; --14   VBLANK ends at V = 0
	  elsif (HCnt = x"216") then vblank <= '1'; --216  VBLANK begins at V = 224 (0x0e0)
	  end if;

	  if    (VCnt = x"7E")  then hblank <= '0'; --7e  HBLANK ends at H = 0
	  elsif (VCnt = x"1FC") then hblank <= '1'; --1fc HBLANK begins at H = 256 (0x100)
	  end if;
		
	  blank <= not (hblank or vblank);
     
	  -- csync 
	  if     Vcnt = x"0"  then csync0 <= '0';  --              HSYNC begins at H = 272 (0x110)
	  elsif  Vcnt = x"9"  then csync0 <= '1';  --1b ok:9       HSYNC ends at H = 288 (0x120)
	  end if;
	  
	  if     Hcnt < x"2c" then csync <='0'; --   VSYNC begins at V = 236 (0x0ec)
	                      else csync <= csync0;                           -- VSYNC ends at V = 240 (0x0f0)
	  end if;
	  
	  --Overlay
	  Overlay_R1 <= false;
	  Overlay_G1 <= false;
	  Overlay_B1 <= false;
	  Overlay_A1 <= false;
	  Overlay_C1 <= false;
	  Overlay_M1 <= false;
    if (SoundCtrl3(2)='1') then
	  Overlay_R1 <= true; 
	 else 
		if (HCnt > x"035" and HCnt < x"046" ) then 
		  if (Vcnt > x"0" and Vcnt < x"1F") then Overlay_A1 <= true; elsif (Vcnt > x"96" and Vcnt < x"C6") then Overlay_M1 <= true; else Overlay_C1 <= true; end if; --if (Vcnt > x"C6" and Vcnt < x"D6") then Overlay_M1 <= false; else Overlay_M1 <= true; end if;
		end if;

		if (HCnt > x"045" and HCnt < x"056" ) then
		  Overlay_R1 <= true; 
		end if;

	  if (HCnt > x"055" and HCnt < x"076") then
		Overlay_C1 <= true; 
	  end if;

	  if (HCnt > x"075" and HCnt < x"0A6") then 
		Overlay_R1 <= true; 
	  end if;

	  if (HCnt > x"0A5" and HCnt < x"0E6") then 
		Overlay_A1 <= true; 
	  end if;

	  if (HCnt > x"0E5" and HCnt < x"126") then --MAGENTA
		Overlay_M1 <= true;
	  end if;

	  if (HCnt > x"125" and HCnt < x"166") then --CYAN
		Overlay_C1 <= true;
	  end if;

	  if (HCnt > x"165" and HCnt < x"1A6") then 
		Overlay_G1 <= true;
	  end if;

	  if (HCnt > x"1A5" and HCnt < x"1D6") then --MAGENTA
		Overlay_M1 <= true;
	  end if;

	  if (HCnt > x"1D5" and HCnt < x"1E6") then 
		Overlay_R1 <= true;
	  end if;

	  if (HCnt > x"1E5" and HCnt < x"1F6") then 
		if (Vcnt > x"60" and Vcnt < x"A0") then Overlay_G1 <= true; elsif (Vcnt > x"A0" and Vcnt < x"F1") then Overlay_A1 <= true; end if;
	  end if;
	
	  if (HCnt > x"205" and HCnt < x"216") then 
	  if (Vcnt > x"0" and Vcnt < x"60") then Overlay_C1 <= true; elsif (Vcnt > x"60" and Vcnt < x"A0") then Overlay_R1 <= true; else Overlay_A1 <= true; end if;
	  end if;
	  
   end if; 
  end if;
 end process;
--------------------------------------------------------------------------------
  p_video_out_comb : process(Video)
  begin
	if (Video = '0') then
	  VideoRGB  <= "000";
	else
	  if    Overlay_R1 then
		VideoRGB  <= "100";
	  elsif Overlay_G1 then
		VideoRGB  <= "010";
	  elsif Overlay_B1 then
		VideoRGB  <= "001";
  	  elsif Overlay_A1 then
		VideoRGB  <= "110";
  	  elsif Overlay_C1 then
		VideoRGB  <= "011";
  	  elsif Overlay_M1 then
		VideoRGB  <= "101";
	  else
		VideoRGB  <= "111";
	  end if;
	end if;
  end process;
--------------------------------------------------------------------------------
  u_dblscan : entity work.DBLSCAN
	port map (
	  RGB_IN(7 downto 3) => "00000",
	  RGB_IN(2 downto 0) => VideoRGB,
	  HSYNC_IN           => HSync,
	  VSYNC_IN           => VSync,

	  RGB_OUT            => VideoRGB_X2,
	  HSYNC_OUT          => HSync_X2,
	  VSYNC_OUT          => VSync_X2,
	  --  NOTE CLOCKS MUST BE PHASE LOCKED !!
	  CLK                => Clock_10,
	  CLK_X2             => Clock_20,
	  scanlines			 => scanlines
	);
---------------------------------------------------------------------------------
  O_VIDEO_R <= VideoRGB_X2(2);
  O_VIDEO_G <= VideoRGB_X2(1);
  O_VIDEO_B <= VideoRGB_X2(0);
  O_HSYNC   <= not HSync_X2;
  O_VSYNC   <= not VSync_X2;
---------------------------------------------------------------------------------
-- get scancode from keyboard

keyboard : entity work.io_ps2_keyboard
port map (
  clk       => Clock_10, -- use same clock as main core
  kbd_clk   => ps2_clk,
  kbd_dat   => ps2_dat,
  interrupt => kbd_intr,
  scancode  => kbd_scancode
);
---------------------------------------------------------------------------------
-- translate scancode to joystick

joystick : entity work.kbd_joystick
port map (
  clk          => Clock_10, -- use same clock as main core
  kbdint       => kbd_intr,
  kbdscancode  => std_logic_vector(kbd_scancode), 
  joyHBCPPFRLDU => joyHBCPPFRLDU
);
---------------------------------------------------------------------------------
input_registers : process
  begin
   wait until rising_edge(Clock_10);
	GDB0(0) <= '0'; -- Unused ?
	GDB0(1) <= '0';
	GDB0(2) <= '0'; -- Unused ?
	GDB0(3) <= '0'; -- Unused ?
	GDB0(4) <= '0'; --Fire p?
	GDB0(5) <= '0'; --left p?
	GDB0(6) <= '1'; --right p?
	GDB0(7) <= '0'; -- Unused ?

	GDB1(0) <= not joyHBCPPFRLDU(7);  -- Coin 1 - Active High !
	GDB1(1) <= joyHBCPPFRLDU(6); --start p2
	GDB1(2) <= joyHBCPPFRLDU(5); --start p1
	GDB1(3) <= '0';           -- Unused ?
	GDB1(4) <= joyHBCPPFRLDU(4); -- Fire p1 - Active Low
	GDB1(5) <= joyHBCPPFRLDU(2); -- MoveLeft p1 - Active Low
	GDB1(6) <= joyHBCPPFRLDU(3); -- MoveRight p1 - Active Low
	GDB1(7) <= '1';           -- Unused ?

	GDB2(0) <= '0';  -- LSB Lives 3-6
	GDB2(1) <= '0';  -- MSB Lives 3-6
	GDB2(2) <= '0';  -- Tilt
	GDB2(3) <= '0';  -- Bonus life at 1000 or 1500
	GDB2(4) <= joyHBCPPFRLDU(4); -- Fire p2 - Active Low
	GDB2(5) <= joyHBCPPFRLDU(2); -- MoveRight p2 - Active Low
	GDB2(6) <= joyHBCPPFRLDU(3); -- MoveLeft p2 - Active Low
	GDB2(7) <= '0';  -- Coin info
  end process;
---------------------------------------------------------------------------------
-- Audio

  u_audio : entity work.invaders_audio
	port map (
	  Clk => Clock_10,
	  P3  => SoundCtrl3,
	  P5  => SoundCtrl5,
	  Aud => Audio
	  );
---------------------------------------------------------------------------------
  u_dac : entity work.dac
	generic map(
	  msbi_g => 7
	)
	port  map(
	  clk_i   => Clock_10,
	  res_n_i => Rst_n_s,
	  dac_i   => Audio,
	  dac_o   => AudioPWM
	);

  O_AUDIO_L <= AudioPWM;
  O_AUDIO_R <= AudioPWM;
---------------------------------------------------------------------------------
-- debug

process(reset, clock_27)
begin
  if reset = '1' then
    clock_4hz <= '0';
    counter_clk <= (others => '0');
  else
    if rising_edge(clock_27) then
      if counter_clk = CLOCK_FREQ/8 then
        counter_clk <= (others => '0');
        clock_4hz <= not clock_4hz;
        led(5 downto 0) <= not AD(9 downto 4);
      else
        counter_clk <= counter_clk + 1;
      end if;
    end if;
  end if;
end process;
----------------------------------------------------------------------------------
end;