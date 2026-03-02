# Quadrotor UAV: Robust Control under Aerodynamic Disturbances

![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)
![Simulink](https://img.shields.io/badge/Simulink-Simulation-orange.svg)
![Control Theory](https://img.shields.io/badge/Control_Theory-Nonlinear-success.svg)

## Project Overview
This repository contains the MATLAB/Simulink implementation of advanced nonlinear control strategies for a Quadrotor Unmanned Aerial Vehicle (UAV). The project focuses on evaluating trajectory tracking performance and robustness against severe parametric uncertainties (**+40% unmodeled mass**) and complex aerodynamic disturbances (**Ground Effect** and **Ceiling Effect**).

## Key Features
* **Modular Cascade Architecture:** The control system is explicitly divided into an Outer Loop (Translational Dynamics / Position) and an Inner Loop (Rotational Dynamics / Attitude) for all implemented controllers.
* **Aerodynamic Disturbance Modeling:** Explicit MATLAB functions simulating nonlinear thrust variations near boundaries. Both Ground and Ceiling effects have been mathematically modeled following the formulations and guidelines presented in the "Field and Service Robotics" course slides by Prof. Ruggiero.
* **Comparative Control Analysis:** Implementation and direct comparison of four distinct control strategies.

## Implemented Control Strategies
1. **Geometric Controller (Static Control):** A baseline feedforward-feedback controller lacking adaptive mechanisms.
2. **Standard Vectorial Backstepping (BS):** A nonlinear Lyapunov-based controller utilizing nominal model parameters.
3. **Integral Backstepping (IBS):** An augmented Backstepping approach incorporating integral action ($\int e_p dt$) to estimate and compensate for slowly varying uncertainties.
4. **Sliding Mode Control (SMC):** A highly robust variable structure controller. Implemented as a *Quasi-Sliding Mode* utilizing a continuous boundary layer (`tanh`) to mitigate chattering while ensuring instantaneous disturbance rejection.

## Files Description
Below is the complete list of the files included in this repository and their specific roles:

### MATLAB Scripts (Initialization & Post-Processing)
* **`setup_mission.m`**: The main initialization script. It loads the UAV's physical parameters (nominal mass, inertia matrix), tuning gains, aerodynamic coefficients, and generates the reference trajectories into the MATLAB workspace.
* **`autoplot.m`**: A post-processing script designed to automatically generate comparative plots for position errors and control efforts (thrust and torques) after a simulation ends.
* **`video.m`**: Script utilized to generate and render the 3D flight animation of the quadrotor, visually demonstrating the tracking performance and the impact of the aerodynamic boundaries.

### Simulink Models (Control Strategies)
* **`geometric_control.slx`**: Baseline Geometric Controller model evaluated under nominal flight conditions.
* **`geom_ceilground.slx`**: Geometric Controller evaluated under the perturbed scenario (+40% mass, Ground & Ceiling effects).
* **`backstepping.slx`**: Standard Vectorial Backstepping controller model in nominal conditions.
* **`backstepping_ceilground.slx`**: Standard Backstepping model tested against severe mass uncertainty and aerodynamic disturbances.
* **`integral_backstepping.slx`**: Integral Backstepping (IBS) controller model, featuring integral error accumulation to dynamically handle the unmodeled mass and steady-state errors.
* **`smc_controller.slx`**: Sliding Mode Controller (SMC) model utilizing the hyperbolic tangent (`tanh`) boundary layer in nominal conditions.
* **`smc_ceilground.slx`**: SMC model evaluated in the severely perturbed scenario, demonstrating instantaneous robust switching against unmodeled dynamics.

### Visualization Utilities (LaTeX Formatting)
These helper functions are called by `autoplot.m` to export publication-quality vector graphics with LaTeX interpreters and dynamic axis padding:
* **`latex_plot.m`**: Generates a standard single plot (e.g., for Total Thrust).
* **`latex_subplot_plot.m`**: Generates two stacked subplots.
* **`latex_triple_subplot_plot.m`**: Generates three stacked subplots (e.g., for 3-axis control torques).
* **`latex_dual_column_plot.m`**: Generates a 3x2 grid layout (e.g., reference vs. actual position on the left, tracking errors on the right).

### 3D Assets
* **`quadrotor.stl`**: A 3D CAD mesh file representing the UAV. It is imported by the `video.m` script to render the realistic 3D flight animation.

## Usage Instructions

### 1. Prerequisites
* **MATLAB & Simulink:** Recommended version R2023a or newer.
* **Required Toolboxes:** Ensure you have the standard Simulink toolbox installed. No external hardware is required; the project is entirely simulation-based.

### 2. Initialization (Setup)
1) Run `setup_mission.m` to load the UAV parameters and trajectory data into the workspace.
2) Open the desired `.slx` file based on the control strategy and scenario you want to test.
3) Wait for the simulation to finish.

*Note on Automation:* The `autoplot.m` script is explicitly configured within the `StopFcn` callback in the Model Properties of each Simulink file. This means the comparative plots (position tracking errors, thrust, and torques) will be generated and displayed automatically as soon as the simulation successfully ends.
