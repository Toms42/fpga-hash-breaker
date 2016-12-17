//`define REVERSE_BYTES_64(__IN) ({__IN[7:0],__IN[15:8],__IN[23:16],__IN[31:24],__IN[39:33],__IN[47:34],__IN[55:48],__IN[63:56]})

module md5core(
	//input wire clk,
	input wire [447:0] message,
	input wire [63:0] length,
	input wire clk,

	output reg [127:0] hash,
	output reg [511:0] message_out
);

localparam [32*64-1:0] k = {
32'hd76aa478, 32'he8c7b756, 32'h242070db, 32'hc1bdceee,
32'hf57c0faf, 32'h4787c62a, 32'ha8304613, 32'hfd469501,
32'h698098d8, 32'h8b44f7af, 32'hffff5bb1, 32'h895cd7be,
32'h6b901122, 32'hfd987193, 32'ha679438e, 32'h49b40821,
32'hf61e2562, 32'hc040b340, 32'h265e5a51, 32'he9b6c7aa,
32'hd62f105d, 32'h02441453, 32'hd8a1e681, 32'he7d3fbc8,
32'h21e1cde6, 32'hc33707d6, 32'hf4d50d87, 32'h455a14ed,
32'ha9e3e905, 32'hfcefa3f8, 32'h676f02d9, 32'h8d2a4c8a,
32'hfffa3942, 32'h8771f681, 32'h6d9d6122, 32'hfde5380c,
32'ha4beea44, 32'h4bdecfa9, 32'hf6bb4b60, 32'hbebfbc70,
32'h289b7ec6, 32'heaa127fa, 32'hd4ef3085, 32'h04881d05,
32'hd9d4d039, 32'he6db99e5, 32'h1fa27cf8, 32'hc4ac5665,
32'hf4292244, 32'h432aff97, 32'hab9423a7, 32'hfc93a039,
32'h655b59c3, 32'h8f0ccc92, 32'hffeff47d, 32'h85845dd1,
32'h6fa87e4f, 32'hfe2ce6e0, 32'ha3014314, 32'h4e0811a1,
32'hf7537e82, 32'hbd3af235, 32'h2ad7d2bb, 32'heb86d391
};

localparam [64*5-1:0] s = {
5'd7, 5'd12, 5'd17, 5'd22,  5'd7, 5'd12, 5'd17, 5'd22,  5'd7, 5'd12, 5'd17, 5'd22,  5'd7, 5'd12, 5'd17, 5'd22,
5'd5,  5'd9, 5'd14, 5'd20,  5'd5, 5'd9,  5'd14, 5'd20,  5'd5, 5'd9,  5'd14, 5'd20,  5'd5, 5'd9,  5'd14, 5'd20,
5'd4, 5'd11, 5'd16, 5'd23,  5'd4, 5'd11, 5'd16, 5'd23,  5'd4, 5'd11, 5'd16, 5'd23,  5'd4, 5'd11, 5'd16, 5'd23,
5'd6, 5'd10, 5'd15, 5'd21,  5'd6, 5'd10, 5'd15, 5'd21,  5'd6, 5'd10, 5'd15, 5'd21,  5'd6, 5'd10, 5'd15, 5'd21
};


wire[31:0] bl_a [0:64];
wire[31:0] bl_b [0:64];
wire[31:0] bl_c [0:64];
wire[31:0] bl_d [0:64];
wire[511:0] bl_m [0:64];

reg[511:0] message_padded=0;

parameter[31:0] a_initial = 32'h67452301;
parameter[31:0] b_initial = 32'hefcdab89;
parameter[31:0] c_initial = 32'h98badcfe;
parameter[31:0] d_initial = 32'h10325476;

hash_op #(
		.k(k[63*32 +: 32]),
		.s(s[63*5 +: 5]),
		.index(0))

	hash_op_0(
		.clk(clk),
		.a(a_initial),
		.b(b_initial),
		.c(c_initial),
		.d(d_initial),
		.m(message_padded),
		.a_out(bl_a[1]),
		.b_out(bl_b[1]),
		.c_out(bl_c[1]),
		.d_out(bl_d[1]),
		.m_out(bl_m[1])
	);

generate
	genvar i, s_current;
		for(i = 1; i<64; i=i+1)
		begin : generate_hash_ops
			hash_op #(
					.k(k[(63-i)*32 +: 32]),
					.s(s[(63-i)*5 +: 5]),
					.index(i))

				hash_op_i(
					.clk(clk),
					.a(bl_a[i]),
					.b(bl_b[i]),
					.c(bl_c[i]),
					.d(bl_d[i]),
					.m(bl_m[i]),
					.a_out(bl_a[i+1]),
					.b_out(bl_b[i+1]),
					.c_out(bl_c[i+1]),
					.d_out(bl_d[i+1]),
					.m_out(bl_m[i+1])
				);
		end
endgenerate

function[511:0] pad_message;
	input[447:0] m;
	input[63:0] l;
	begin
		pad_message = {m<<(448-l)
			|1'b1<<(448-l-1),
			l[7:0],
			l[15:8],
			l[23:16],
			l[31:24],
			l[39:32],
			l[47:40],
			l[55:48],
			l[63:56]
			};
	end
endfunction

//testbench stuff:
always @(posedge clk)
begin
	message_padded <= pad_message(message,length);
	hash <= {bl_a[64],bl_b[64],bl_c[64],bl_d[64]};
	message_out <=bl_m[64];
end
endmodule