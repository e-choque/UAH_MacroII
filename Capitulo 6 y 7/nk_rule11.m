clear all; close all; clc;

rng(0); % Fijar semilla para reproducibilidad
n_simulations = 10000;
T = 200;

% Parámetros para pérdida de bienestar
siggma = 1; varphi = 5; alppha = 1/4; epsilon = 9; theta = 3/4; betta = 0.99;
Omega = (1 - alppha)/(1 - alppha + alppha*epsilon);
lambda = (1 - theta)*(1 - betta*theta)/(theta*Omega);
coeff_y = siggma + (varphi + alppha)/(1 - alppha);
coeff_pi = epsilon / lambda;

losses = zeros(n_simulations,1);
var_y_gap_all = zeros(n_simulations,1);
var_pi_all = zeros(n_simulations,1);

% Cargar modelo una vez
dynare nk1a.mod noclearall nolog;

% Ajustar choques: solo tecnología
M_.Sigma_e = diag([1, 0]);

options_.irf = 0; options_.nograph = 1; options_.nodisplay = 1;
options_.nomoments = 1; options_.order = 1; options_.periods = T;

for i = 1:n_simulations
    oo_.exo_simul = randn(T, M_.exo_nbr);
    [~, oo_] = stoch_simul(M_, options_, oo_, []);

    pi_series = oo_.endo_simul(strmatch('pi', M_.endo_names, 'exact'), :)';
    y_gap_series = oo_.endo_simul(strmatch('y_gap', M_.endo_names, 'exact'), :)';

    var_y_gap_all(i) = var(y_gap_series);
    var_pi_all(i) = var(pi_series);
    losses(i) = 0.5 * (coeff_y * var_y_gap_all(i) + coeff_pi * var_pi_all(i));
end

mean_loss = mean(losses);
mean_var_y_gap = mean(var_y_gap_all);
mean_var_pi = mean(var_pi_all);

fprintf('\nPérdida promedio (Regla estándar – tech): %.4f\n', mean_loss);
fprintf('Varianza promedio brecha de producto: %.4f\n', mean_var_y_gap);
fprintf('Varianza promedio inflación: %.4f\n', mean_var_pi);

save('losses_rule11.mat', 'losses', 'mean_loss', 'mean_var_y_gap', 'mean_var_pi');

figure;
histogram(losses, 50, 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'white');
title('Pérdida – Taylor Estándar (Shock Tecnología)');
grid on;
saveas(gcf, 'hist_rule11.png');
