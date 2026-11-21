`timescale 1ns/1ps
// Independent behavioral target: bus edges, not internal DUT states.
module tb_i2c;
  reg clk=0, rst=1, start=0, read_cmd=0;
  reg [6:0] address=7'h50;
  reg [7:0] tx_data=0;
  tri1 scl, sda; // Ideal pull-ups in the digital model.
  reg target_low=0, stretch_low=0;
  assign sda = target_low ? 1'b0 : 1'bz;
  assign scl = stretch_low ? 1'b0 : 1'bz;
  wire busy, done, nack_error;
  wire [7:0] rx_data;
  integer passed=0, case_id=0, clocks_seen=0;
  reg [7:0] observed_address, observed_data;
  reg observed_nack;
  time fall_time=0, rise_time=0;
  reg measure=0;
  time start_time=0, stop_time=0;
  reg start_pending=0;
  i2c_top dut(clk,rst,start,read_cmd,address,tx_data,
    scl,sda,busy,done,nack_error,rx_data);
  always #10 clk=~clk; // 50 MHz

  task check;
    input condition;
    input [511:0] message;
    begin
      if (condition !== 1'b1) begin
        $display("FAIL case=%0d: %0s",case_id,message); $fatal(1);
      end
    end
  endtask
  task get_byte;
    output [7:0] value;
    integer k;
    begin
      for(k=7;k>=0;k=k-1) begin
        @(posedge scl); #1; value[k]=sda;
      end
    end
  endtask
  task target_ack;
    input enable_ack;
    begin
      @(negedge scl); target_low=enable_ack;
      @(posedge scl); @(negedge scl); target_low=0;
    end
  endtask
  task put_byte;
    input [7:0] value;
    integer k;
    begin
      for(k=7;k>=0;k=k-1) begin
        target_low=!value[k];
        @(posedge scl); @(negedge scl);
      end
      target_low=0;
      @(posedge scl); #1; observed_nack=sda;
      @(negedge scl);
    end
  endtask
  task target_transaction;
    input rd, ack_addr, ack_data;
    input [7:0] returned_data;
    begin
      @(negedge sda); check(scl===1'b1,"START while SCL high");
      get_byte(observed_address);
      target_ack(ack_addr);
      if (ack_addr) begin
        if (rd) put_byte(returned_data);
        else begin get_byte(observed_data); target_ack(ack_data); end
      end
      // Releasing an ACK may also raise SDA while SCL is low.
      // Only a rising SDA with SCL high denotes STOP.
      @(posedge sda);
      while (scl!==1'b1) @(posedge sda);
    end
  endtask
  task launch;
    input rd;
    input [7:0] value;
    begin
      @(negedge clk); read_cmd=rd; tx_data=value; start=1;
      @(negedge clk); start=0;
      wait(done); #1;
      check(!busy,"busy clears when done");
      check(scl===1'b1 && sda===1'b1,"bus idle after STOP");
      @(posedge clk); #1; check(!done,"done is one clock pulse");
    end
  endtask
  task run_case;
    input rd, ack_addr, ack_data, stretch;
    input [7:0] value;
    begin
      case_id=case_id+1; clocks_seen=0;
      observed_data=0; observed_address=0; observed_nack=0;
      measure=1;
      fork
        target_transaction(rd,ack_addr,ack_data,value);
        launch(rd,value);
        begin
          if(stretch) begin
            @(negedge scl); stretch_low=1;
            #17000; stretch_low=0;
          end
        end
      join
      measure=0;
      check(observed_address=={7'h50,rd},"address and R/W bit");
      check(nack_error==(!ack_addr || (!rd && !ack_data)),"NACK flag");
      if(ack_addr && rd) begin
        check(rx_data==value,"received byte");
        check(observed_nack,"controller NACK after final read byte");
      end
      if(ack_addr && !rd) check(observed_data==value,"transmitted byte");
      // 9 address clocks, optionally 9 data clocks, and STOP's rising edge.
      check(clocks_seen==(ack_addr ? 19 : 10),"number of SCL rising edges");
      passed=passed+1;
      $display("PASS %0d rd=%0b data=%02h ack_addr=%0b ack_data=%0b stretch=%0b time_ps=%0t",
        case_id,rd,value,ack_addr,ack_data,stretch,$time);
      #10000;
    end
  endtask
  // Check physical low/high durations on every ordinary SCL pulse.
  always @(negedge scl) begin
    if(measure && start_pending) begin
      check($time-start_time>=4000,"START hold >= 4 us");
      start_pending=0;
    end
    if(measure && rise_time!=0)
      check($time-rise_time>=4000,"tHIGH >= 4 us");
    fall_time=$time;
  end
  always @(posedge scl) begin
    if(measure) begin
      clocks_seen=clocks_seen+1;
      check($time-fall_time>=4700,"tLOW >= 4.7 us");
    end
    rise_time=$time;
  end
  always @(negedge sda) if(measure && scl===1'b1) begin
    if(stop_time!=0) check($time-stop_time>=4700,"bus free >= 4.7 us");
    start_time=$time; start_pending=1;
  end
  always @(posedge sda) if(measure && scl===1'b1) begin
    check($time-rise_time>=4000,"STOP setup >= 4 us");
    stop_time=$time;
  end
  initial begin
    $dumpfile("results/i2c.vcd"); $dumpvars(0,tb_i2c);
    #200; @(negedge clk); rst=0;
    #200;
    run_case(0,1,1,0,8'hA5);
    run_case(0,1,1,0,8'h00);
    run_case(0,1,1,0,8'hFF);
    run_case(0,1,1,0,8'h5A);
    run_case(1,1,1,0,8'h3C);
    run_case(1,1,1,0,8'h00);
    run_case(1,1,1,0,8'hFF);
    run_case(0,0,1,0,8'hA5); // Address NACK: abort before data.
    run_case(0,1,0,0,8'h96); // Data NACK: report error and STOP.
    run_case(1,1,1,1,8'hC3); // Target stretches first SCL low phase.
    // Ignore a new start request while busy; command data is latched.
    case_id=case_id+1;
    fork
      target_transaction(0,1,1,0);
      launch(0,8'h69);
      begin
        wait(busy); #30000;
        @(negedge clk); tx_data=8'h12; address=7'h42; start=1;
        @(negedge clk); start=0;
      end
    join
    check(observed_address==8'hA0 && observed_data==8'h69,
      "busy ignores new command and preserves latched inputs");
    passed=passed+1; $display("PASS %0d busy command ignored",case_id);
    address=7'h50;
    // Reset in the middle of a frame releases both open-drain pins.
    case_id=case_id+1;
    @(negedge clk); start=1;
    @(negedge clk); start=0;
    #30000; @(negedge clk); rst=1;
    @(posedge clk); #1;
    check(!busy && !done && !nack_error && scl && sda,"reset during transfer");
    @(negedge clk); rst=0;
    passed=passed+1; $display("PASS %0d reset during frame",case_id);
    #200;
    run_case(0,1,1,0,8'h81); // Recovery after reset.
    $display("ALL PASS: %0d scenarios",passed); $finish;
  end
  initial begin #10000000; $display("FAIL watchdog timeout"); $fatal(1); end
endmodule
