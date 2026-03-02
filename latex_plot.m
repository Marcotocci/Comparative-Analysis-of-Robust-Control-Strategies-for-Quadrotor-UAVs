function latex_plot(time, y, x_lab, y_lab, title_str, legend_str, pdf_name)
% LATEX_PLOT: Versione "Zoom Out 20%" per il Thrust
% Titolo normale (NON in grassetto).

% --- Setup LaTeX ---
set(0, 'DefaultTextInterpreter', 'latex');
set(0, 'DefaultLegendInterpreter', 'latex');
set(0, 'DefaultAxesTickLabelInterpreter', 'latex');

col_line = [0, 0.447, 0.741]; % Blu
lw = 1.2; % Spessore linea

h = figure('Renderer', 'painters', 'Position', [100 100 800 400]);

plot(time, y, 'Color', col_line, 'LineWidth', lw); hold on;

% --- CALCOLO LIMITI CON PADDING 20% ---
mid_val = mean(y);          % Valore centrale
delta = max(abs(y - mid_val)); % Massima oscillazione

if delta < 0.1
    margin = 1.0; 
else
    % Aggiungiamo il 20% di margine
    margin = delta * 1.2; 
end

yline(mid_val, 'k--', 'Alpha', 0.5); % Linea media

% Imposta limiti allargati
ylim([mid_val - margin, mid_val + margin]);

xlabel(x_lab, 'FontSize', 10);
ylabel(y_lab, 'FontSize', 10);

% --- MODIFICA: TITOLO SENZA GRASSETTO ---
if ~isempty(title_str)
    % Ho rimosso ['\textbf{' ... '}']
    title(title_str, 'FontSize', 12); 
end

grid on; box on;
xlim([time(1) time(end)]);

if ~isempty(legend_str)
    legend({legend_str}, 'Location', 'best', 'FontSize', 10);
end

set(gcf, 'Color', 'w');
exportgraphics(h, pdf_name, 'ContentType', 'vector');
end