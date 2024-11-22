# FlowAC Project

This repository contains the code to calculate power flow using the Newton-Raphson method. Below is a description of the included files and how to run the project.

## Files

- **CalcFlow.m**: Core function for calculating power flows.
- **CalcJcob.m**: Calculates the Jacobian matrix.
- **DispAll.m**: Displays all data related to the power flow.
- **DispResults.m**: Displays the results of the power flow calculation.
- **GetPQesp.m**: Handles the calculation of power mismatches.
- **Main.m**: Main script to execute the power flow calculations.
- **MakeYBus.m**: Creates the system's Y-Bus matrix.
- **ReadData.m**: Reads input data from a text file.
- **dados_sistema13B_EC1.txt**: Example input data for a 13-bus system.

## How to Run

1. Add your system data in a `.txt` file in the same format as `dados_sistema13B_EC1.txt`.
2. Run the script `Main.m` in MATLAB.
3. The results of the power flow calculation will be displayed.

Feel free to modify the example data file to adapt it to your system.

---
