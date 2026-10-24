module dendrite #(
    parameter WIDTH = 16,
    parameter leakFactor = 4, // 1 - 2^-4 = 15/16
    parameter logic signed [WIDTH-1:0] threshold = 16'sd4096
)(
input logic clock,
input logic reset,
input logic signed [WIDTH-1:0]inputCurrent,
output logic signed [WIDTH-1:0]newMembranePotential,
output logic signed [WIDTH-1:0]debug_membranePotential,
output logic spike
);

reg signed [WIDTH-1:0] membranePotential;

wire signed [WIDTH+1:0] currentComputation = membranePotential + inputCurrent - (membranePotential >>> leakFactor);
wire pos_overflow = !currentComputation[WIDTH+1] && (|currentComputation[WIDTH:WIDTH-1]);
wire neg_underflow = currentComputation[WIDTH+1] && !( &currentComputation[WIDTH:WIDTH-1]);
// V[t+1] = V[t] + I[t] - (2^-k)V[t]
assign newMembranePotential = (pos_overflow) ? {1'b0, {(WIDTH-1){1'b1}}} : neg_underflow ? {1'b1, {(WIDTH-1){1'b0}}} : currentComputation[WIDTH-1:0];
assign debug_membranePotential = membranePotential;

always_ff @(posedge clock or posedge reset) begin
    // update membrane potential
    if (reset) begin
        membranePotential <= {WIDTH{1'b0}};
        spike <= '0;
    end
    else if (update) begin
        if (currentComputation >= threshold) begin
            spike <= 1'b1; // generate spike
            membranePotential <= '0; // reset membrane potential after spike
        end else begin
            membranePotential <= newMembranePotential;
            spike <= 1'b0; // no spike
        end
    end
    else begin
        spike <= 1'b0;
    end
end
endmodule