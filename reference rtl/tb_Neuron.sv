module tb_neuron ();
reg clock;
reg reset;
reg update;
reg signed [15:0]inputCurrent;
wire signed [15:0]newMembranePotential;
wire signed [15:0]debug_membranePotential;
wire spike;


neuron dut(
    .clock(clock),
    .reset(reset),
    .update(update),
    .inputCurrent(inputCurrent),
    .newMembranePotential(newMembranePotential),
    .debug_membranePotential(debug_membranePotential),
    .spike(spike)
); 

always #10 clock = ~clock; // 50 MHz

initial begin
    
    clock = 0;
    reset = 1;
    update = 0;
    inputCurrent = 0;

    #20 reset = 0; // Release reset after 20 time units

    // Apply some test inputs
    #20 inputCurrent = 16'sd100; // Apply a positive current
    #40 update = 1; // Trigger an update
    #20 update = 0; // Release update

    #40 inputCurrent = -16'sd50; // Apply a negative current
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update

    #40 inputCurrent = 16'sd5000; // Apply a large positive current to trigger spike
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update
    
    #40 inputCurrent = 16'sd0; // No current
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update

    #20 inputCurrent = 16'sd100; // Apply a positive current
    #40 update = 1; // Trigger an update
    #20 update = 0; // Release update

    #40 inputCurrent = -16'sd2000; // Apply a negative current
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update

    #40 inputCurrent = -16'sd30000; // Apply a negative current
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update

    #40 inputCurrent = 16'sd0; // No current
    #40 update = 1; // Trigger another update
    #20 update = 0; // Release update


    #100 $finish; // End simulation after some time
end
endmodule