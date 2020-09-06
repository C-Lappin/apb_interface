# apb_interface

This is a APB slave interface that was created to aid in learning of:
1. using Symbiyosys (Formal Proofs).
2. Using iverilog (for simulation of testbenches).
3. Using verilator.

Each of the command line commands will be scripted in the future.

# Formal Tools

The formal tools used to test the APB slave interface are Symbiyosys. 
For more information on Symbiyosys, please see the [Documentation](https://symbiyosys.readthedocs.io/en/latest/).
Basic commands for running the formal proof.

sby -f apb_if.sby 

# Using iverilog
Basic commands to run the testbench using iverilog.

iverilog -o dut0.vvp apb_if.v apb_if_tb.v
vvp dut0.vvp

# Using GTKWave
Basic command to open the VCD created by iverilog.
gtkwave example.vcd