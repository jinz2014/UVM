//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010-2011 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`include "uvm_macros.svh"

package user_pkg;

  import uvm_pkg::*;

  typedef enum { BUS_READ, BUS_WRITE } bus_op_t;
  typedef enum { STATUS_OK, STATUS_NOT_OK } status_t;

  //--------------------------------------------------------------------
  // bus_trans
  //--------------------------------------------------------------------
  class bus_trans extends uvm_sequence_item;

    bit [11:0] addr;
    bit [7:0] data;
    bus_op_t op;

    function new();
      super.new();
    endfunction

    function uvm_object clone();
      bus_trans t; t = new();
      t.copy(this);
      return t;
    endfunction

    function void copy (bus_trans t);
      super.copy(t);
      addr = t.addr;
      data = t.data;
      op = t.op;
    endfunction

    function bit compare(bus_trans t);
      return ((op == t.op) && (addr == t.addr) && (data == t.data));
    endfunction

    function string convert2string();
      string s;
      $sformat(s, "op %s: addr=%03x, data=%02x", op.name(), addr, data);
      return s;
    endfunction

  endclass

  //--------------------------------------------------------------------
  // bus_req
  //--------------------------------------------------------------------
  class bus_req extends bus_trans;

    function uvm_object clone();
      bus_req t; t = new();
      t.copy(this);
      return t;
    endfunction

    function void copy (bus_req t);
      super.copy(t);
    endfunction

  endclass

  //--------------------------------------------------------------------
  // bus_rsp
  //--------------------------------------------------------------------
  class bus_rsp extends bus_trans;

    status_t status;

    function uvm_object clone();
      bus_rsp t; t = new();
      t.copy(this);
      return t;
    endfunction

    function void copy (bus_rsp t);
      super.copy(t);
      status = t.status;
    endfunction

    function void copy_req (bus_req t);
      super.copy(t);
    endfunction

    function string convert2string();
      string s;
      $sformat(s, "op %s, status=%s", super.convert2string(), status.name());
      return s;
    endfunction

  endclass

class my_driver #(type REQ = uvm_sequence_item, 
                  type RSP = uvm_sequence_item)  extends uvm_driver #(REQ, RSP);

  int data_array[511:0];

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    REQ req;
    RSP rsp;

    forever begin
      seq_item_port.get(req);
      rsp = new();
      rsp.set_id_info(req);

      // Actually do the read or write here
      if (req.op == BUS_READ) begin
        rsp.addr = req.addr[8:0];
        rsp.data = data_array[rsp.addr];
        `uvm_info("my_driver",rsp.convert2string(),UVM_MEDIUM);
      end else begin
        data_array[req.addr[8:0]] = req.data;
        `uvm_info("my_driver",req.convert2string(),UVM_MEDIUM);
      end
      seq_item_port.put(rsp); // match get_response()
    end
  endtask
endclass


`define num_loops 10

class sequenceA #(type REQ = uvm_sequence_item,
                  type RSP = uvm_sequence_item) extends uvm_sequence #(REQ, RSP);

  static integer g_my_id = 1;
  integer my_id;
  
  function new(string name);
    super.new(name);
    my_id = g_my_id++;
  endfunction

  /*
  task wait_for_grant()
  This task issues a request to the current sequencer. If item_priority is not
  specified, then the current sequence priority will be used by the arbiter. If a
  lock_request is made, then the sequencer will issue a lock immediately before granting the
  sequence. (Note that the lock may be granted without the sequence being granted if
  is_relevant is not asserted).
  When this method returns, the sequencer has granted the sequence,
  and the sequence must call send_request without inserting any simulation delay other
  than delta cycles.  The driver is currently waiting for the next item to be sent via the
  send_request call.

  send_request
  function void send_request(uvm_sequence_item request, bit rerandomize = 0)

  The send_request function may only be called after a wait_for_grant
  call. This call will send the request item to the sequencer, which will forward it to the
  driver. If the rerandomize bit is set, the item will be randomized before being
  sent to the driver.

  get_response

  virtual task get_response(output RSP response, input int transaction_id = -1)

  By default, sequences must retrieve responses by calling get_response. If no
  transaction_id is specified, this task will return the next response sent
  to this sequence.

  If no response is available in the response queue, the method will block
  until a response is recieved.

  If a transaction_id is parameter is specified, the task will block until
  a response with that transaction_id is received in the response queue.
  
  The default size of the response queue is 8. The get_response method
  must be called soon enough to avoid an overflow of the response queue to prevent
  responses from being dropped.

  If a response is dropped in the response queue, an error will be
  reported unless the error reporting is disabled via set_response_queue_error_report_disabled.
  */
  task body();
    string prstring;
    int  ret_data;
    REQ  req;
    RSP  rsp;

    `uvm_info("sequenceA", "Starting sequence", UVM_MEDIUM)
    
    for(int unsigned i = 0; i < `num_loops; i++) begin
      req = new();
      req.addr = (my_id * `num_loops) + i;
      req.data = my_id + i + 55;
      req.op   = BUS_WRITE;

      wait_for_grant();
      send_request(req);
      get_response(rsp);
      
      req = new();
      req.addr = (my_id * `num_loops) + i;
      req.data = 0;
      req.op   = BUS_READ;

      wait_for_grant();
      send_request(req);
      get_response(rsp);
      
      if (rsp.data != (my_id + i + 55)) begin
        $sformat(prstring, "Error, addr: %0d, expected data: %0d, actual data: %0d",
                 req.addr, req.data, rsp.data);
        `uvm_error("SequenceA", prstring)
      end
    end
    `uvm_info("sequenceA", "Finishing sequence", UVM_MEDIUM)
  endtask // body

endclass

`define NUM_SEQS `num_loops

class env extends uvm_env;
  int i;
  uvm_sequencer #(bus_req, bus_rsp) sqr;

  sequenceA #(bus_req, bus_rsp) sequence_a[`NUM_SEQS];
  my_driver #(bus_req, bus_rsp) drv ;

  function new(string name, uvm_component parent);
    string str;

    super.new(name, parent);
    sqr = new("sequence_controller", this);

    for (i = 0; i < `NUM_SEQS; i++) begin
      sequence_a[i] = new("sequence");
    end
    
    // create and connect driver
    drv = new("slave", this);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction


  /*
  Executes this sequence, returning when the sequence has completed.
  The sequencer argument specifies the sequencer on which to run this
  sequence. The sequencer must be compatible with the sequence.

  If parent_sequence is null, then this sequence is a root parent, otherwise
  it is a child of parent_sequence. The parent_sequence’s pre_do, mid_do, and post_do
  methods will be called during the execution of this sequence.
  */
  task run_phase(uvm_phase phase);
      int i;

      phase.raise_objection(this);
      for (i = 0; i < `NUM_SEQS; i++) begin
        fork
          sequence_a[i].start(sqr, null);
        join_none
        #0;
      end
      wait fork;
      phase.drop_objection(this);
  endtask

endclass
endpackage

module top;
  import user_pkg::*;
  import uvm_pkg::*;
  env e;

  initial begin
    `uvm_info("top","In top initial block",UVM_MEDIUM);
    e = new("env", null);
    run_test();
  end
endmodule

