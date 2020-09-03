// APB interface Slave
`default_nettype none


module apb_s_if(pclk, presetn, paddr, pwdata, prdata, penable, psel, pwrite, pready);
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
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
        
   assign wr_enable = (penable && pwrite && psel);
   assign rd_enable = (!pwrite && psel);
   
   
   
   `ifdef	FORMAL
   
            // apb state cannot be 2'b11
            always @(*)
                assert(apb_state <= 2'b11);
    
            // if psel is not set then a write cannot happen 
            /*always@(*)
                begin
                    if (!psel)                   
                end*/
            // if wr_enable is asserted then rd_enable cannot be asserted
            always@(*)
                begin
                    if(penable && pwrite && psel)
                        assert(wr_enable);
                end
            
            // if rd_enable is asserted then wr_enable cannot be asserted
            always@(*)
                begin
                    if(!pwrite && psel)
                        assert(rd_enable);
                end
   
   `endif


endmodule 
