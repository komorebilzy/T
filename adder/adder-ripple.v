module fullAdder(input a,input b,input cin,output sum,output cout);
	assign sum=a^b^c;
	assign cout=(a&b) | (cin & (a^b));
endmodule

module adder32(input [31:0]a,input [31:0]b,input cin,output [31:0]sum,output cout);
	wire [32:0] carry;
	assign carry[0]=cin;

	genvar i;
	generate
		for(i=0;i<32;i=i+1) begin
			fullAdder add(a[i],b[i],carry[i],sum[i],carry[i+1]);
		end
	endgenerate

	assign cout=carry[32];
endmodule


module ADD(input [31:0]a,input [31:0]b,output reg[31:0]sum);

	wire finalcarry;
	wire [31:0] tmp;
	adder32 adder(a,b,1,tmp,finalcarry);

	always @* begin
		sum <= tmp;
		end

endmodule