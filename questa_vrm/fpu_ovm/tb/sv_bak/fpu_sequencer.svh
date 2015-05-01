// Not used in this example
class fpu_sequencer extends uvm_sequencer #(fpu_request, fpu_response);
`uvm_sequencer_utils(fpu_sequencer)

function new(string name, uvm_component parent=null);
      super.new(name, parent);
      `uvm_update_sequence_lib_and_item(fpu_request)
endfunction // new

endclass

