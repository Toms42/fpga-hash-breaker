module testbench();

reg clk = 0;
reg[63:0] message = "test";

wire[127:0] hash;
wire [511:0] message_out;

md5core hasher(
	.message(message),
	.length(64'd32),
	.clk(clk),
	.hash(hash),
	.message_out(message_out)
);

always begin
	#1 clk = !clk;
	if(clk==1)
	begin
		$display("hash=%x for message=%x",hash,message_out);
	end
end

initial begin
	$dumpfile("hash_test.vcd");
	$dumpvars;
	#150 $stop;
end

endmodule