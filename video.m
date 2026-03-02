%% GENERATORE VIDEO
clearvars -except out; close all; clc;

video_filename = 'ibs.mp4';
FPS = 30;          
SPEED_FACTOR = 1.5; 

if ~exist('out', 'var')
    error('ERRORE: Variabile "out" non trovata. Esegui la simulazione!');
end
try
    
    data_src = out.pos_fb;
    if isa(data_src, 'timeseries')
        raw_t = data_src.Time; raw_x = data_src.Data(:,1); raw_y = data_src.Data(:,2); raw_z = data_src.Data(:,3);
    elseif isstruct(data_src)
        raw_t = data_src.time; raw_x = data_src.signals.values(:,1); raw_y = data_src.signals.values(:,2); raw_z = data_src.signals.values(:,3);
    else
        error('Formato dati non riconosciuto.');
    end
catch
    error('Errore lettura out.pos_fb. Controlla i nomi nel Workspace.');
end

t_final = raw_t(end);
dt_video = (1/FPS) * SPEED_FACTOR; 
t_video = 0 : dt_video : t_final;
fprintf('Durata Simulazione: %.1f s -> Durata Video: %.1f s (Speed: %.1fx)\n', ...
        t_final, t_final/SPEED_FACTOR, SPEED_FACTOR);
X_sim = interp1(raw_t, raw_x, t_video, 'linear');
Y_sim = interp1(raw_t, raw_y, t_video, 'linear');
Z_sim = interp1(raw_t, raw_z, t_video, 'linear');
Z_plot_sim = -Z_sim; 

h_ground = -0.3; h_ceil = -3.7; h_hover = -2.0; h_start = -1.5;
box_min = 1.5; box_max = 8.5;
WPs = [
      0       2.0      2.0      h_start     0;
      5       2.0      2.0      h_ground    0;
      5       box_min  box_min  h_ground    0;
      6       box_max  box_min  h_ground    0;
      6       box_max  box_max  h_ground    0;
      6       box_min  box_max  h_ground    0;
      6       box_min  box_min  h_ground    0;
      6       5.0      5.0      h_ground    0;
      6       5.0      5.0      h_ceil      0;
      5       box_min  box_min  h_ceil      0;
      6       box_max  box_min  h_ceil      0;
      6       box_max  box_max  h_ceil      0;
      6       box_min  box_max  h_ceil      0;
      6       box_min  box_min  h_ceil      0;
      6       5.0      5.0      h_ceil      0;
      6       5.0      5.0      h_hover     0;
      10      5.0      5.0      h_hover     0;
];
p_ref = []; dt_ref = 0.05;
for i = 1:size(WPs,1)-1
    P_start = WPs(i, 2:4)'; P_end = WPs(i+1, 2:4)';
    Duration = WPs(i+1, 1);
    t_loc = 0:dt_ref:Duration; t_norm = t_loc / Duration;
    s = 10*t_norm.^3 - 15*t_norm.^4 + 6*t_norm.^5; 
    seg_pos = P_start + (P_end - P_start) * s;
    if i > 1, p_ref = [p_ref, seg_pos(:, 2:end)]; else, p_ref = seg_pos; end
end
X_ref = p_ref(1,:); Y_ref = p_ref(2,:); Z_ref = -p_ref(3,:);

fig = figure('Name', 'Video Simulazione', 'Color', 'w', 'Position', [50, 50, 1280, 720]);
hold on; grid on; axis equal;
set(gca, 'FontName', 'Arial', 'FontSize', 12);
xlabel('X [m]'); ylabel('Y [m]'); zlabel('Height Z [m]');
view(-35, 25); xlim([0, 10]); ylim([0, 10]); zlim([0, 4.5]);

H_ROOM = 4.0; col_wall = [0.95, 0.95, 0.95];
fill3([0, 10, 10, 0], [0, 0, 10, 10], [0, 0, 0, 0], [0.85 0.85 0.85], 'EdgeColor', 'none', 'HandleVisibility', 'off'); 
fill3([10, 10, 10, 10], [0, 10, 10, 0], [0, 0, H_ROOM, H_ROOM], col_wall, 'FaceAlpha', 0.4, 'EdgeColor', 'k', 'HandleVisibility', 'off'); 
fill3([0, 10, 10, 0], [10, 10, 10, 10], [0, 0, H_ROOM, H_ROOM], col_wall, 'FaceAlpha', 0.4, 'EdgeColor', 'k', 'HandleVisibility', 'off'); 
fill3([0, 10, 10, 0], [0, 0, 10, 10], [H_ROOM, H_ROOM, H_ROOM, H_ROOM], col_wall, 'FaceAlpha', 0.1, 'EdgeColor', 'k', 'LineStyle', ':', 'HandleVisibility', 'off');

h_ref = plot3(X_ref, Y_ref, Z_ref, 'k--', 'LineWidth', 1.5, 'DisplayName', 'Reference');
h_trail = animatedline('Color', 'b', 'LineWidth', 2, 'DisplayName', 'Actual');
h_shadow = plot3(X_sim(1), Y_sim(1), 0, 'k.', 'Color', [0.5 0.5 0.5], 'MarkerSize', 15, 'HandleVisibility', 'off');
stl_file = 'quadrotor.stl'; use_stl = false;
if exist(stl_file, 'file')
    try
        model = stlread(stl_file); V_orig = model.Points - mean(model.Points); 
        h_drone = patch('Faces', model.ConnectivityList, 'Vertices', V_orig + [X_sim(1), Y_sim(1), Z_plot_sim(1)], ...
              'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'none', 'FaceAlpha', 1.0, 'HandleVisibility', 'off');
        camlight('headlight'); lighting gouraud; use_stl = true;
    catch; end
end
if ~use_stl
    h_drone = plot3(X_sim(1), Y_sim(1), Z_plot_sim(1), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8, 'HandleVisibility', 'off'); 
end
legend([h_ref, h_trail], 'Location', 'northeast');

tit_h = title('Time: 0.00 s', 'FontWeight', 'normal', 'Interpreter', 'none'); 


v = VideoWriter(video_filename, 'MPEG-4');
v.FrameRate = FPS; v.Quality = 100;
open(v);
fprintf('Generazione video in corso (%d frames)...\n', length(t_video));
for k = 1:length(t_video)
    pos_now = [X_sim(k), Y_sim(k), Z_plot_sim(k)];
    
    if use_stl, h_drone.Vertices = V_orig + pos_now;
    else, h_drone.XData = pos_now(1); h_drone.YData = pos_now(2); h_drone.ZData = pos_now(3); end
    
    addpoints(h_trail, pos_now(1), pos_now(2), pos_now(3));
    h_shadow.XData = pos_now(1); h_shadow.YData = pos_now(2);
    
    
    set(tit_h, 'String', sprintf('Time: %.2f s', t_video(k)));
    
    drawnow limitrate;
    writeVideo(v, getframe(gcf));
end
close(v);