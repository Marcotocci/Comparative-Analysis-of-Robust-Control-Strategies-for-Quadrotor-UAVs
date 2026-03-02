function z = latex_triple_subplot_plot(x, y1, y2, y3, ...
                                       y1_label_latex, y2_label_latex, y3_label_latex, ...
                                       x_label_latex, ...
                                       title_latex, pdf_name)
% LATEX_TRIPLE_SUBPLOT_PLOT: 3 segnali in colonna.
% Padding 20% simmetrico rispetto allo zero.

% Impostazioni LaTeX globali
set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'DefaultLegendInterpreter', 'latex')
set(0, 'DefaultAxesTickLabelInterpreter', 'latex')

lw = 1.2; % Spessore linea sottile (modificato da 1.2 a 0.8 per coerenza)
col = [0, 0.447, 0.741]; % Grigio scuro professionale

% Crea figura
z = figure('Renderer', 'painters', 'Position', [100 100 800 600]);

% Titolo globale
sgtitle(title_latex, 'FontSize', 12, 'Interpreter', 'latex');

% Dati in celle per iterare il calcolo dei limiti
ys = {y1, y2, y3};
ylabs = {y1_label_latex, y2_label_latex, y3_label_latex};

for i = 1:3
    subplot(3,1,i)
    plot(x, ys{i}, 'LineWidth', lw, 'Color', col); hold on;
    yline(0, 'k--', 'LineWidth', 0.5); % Aggiungo linea dello zero (utile per torques)
    
    ylabel(ylabs{i}, 'FontSize', 10)
    grid on; box on;
    set(gca, 'FontSize', 10);
    xlim([x(1) x(end)]);
    
    % --- LOGICA PADDING 20% ---
    max_val = max(abs(ys{i}));
    if max_val < 0.01, max_val = 0.1; end % Evita errori se segnale nullo
    
    limit = max_val * 1.2; % 20% di spazio extra
    ylim([-limit, limit]); % Limiti simmetrici
    
    % Asse X solo sull'ultimo
    if i == 3
        xlabel(x_label_latex, 'FontSize', 10)
    else
        set(gca, 'XTickLabel', []); % Rimuove numeri asse X per i primi due
    end
end

% Estetica generale
set(gcf, 'Color', 'w');
% Esportazione PDF Vettoriale
exportgraphics(z, pdf_name, 'ContentType', 'vector');
end