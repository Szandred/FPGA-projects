`default_nettype none // find typo

module test; // testbench module; creates "fake" wires and uses these to digitally test the system
    reg clk = 0; 
    reg btn1 = 1;
    reg btn2 = 1;
    wire [5:0] led;
    reg[5:0] saved;

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
if (dut.ledCounter === 0)
    $display("FAIL: counter never went up");
else
    $display("PASS: counter is %d at", dut.ledCounter);

// test 2
    btn1 = 0; // press button 1 (pause)
    #4; // wait
    btn1 = 1; // let go (active low)
    saved = dut.ledCounter; // save the current count
    #100; // run 100 time units -- stays frozen
    if (dut.paused !== 1)
    $display("FAIL: counter should be paused but isn't");
    else if ( dut.ledCounter !== saved)
    $display("FAIL Test 2: count changed while paused (%0d -> %0d)", saved, dut.ledCounter); 
    else 
    $display("PASS Test 2: paused, count stayed at %0d", saved);  
    

// test 3: same as 2 but this should resume the count
btn1 = 0; // press button 1 (resume)
#4;
btn1 = 1;
saved = dut.ledCounter; // save the current count
#100; // run 100 time units -- running
if (dut.paused !== 0) 
$display("FAIL Test 3: expected paused = 0, got %b", dut.paused); 
else if (dut.ledCounter === saved) 
$display("FAIL Test 3: count did not change after resuming"); 
else 
$display("PASS Test 3: resumed, count went %0d -> %0d", saved, dut.ledCounter);


// test 4 press the button to pause and hold it for a while which shouldn't do anything since its a toggle
btn1 = 0;
#4;
saved = dut.ledCounter; // save the current count
#196;
btn1 = 1;
#50;
if (dut.paused !== 1) 
$display("FAIL Test 4: expected paused = 1 after long hold, got %b", dut.paused); 
else if (dut.ledCounter !== saved) 
$display("FAIL Test 4: count changed during hold (%0d -> %0d)", saved, dut.ledCounter); 
else 
$display("PASS Test 4: toggled once, count stayed at %0d", saved);

// test 5: preses btn2 (still pause) should just reset to 0 and stay 0
btn2 = 0;
#4;
btn2 = 1;
#50;
if (dut.ledCounter !== 0) 
$display("FAIL Test 5: expected count = 0 after reset, got %0d", dut.ledCounter); 
else if (dut.paused !== 1) 
$display("FAIL Test 5: expected still paused after reset, got paused = %b", dut.paused); 
else 
$display("PASS Test 5: reset to 0 and still paused");

btn1 = 0; // press to unpause
#4;
btn1 = 1;

#700;

$finish;
end



endmodule
