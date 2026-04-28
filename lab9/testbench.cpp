#include "systemc.h"
#include "design.h"
#include <iostream>

int sc_main(int argc, char* argv[]) {
    // Signals
    sc_signal<bool> clk_i;
    sc_signal<bool> rst_i;
    sc_signal<sc_uint<3>> led_o;

    // Instantiate Design Under Test
    grey_counter dut("DUT");
    dut.clk_i(clk_i);
    dut.rst_i(rst_i);
    dut.led_o(led_o);

    // VCD Trace File
    sc_trace_file *wf = sc_create_vcd_trace_file("wave");
    wf->set_time_unit(1, SC_US);
    sc_trace(wf, clk_i, "clk_i");
    sc_trace(wf, rst_i, "rst_i");
    sc_trace(wf, led_o, "led_o");

    // --- Start of Testbench ---
    
    // Initial state
    clk_i = 0;
    rst_i = 0;
    sc_start(1, SC_US);

    cout << "@" << sc_time_stamp() << " Starting TEST 1: Stable clock incrementation and overflow" << endl;
    rst_i = 1;
    sc_start(100, SC_MS);
    rst_i = 0;

    for (int i = 0; i <= 8; i++) {
        clk_i = 1; sc_start(10, SC_MS);
        clk_i = 0; sc_start(90, SC_MS);
    }
    
    cout << "@" << sc_time_stamp() << " Starting TEST 2: Stable clock and reset in the middle" << endl;
    for (int i = 0; i <= 4; i++) {
        clk_i = 1; sc_start(10, SC_MS);
        clk_i = 0; sc_start(90, SC_MS);
    }
    
    // Assuming we click reset in the middle of the clk_i = 1 pulse
    clk_i = 1; sc_start(5, SC_MS);  
    
    rst_i = 1; sc_start(5, SC_MS); // Reset pressed
    clk_i = 0; sc_start(90, SC_MS);
    
    rst_i = 0; // Reset released
    
    for (int i = 0; i <= 4; i++) {
        clk_i = 1; sc_start(10, SC_MS);
        clk_i = 0; sc_start(90, SC_MS);
    }
    
    cout << "@" << sc_time_stamp() << " Starting TEST 3: Bouncing clock" << endl;
    for (int i = 0; i <= 8; i++) {
        // Simulate bouncing
        for (int j = 0; j <= 50; j++) {
            clk_i = 1; sc_start(10, SC_US);
            clk_i = 0; sc_start(10, SC_US);
        }
        clk_i = 1; sc_start(5, SC_MS); // Stabilisation
        clk_i = 0; sc_start(90, SC_MS);
    }
    
    sc_start(10, SC_MS);
    cout << "@" << sc_time_stamp() << " Terminating simulation" << endl;

    // Close trace file
    sc_close_vcd_trace_file(wf);

    return 0;
}
