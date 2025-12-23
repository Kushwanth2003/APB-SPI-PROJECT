module spi_slave_select (
    input        PRESET_n,
    input  [1:0] spi_mode_i,
    input        mstr_i,
    input        spiswai_i,
    input        PCLK,
    input        send_data_i,
    input  [11:0] BaudRateDivisor_i,
    output reg   ss_o,
    output reg   receive_data_o,
    output       tip_o);

    reg [15:0] count_s;
 wire    [15:0] target_s;
    reg rcv_s;

    assign tip_o = ~ss_o;
	 assign target_s = (BaudRateDivisor_i/2)*16;
   

    always @(posedge PCLK or negedge PRESET_n) 
	 begin
        if (!PRESET_n) 
		  begin
            count_s <= 16'hFFFF;
            ss_o    <= 1'b1;
            rcv_s   <= 1'b0;
        end 
		  else if (mstr_i && ((spi_mode_i == 2'b00) || ((spi_mode_i == 2'b01) && !spiswai_i))) 
		  begin
            if (send_data_i) 
				begin
                ss_o    <= 1'b0;
                count_s <= 16'd0;
                rcv_s   <= 1'b0;
					 //rcv_s <= rcv_s;
            end else if (count_s <= target_s - 1)
				begin
                ss_o    <= 1'b0;
                count_s <= count_s + 1'b1;
            if (count_s == target_s - 1)
                    rcv_s <= 1'b1;
            end
				else 
				begin
                ss_o    <= 1'b1;
                rcv_s   <= 1'b0;
                count_s <= 16'hFFFF;
            end
        end else begin
            ss_o    <= 1'b1;
            rcv_s   <= 1'b0;
            count_s <= 16'hFFFF;
        end
    end
always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
			receive_data_o<=1'b0;
		else
			receive_data_o<=rcv_s;
	end
	endmodule


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


	
		

