module Synapse #(
    parameter int numNeurons = 16,
    parameter int ID_WIDTH =
        (numNeurons > 1) ? $clog2(numNeurons) : 1,
    parameter int CURRENT_WIDTH = 16,
    parameter int WEIGHT_WIDTH = 16,
    parameter int maxConnections = 4
)(
    input logic clock,
    input logic reset,

    input logic [maxConnections-1:0] spikeValid,
    input logic [ID_WIDTH-1:0] spikeNeuronID,
    
    output logic spikeReady,
    output logic [ID_WIDTH-1:0] currentDestID,
    output logic signed [CURRENT_WIDTH-1:0] currentWeight
);

    logic [ID_WIDTH-1:0] destMemory [0:numNeurons-1][0:maxConnections-1];
    logic signed [WEIGHT_WIDTH-1:0] weightMemory [0:numNeurons-1][0:maxConnections-1];

    always_comb begin
        if (spikeValid) begin
            // Generate a fixed synaptic current for demonstration purposes
            synapticCurrent = 16'sd100; // Example fixed current value
        end else begin
            synapticCurrent = 16'sd0; // No current if no spike
        end
    end

endmodule