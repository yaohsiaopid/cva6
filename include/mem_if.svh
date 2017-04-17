// Author: Florian Zaruba, ETH Zurich
// Date: 3/18/2017
// Description: Generic memory interface used by the core.
//              The interface can be used in Master or Slave mode.
//
// Copyright (C) 2017 ETH Zurich, University of Bologna
// All rights reserved.

// Guard statement proposed by "Easier UVM" (doulos)
`ifndef MEM_IF__SV
`define MEM_IF__SV
interface mem_if #(parameter int ADDRESS_SIZE = 64,
                   parameter int DATA_WIDTH = 64   )
                  (input clk);
        wire [ADDRESS_SIZE-1:0] address;           // Address for read/write request
        wire [DATA_WIDTH-1:0]   data_wdata;        // Data to be written
        wire                    data_req;          // Requests read data
        wire                    data_gnt;          // Request has been granted, signals can be changed as
                                                   // soon as request has been granted
        wire                    data_rvalid;       // Read data is valid
        wire [DATA_WIDTH-1:0]   data_rdata;        // Read data
        wire                    data_we;           // Write enable
        wire [DATA_WIDTH/8-1:0] data_be;           // Byte enable
        // Memory interface configured as master
        clocking mck @(posedge clk);
            default input #1ns output #1ns;
            input   address, data_wdata, data_req, data_we, data_be;
            output  data_gnt, data_rvalid, data_rdata;
        endclocking
        // Memory interface configured as slave
        clocking sck @(posedge clk);
            default input #1ns output #1ns;
            output  address, data_wdata, data_req, data_we, data_be;
            input   data_gnt, data_rvalid, data_rdata;
        endclocking

        clocking pck @(posedge clk);
            default input #1ns output #1ns;
            input  address, data_wdata, data_req, data_we, data_be,
                   data_gnt, data_rvalid, data_rdata;
        endclocking

        modport Master (
            clocking mck,
            input   address, data_wdata, data_req, data_we, data_be,
            output  data_gnt, data_rvalid, data_rdata
        );
        modport Slave  (
            clocking sck,
            output  address, data_wdata, data_req, data_we, data_be,
            input   data_gnt, data_rvalid, data_rdata
        );
        // modport Passive (clocking pck);
endinterface
`endif