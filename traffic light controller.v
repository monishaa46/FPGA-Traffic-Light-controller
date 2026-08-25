module traffic_light_controller (
    input  wire clk,
    input  wire reset,
    input  wire emergency,

    output reg roadA_red,
    output reg roadA_yellow,
    output reg roadA_green,

    output reg roadB_red,
    output reg roadB_yellow,
    output reg roadB_green,

    output reg [1:0] state_debug
);

    // FSM states
    parameter A_GREEN  = 2'b00;
    parameter A_YELLOW = 2'b01;
    parameter B_GREEN  = 2'b10;
    parameter B_YELLOW = 2'b11;

    reg [1:0] state;
    reg [3:0] counter;

    // State machine
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            state   <= A_GREEN;
            counter <= 0;
        end

        else if (emergency) begin
            // Emergency vehicle priority
            state   <= B_GREEN;
            counter <= 0;
        end

        else begin

            case (state)

                A_GREEN: begin
                    if (counter == 4) begin
                        counter <= 0;
                        state <= A_YELLOW;
                    end
                    else
                        counter <= counter + 1;
                end

                A_YELLOW: begin
                    if (counter == 1) begin
                        counter <= 0;
                        state <= B_GREEN;
                    end
                    else
                        counter <= counter + 1;
                end

                B_GREEN: begin
                    if (counter == 4) begin
                        counter <= 0;
                        state <= B_YELLOW;
                    end
                    else
                        counter <= counter + 1;
                end

                B_YELLOW: begin
                    if (counter == 1) begin
                        counter <= 0;
                        state <= A_GREEN;
                    end
                    else
                        counter <= counter + 1;
                end

                default: begin
                    state <= A_GREEN;
                    counter <= 0;
                end

            endcase
        end
    end

    // Traffic light output decoder
    always @(*) begin

        // Turn all lights OFF first
        roadA_red    = 0;
        roadA_yellow = 0;
        roadA_green  = 0;

        roadB_red    = 0;
        roadB_yellow = 0;
        roadB_green  = 0;

        case (state)

            // Road A GREEN
            A_GREEN: begin
                roadA_green = 1;
                roadB_red   = 1;
            end

            // Road A YELLOW
            A_YELLOW: begin
                roadA_yellow = 1;
                roadB_red    = 1;
            end

            // Road B GREEN
            B_GREEN: begin
                roadA_red   = 1;
                roadB_green = 1;
            end

            // Road B YELLOW
            B_YELLOW: begin
                roadA_red    = 1;
                roadB_yellow = 1;
            end

            default: begin
                roadA_red = 1;
                roadB_red = 1;
            end

        endcase

    end

    // Make FSM state visible in waveform
    always @(*) begin
        state_debug = state;
    end

endmodule
