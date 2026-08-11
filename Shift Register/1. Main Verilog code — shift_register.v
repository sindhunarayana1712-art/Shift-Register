module shift_register (
    input  wire       clk,
    input  wire       reset,
    input  wire       serial_in,
    output wire       serial_out,
    output reg  [3:0] q
);

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            q <= 4'b0000;
        end

        else begin
            q <= {q[2:0], serial_in};
        end

    end

    assign serial_out = q[3];

endmodule