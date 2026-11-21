// Single-controller I2C: one address plus one data byte per command.
// read_cmd=0: START, address+W, ACK, data, ACK, STOP.
// read_cmd=1: START, address+R, ACK, data, controller NACK, STOP.
// Open-drain outputs: 1 means pull low, 0 means release the line.
// No arbitration, repeated START, 10-bit addressing or stretch timeout.
module i2c_master #(
  parameter integer CLK_HZ = 50000000,
  parameter integer I2C_HZ = 100000
)(input wire clk, rst, start, read_cmd,
  input wire [6:0] address,
  input wire [7:0] tx_data,
  input wire scl_i, sda_i,
  output reg scl_low, sda_low,
  output wire busy,
  output reg done, nack_error,
  output reg [7:0] rx_data);

  localparam integer DIV = (CLK_HZ + 4*I2C_HZ - 1) / (4 * I2C_HZ);
  localparam integer CW = (DIV < 2) ? 1 : $clog2(DIV);
  localparam IDLE=0, START_A=1, START_B=2, LOAD_ADDR=3,
    TX=4, ACK_IN=5, LOAD_DATA=6, LOAD_RX=7, RX=8,
    ACK_OUT=9, STOP_A=10, STOP_B=11, STOP_C=12,
    STOP_D=13, FREE=14;
  reg [3:0] state;
  reg [1:0] phase;
  reg [2:0] bit_count;
  reg [CW-1:0] divider;
  reg [6:0] address_latched;
  reg [7:0] data_latched;
  reg read_latched, address_byte;
  // Synchronizers isolate the FSM from asynchronous external bus inputs.
  (* ASYNC_REG="TRUE" *) reg scl_meta, scl_sync, sda_meta, sda_sync;
  wire tick = divider == DIV-1;
  wire tx_bit;
  wire [7:0] rx_shift;
  assign busy = state != IDLE;
  wire load_tx = state == LOAD_ADDR || state == LOAD_DATA;
  wire advance_tx = tick && state == TX && phase == 3;
  wire sample_rx = tick && state == RX && phase == 2 && scl_sync;
  wire wait_clock = (state==TX || state==RX || state==ACK_IN || state==ACK_OUT)
                    && phase==2 && !scl_sync;
  i2c_tx tx_unit(clk, rst, load_tx, advance_tx,
    state == LOAD_ADDR ? {address_latched,read_latched} : data_latched, tx_bit);
  i2c_rx rx_unit(clk, rst, state == LOAD_RX, sample_rx, sda_sync, rx_shift);

  always @(posedge clk) begin
    if (rst) begin
      scl_meta<=1; scl_sync<=1; sda_meta<=1; sda_sync<=1;
    end else begin
      scl_meta<=scl_i; scl_sync<=scl_meta;
      sda_meta<=sda_i; sda_sync<=sda_meta;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      state<=IDLE; phase<=0; bit_count<=0; divider<=0;
      scl_low<=0; sda_low<=0; done<=0; nack_error<=0;
      rx_data<=0; address_latched<=0; data_latched<=0;
      read_latched<=0; address_byte<=1;
    end else begin
      done<=0;
      // Restart the high-phase timer while the actual bus is still low.
      // This preserves a full high phase even after arbitrary stretching.
      if (tick || wait_clock) divider<=0; else divider<=divider+1'b1;
      if (state == IDLE) begin
        divider<=0;
        if (start && scl_sync && sda_sync) begin
          address_latched<=address; data_latched<=tx_data;
          read_latched<=read_cmd; nack_error<=0;
          address_byte<=1; phase<=0; state<=START_A;
        end
      end else if (state == LOAD_ADDR || state == LOAD_DATA) begin
        bit_count<=0; phase<=0; state<=TX;
      end else if (state == LOAD_RX) begin
        bit_count<=0; phase<=0; state<=RX;
      end else if (tick) begin
        case (state)
          START_A: begin sda_low<=1; state<=START_B; end
          START_B: if (phase==1) begin
            scl_low<=1; phase<=0; state<=LOAD_ADDR;
          end else phase<=1; // Hold START for two quarter periods.
          TX, RX: begin
            case (phase)
              0: begin
                scl_low<=1;
                sda_low <= (state == TX) ? !tx_bit : 1'b0;
                phase<=1;
              end
              1: begin scl_low<=0; phase<=2; end
              2: if (scl_sync) phase<=3; // Wait for clock stretching.
              3: begin
                scl_low<=1; phase<=0;
                if (bit_count == 7) begin
                  if (state == TX) state<=ACK_IN;
                  else begin rx_data<=rx_shift; state<=ACK_OUT; end
                end else bit_count<=bit_count+1'b1;
              end
            endcase
          end
          ACK_IN: begin
            case (phase)
              0: begin sda_low<=0; phase<=1; end
              1: begin scl_low<=0; phase<=2; end
              2: if (scl_sync) begin
                if (sda_sync) nack_error<=1;
                phase<=3;
              end
              3: begin
                scl_low<=1; phase<=0;
                if (nack_error || !address_byte) state<=STOP_A;
                else begin
                  address_byte<=0;
                  if (read_latched) state<=LOAD_RX;
                  else state<=LOAD_DATA;
                end
              end
            endcase
          end
          ACK_OUT: begin // NACK terminates a single-byte read.
            case (phase)
              0: begin sda_low<=0; phase<=1; end
              1: begin scl_low<=0; phase<=2; end
              2: if (scl_sync) phase<=3;
              3: begin scl_low<=1; phase<=0; state<=STOP_A; end
            endcase
          end
          STOP_A: begin scl_low<=1; sda_low<=1; state<=STOP_B; end
          STOP_B: begin scl_low<=0; state<=STOP_C; end
          STOP_C: if (scl_sync) state<=STOP_D;
          STOP_D: begin sda_low<=0; phase<=0; state<=FREE; end
          FREE: if (phase==1) begin state<=IDLE; done<=1; end
                else phase<=phase+1'b1;
          default: state<=IDLE;
        endcase
      end
    end
  end
endmodule
