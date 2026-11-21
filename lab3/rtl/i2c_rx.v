// Byte deserializer. sample is a one-clock enable inside SCL's high phase.
module i2c_rx(input wire clk, rst, clear, sample, serial_in,
              output reg [7:0] data);
  always @(posedge clk) begin
    if (rst || clear) data <= 0;
    else if (sample) data <= {data[6:0], serial_in};
  end
endmodule
