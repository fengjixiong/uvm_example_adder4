// adder_sequencer.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_sequencer extends uvm_sequencer #(adder_transaction);
    `uvm_component_utils(adder_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SEQER_BUILD","sequencer build_phase start",UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SEQER_CONNECT","sequencer connect_phase start",UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SEQER_RUN","sequencer run_phase start",UVM_LOW)
    endtask
endclass