interface apb_if(input PCLK,
                 input PRESETn);

  logic[31:0] PADDR;
  logic[31:0] PRDATA;
  logic[31:0] PWDATA;
  logic[15:0] PSEL; // Only connect the ones that are needed
  logic PENABLE;
  logic PWRITE;
  logic PREADY;

  property psel_valid;
    @(posedge PCLK)
    !$isunknown(PSEL);
  endproperty: psel_valid

  CHK_PSEL: assert property(psel_valid);

  COVER_PSEL: cover property(psel_valid);

endinterface: apb_if