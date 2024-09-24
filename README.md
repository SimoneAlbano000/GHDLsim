### GHDLsim - Fast VHDL testbench simulation for Windows

The GHDLsim script is a tool that automate the process of running VHDL testbenches under a Windows enviroment.
The script needs to be placed in the same folder that contains the main VHDL testbench file. All the VHDL Component files
that are imported in the testbench will be automatically linked and compiled to the current project 
(VHDL Component files can also be placed inside additional subfolders).

## Script requirements

In order to function correctly, the script needs the GHDL simulation software and the GTKWave signal visualizer to be installed.
They can be installed under the Windows enviroment using the MSYS2 tool, that can be found at the following link: https://www.msys2.org/  
Once the MSYS2 software has been installed correctly, the script will automatically download and install all the required packages.

## How to use GHDLsim

In order to start the simulation, the name of the file containing the testbench code needs to be supplied (without the .vhd extension) along with 
the simulation time expressed in microsecond. If the code contains no errors, GTKWave will automatically open allowing the user to inspect all the signals.
