module Synapse #(
    parameter int numNeurons = 16,
    parameter int ID_WIDTH =
        (numNeurons > 1) ? $clog2(numNeurons) : 1
)(
    input  logic spikeValid,
    input  logic [ID_WIDTH-1:0] spikeNeuronID,

    output logic signed [15:0] synapticCurrent
);

    // For now, we will just generate a fixed synaptic current for each spike event.
    // In a more complex implementation, this could be based on synaptic weights, delays, etc.


    always_comb begin
        if (spikeValid) begin
            // Generate a fixed synaptic current for demonstration purposes
            synapticCurrent = 16'sd100; // Example fixed current value
        end else begin
            synapticCurrent = 16'sd0; // No current if no spike
        end
    end

endmodule