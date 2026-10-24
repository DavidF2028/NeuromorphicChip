
module lif_datapath #(
    parameter int WIDTH = 16,
    parameter logic signed [WIDTH-1:0] THRESHOLD = 16'sd4096,
    parameter int LEAK_FACTOR = 4
)(
    input  logic signed [WIDTH-1:0] membrane_in,
    input  logic signed [WIDTH-1:0] current_in,

    output logic signed [WIDTH-1:0] membrane_next,
    output logic                    spike
);

    localparam int EXT_WIDTH = WIDTH + 2;

    localparam logic signed [WIDTH-1:0] MAX_POTENTIAL =
        {1'b0, {(WIDTH-1){1'b1}}};

    localparam logic signed [WIDTH-1:0] MIN_POTENTIAL =
        {1'b1, {(WIDTH-1){1'b0}}};

    logic signed [EXT_WIDTH-1:0] membrane_ext;
    logic signed [EXT_WIDTH-1:0] current_ext;
    logic signed [EXT_WIDTH-1:0] leak;
    logic signed [EXT_WIDTH-1:0] candidate;

    localparam logic signed [EXT_WIDTH-1:0] MAX_EXT =
        {{(EXT_WIDTH-WIDTH){MAX_POTENTIAL[WIDTH-1]}}, MAX_POTENTIAL};

    localparam logic signed [EXT_WIDTH-1:0] MIN_EXT =
        {{(EXT_WIDTH-WIDTH){MIN_POTENTIAL[WIDTH-1]}}, MIN_POTENTIAL};

    localparam logic signed [EXT_WIDTH-1:0] THRESHOLD_EXT =
        {{(EXT_WIDTH-WIDTH){THRESHOLD[WIDTH-1]}}, THRESHOLD};

    always_comb begin
        membrane_ext = {{(EXT_WIDTH-WIDTH){membrane_in[WIDTH-1]}}, membrane_in};
        current_ext  = {{(EXT_WIDTH-WIDTH){current_in[WIDTH-1]}}, current_in};

        leak = membrane_ext >>> LEAK_FACTOR;

        candidate = membrane_ext + current_ext - leak;

        spike = 1'b0;
        membrane_next = '0;

        if (candidate >= THRESHOLD_EXT) begin
            spike = 1'b1;
            membrane_next = '0;
        end
        else if (candidate > MAX_EXT) begin
            membrane_next = MAX_POTENTIAL;
        end
        else if (candidate < MIN_EXT) begin
            membrane_next = MIN_POTENTIAL;
        end
        else begin
            membrane_next = candidate[WIDTH-1:0];
        end
    end

endmodule
