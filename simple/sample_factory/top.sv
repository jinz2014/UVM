module top;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "packet.sv"
`include "driverB.sv"
`include "driverD.sv"
`include "agent.sv"
`include "env.sv"


  env env0;

  initial begin
    // Being registered first, the following overrides take precedence
    // over any overrides made within env0's construction & build.

    // Replace all base drivers with derived drivers...
    B_driver::type_id::set_type_override(D1_driver::get_type());

    // ...except for agent0.driver0, whose type remains a base driver.
    // (Both methods below have the equivalent result.)
    // - via the component's proxy (preferred)
    B_driver::type_id::set_inst_override(B_driver::get_type(), "env0.agent0.driver0");

    // - via a direct call to a factory method 
    // (vcs reports get_full_name() is not declared, so remove get_full_name())
    factory.set_inst_override_by_type(B_driver::get_type(), D2_driver::get_type(), "env0.agent1.driver0");

    // now, create the environment; our factory configuration will
    // govern what topology gets created
    env0 = new("env0");

    factory.print(1);

    // run the test (will execute build phase)
    run_test();

    // reporter UVM testbench topology after run_test() !
    //factory.print(1);

  end

endmodule
