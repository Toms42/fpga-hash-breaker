module testbench();

reg clk = 0;
reg[447:0] message = "test";
wire[63:0] len;

wire[7:0] state;
wire[127:0] hash;
wire [511:0] message_out;

md5core hasher(
	.message(message),
	.length(len),
	.clk(clk),
	.hash(hash),
	.message_out(message_out)
);

reg initiate=0;
reg program=0;

parameter[8*127-1:0] charlist_example="abcdefghijklmnopqrstuvwxyz1234567890";
reg[25*8*127-1:0] prg_format={25{charlist_example}};


generator phrase_gen(
	.clk(clk),
	.initiate(initiate),
	.program(program),
	.prg_format(prg_format),
	.prg_num_characters(8'd36),
	.prg_len(8'd5),
	.prg_h_goal("test"),
	.h_res(hash),
	.m(m),
	.m_len(len),
	.state(state)
);

reg[7:0] count=0;
reg[7:0] count2=0;
always begin
	#1 clk = !clk;
	if(clk==1)
	begin
		if(count==1)
		begin
			program<=1;
		end
		else if(count==3)
		begin
			program<=0;
		end
		else if(count==5)
		begin
			initiate<=1;
		end
		else if(count==6)
		begin
			initiate<=0;
		end
	count<=count+1;
	end
end

initial begin
	$display("simulation started!");
	$dumpfile("hash_test.vcd");
	$dumpvars;
	#150 $finish;
end

endmodule