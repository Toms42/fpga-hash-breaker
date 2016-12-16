module testbench();

reg clk = 0;
reg[511:0] message = "test";

wire[127:0] hash;
wire [511:0] message_out;

md5core hasher(
	.message(message),
	.length(64'd32),
	.clk(clk),
	.hash(hash),
	.message_out(message_out)
);

reg[7:0] count=0;
reg[7:0] count2=0;
always begin
	#1 clk = !clk;
	if(clk==1)
	begin
		if(count==66 || count==65)
		begin
			$display("hash=%x for message=%x",hash,message_out);

			for(count2=0;count2<64;count2=count2+1)
			begin
				$display("\t%d | %x",count2,message_out[(512-8-count2*8)+:8]);
			end
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