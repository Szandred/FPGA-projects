# FPGA-projects
Personal FPGA/verilog projects using a Sipeed Tang Nano 9K.


## 1-button-counter 
Contains a 6-bit binary counter with the Sipeed Tang Nano 9k's 6 on-board LEDs with button controls.
- 27 MHz clock divided to increment count twice per second
- btn1: pauses and resumes using rising-edge detection
- btn2: resets count to zero


## 2-button-testbench
Contains a self-checkiing testbench for the button counter found in "1-button-counter." 
Includes 6 test each with PASS/FAIL scenarios. Each test was verified by initially running the working program 
and then including bugs in the initial code to check for FAILS. Below are some simulation expectations:

| Test | Scenario | Expected result |
| 1 | Normal operation | Count increments |
| 2 | Press button 1 | Pauses and count stays frozen |
| 3 | Press button 1 again | Resumes from the same count |
| 4 | Hold button 1 for a long time | Toggles only once (edge detection) so no change|
| 5 | Press button 2 while paused | Count resets to 0, stays paused |
