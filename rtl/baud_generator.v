module spi_baud_generator(input PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i,
			input [2:0]sppr_i,spr_i,			  
			input [1:0]spi_mode_i,
			output reg sclk_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o, 
		        output  [11:0]BaudRateDivisor_o);
	reg [11:0]count_s;
	wire pre_sclk_s;
	//parameter run=2'b00,wai=2'b01,stop=2'b10;
	assign BaudRateDivisor_o=(sppr_i+1)*(2**(spr_i+1));
	assign pre_sclk_s=(cpol_i)? 1'b1:1'b0;
	//Generate SPI Clock
   always@(posedge PCLK or negedge PRESET_n)
	begin
	  if (!PRESET_n)
	  
	  begin
			count_s<=12'b0;
			sclk_o<=pre_sclk_s;
			end
		else if(!ss_i && !spiswai_i && (spi_mode_i==2'b00 ||spi_mode_i==2'b01))
		begin
	     	 if(count_s==BaudRateDivisor_o/2-1)
	       begin
		     		 sclk_o<=~sclk_o;
		     		 count_s<=12'b0;
	        	end
			  else
				count_s<=count_s+12'b1;
	end
	else
      	  begin
		sclk_o<=pre_sclk_s;
		count_s<=12'b0;
	  end
     end
	  //Generate MISO Sample Flags
always@(posedge PCLK or negedge PRESET_n)
 begin
	if(!PRESET_n)
	  begin
		miso_receive_sclk_o<=1'b0;
		miso_receive_sclk0_o<=1'b0;
	  end

		else if((!cpha_i &&cpol_i) || (cpha_i && !cpol_i))
		 begin
     		  if(sclk_o && count_s==BaudRateDivisor_o/2-1)
	
					miso_receive_sclk0_o<=1'b1;
				else
                 miso_receive_sclk0_o<=1'b0;
 	 end

	  else if((!cpha_i && !cpol_i) || (cpha_i && cpol_i))
	    begin
			if(!sclk_o && count_s==BaudRateDivisor_o/2-1)
	   	 
		       miso_receive_sclk_o<=1'b1;	
		else
			miso_receive_sclk_o<=1'b0;
		end
		else
			begin
		miso_receive_sclk_o<=1'b0;
		miso_receive_sclk0_o<=1'b0;
	  end
		
end
	
//Generate MOSI Sample Flags
always@(posedge PCLK or negedge PRESET_n)
begin
	if(!PRESET_n)
	begin
		mosi_send_sclk_o<=1'b0;
		mosi_send_sclk0_o<=1'b0;
	end
	else if((!cpha_i && cpol_i)||(cpha_i && !cpol_i))
			begin
			 if(sclk_o && count_s==BaudRateDivisor_o/2-2)
					mosi_send_sclk0_o<=1'b1;
				else
					mosi_send_sclk0_o<=1'b0;
			end
			else if((!cpha_i &&!cpol_i)||(cpha_i && cpol_i))
			begin
				if(!sclk_o && count_s==BaudRateDivisor_o/2-2)
						mosi_send_sclk_o<=1'b1;
					else
						mosi_send_sclk_o<=1'b0;
				end
				else
				begin
					mosi_send_sclk_o<=1'b0;
					mosi_send_sclk0_o<=1'b0;
				end
end
endmodule
