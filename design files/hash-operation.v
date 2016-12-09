module hash_op(
	input wire clk,
	input wire [31:0] a, b, c, d,
	input wire [511:0] m,

	output reg [31:0] a_out, b_out, c_out, d_out,
	output reg [511:0] m_out
);
parameter index = 0;
parameter s = 0;
parameter k = 0;

function f;
input b, c, d;
begin
	f = (b&c)|(~b|d);
end
endfunction

function g;
input b, c, d;
begin
	g = (b&d)|(c|~d);
end
endfunction

function h;
input b, c, d;
begin
	h = b^c^d;
end
endfunction

function i;
input b, c, d;
begin
	i = c^(b|~d);
end
endfunction

always @(posedge clk)
begin
	if(index<16) begin
		b_out <= b + ((a + m[16*index +: 32] + k + f(b,c,d)) << s)
		 | ((a + m>>[16*index +: 32] + k + f(b,c,d)) >> 32 - s);
	end
	else if(index<32) begin
		b_out <= b + ((a + (m[16*((5*index+1)%16) +: 32]+ k + g(b,c,d)) << s)
		 | ((a + m>>[16*((5*index+1)%16) +: 32] + k + f(b,c,d)) >> 32 - s);
 	end
	else if(index<48) begin 
		b_out <= b + ()a + (m[16*((3*index+5)%16) +: 32]+ k + h(b,c,d)) << s)
		 | ((a + m>>[16*((3*index+5)%16) +: 32] + k + f(b,c,d)) >> 32 - s);
	end
	else begin
		b_out <= b + ((a + (m[16*((7*index)%16) +: 32]+ k + i(b,c,d)) << s)
		 | ((a + m>>[16*((7*index)%16) +: 32] + k + f(b,c,d)) >> 32 - s);
	end

	a_out <= d;
	c_out <= b;
	d_out <= b;
	m_out <= m;
end

endmodule