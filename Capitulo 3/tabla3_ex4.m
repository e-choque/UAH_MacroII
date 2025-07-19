% Genera los promedios para la Tabla 3 de la Extensión 4

clear; clc;

% Cargar resultados simulados
load monte_carlo_ex4_results.mat

% Calcular medias
m = @(x) mean(x);

fprintf('\n--- Tabla 3: Resultados promedio (Extensión 4: Home Production) ---\n');
fprintf('\\begin{tabular}{lcc}\\toprule\n');
fprintf('Estadística & Promedio\\\\\\midrule\n');
fprintf('$\\sigma_y$ & %.2f\\\\\n',     m(sigma_y));
fprintf('$\\sigma_{cM}/\\sigma_y$ & %.2f\\\\\n', m(sigma_cM_y));
fprintf('$\\sigma_i/\\sigma_y$ & %.2f\\\\\n',   m(sigma_i_y));
fprintf('$\\sigma_h/\\sigma_y$ & %.2f\\\\\n',   m(sigma_h_y));
fprintf('$\\sigma_w/\\sigma_y$ & %.2f\\\\\n',   m(sigma_w_y));
fprintf('$\\sigma_h/\\sigma_w$ & %.2f\\\\\n',   m(sigma_h_w));
fprintf('$\\text{corr}(h,w)$ & %.2f\\\\\n',     m(corr_hw));
fprintf('\\bottomrule\n\\end{tabular}\n');
