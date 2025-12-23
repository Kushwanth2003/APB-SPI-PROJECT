module spi_baud_generator_tb();
 	reg PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i;
	reg [2:0]sppr_i,spr_i;
	reg [1:0]spi_mode_i;
	wire sclk_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o;
	wire [11:0]BaudRateDivisor_o;
 spi_baud_generator dut( PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i,sppr_i,spr_i,spi_mode_i,sclk_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o,BaudRateDivisor_o);
	initial
	begin
		PCLK=1'b0;
		forever #10 PCLK=~PCLK;
	end
	 
	task reset();
		begin
			@(negedge PCLK)
			PRESET_n=1'b0;
			@(negedge PCLK)
			PRESET_n=1'b1;
		end
	endtask
	task t1(input a,b,c,d);
		begin
			cpol_i=a;
			cpha_i=b;
			ss_i=c;
			spiswai_i=d;
		end
	endtask
	
	task t2(input [2:0]e,f,input [1:0]g);
		begin
			sppr_i=e;
			spr_i=f;
			spi_mode_i=g;
		end
	endtask
	initial
	begin
		
	 reset();
	 #30;
		
		t1(0,0,0,0);
		#150;
		t1(0,1,0,0);
		#150;
		t1(1,0,0,0);
		#150;
		t1(1,1,0,0);
		#150;
		t2(3'b001,3'b010,2'b00 );
		#10;
	end
	endmodule

			

