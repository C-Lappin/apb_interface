// APB interface Slave
`default_nettype none


module apb_s_if(pclk, presetn, paddr, pwdata, prdata, penable, psel, pwrite, pready);
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter RAM_WIDTH  = 32;
parameter n = 8;
   // inputs 
   input pclk;
   input presetn;
   input penable;
   input psel;
   input pwrite;
   input [ADDR_WIDTH - 1:0] paddr;
   input [DATA_WIDTH -1 :0] pwdata;
   
   
   // outputs
   output [DATA_WIDTH -1 :0] prdata;
   output pready;
   
   logic reg [RAM_WIDTH -1:0] ram [2**n-1:0];
   logic wire wr_enable;
   logic wire rd_enable;
   
   // apb_state 
   // 00 IDLE
   // 01 SETUP
   // 10 ACCESS
   // 11 NOT_USED
   logic reg [1:0] apb_state;
   initial apb_state = 0;
   
    always@(posedge pclk or negedge presetn)
        begin
            if (~presetn)
                begin
                    apb_state <= 2'b00;
                end
            else
                begin
                    case(apb_state)
                        2'b00:
                            begin                          
                                if (~psel)
                                    begin
                                        apb_state <= 2'b00;
                                    end
                                else
                                    begin
                                        apb_state <= 2'b01;
                                    end
                            end
                            
                        2'b01:
                            begin
                                if (pwrite)
                                    begin
                                        apb_state <= 2'b00;
                                    end
                                else
                                    begin
                                        apb_state <= 2'b10;
                                    end
                            end

                        2'b10:
                            begin
                                apb_state <= 2'b00;
                            end
                            
                        default:
                            begin   
                                apb_state <= 2'b00;
                            end
                    endcase
                end
            
            
        end   

    always@(*)
        begin
            if (psel == 1'b1 && apb_state == 2'b00 && pwrite == 1'b1)
                begin
                    pready <= 1'b1;
                end
            else if (apb_state == 2'b01 && pwrite == 1'b1)
                begin
                    pready <= 1'b1;
                end
            else if (apb_state == 2'b10)
                begin
                    pready <= 1'b1;
                end
            else
                begin
                    pready <= 1'b0;
                end
        end
     
    always@(*)
        begin
            if (psel == 1'b1 && apb_state == 2'b00 && pwrite == 1'b1)
                begin
                    wr_enable <= 1'b1;
                end
            else
                begin
                    wr_enable <= 1'b0;
                end
        end
        
    always@(*)
        begin
            if (psel == 1'b1 && apb_state == 2'b00 && pwrite == 1'b0)
                begin
                    rd_enable <= 1'b1;
                end
            else
                begin
                    rd_enable <= 1'b0;
                end
        end
    
   `ifdef	FORMAL
   
            // apb state cannot be 2'b11
            always @(*)
                assert(apb_state <= 2'b11);
                
            // wr_enable can only be asserted when  in apb_state IDLE, pwrite and psel asserted.
            always@(*)
                begin
                    if(apb_state == 2'b00 && pwrite && psel)
                        assert(wr_enable);
                end
            
            // rd_enable can only be asserted when pwrite is not assert, apb_state is IDLE and psel is asserted.
            always@(*)
                begin
                    if(apb_state == 2'b00 && !pwrite && psel)
                        assert(rd_enable);
                end
   
   `endif


endmodule 
