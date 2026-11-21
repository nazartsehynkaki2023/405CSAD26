// Byte serializer. The controller sets up SDA while SCL is low.
module i2c_tx(input wire clk, rst, load, advance,
              input wire [7:0] data, output wire bit_value);
  reg [7:0] shift;
  assign bit_value = shift[7]; // I2C sends the most significant bit first.
  always @(posedge clk) begin
    if (rst) shift <= 0;
    else if (load) shift <= data;
    else if (advance) shift <= {shift[6:0], 1'b0};
  end
endmodule
