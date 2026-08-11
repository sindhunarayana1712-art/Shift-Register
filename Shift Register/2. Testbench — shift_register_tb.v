`timescale 1ns/1ps

module shift_register_tb;

    reg clk;
    reg reset;
    reg serial_in;

    wire serial_out;
    wire [3:0] q;

    integer errors;

    // Instantiate Shift Register
    shift_register uut (
        .clk       (clk),
        .reset     (reset),
        .serial_in (serial_in),
        .serial_out(serial_out),
        .q         (q)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Send one bit
    task send_bit;
        input bit_value;

        begin
            serial_in = bit_value;
            @(posedge clk);
            #1;

            $display(
                "Input = %b | Register = %b | Serial Out = %b",
                serial_in,
                q,
                serial_out
            );
        end
    endtask

    initial begin

        // Waveform generation
        $dumpfile("waveform.vcd");
        $dumpvars(0, shift_register_tb);

        clk       = 0;
        reset     = 1;
        serial_in = 0;
        errors    = 0;

        $display("==========================================");
        $display("        SHIFT REGISTER SIMULATION");
        $display("==========================================");

        // Reset
        #10;
        reset = 0;

        // --------------------------------
        // Send data: 1 0 1 1
        // --------------------------------

        $display("");
        $display("Sending data: 1011");
        $display("");

        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        #10;

        // Check final register value
        if (q == 4'b1011) begin
            $display("PASS: Final register value = %b", q);
        end

        else begin
            $display(
                "FAIL: Expected = 1011, Received = %b",
                q
            );

            errors = errors + 1;
        end

        // --------------------------------
        // Send another pattern
        // --------------------------------

        $display("");
        $display("Sending data: 0101");
        $display("");

        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);

        #10;

        if (q == 4'b0101) begin
            $display("PASS: Final register value = %b", q);
        end

        else begin
            $display(
                "FAIL: Expected = 0101, Received = %b",
                q
            );

            errors = errors + 1;
        end

        // --------------------------------
        // Final result
        // --------------------------------

        #10;

        $display("");
        $display("------------------------------------------");

        if (errors == 0)
            $display("ALL SHIFT REGISTER TESTS PASSED!");
        else
            $display(
                "SHIFT REGISTER TESTS FAILED: %0d errors",
                errors
            );

        $display("------------------------------------------");

        $finish;

    end

endmodule