
// Simple top-level. Instantiates DUT (to be added) and kicks off UVM.



`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import uvm_tb_pkg::*;
module top;
my_if tb_if();



  axi_gpio dut(

    .s_axi_aclk(tb_if.s_axi_aclk),

    .s_axi_aresetn(tb_if.s_axi_aresetn),



    .s_axi_awaddr (tb_if.s_axi_awaddr),

    .s_axi_awvalid(tb_if.s_axi_awvalid),

    .s_axi_awready(tb_if.s_axi_awready),

    .s_axi_wdata  (tb_if.s_axi_wdata),

    .s_axi_wstrb  (tb_if.s_axi_wstrb),

    .s_axi_wvalid (tb_if.s_axi_wvalid),

    .s_axi_wready (tb_if.s_axi_wready),

    .s_axi_bresp  (tb_if.s_axi_bresp),

    .s_axi_bvalid (tb_if.s_axi_bvalid),

    .s_axi_bready (tb_if.s_axi_bready),

    .s_axi_araddr (tb_if.s_axi_araddr),

    .s_axi_arvalid(tb_if.s_axi_arvalid),

    .s_axi_arready(tb_if.s_axi_arready),

    .s_axi_rdata  (tb_if.s_axi_rdata),

    .s_axi_rresp  (tb_if.s_axi_rresp),

    .s_axi_rvalid (tb_if.s_axi_rvalid),

    .s_axi_rready (tb_if.s_axi_rready),



    .ip2intc_irpt (tb_if.ip2intc_irpt),



    .gpio_io_i    (tb_if.gpio_io_i),

    .gpio_io_o    (tb_if.gpio_io_o),

    .gpio_io_t    (tb_if.gpio_io_t),

    .gpio2_io_i   (tb_if.gpio2_io_i),

    .gpio2_io_o   (tb_if.gpio2_io_o),

    .gpio2_io_t   (tb_if.gpio2_io_t)

  );

  /*initial begin
    #5
    force tb_if.s_axi_wdata='bx;
    force tb_if.s_axi_rdata='bx;
  end*/


  // Clock/reset gen (example placeholder)

  initial begin
    tb_if.s_axi_aclk = 0;
  end

    always #5 tb_if.s_axi_aclk = ~tb_if.s_axi_aclk;



  initial begin

        tb_if.s_axi_aresetn = 0;

    #50  tb_if.s_axi_aresetn = 1;

  end



  // Make virtual interface(s) available via UVM config DB

  initial begin

    // Provide single interface without modports

    uvm_config_db#(virtual my_if)::set(null, "*", "vif", tb_if);

  end



  // Kick off UVM

  initial begin

    `uvm_info("TOP", "SIMULATION STARTED", UVM_NONE)

    fork

        begin
            run_test("base_test"); // +UVM_TESTNAME=base_test can override
        end

        begin
           repeat(10000) @(posedge tb_if.s_axi_aclk);

            `uvm_fatal("SIM_END", $sformatf("Reached the simulation limit"))

        end

    join_any



  end

endmodule : top