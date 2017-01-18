module character_counter(
	input wire count,

	input wire carry_in,
	input wire[7:0] prg_numchars,
	input wire[8*127-1:0] prg_charlist,
	input wire enable,

	input wire program,

	output reg carry_out,

	output reg[7:0] char
	);

reg[7:0] counter=0;
reg[7:0] numchars =0;
reg[8*127:0] charlist;

always @(posedge count)
begin
	if(program==1'b1)
	begin
		counter<=0;
		numchars<=prg_numchars;
		charlist<=prg_charlist;
	end
	else begin
		if(enable==1'b1)
		begin
			char<=charlist[counter*8+:8];
		end
		else begin
			char<=8'd0;
		end
	end
end

always @(negedge count)
begin
	if(carry_in==1'b1)
	begin
		counter<=counter+1;
	end

	if(counter==numchars)
	begin
		carry_out<=1'b1;
		counter<=0;
	end
	else begin
		carry_out<=1'b0;
	end
end

endmodule