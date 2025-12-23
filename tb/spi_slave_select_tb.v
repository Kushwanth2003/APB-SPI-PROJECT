module spi_slave_selecttb ();
    reg        PRESET_n;
    reg        mstr_i;
	 reg  [1:0] spi_mode_i;
    reg       spiswai_i;
    reg        PCLK;
    reg       send_data_i;
    reg  [11:0] BaudRateDivisor_i;
    wire   ss_o;
    wire   receive_data_o;
    wire      tip_o;
spi_slave_select DUT(PRESET_n,spi_mode_i,mstr_i,spiswai_i,PCLK,send_data_i,BaudRateDivisor_i,ss_o,receive_data_o,tip_o);
initial
begin
	PCLK=1'b0;
	forever
	#5 PCLK=~PCLK;
	end
	
task reset_in();
	begin
	@(negedge PCLK)
	PRESET_n=1'b0;
	@(negedge PCLK)
	PRESET_n=1'b1;
        end
endtask
/*task init();
	begin
		{PRESET_n,spi_mode_i,mstr_i,spiswai_i,send_data_i,BaudRateDivisor_i}=0;
	end
endtask*/
task data(input[1:0]i,input[11:0]j,input k,l,m);
begin
	@(negedge PCLK)
    spi_mode_i=i;
	 BaudRateDivisor_i=j;
    mstr_i=k;
    spiswai_i=l;
    send_data_i=m;
	 
end
endtask

initial 
begin
reset_in;
 data(2'b00,16'd8,1'b1,1'b0,1'b1);
 #80;
 data(2'b00,16'd8,1'b1,1'b0,1'b0);

end
initial
#1000 $finish; 
endmodule	
