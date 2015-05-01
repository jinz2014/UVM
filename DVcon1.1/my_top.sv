/*
Sequences are assembled from transactions and are used to build realistic sets
of stimuli. A sequence could generate a specific pre-determined set of
transactions, a set of randomized transactions, or anything in between.
Sequences can run other sequences, possibly selecting which sequence to run at
random.

Sequences can be layered such that higher-level sequences send
transactions to lower-level sequences in a protocol stack.

Here is a skeleton sequence. It is similar to a transaction in outline, but
the base class uvm_sequence is parameterized with the type of the transaction
of which the sequence is composed. 

Also every sequence contains a body task, which when it executes generates those transactions or 
runs other sequences.

class my_seq extends uvm_sequence #(my_tx);
  `uvm_object_utils(my_seq)
  function new (string name = "");
    super.new(name);
  endfunction
  task body;
    ...
  endtask
  ...
endclass

Transactions and sequences together represent the domain of dynamic data
within the verification environment.
*/

`include "uvm_macros.svh"

import uvm_pkg::*;

// transaction
class my_tx extends uvm_sequence_item;

  rand int id;

  // automation macros for general objs
  `uvm_object_utils_begin(my_tx)
    `uvm_field_int(id, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "my_tx");
    super.new(name);
  endfunction
endclass

class driver extends uvm_driver #(my_tx);
  `uvm_component_utils(driver)

  //virtual dut_if dut_vi;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      my_tx tx;
      seq_item_port.get(tx);
      `uvm_info("driver", $sformatf("Get tx id=%0d", tx.id), UVM_LOW)
      //seq_item_port.item_done();
    end
  endtask
endclass

class sqr extends uvm_sequencer #(my_tx);
  `uvm_component_utils(sqr)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

class ano_sqr extends uvm_sequencer #(my_tx);
  `uvm_component_utils(ano_sqr)

  uvm_seq_item_pull_port #(my_tx) seq_item_port;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_item_port = new ("seq_item_port", this);
  endfunction

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass


// a sequence is generated dynamically
class seq extends uvm_sequence #(my_tx);

  function new(string name = ""); 
    super.new(name); 
  endfunction

 /*
 Error-[TMAFTC] Too many arguments to function/task call my_top.sv, 70
 "uvm_sequence::new(name, parent)"
   The above function/task call is done with more arguments than needed.
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  */

  task body;
    my_tx tx;
    tx = my_tx::type_id::create("tx");
    //start_item waits for the downstream component to request the transaction,
    //finish_item waits for the downstream component to indicate that it has
    //finished with the transaction.
    start_item(tx);
    assert(tx.randomize());
    `uvm_info("seq", $sformatf("Send tx id=%0d", tx.id), UVM_LOW)
    finish_item(tx);
  endtask
endclass


class ano_seq extends uvm_sequence #(my_tx);
  `uvm_declare_p_sequencer(ano_sqr)

  function new(string name = ""); 
    super.new(name); 
  endfunction

  task body;
    my_tx tx;
    p_sequencer.seq_item_port.get(tx);
    `uvm_info("ano_seq", $sformatf("Get tx id=%0d", tx.id), UVM_LOW)
    start_item(tx);
    `uvm_info("ano_seq", $sformatf("Send tx id=%0d", tx.id), UVM_LOW)
    finish_item(tx);
  endtask
endclass

class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  sqr sqr1;
  ano_sqr sqr2;
  driver drv1;
  seq seq1;
  ano_seq seq2;
  //...
  //my_env env;
  //...
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    sqr1 = sqr::type_id::create("sqr1", this);
    sqr2 = ano_sqr::type_id::create("sqr2", this);
    drv1 = driver::type_id::create("drv1", this);
    seq1 = new("seq1"); // Create the sequence
    seq2 = new("seq2"); // Create the sequence
  endfunction

  function void connect_phase(uvm_phase phase);
    sqr2.seq_item_port.connect(sqr1.seq_item_export);
    drv1.seq_item_port.connect(sqr2.seq_item_export);
  endfunction : connect_phase
  
  task run_phase(uvm_phase phase);
    int i;

    phase.raise_objection(this);

    for (i = 0; i < 10; i++) begin
      //assert( seq1.randomize() ); // randomize it
      seq1.start( sqr2 ); // and start it on the sequencer
      seq2.start( sqr2 ); // and start it on the sequencer
      #10;
    end

    phase.drop_objection(this);
  endtask

endclass

module top;

   //import uvm_pkg::*;
   //import pkg::*;
  initial begin
    `uvm_info("top","In top initial block",UVM_MEDIUM);
    run_test("my_test");
  end
endmodule

