#ifndef DESIGN_H
#define DESIGN_H

#include "systemc.h"

SC_MODULE(grey_counter) {
    // Ports
    sc_in<bool> clk_i;
    sc_in<bool> rst_i;
    sc_out<sc_uint<3>> led_o;

    // Internal state
    sc_uint<3> count_reg;

    void process() {
        // Asynchronous reset
        if (rst_i.read() == 1) {
            count_reg = 0;
        } 
        // Synchronous increment
        else if (clk_i.read() == 1) {
            count_reg = count_reg + 1;
        }
        
        sc_uint<3> grey;
        // Convert to Grey code
        grey[2] = count_reg[2];
        grey[1] = count_reg[1] ^ count_reg[2];
        grey[0] = count_reg[0] ^ count_reg[1];
        
        led_o.write(grey);
    }

    SC_CTOR(grey_counter) {
        SC_METHOD(process);
        // Trigger on positive edge of clock or any change of reset for async behavior
        sensitive << clk_i.pos() << rst_i; 
        count_reg = 0;
    }
};

#endif
