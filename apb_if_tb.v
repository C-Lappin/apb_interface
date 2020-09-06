module apb_if_tb();

  reg                         PCLK;
  reg                         PRESETn;
  reg        [32-1:0]         PADDR;
  reg                         PWRITE;
  reg                         PSEL;
  reg                         PENABLE;
  reg     	 [32-1:0]         PWDATA;
  wire 	  	 [32-1:0]         PRDATA;
  wire	                      PREADY;
  
  initial
    begin
            
    $dumpfile("example.vcd");
    $dumpvars(0, apb_if_tb);
    PCLK = 0;
    PRESETn=0;
    PADDR= 32'b0;
    PWRITE=0;
    PSEL=0;
    PENABLE=0;
    PWDATA = 32'b0;
    
        
        // 3. Finish the stimulus after 200ns
        #200 $finish;
        
    end
    
    always #1  PCLK = ~PCLK;
  
  
// Design Under Test

apb_s_if dut_0(
        .pclk(PCLK), 
        .presetn(PRESETn), 
        .paddr(PADDR),
        .pwdata(PWDATA), 
        .prdata(PRDATA),
        .penable(PENABLE), 
        .psel(PSEL), 
        .pwrite(PWRITE), 
        .pready(PREADY)); 
  
endmodule 