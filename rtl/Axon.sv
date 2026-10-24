module axon #(
    parameter int numNeurons = 16,
    parameter int ID_WIDTH =
        (numNeurons > 1) ? $clog2(numNeurons) : 1
)(
    input  logic spike,
    input  logic [ID_WIDTH-1:0] neuronID,

    output logic spikeValid,
    output logic [ID_WIDTH-1:0] spikeNeuronID
);

// doesn't do any processing yet, but can be extended in the future for more complex axon behavior

    assign spikeValid = spike;
    assign spikeNeuronID = neuronID;

endmodule