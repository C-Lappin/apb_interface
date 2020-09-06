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
  reg [31:0] i_addr ; 
  initial i_addr = 32'h00000000;
  reg [31:0] i_data ; 
  initial i_data = 32'hDEADC001;
  
    task write(input [31:0] addr, input [31:0] data);
        begin
            PADDR <= addr;
            PWDATA <= data;
            PSEL <= 1'b1;
            PWRITE <= 1'b1;
            #20;
            PSEL <= 1'b0;
            #20
            PWRITE <= 1'b0;   
            #20;
        end
    endtask
  
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
    #10;
    write(i_addr, i_data);
    write(32'h00000001, 32'hC001DEAF);
    
        
        // 3. Finish the stimulus after 200ns
        #100 $finish;
        
    end
    
    always #10  PCLK = ~PCLK;
  
  

  
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