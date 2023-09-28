//carry lookahead unit with PGM generator
module CLU(
        input [3:0] p, g,
        input cin,
        output [3:1] c,
        output cout, pm, gm
    );
    assign c[1] = g[0] | cin & p[0];
    assign c[2] = g[1] | g[0] & p[1] | cin  & (&p[1:0]);
    assign c[3] = g[2] | g[1] & p[2] | g[0] & (&p[2:1]) | cin  & (&p[2:0]);
    assign cout = g[3] | g[2] & p[3] | g[1] & (&p[3:2]) | g[0] & (&p[3:1]) | cin & (&p[3:0]);
    assign gm = g[3] | g[2] & p[3] | g[1] & (&p[3:2]) | g[0] & (&p[3:1]);
    assign pm = &p;  

endmodule 

//四位超进位进位加法器
module CLA_4(
        input [3:0] a, b,
        input cin,
        output [3:0] s,
        output cout, p, g
    );
    wire [3:0] P;
    wire [3:0] G;
    wire [3:1] c;
    assign P = a ^ b;
    assign G = a & b;
    CLU unit(.p(P), .g(G), .c(c), .cin(cin), .cout(cout), .gm(g), .pm(p));
    assign s = P ^ {c,cin};
    //注意到c为【3：1】，这里恰好与cin合在一起并且与P异或

endmodule 

//十六位超进位加法器
module CLA_16 (
        input [15:0] a, b,
        input cin,
        output [15:0] s,
        output cout, p, g
    );
    wire [3:0] G;
    wire [3:0] P;
    wire [3:1] c;
    CLA_4 a0(.a(a[ 3: 0]), .b(b[ 3: 0]), .s(s[ 3: 0]), .cin(cin),  .p(P[0]), .g(G[0]));
    CLA_4 a1(.a(a[ 7: 4]), .b(b[ 7: 4]), .s(s[ 7: 4]), .cin(c[1]), .p(P[1]), .g(G[1]));
    CLA_4 a2(.a(a[11: 8]), .b(b[11: 8]), .s(s[11: 8]), .cin(c[2]), .p(P[2]), .g(G[2]));
    CLA_4 a3(.a(a[15:12]), .b(b[15:12]), .s(s[15:12]), .cin(c[3]), .p(P[3]), .g(G[3]));
    CLU unit(.p(P), .g(G), .c(c), .cin(cin), .cout(cout), .gm(g), .pm(p));

endmodule 

//三十二位超进位加法器
module Add(
        input       [31:0]          a, b,
        output   reg [31:0]          sum
    );

    wire c16;
    CLA_16 a0(.a(a[15: 0]), .b(b[15: 0]), .s(s[15: 0]), .cin(0), .g(c16));
    CLA_16 a1(.a(a[31:16]), .b(b[31:16]), .s(s[31:16]), .cin(c16));

    wire [31:0] s;
    always @* begin
            sum <= s;
        end
endmodule 
