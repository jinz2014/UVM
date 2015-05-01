//----------------------------------------------------------------------
//   Copyright 2005-2008 Mentor Graphics Corporation
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

covergroup fcoverage ( ref fpu_response response );
    option.per_instance = 0;
    //option.cross_num_print_missing = 100;

    // This section are for bookkeeping only, coverpoints are below this section
    a_sign : coverpoint response.a.operand.sign { bins neg = { 'h1 }; 
                                                  bins pos = { 'h0 }; 
                                                }

    a_exponent : coverpoint response.a.operand.exponent { bins e255  = { 'hff }; 
                                                  bins zero  = { 'h00 }; 
                                                }

    a_mantissa : coverpoint response.a.operand.mantissa { bins zero  = { 0 };    
                                                  bins other = { [1:'h7ffffe] };
                                                }

    b_sign : coverpoint response.b.operand.sign { bins neg = { 'h1 }; 
                                                  bins pos = { 'h0 }; 
                                                }

    b_exponent : coverpoint response.b.operand.exponent { bins e255  = { 'hff }; 
                                                  bins zero  = { 'h00 }; 
                                                }

    b_mantissa : coverpoint response.b.operand.mantissa { bins zero  = { 0 };    
                                                  bins other = { [1:'h7ffffe] };
                                                  }

    result_exponent : coverpoint response.result.operand.exponent { bins e255 = { 'hff }; 
                                                            }
    result_mantissa : coverpoint response.result.operand.mantissa { bins zero = { 0 }; 
                                                            ignore_bins one  = { 1 }; 
                                                            bins other = { [2:'h7ffffe] };
                                                          }
    A_NAN : cross a_exponent, a_mantissa { 
                                           bins n1 = binsof(a_exponent.e255) && binsof(a_mantissa.other); 
                                           ignore_bins ignored = binsof(a_exponent.zero) || binsof(a_mantissa.zero) || binsof(a_mantissa.zero);
                                           }

    B_NAN : cross b_exponent, b_mantissa { 
                                           bins n1 = binsof(b_exponent.e255) && binsof(b_mantissa.other); 
                                           ignore_bins ignored = binsof(b_exponent.zero) || binsof(b_mantissa.zero) || binsof(b_mantissa.zero);
                                           }
                                                                                                                     
    A_Zero: cross a_exponent, a_mantissa { 
                                           bins n1 = binsof(a_exponent.zero) && binsof(a_mantissa.zero); 
                                           ignore_bins ignored = binsof(a_exponent.e255) || binsof(a_mantissa.other);
                                           }

    B_Zero: cross b_exponent, b_mantissa { 
                                           bins n1 = binsof(b_exponent.zero) && binsof(b_mantissa.zero); 
                                           ignore_bins ignored = binsof(b_exponent.e255) || binsof(b_mantissa.other);
                                           }

    A_Infinity: cross a_exponent, a_mantissa { 
                                           bins n1 = binsof(a_exponent.e255) && binsof(a_mantissa.zero);
                                           ignore_bins ignored = binsof(a_exponent.zero) || binsof(a_mantissa.other);
                                           }

    B_Infinity: cross b_exponent, b_mantissa { 
                                           bins n1 = binsof(b_exponent.e255) && binsof(b_mantissa.zero);
                                           ignore_bins ignored = binsof(b_exponent.zero) || binsof(b_mantissa.other);
                                           }

    result :cross result_exponent, result_mantissa {  
                                           bins QNaN         = binsof(result_exponent.e255) && binsof(result_mantissa.other);
                                           bins Infinity     = binsof(result_exponent.e255) && binsof(result_mantissa.zero);
                                           }
     // Coverpoints are below
     exception : coverpoint response.status {
                             //option.comment = "section 3.2.0";
                             wildcard bins INEXACT   = {8'bxxxxxxx1};
                             wildcard bins OVERFLOW  = {8'bxxxxxx1x};
                             wildcard bins UNDERFLOW = {8'bxxxxx1xx};
                             wildcard bins DIV_ZERO  = {8'bxxxx1xxx};
                             wildcard bins INFINITY  = {8'bxxx1xxxx}; 
                             wildcard bins ZERO      = {8'bxx1xxxxx}; 
                             wildcard bins QNAN      = {8'bx1xxxxxx}; 
                          // wildcard bins SNAN      = {8'b1xxxxxxx};
     }

    operation : coverpoint response.op;
    

    nanXop : cross a_exponent, a_mantissa, b_exponent, b_mantissa, operation {
                                     //option.comment = "section 3.2.1 - 1 and 3.3.0";
                                     bins n1 = binsof(a_exponent.e255) && binsof(a_mantissa.other);
                                     bins n2 = binsof(b_exponent.e255) && binsof(b_mantissa.other);
                                     bins n3 = binsof(operation);
                                     }
    add_subXinf : cross a_exponent, a_mantissa, b_exponent, b_mantissa, operation {
                                     //option.comment = "section 3.2.1 - 2";
                                     bins n1 = (binsof(a_exponent.e255) && binsof(a_mantissa.zero)) || (binsof(b_exponent.e255) && binsof(b_mantissa.zero));
                                     bins n2 = binsof(operation) intersect {OP_ADD, OP_SUB};
                                     ignore_bins ignored = binsof(operation) intersect {OP_MUL, OP_DIV, OP_SQR};
                                     }
     mul_Xinf : cross a_exponent, a_mantissa, b_exponent, b_mantissa, operation {
                                     //option.comment = "section 3.2.1 - 3";
                                     bins n1 = (binsof(a_exponent.e255) && binsof(a_mantissa.zero)) || (binsof(a_exponent.zero) && binsof(a_mantissa.zero));
                                     bins n2 = (binsof(b_exponent.e255) && binsof(b_mantissa.zero)) || (binsof(b_exponent.zero) && binsof(b_mantissa.zero));
                                     bins n3 = binsof(operation) intersect {OP_MUL};
                                     ignore_bins ignored = binsof(operation) intersect {OP_ADD, OP_SUB, OP_DIV, OP_SQR};                                                                                 
                                     }
    divXinf_zero : cross a_exponent, a_mantissa, b_exponent, b_mantissa, operation {
                                     //option.comment = "section 3.2.1 - 4";
                                     bins n1 = (binsof(a_exponent.e255) && binsof(a_mantissa.zero)) || (binsof(b_exponent.e255) && binsof(b_mantissa.zero));
                                     bins n2 = (binsof(a_exponent.zero) && binsof(a_mantissa.zero)) || (binsof(b_exponent.zero) && binsof(b_mantissa.zero));
                                     bins n3 = binsof(operation) intersect {OP_DIV};
                                     ignore_bins ignored = binsof(operation) intersect {OP_ADD, OP_SUB, OP_MUL, OP_SQR};                                                                                 
                                     }
    divXexc : cross a_exponent, a_mantissa, b_exponent, b_mantissa, operation, result_exponent, result_mantissa, exception {
                                     //option.comment = "section 3.2.3";
                                     bins a  = (binsof(a_exponent.zero) && binsof(a_mantissa.other)) || (binsof(a_exponent.e255) && binsof(a_mantissa.zero));
                                     bins b  = binsof(b_exponent.zero) && binsof(b_mantissa.zero);
                                     bins r  = binsof(result_exponent.e255) && binsof(result_mantissa.zero);
                                     bins n1 = binsof(operation) intersect {OP_DIV} && binsof(exception.DIV_ZERO);

                                     bins ignored = binsof(result_mantissa.other) || 
                                                    binsof(operation) intersect {OP_ADD, OP_SUB, OP_MUL, OP_SQR}
                                                        || binsof(b_exponent.e255)        
                                                        || binsof(b_mantissa.zero)
                                                        || binsof(b_mantissa.other)
                                                        || binsof(exception.INEXACT)
                                                        || binsof(exception.OVERFLOW)
                                                        || binsof(exception.UNDERFLOW)
                                                        || binsof(exception.INFINITY)
                                                        || binsof(exception.ZERO)
                                                        || binsof(exception.QNAN);
                                     }
    N2N_operations : coverpoint response.op {
                                     //option.comment = "section 3.5";
                                     bins N2N[] = ( OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_SQR => OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_SQR);
                                     }

   signXop : cross a_sign, b_sign, operation {
                                              //option.comment = "just for fun";
                                              bins n1 = binsof(a_sign.pos) && binsof(b_sign.neg);
                                              bins n2 = binsof(b_sign.pos) && binsof(a_sign.neg);
                                              bins n3 = binsof(operation);
                                              }

    round     : coverpoint response.round;
endgroup




class fpu_coverage extends uvm_subscriber #( fpu_response );

//Using with uvm 2.0 factory
 `uvm_component_utils(fpu_coverage)

local bit m_match;
  
local fpu_response m_response;
fcoverage fpu_coverage;

function new( string name , uvm_component parent = null );
      super.new( name , parent );
endfunction

function void build();
      int verbosity_level = UVM_FULL;
      uvm_object tmp;

      super.build();

      m_response = new;
      fpu_coverage = new( m_response );
      
      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction


function void write( input fpu_response t ); 
      string s;
      
      m_response = t;
      uvm_report_info("response", m_response.convert2string, UVM_HIGH ,`__FILE__,`__LINE__); 

      fpu_coverage.sample ;
endfunction


function void report;
      string report_str;

      $sformat( report_str , "%d percent covered" , fpu_coverage.get_inst_coverage );
      uvm_report_info( "report" , report_str, UVM_MEDIUM ,`__FILE__,`__LINE__);

endfunction

endclass

