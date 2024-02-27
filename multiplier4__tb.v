`timescale 1ns/1ns

module multiplier4__tb ();

   parameter no_of_tests = 100;
   parameter N = 12;

//----------------generating clock signal in 100MHz
   reg clk = 1'b1;
   always @(clk)
      clk <= #5 ~clk;
//---------------------------------------------------
 
//------------------------------------ reg declaration 
   reg start;
   reg signed [N-1:0] A, B, C, D;
   reg signed [2*N-1:0] expected_product;
   
   // Declare signals to observe counter and product
   reg [2*N-1:0] product_signal;
   reg [N:0] tb_adder_output;
//--------------------------------------------------------    
   integer i, j, err = 0;
   
   initial begin
      start = 0;

      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
//----------------------------------------repeat the test no_of_tests times with different random numbers
      for(i=0; i<no_of_tests; i=i+1) begin

         A = $random();    
         B = $random();
         expected_product = A * B;
         C = A;
         D = B;
      //----------------------------------generating start signal -------------------------------------------------------------     
         start = 1;
         @(posedge clk);
         #1;
         start = 0;
         A = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
         B = 'bx; //When start became "1" we register A & B and their changes is not important after start became "0"
      //----------------------------------------------------------------------------------------------------------------------
         
      //-----------------------------------wait until multiplication completes
         for(j=0; j<=N-1; j=j+1)        
            @(posedge clk);
         @(posedge clk);
      //------------------------------------------------------------------------------

         // Assign signals to be observed
         product_signal = uut.Product;
         tb_adder_output = uut.adder_output;

         $display   ("%x (%0d) x %x (%0d) = %x (%0d) ", {C}, {C}, {D}, {D}, product_signal, product_signal,tb_adder_output);

         if (expected_product === product_signal)
            $display(", OK");
         else 
            $display (", ERROR: expected %x, got %x", expected_product, product_signal); 

      end

      $stop;
   end


    multiplier4 #(N) uut (        // unsigned unit
        .clk(clk),
        .start(start),
        .A(A),
        .B(B),
        .Product(),
      .ready()
    );


endmodule
