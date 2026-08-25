`timescale 1ns/1ps

module traffic_light_controller_tb;

    reg clk;
    reg reset;
    reg emergency;

    wire roadA_red;
    wire roadA_yellow;
    wire roadA_green;

    wire roadB_red;
    wire roadB_yellow;
    wire roadB_green;

    wire [1:0] state_debug;

    // Connect the controller
    traffic_light_controller DUT (
        .clk(clk),
        .reset(reset),
        .emergency(emergency),

        .roadA_red(roadA_red),
        .roadA_yellow(roadA_yellow),
        .roadA_green(roadA_green),

        .roadB_red(roadB_red),
        .roadB_yellow(roadB_yellow),
        .roadB_green(roadB_green),

        .state_debug(state_debug)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Initial conditions
        clk = 0;
        reset = 1;
        emergency = 0;

        // Reset
        #20;
        reset = 0;

        // Normal traffic operation
        #100;

        // Emergency vehicle arrives
        emergency = 1;

        #30;

        // Emergency vehicle leaves
        emergency = 0;

        // Continue normal operation
        #100;

        $finish;

    end

    // Print simulation values
    initial begin

        $monitor(
            "TIME=%0t | RESET=%b | EMERGENCY=%b | STATE=%b | A_RED=%b A_YELLOW=%b A_GREEN=%b | B_RED=%b B_YELLOW=%b B_GREEN=%b",
            $time,
            reset,
            emergency,
            state_debug,
            roadA_red,
            roadA_yellow,
            roadA_green,
            roadB_red,
            roadB_yellow,
            roadB_green
        );

    end

    // Create waveform
    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, traffic_light_controller_tb);
    end

endmodule
