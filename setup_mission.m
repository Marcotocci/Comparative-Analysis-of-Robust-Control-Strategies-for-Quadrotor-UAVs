clearvars; close all; clc;

%% 1. PHYSICAL PARAMETERS (Nominal OS4 Model)
params.m  = 0.468;
params.g  = 9.81;
params.Ix = 0.004856; params.Iy = 0.004856; params.Iz = 0.008801;
% params.l  = 0.225; params.b  = 2.980e-6; params.d  = 1.140e-7; params.Jr = 3.357e-5;

% Mass passed to Plant (Nominal)
mass = params.m; 
Ib = diag([params.Ix, params.Iy, params.Iz]); 

% Sampling time
dt = 0.001; 
Ts = dt;

%% 2. WAYPOINT DEFINITION (Trajectory)
% NED System: Negative Z = Up. 
% Floor at 0.0m, Ceiling at 4.0m
% Pattern Parameters (Absolute Coordinates in 10x10 room)
h_start   = -1.5;   % Safe starting height
h_ground  = -0.3;   % Ground Effect Zone (30cm from floor)
h_ceil    = -3.7;   % Ceiling Effect Zone (30cm from 4.0 ceiling)
h_hover   = -2.0;   % Final mid-air hovering
box_min = 1.5;      % Minimum coordinate of inspection square
box_max = 8.5;      % Maximum coordinate of inspection square

% Format: [Duration_to_reach, x, y, z, yaw_deg]
WPs = [
      0       2.0      2.0      h_start     0;    % Start 

      % --- PHASE 1: GROUND INSPECTION (CLOSED LOOP) ---
      5       2.0      2.0      h_ground    0;    
      5       box_min  box_min  h_ground    0;    
      6       box_max  box_min  h_ground    0;    
      6       box_max  box_max  h_ground    0;    
      6       box_min  box_max  h_ground    0;    
      6       box_min  box_min  h_ground    0;    
      6       5.0      5.0      h_ground    0;    
      
      % --- PHASE 2: CEILING INSPECTION (CLOSED LOOP) ---
      6       5.0      5.0      h_ceil      0;   
      5       box_min  box_min  h_ceil      0;    
      6       box_max  box_min  h_ceil      0;    
      6       box_max  box_max  h_ceil      0;    
      6       box_min  box_max  h_ceil      0;    
      6       box_min  box_min  h_ceil      0;    
      6       5.0      5.0      h_ceil      0;    
      
      % --- PHASE 3: FINAL HOVERING ---
      6       5.0      5.0      h_hover     0;    
      10      5.0      5.0      h_hover     0;    
];

%% 3. POLYNOMIAL GENERATION (Minimum Jerk - 5th Order)
t_total = [];
p_ref = []; v_ref = []; a_ref = []; psi_ref = [];
curr_t = 0;

for i = 1:size(WPs,1)-1
    P_start = WPs(i, 2:4)'; P_end = WPs(i+1, 2:4)';
    Yaw_start = deg2rad(WPs(i, 5)); Yaw_end = deg2rad(WPs(i+1, 5));
    Duration = WPs(i+1, 1);
    
    t_loc = 0:dt:Duration;
    t_norm = t_loc / Duration;
    
    
    s = 10*t_norm.^3 - 15*t_norm.^4 + 6*t_norm.^5;
    ds = (30*t_norm.^2 - 60*t_norm.^3 + 30*t_norm.^4) / Duration;
    dds = (60*t_norm - 180*t_norm.^2 + 120*t_norm.^3) / (Duration^2);
    
    seg_pos = P_start + (P_end - P_start) * s;
    seg_vel = (P_end - P_start) * ds;
    seg_acc = (P_end - P_start) * dds;
    seg_psi = Yaw_start + (Yaw_end - Yaw_start) * s;
    
    % Concatenation
    if i > 1
        t_total = [t_total, curr_t + t_loc(2:end)];
        p_ref = [p_ref, seg_pos(:, 2:end)];
        v_ref = [v_ref, seg_vel(:, 2:end)];
        a_ref = [a_ref, seg_acc(:, 2:end)];
        psi_ref = [psi_ref, seg_psi(2:end)];
    else
        t_total = t_loc; p_ref = seg_pos; v_ref = seg_vel; a_ref = seg_acc; psi_ref = seg_psi;
    end
    curr_t = t_total(end);
end

% Timeseries for Simulink
ts_pos_x = timeseries(p_ref(1,:)', t_total); 
ts_pos_y = timeseries(p_ref(2,:)', t_total); 
ts_pos_z = timeseries(p_ref(3,:)', t_total);
ts_vel_x = timeseries(v_ref(1,:)', t_total); 
ts_vel_y = timeseries(v_ref(2,:)', t_total); 
ts_vel_z = timeseries(v_ref(3,:)', t_total);
ts_acc_x = timeseries(a_ref(1,:)', t_total); 
ts_acc_y = timeseries(a_ref(2,:)', t_total); 
ts_acc_z = timeseries(a_ref(3,:)', t_total);
ts_psi   = timeseries(psi_ref', t_total); 

% Yaw Derivative
dpsi_vals = gradient(psi_ref, dt); 
ts_dpsi  = timeseries(dpsi_vals', t_total);

%% 4. INITIAL CONDITIONS WITH OFFSET
% The reference starts at [2.0, 2.0, -1.5].
offset_init = [0.0; 0.5; 0.5]; 
pos_0 = p_ref(:,1) + offset_init; 
lin_vel_0 = [0; 0; 0];      
eul_0 = [0; 0; 0];          
w_bb_0 = [0; 0; 0];


fprintf('   Ref (Trajectory): [%.2f %.2f %.2f]\n', p_ref(:,1));
fprintf('   Act (Physical Drone):[%.2f %.2f %.2f]\n', pos_0);
