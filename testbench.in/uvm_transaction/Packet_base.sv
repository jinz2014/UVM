////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s              UVM Tutorial            s////
////s                                      s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
//////////////////////////////////////////////// 
`ifndef GUARD_PACKET
`define GUARD_PACKET


 `include "uvm_macros.svh"
 import uvm_pkg::*;


//Define the enumerated types for packet types
typedef enum { GOOD_FCS, BAD_FCS } fcs_kind_t;

class Packet extends uvm_transaction;

    rand fcs_kind_t     fcs_kind;
    
    rand bit [7:0] length;
    rand bit [7:0] da;
    rand bit [7:0] sa;
    rand bit [7:0] data[];
    rand byte fcs;
    
    constraint payload_size_c { data.size inside { [1 : 6]};}
    
    constraint length_c {  length == data.size; } 
                     
    function new(string name = "");
         super.new(name);
    endfunction : new
    
    function void post_randomize();
         if(fcs_kind == GOOD_FCS)
             fcs = 8'b0;
         else
            fcs = 8'b1;
         fcs = cal_fcs();
    endfunction : post_randomize
    
    ///// method to calculate the fcs /////
    virtual function byte cal_fcs;
         integer i;
         byte result ;
         result = da ^ sa ^ length;
         for (i = 0;i< data.size;i++)
           result = result ^ data[i];
         result = fcs ^ result;
         return result;
    endfunction : cal_fcs
    
    `uvm_object_utils_begin(Packet)
       `uvm_field_int(da, UVM_ALL_ON)
       `uvm_field_int(sa, UVM_ALL_ON)
       `uvm_field_int(length, UVM_ALL_ON)
       `uvm_field_array_int(data, UVM_ALL_ON)
       `uvm_field_int(fcs, UVM_ALL_ON)
    `uvm_object_utils_end

endclass : Packet


/////////////////////////////////////////////////////////
////    Test to check the packet implementation      ////
/////////////////////////////////////////////////////////
module test;

    Packet pkt1 = new("pkt1");
    Packet pkt2 = new("pkt2");
    byte unsigned pkd_bytes[];

    initial
    repeat(1)
       if(pkt1.randomize)
       begin
          $display(" Randomization Sucessesfull.");
          pkt1.print();
          //uvm_default_packer.use_metadata = 1;     
          
          //void'(pkt1.pack_bytes(pkdbytes));
          pkt1.pack_bytes(pkd_bytes);
          $display("Size of pkd bits %d",pkd_bytes.size());

          pkt2.unpack_bytes(pkd_bytes);
          pkt2.print();

          if(pkt2.compare(pkt1))
              $display(" Packing,Unpacking and compare worked");
          else
              $display(" *** Something went wrong in Packing or Unpacking *** \n \n");
       end
       else
       $display(" *** Randomization Failed ***");
    
endmodule


`endif
