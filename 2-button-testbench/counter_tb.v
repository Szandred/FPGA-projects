`default_nettype none // find typo

module test; // testbench module; creates "fake" wires and uses these to digitally test the system
    reg clk = 0; 
    reg btn1 = 1;
    reg btn2 = 1;
    wire [5:0] led;

// make a copy of the counter and make it count fast
    top #(.WAIT_TIME(4)) dut ( 
        .clk(clk),
        .btn1(btn1),
        .btn2(btn2),
        .led(led)
    );

always #1 clk = ~clk; // constantly run clock 0, 1, 0, 1, ... every 1 time unit


initial begin
    $dumpfile("counter.vcd");
    $dumpvars(0, test);


// test 1
#100; // let it run 100 time units without doing anything

// test 2
    btn1 = 0; // press button 1 (pause)
    #4; // wait
    btn1 = 1; // let go (active low)
    #100; // run 100 time units -- stays frozen
    

// test 3: same as 2 but this should resume the count
btn1 = 0; // press button 1 (resume)
#4;
btn1 = 1;
#100; // run 100 time units -- running


// test 4 press the button to pause and hold it for a while which shouldn't do anything since its a toggle
btn1 = 0;
#200;
btn1 = 1;
#50;

// test 5: preses btn2 (still pause) should just reset to 0 and stay 0
btn2 = 0;
#4;
btn2 = 1;
#50;

btn1 = 0; // press to unpause
#4;
btn1 = 1;

#700;

$finish;
end



endmodule
