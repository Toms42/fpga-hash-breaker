`define STATE_PROGRAMMING 0
`define STATE_RUNNING 1
`define STATE_SUCCESS 2
`define STATE_IDLE 3
`define STATE_START 4

module generator(
	input wire clk,

	input wire initiate,

	input wire program,
	input wire[25*8*127-1:0] prg_format,
	input wire[7:0] prg_num_characters,
	input wire[7:0] prg_len,
	input wire[127:0] prg_h_goal,

	input wire[127:0] h_success,
	input wire[511:0] m_success,

	output reg[447:0] m,
	output reg[63:0] m_len,
	output reg[7:0] state
	);

reg[25*8*127-1:0] format;
reg[25*8-1:0] lengths;

reg[7:0] len = 0;
reg[7:0] num_characters = 0;

reg[7:0] state=`STATE_IDLE;

wire count;
assign count = state==`STATE_START ? clk : 0;

wire carry_array[0:25];
reg enable_array[0:25];

reg programming=0;

generate
	genvar i;
		for(i=0;i<25;i=i+1)
		begin : generate_char_generators
			character_counter(
				.count(count),
				.carry_in(carry_array[i]),
				.carry_out(carry_array[i+1]),
				.prg_num_chars(lengths[i*8+:8]),
				.prg_charlist(format[i*8*127+:8*127]),
				.enable(enable_array[i]),
				.program(programming),
				.char(m[8*i+:8])
			);
		end

endgenerate

reg[4:0] i=0;

always @(posedge clk)
begin
	case state
	begin

		`STATE_PROGRAMMING: 
		begin
			format<=prg_format;
			len<=prg_len;
			num_characters<=prg_num_characters;

			enable_array<=0;

			for(i=0;i<num_characters;i++)
			begin
				enable_array[i+1]=1'b1
			end

			state<=`STATE_IDLE;

		end

		`STATE_IDLE:
		begin
			if(initiate==1'b1)
			begin
				state<=`STATE_RUNNING;
			end
		end

		`STATE_START:
		begin
			state <= `STATE_RUNNING;
		end

		`STATE_RUNNING:
		begin
			if(h_goal==h_res) //check if already cracked
			begin
				state=`STATE_SUCCESS;
				$display("success! | %x (%x)",m_res,h_res);
			end

			else begin
				m<={}
			end
		end
	end
	
end