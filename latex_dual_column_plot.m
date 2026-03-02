function latex_dual_column_plot(time, ref, act, err_ext, pdf_name)
% LATEX_DUAL_COLUMN_PLOT: Versione Standard con LEGENDA PICCOLA
% Griglia 3x2. Legenda automatica (Location 'best') con font ridotto.

% --- Impostazioni Estetiche LaTeX ---
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultLegendInterpreter', 'latex');
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');

% Colori
lw = 1.2; 
col_ref = [0, 0, 0];             % Nero (Ref)
col_act = [0, 0.447, 0.741];     % Blu (Act)
col_err = [0.850, 0.325, 0.098]; % Rosso/Arancio (Err)

% Gestione dimensioni array (trasponi se necessario)
if size(ref,2) > size(ref,1), ref = ref.'; end
if size(act,2) > size(act,1), act = act.'; end
if size(err_ext,2) > size(err_ext,1), err_ext = err_ext.'; end

labels_ax = {'X', 'Y', 'Z'}; 
labels_units = {'[m]', '[m]', '[m]'};

% Crea Figura
h = figure('Renderer', 'painters', 'Position', [100 100 1000 750]);

for i = 1:3
    % --- COLONNA SINISTRA: TRACKING ---
    subplot(3, 2, (i*2)-1);
    
    plot(time, ref(:,i), '--', 'Color', col_ref, 'LineWidth', lw); hold on;
    plot(time, act(:,i), '-', 'Color', col_act, 'LineWidth', lw);
    
    ylabel(['$' lower(labels_ax{i}) '$ ' labels_units{i}], 'FontSize', 10);
    title(['Position ' labels_ax{i} '-axis'], 'FontSize', 12);
    
    % LEGENDA STANDARD (Solo sul primo grafico)
    if i == 1
        legend({'Reference', 'Actual'}, ...
            'Location', 'best', ...  % MATLAB sceglie l'angolo più vuoto
            'Box', 'on', ...         
            'FontSize', 8);          % <--- DIMENSIONE RIDOTTA (Era 10)
    end
    
    grid on; box on; 
    xlim([time(1) time(end)]);
    
    % --- COLONNA DESTRA: ERRORE ---
    subplot(3, 2, i*2);
    plot(time, err_ext(:,i), 'Color', col_err, 'LineWidth', lw); hold on;
    yline(0, 'k--'); 
    
    % Limiti simmetrici per centrare lo zero
    max_val = max(abs(err_ext(:,i)));
    if max_val < 1e-3, max_val = 0.05; end
    ylim([-max_val*1.1, max_val*1.1]);
    
    ylabel(['$e_' lower(labels_ax{i}) '$ ' labels_units{i}], 'FontSize', 10);
    title(['Position Error ' labels_ax{i} '-axis'], 'FontSize', 12);
    
    grid on; box on; 
    xlim([time(1) time(end)]);
end

% Asse X comune in basso
subplot(3,2,5); xlabel('Time [s]', 'FontSize', 10);
subplot(3,2,6); xlabel('Time [s]', 'FontSize', 10);

% Salva PDF
set(gcf, 'Color', 'w');
exportgraphics(h, pdf_name, 'ContentType', 'vector');

end