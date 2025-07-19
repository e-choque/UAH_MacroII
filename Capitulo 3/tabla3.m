% Genera los promedios para la Tabla 3 del modelo base de Hansen & Wright

clear; clc;

% Cargar resultados simulados
load monte_carlo_results.mat

% Calcular promedios
m = @(x) mean(x);

fprintf('\\begin{tabular}{lcc}\\toprule\\n');
fprintf('Estadística & Promedio\\\\\\midrule\\n');
fprintf('$\\sigma_y$ & %.2f\\\\\\n',     m(sigma_y));
fprintf('$\\sigma_c/\\sigma_y$ & %.2f\\\\\\n', m(sigma_c_y));
fprintf('$\\sigma_i/\\sigma_y$ & %.2f\\\\\\n', m(sigma_i_y));
fprintf('$\\sigma_h/\\sigma_y$ & %.2f\\\\\\n', m(sigma_h_y));
fprintf('$\\sigma_w/\\sigma_y$ & %.2f\\\\\\n', m(sigma_w_y));
fprintf('$\\sigma_h/\\sigma_w$ & %.2f\\\\\\n', m(sigma_h_w));
fprintf('$\\text{corr}(h,w)$ & %.2f\\\\\\n',   m(corr_hw));
fprintf('\\bottomrule\\n\\end{tabular}\\n');
