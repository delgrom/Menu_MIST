module neptuno2_top (
	input         CLOCK_50,
	//input         KEY0,
	//input         KEY1,
	output        LED           = 1'b1, // '0' is LED on,

	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,

	input         SPI_SCK,
	inout         SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,    // data_io
	input         SPI_SS3,    // OSD
	input         CONF_DATA0, // SPI_SS for user_io
	input         SPI_SS4,

	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE,

	output        AUDIO_L,
	output        AUDIO_R,

	output        I2S_BCK,
	output        I2S_LRCK,
	output        I2S_DATA,

	//joystick reflection
	input        JOY_XCLK,
	input        JOY_XLOAD,
	output       JOY_XDATA,	

	// db9 joystick
	output        JOY_CLK       = 1'b1,
	output        JOY_LOAD      = 1'b1,
	input         JOY_DATA,
	output        JOY_SELECT    = 1'b1,		
	
`ifdef USE_AUDIO_IN
	input         AUDIO_IN,
`endif
	input         UART_RX,
	output        UART_TX,

	input         SD_SCK,		//SD_SCK is being driven by middleboard
	input         SD_MISO
);


MENU guest
 (
 .CLOCK_27 	(CLOCK_27),
 .LED       (LED),	
 .SDRAM_DQ	 (SDRAM_DQ),	
 .SDRAM_A	 (SDRAM_A),
 .SDRAM_DQML (SDRAM_DQML),
 .SDRAM_DQMH (SDRAM_DQMH),
 .SDRAM_nWE	 (SDRAM_nWE),
 .SDRAM_nCAS (SDRAM_nCAS),
 .SDRAM_nRAS (SDRAM_nRAS),
 .SDRAM_nCS	 (SDRAM_nCS),
 .SDRAM_BA	 (SDRAM_BA),
 .SDRAM_CLK	 (SDRAM_CLK),
 .SDRAM_CKE	 (SDRAM_CKE),
		 			
 .SPI_DO	 (spi_do_int),
 .SPI_DI	 (SPI_DI),
 .SPI_SCK	 (SPI_SS4 ? SPI_SCK : SD_SCK),
 .SPI_SS2	 (SPI_SS2),
 .SPI_SS3	 (SPI_SS3),
 .SPI_SS4	 (SPI_SS4),
 .CONF_DATA0 (CONF_DATA0),

 // AUDIO
 .AUDIO_L    (AUDIO_L),
 .AUDIO_R    (AUDIO_R),
 .I2S_BCK	 (I2S_BCK),
 .I2S_LRCK	 (I2S_LRCK),
 .I2S_DATA	 (I2S_DATA),

 .VGA_HS	 (VGA_HS),
 .VGA_VS	 (VGA_VS),
 .VGA_R	 	 (VGA_R),
 .VGA_G		 (VGA_G),
 .VGA_B		 (VGA_B),
`ifdef USE_AUDIO_IN
 .AUDIO_IN   (AUDIO_IN),
`endif
 .UART_RX	 (UART_RX),	
 .UART_TX	 (UART_TX) 
);

// direct upload fix
wire spi_do_int;
assign spi_do_int = SPI_SS4 ? 1'bz : SD_MISO;
assign SPI_DO = spi_do_int;

// JAMMA interface
reg joy_select = 1'b1;
always @(posedge JOY_XLOAD) begin
	joy_select <= ~joy_select | ~JOY_XCLK;
end

assign JOY_CLK = JOY_XCLK;
assign JOY_LOAD = JOY_XLOAD;
assign JOY_XDATA = JOY_DATA;
assign JOY_SELECT = joy_select;


wire CLOCK_27;
wire pll_lock;
clk50to27 u_pll_50_27 (
	.inclk0 ( CLOCK_50 ),
	.c0     ( CLOCK_27 ),
	.locked ( pll_lock )
);

endmodule
