`default_nettype none

module top #(
    parameter WAIT_TIME = 13500000
)(
    input clk,
    input btn1,
    input btn2,
    output [5:0] led
);

 // localparam WAIT_TIME = 13500000; // TANG NANO 9k has 27 MHz clock frequency so to to wait half a second we delay by 27MHz / 2
reg [5:0] ledCounter = 0;
reg [23:0] clockCounter = 0; // need 24 bits to get up to 13.5Mhz
reg paused = 0;
reg btn1_previous = 1;
always @(posedge clk) begin // trigger on rising edge ( 0 --> 1)
    btn1_previous <= btn1;

    if (btn1_previous == 1 && btn1 == 0) // when button 1 is pressed (since it will be 1 previously and then btn1 which is the current state will be 0)
        paused <= ~paused; // toggle pause on/off

    if(btn2 == 0) begin // if button 2 is pressed then reset count
        ledCounter <= 0;
        clockCounter <= 0;
    end
    else begin
        if (paused == 0) begin
        // if (btn1 == 1) begin if button is NOT pressed (active low) continue and increment LEDs
        clockCounter <= clockCounter + 1;
            if (clockCounter == WAIT_TIME) begin
            clockCounter <= 0;
            ledCounter <= ledCounter + 1;
            end
        end
    end
end

assign led = ~ledCounter;

endmodule
