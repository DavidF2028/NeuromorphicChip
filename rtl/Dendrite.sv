module dendrite #(
    parameter WIDTH = 16,
    parameter leakFactor = 4, // 1 - 2^-4 = 15/16
    parameter logic signed [WIDTH-1:0] threshold = 16'sd4096,
    parameter int numNeurons = 16,
    parameter int ID_WIDTH = (numNeurons > 1) ? $clog2(numNeurons) : 1
)(
input logic clock,
input logic reset,
input logic signed [WIDTH-1:0]inputCurrent,
output logic signed [WIDTH-1:0]newMembranePotential,
output logic [ID_WIDTH-1:0] neuronID,
output logic spike
);



logic signed [WIDTH-1:0] membMemory [0:numNeurons-1];
logic signed [WIDTH-1:0] currentMemory [0:numNeurons-1];
logic [ID_WIDTH-1:0] currentNeuronID;

logic signed [WIDTH-1:0] nextMemb;
logic neurSpike;

lif_datapath #(
    .WIDTH(WIDTH),
    .leakFactor(leakFactor),
    .threshold(threshold)
) lif (
    .membrane_in   (membMemory[currentNeuronID]),
    .current_in    (currentMemory[currentNeuronID]),
    .membrane_next (nextMemb),
    .spike         (neurSpike)
);

always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < numNeurons; i++) begin
            membMemory[i] <= '0;
            currentMemory[i] <= '0;
        end
        neuronID <= '0;
        newMembranePotential <= '0;
        spike <= '0;
        currentNeuronID <= '0;
    end else begin
        // update neuron
        membMemory[currentNeuronID] <= nextMemb;
        currentMemory[currentNeuronID] <= inputCurrent;

        // next index
        if (currentNeuronID == numNeurons - 1)
            currentNeuronID <= '0;
        else
            currentNeuronID <= currentNeuronID + 1'b1;

        // Output the membrane potential and spike of the current neuron
        newMembranePotential <= nextMemb;
        spike <= neurSpike;
        neuronID <= currentNeuronID;
    end
end
endmodule