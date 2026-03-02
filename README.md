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
* **`autoplot.m`**: A post-processing script designed to automatically generate comparative plots for position errors, attitude tracking, and control efforts (thrust and torques) after a simulation ends.
* **`video.m`**: Script utilized to generate and render the 3D flight animation of the quadrotor, visually demonstrating the tracking performance and the impact of the aerodynamic boundaries.

### Simulink Models (Control Strategies)
* **`geometric_control.slx`**: Baseline Geometric Controller model evaluated under nominal flight conditions.
* **`geom_ceilground.slx`**: Geometric Controller evaluated under the perturbed scenario (+40% mass, Ground & Ceiling effects).
* **`backstepping.slx`**: Standard Vectorial Backstepping controller model in nominal conditions.
* **`backstepping_ceilground.slx`**: Standard Backstepping model tested against severe mass uncertainty and aerodynamic disturbances.
* **`integral_backstepping.slx`**: Integral Backstepping (IBS) controller model, featuring integral error accumulation to dynamically handle the unmodeled mass and steady-state errors.
* **`smc_controller.slx`**: Sliding Mode Controller (SMC) model utilizing the hyperbolic tangent (`tanh`) boundary layer in nominal conditions.
* **`smc_ceilground.slx`**: SMC model evaluated in the severely perturbed scenario, demonstrating instantaneous robust switching against unmodeled dynamics.
