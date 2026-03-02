clc;
try
    
    %% 1. POSIZIONE (TRACKING & ERRORI)
    if any(strcmp(out.who, 'pos_fb'))
        
       
        raw_pos = out.pos_fb;
        if isa(raw_pos, 'timeseries')
            T_sim = raw_pos.Time;
            P_act = squeeze(raw_pos.Data);
        else
            
            if exist('out', 'var') && any(strcmp(out.who, 'tout'))
                T_sim = out.tout;
            else
                 T_sim = (0:length(raw_pos)-1)' * 0.001; 
            end
            P_act = squeeze(raw_pos);
        end
        
        
        if size(P_act, 1) ~= length(T_sim), P_act = P_act.'; end
        
       
        if exist('ts_pos_x', 'var')
            X_ref = interp1(ts_pos_x.Time, ts_pos_x.Data, T_sim, 'linear', 'extrap');
            Y_ref = interp1(ts_pos_y.Time, ts_pos_y.Data, T_sim, 'linear', 'extrap');
            Z_ref = interp1(ts_pos_z.Time, ts_pos_z.Data, T_sim, 'linear', 'extrap');
            Ref = [X_ref, Y_ref, Z_ref];
        else
            warning('⚠️ Variabili ts_pos_x/y/z non trovate. Uso riferimento zero.');
            Ref = zeros(size(P_act));
        end
        
        
        var_name = 'err_p';
        if any(strcmp(out.who, var_name))
            raw_err = out.(var_name);
            if isa(raw_err, 'timeseries')
                Err = squeeze(raw_err.Data);
            else
                Err = squeeze(raw_err);
            end
            
            if size(Err, 1) ~= length(T_sim), Err = Err.'; end
            fprintf('Errore caricato direttamente da Simulink (%s)\n', var_name);
        else
            
            warning('⚠️ Variabile "%s" non trovata. Calcolo errore manuale (Act - Ref).', var_name);
            Err = P_act - Ref; 
        end
        
        latex_dual_column_plot(T_sim, Ref, P_act, Err, 'Fig_3_Position_Results.pdf');
        fprintf('Posizione salvata: Fig_3_Position_Results.pdf\n');
    else
        warning('Variabile pos_fb non trovata.');
    end
    
    %% INPUT DI CONTROLLO (THRUST uT)
    if any(strcmp(out.who, 'uT'))
        raw_uT = out.uT;
        if isa(raw_uT, 'timeseries')
            T_uT = raw_uT.Time;
            u_thrust = squeeze(raw_uT.Data);
        else
            if ~exist('T_sim', 'var'), T_sim = (0:length(raw_uT)-1)'*0.001; end
            T_uT = T_sim;
            u_thrust = squeeze(raw_uT);
        end
        
        if size(u_thrust, 1) ~= length(T_uT), u_thrust = u_thrust.'; end
        
        latex_plot(T_uT, u_thrust, ...
                   'Time [s]', '$u_T$ [N]', ...
                   'Total Thrust Control', '', ...
                   'Fig_4a_Thrust_Input.pdf');
                   
        fprintf('Thrust salvato: Fig_4a_Thrust_Input.pdf\n');
    else
        warning('⚠️ Variabile uT non trovata.');
    end

    %% INPUT DI CONTROLLO (TORQUES)
    if any(strcmp(out.who, 'tau_b'))
        raw_tau = out.tau_b;
        if isa(raw_tau, 'timeseries')
            T_u = raw_tau.Time;
            u_torques = squeeze(raw_tau.Data);
        else
            if ~exist('T_sim', 'var'), T_sim = (0:length(raw_tau)-1)'*0.001; end 
            T_u = T_sim; 
            u_torques = squeeze(raw_tau);
        end
        
        if size(u_torques, 1) ~= length(T_u), u_torques = u_torques.'; end
        
        latex_triple_subplot_plot(T_u, u_torques(:,1), u_torques(:,2), u_torques(:,3), ...
            '$\tau_\phi$ [Nm]', '$\tau_\theta$ [Nm]', '$\tau_\psi$ [Nm]', ...
            'Time [s]', 'Control Torques', 'Fig_4b_Control_Torques.pdf');
        fprintf('Torques salvati: Fig_4b_Control_Torques.pdf\n');
    end
    

    
    
catch ME
    fprintf('ERRORE: %s (Riga %d)\n', ME.message, ME.stack(1).line);
end