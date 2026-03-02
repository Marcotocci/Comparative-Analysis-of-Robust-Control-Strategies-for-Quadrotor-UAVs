function g = latex_subplot_plot(x, y1, y2, ...
                                 x_label_latex, ...
                                 y1_label_latex, y2_label_latex, ...
                                 y1_legend_latex, y2_legend_latex, ...
                                 title1_latex, title2_latex, ...
                                 pdf_name)
% Plotta due segnali in colonna con LaTeX e salva PDF vettoriale

% Impostazioni LaTeX
set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'DefaultLegendInterpreter', 'latex')
set(0, 'DefaultAxesTickLabelInterpreter', 'latex')

lw = 1.5;
col = [0.2, 0.2, 0.2];

% Crea figura
g = figure('Renderer', 'painters', 'Position', [100 100 800 500]);

% --- Primo subplot ---
subplot(2,1,1)
plot(x, y1, 'LineWidth', lw, 'Color', col);
ylabel(y1_label_latex, 'FontSize', 12)
title(title1_latex, 'FontSize', 14)
if ~isempty(y1_legend_latex)
    legend(y1_legend_latex, 'Location', 'best');
end
grid on; box on;
set(gca, 'FontSize', 12);
xlim([x(1) x(end)]);

% --- Secondo subplot ---
subplot(2,1,2)
plot(x, y2, 'LineWidth', lw, 'Color', col);
xlabel(x_label_latex, 'FontSize', 12)
ylabel(y2_label_latex, 'FontSize', 12)
title(title2_latex, 'FontSize', 14)
if ~isempty(y2_legend_latex)
    legend(y2_legend_latex, 'Location', 'best');
end
grid on; box on;
set(gca, 'FontSize', 12);
xlim([x(1) x(end)]);

% Estetica
set(gcf, 'Color', 'w');

% Esportazione
exportgraphics(g, pdf_name, 'ContentType', 'vector');

end