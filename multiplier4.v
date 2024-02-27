
`timescale 1ns/1ns
module multiplier4 #( parameter N)(
//---------------------Port directions and declaration
   input clk,  
   input start,
   input  [N-1:0] A, 
   input  [N-1:0] B, 
   output reg [2*N-1:0] Product,
   output ready
);
//----------------------------------------------------

//--------------------------------- register declaration
reg [N-1:0] Multiplicand ;
reg [N-1:0] Multiplier;
reg [$clog2(N)-1:0] counter;
//-----------------------------------------------------

//----------------------------------- wire declaration
wire [N:0] adder_output;
wire [N:0] mux_output;
wire [N:0] sext_output;
wire [N:0] Multiplicand_comp;
wire control;
//-------------------------------------------------------

//------------------------------------ combinational logic
assign control = Product[0];
assign mux_output = control ? {Multiplicand[N-1],Multiplicand} : {(N+1){1'b0}};
assign sext_output = {Product[2*N-1], Product[2*N-1:N]};
assign Multiplicand_comp = (~mux_output+1'b1);
assign adder_output = (counter == N-1 && Multiplier[N-1]) ?  (Multiplicand_comp + sext_output) : (mux_output + sext_output);
assign ready = (counter == N);
//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (posedge clk)

   if(start) begin
      counter <= {$clog2(N){1'b0}} ;
      Multiplier <= B;
      Multiplicand <= A ;
      Product <= {{N{1'b0}},B};
   end

   else if(!ready) begin
      counter <= counter + 1;
      Product <= {adder_output,Product[N-1:1]};
      // $display (", Product: %x",Product); 
   end
endmodule
  