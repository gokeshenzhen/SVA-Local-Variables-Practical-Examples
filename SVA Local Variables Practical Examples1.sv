localparam [7:0] EXPECTED_VAL=8'h8e;
bit START, SER_DIN_VAL, SER_DIN;
logic [7:0] MY_LVAR_out;


property MYPROP;
    int I;
    logic [7:0] MYVEC;
    @(posedge clk) 
    (START, I = 7)  |=> 
        (SER_DIN_VAL, MYVEC[I] = SER_DIN, I--) [*8] ##1 
    MYVEC == EXPECTED_VAL; 
endproperty

property MYPROP_out(local logic[7:0] MY_LVAR);
    int I;
    @(posedge clk)
    (START, I = 7)  |=> (SER_DIN_VAL, MY_LVAR[I] = SER_DIN, I--) [*8] ##1 MY_LVAR == EXPECTED_VAL; 
endproperty

a1: assert property(MYPROP);
a2: assert property(MYPROP_out(MY_LVAR_out));

always@(posedge clk)
    $display("@%0t, MY_LVAR_out=%0h", $time, MY_LVAR_out);

initial begin
    @(posedge clk) START = 1;
    @(posedge clk) START = 0;

    // another start
    //repeat(2) @(posedge clk);
    //START = 1;
    //@(posedge clk) START = 0;
end

initial begin
    repeat(2) @(posedge clk);
    SER_DIN_VAL = 1;
    repeat(8) @(posedge clk);
    SER_DIN_VAL = 0;
end
initial begin
    repeat(2) @(posedge clk);
    SER_DIN = 1;
    @(posedge clk) SER_DIN = 0;
    repeat(3) @(posedge clk);
    SER_DIN = 1;
    repeat(3) @(posedge clk);
    SER_DIN = 0;
end

