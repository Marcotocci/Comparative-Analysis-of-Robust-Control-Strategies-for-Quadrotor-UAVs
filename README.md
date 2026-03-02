# Quadrotor UAV: Robust Control under Aerodynamic Disturbances

![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%2B-blue.svg)
![Simulink](https://img.shields.io/badge/Simulink-Simulation-orange.svg)
![Control Theory](https://img.shields.io/badge/Control_Theory-Nonlinear-success.svg)

## Project Overview
This repository contains the MATLAB/Simulink implementation of advanced nonlinear control strategies for a Quadrotor Unmanned Aerial Vehicle (UAV). The project focuses on evaluating trajectory tracking performance and robustness against severe parametric uncertainties (**+40% unmodeled mass**) and complex aerodynamic disturbances (**Ground Effect** and **Ceiling Effect**).

## Key Features
* **Modular Cascade Architecture:** The control system is explicitly divided into an Outer Loop (Translational Dynamics / Position) and an Inner Loop (Rotational Dynamics / Attitude) for all implemented controllers.
* **Aerodynamic Disturbance Modeling:** Explicit MATLAB functions simulating nonlinear thrust variations near boundaries:
  * *Ground Effect:* Modeled via the Cheeseman & Bennett formulation.
  * *Ceiling Effect:* Modeled via parametric suction force equations.
* **Comparative Control Analysis:** Implementation and direct comparison of four distinct control strategies.

## Implemented Control Strategies
1. **Geometric Controller (Static Control):** A baseline feedforward-feedback controller lacking adaptive mechanisms.
2. **Standard Vectorial Backstepping (BS):** A nonlinear Lyapunov-based controller utilizing nominal model parameters.
3. **Integral Backstepping (IBS):** An augmented Backstepping approach incorporating integral action ($\int e_p dt$) to estimate and compensate for slowly varying uncertainties.
4. **Sliding Mode Control (SMC):** A highly robust variable structure controller. Implemented as a *Quasi-Sliding Mode* utilizing a continuous boundary layer (`tanh`) to mitigate chattering while ensuring instantaneous disturbance rejection.
