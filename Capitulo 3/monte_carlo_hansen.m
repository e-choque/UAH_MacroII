
% Simulación Monte Carlo para el modelo RBC base

clear all;
close all;
clc;

% Correr Dynare una vez para inicializar estructura
dynare rbc_Hansen_1992.mod noclearall nolog

n_replications = 10000;
T = 200;

% Inicializar vectores
sigma_y     = zeros(n_replications,1);
sigma_c_y   = zeros(n_replications,1);
sigma_i_y   = zeros(n_replications,1);
sigma_h_y   = zeros(n_replications,1);
sigma_w_y   = zeros(n_replications,1);
sigma_h_w   = zeros(n_replications,1);

corr_cy     = zeros(n_replications,1);
corr_iy     = zeros(n_replications,1);
corr_hy     = zeros(n_replications,1);
corr_hw     = zeros(n_replications,1);

% Lista de variables endógenas
var_list_ = [];

% Loop de simulación
for i = 1:n_replications
    e = mvnrnd(zeros(1,M_.exo_nbr), M_.Sigma_e, T)';

    options_.nograph = 1;
    options_.nodisplay = 1;
    options_.order = 1;
    options_.periods = T;
    options_.irf = 0;

    oo_.exo_simul = e;

    [ys, check] = rbc_Hansen_1992_ss();
    oo_.steady_state = ys;              % fijar el SS
    M_.params = M_.params;              % mantener consistencia

    [~, oo_, ~, M_] = stoch_simul(M_, options_, oo_, var_list_);
    
    % Extraer variables simuladas
    y   = oo_.endo_simul(strmatch('y', M_.endo_names, 'exact'),:)';
    c   = oo_.endo_simul(strmatch('c', M_.endo_names, 'exact'),:)';
    inv = oo_.endo_simul(strmatch('i', M_.endo_names, 'exact'),:)';
    h   = oo_.endo_simul(strmatch('h', M_.endo_names, 'exact'),:)';
    w   = oo_.endo_simul(strmatch('w', M_.endo_names, 'exact'),:)';

    % Log + filtro HP
    lambda = 1600;
    cycle_y = hpfilter(log(y), lambda);
    cycle_c = hpfilter(log(c), lambda);
    cycle_i = hpfilter(log(inv), lambda);
    cycle_h = hpfilter(log(h), lambda);
    cycle_w = hpfilter(log(w), lambda);

    % Calcular momentos sobre los ciclos
    sigma_y(i)     = std(cycle_y);
    sigma_c_y(i)   = std(cycle_c) / std(cycle_y);
    sigma_i_y(i)   = std(cycle_i) / std(cycle_y);
    sigma_h_y(i)   = std(cycle_h) / std(cycle_y);
    sigma_w_y(i)   = std(cycle_w) / std(cycle_y);
    sigma_h_w(i)   = std(cycle_h) / std(cycle_w);

    corr_cy(i)     = corr(cycle_c, cycle_y);
    corr_iy(i)     = corr(cycle_i, cycle_y);
    corr_hy(i)     = corr(cycle_h, cycle_y);
    corr_hw(i)     = corr(cycle_h, cycle_w);
end

% Guardar resultados
save monte_carlo_results.mat sigma_y sigma_c_y sigma_i_y sigma_h_y sigma_w_y sigma_h_w ...
    corr_hw

% Visualización de histogramas
figure;
vars = {sigma_y, sigma_c_y, sigma_i_y, sigma_h_y, sigma_w_y, sigma_h_w};
titles = {'$\sigma_y$','$\sigma_c/\sigma_y$','$\sigma_i/\sigma_y$', ...
          '$\sigma_h/\sigma_y$','$\sigma_w/\sigma_y$','$\sigma_h/\sigma_w$'};

for i = 1:6
    subplot(2,3,i);
    histogram(vars{i}, 50, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'white');
    xline(mean(vars{i}), '--r', 'LineWidth', 1.5);
    title(titles{i}, 'Interpreter', 'latex'); grid on;
end

sgtitle('Simulación Monte Carlo - Modelo RBC Estándar (Hansen & Wright, 1992)', ...
        'FontSize', 13, 'Interpreter', 'latex');

set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 11 8]);
print(gcf, 'Histogramas_MonteCarlo_Hansen1992', '-dpdf');