
module lif_datapath #(
    parameter int WIDTH = 16,
    parameter logic signed [WIDTH-1:0] threshold = 16'sd4096,
    parameter int leakFactor = 4
)(
    input  logic signed [WIDTH-1:0] membrane_in,
    input  logic signed [WIDTH-1:0] current_in,

    output logic signed [WIDTH-1:0] membrane_next,
    output logic                    spike
);

    localparam int extWidth = WIDTH + 2;

    localparam logic signed [WIDTH-1:0] maxPotential =
        {1'b0, {(WIDTH-1){1'b1}}};

    localparam logic signed [WIDTH-1:0] minPotential =
        {1'b1, {(WIDTH-1){1'b0}}};

    logic signed [extWidth-1:0] membrane_ext;
    logic signed [extWidth-1:0] current_ext;
    logic signed [extWidth-1:0] leak;
    logic signed [extWidth-1:0] candidate;

    localparam logic signed [extWidth-1:0] maxExt =
        {{(extWidth-WIDTH){maxPotential[WIDTH-1]}}, maxPotential};

    localparam logic signed [extWidth-1:0] minEXT =
        {{(extWidth-WIDTH){minPotential[WIDTH-1]}}, minPotential};

    localparam logic signed [extWidth-1:0] threshold_EXT =
        {{(extWidth-WIDTH){threshold[WIDTH-1]}}, threshold};

    always_comb begin
        membrane_ext = {{(extWidth-WIDTH){membrane_in[WIDTH-1]}}, membrane_in};
        current_ext  = {{(extWidth-WIDTH){current_in[WIDTH-1]}}, current_in};

        leak = membrane_ext >>> leakFactor;

        candidate = membrane_ext + current_ext - leak;

        spike = 1'b0;
        membrane_next = '0;

        if (candidate >= threshold_EXT) begin
            spike = 1'b1;
            membrane_next = '0;
        end
        else if (candidate > maxExt) begin
            membrane_next = maxPotential;
        end
        else if (candidate < minEXT) begin
            membrane_next = minPotential;
        end
        else begin
            membrane_next = candidate[WIDTH-1:0];
        end
    end

endmodule
