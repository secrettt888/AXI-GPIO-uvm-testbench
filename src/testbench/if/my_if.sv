// Generic bus-like interface template with clocking and modports
`timescale 1ns/1ps

interface my_if();
  // TODO: Customize signal list for your DUT protocol
    logic s_axi_aclk;             
    logic s_axi_aresetn;          
    logic [8:0] s_axi_awaddr;           
    logic s_axi_awvalid;          
    logic s_axi_awready;          
    
    logic [31:0] s_axi_wdata;           
    logic [3:0] s_axi_wstrb;            
    logic s_axi_wvalid;           
    logic s_axi_wready;           
    
    logic [1:0] s_axi_bresp;           
    logic s_axi_bvalid;          
    logic s_axi_bready;          
    
    logic [8:0] s_axi_araddr;           
    							
    logic s_axi_arvalid;        
    logic s_axi_arready; 
    logic ip2intc_irpt;          
    
    logic [31:0] s_axi_rdata;           
    logic [1:0] s_axi_rresp;          
    logic s_axi_rvalid;          
    logic s_axi_rready; 
    logic [31:0] gpio_io_i;              
    logic [31:0] gpio_io_o;             
    logic [31:0] gpio_io_t;              
    logic [31:0] gpio2_io_i;              
    logic [31:0] gpio2_io_o;            
     logic [31:0] gpio2_io_t;  

clocking mon_cb @(posedge s_axi_aclk);
    default input #3ns output #3ns;
    input s_axi_awready, s_axi_awvalid, s_axi_awaddr;
    input s_axi_wready, s_axi_wvalid, s_axi_wdata;
    input s_axi_arready, s_axi_arvalid, s_axi_araddr;
    input s_axi_rready, s_axi_rvalid, s_axi_rdata, s_axi_rresp;
  endclocking


  // Simple interface without clocking blocks or modports.

  // Synchronous reset default
  // TODO: Adjust reset behavior to match DUT
  // property p_reset_defaults;
  //   @(posedge s_axi_aclk) !rst_n |-> (!valid && !write);
  // endproperty
  // a_reset_defaults: assert property (p_reset_defaults);

  // No modports used in the simplified template.

endinterface : my_if
