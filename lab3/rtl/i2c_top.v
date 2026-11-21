// Hardware wrapper. External pull-up resistors on SCL and SDA are required.
module i2c_top(input wire clk, rst, start, read_cmd,
  input wire [6:0] address, input wire [7:0] tx_data,
  inout wire scl, sda, output wire busy, done, nack_error,
  output wire [7:0] rx_data);
  wire scl_low, sda_low;
  assign scl = scl_low ? 1'b0 : 1'bz;
  assign sda = sda_low ? 1'b0 : 1'bz;
  i2c_master core(clk,rst,start,read_cmd,address,tx_data,
    scl,sda,scl_low,sda_low,busy,done,nack_error,rx_data);
endmodule
