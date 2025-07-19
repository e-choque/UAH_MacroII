% Simulación Monte Carlo para la Extensión 4 del modelo RBC

clear all;
close all;
clc;

% Correr el Dynare una vez
dynare rbc_Hansen_ex4.mod noclearall nolog

n_replications = 10000;
T = 200;

% Inicializar vectores
sigma_y     = zeros(n_replications,1);
sigma_cM_y  = zeros(n_replications,1);
sigma_i_y   = zeros(n_replications,1);
sigma_h_y   = zeros(n_replications,1);
sigma_w_y   = zeros(n_replications,1);
sigma_h_w   = zeros(n_replications,1);
corr_hw     = zeros(n_replications,1);  % única correlación que reporta el paper

var_list_ = [];

for i = 1:n_replications
    e = mvnrnd(zeros(1,M_.exo_nbr), M_.Sigma_e, T)';

    options_.nograph = 1;
    options_.nodisplay = 1;
    options_.order = 1;
    options_.periods = T;
    options_.irf = 0;

    oo_.exo_simul = e;

    [ys, check] = rbc_Hansen_ex4_ss();
    oo_.steady_state = ys;
    M_.params = M_.params;

    [~, oo_, ~, M_] = stoch_simul(M_, options_, oo_, var_list_);

    % Extraer variables
    y   = oo_.endo_simul(strmatch('y', M_.endo_names, 'exact'),:)';
    cM  = oo_.endo_simul(strmatch('cM', M_.endo_names, 'exact'),:)';
    inv = oo_.endo_simul(strmatch('i', M_.endo_names, 'exact'),:)';
    h   = oo_.endo_simul(strmatch('h', M_.endo_names, 'exact'),:)';
    w   = oo_.endo_simul(strmatch('w', M_.endo_names, 'exact'),:)';

    % Log y filtro HP
    lambda = 1600;
    cycle_y  = hpfilter(log(y), lambda);
    cycle_cM = hpfilter(log(cM), lambda);
    cycle_i  = hpfilter(log(inv), lambda);
    cycle_h  = hpfilter(log(h), lambda);
    cycle_w  = hpfilter(log(w), lambda);

    sigma_y(i)     = std(cycle_y);
    sigma_cM_y(i)  = std(cycle_cM) / std(cycle_y);
    sigma_i_y(i)   = std(cycle_i) / std(cycle_y);
    sigma_h_y(i)   = std(cycle_h) / std(cycle_y);
    sigma_w_y(i)   = std(cycle_w) / std(cycle_y);
    sigma_h_w(i)   = std(cycle_h) / std(cycle_w);
    corr_hw(i)     = corr(cycle_h, cycle_w);
end

% Guardar resultados
save monte_carlo_ex4_results.mat sigma_y sigma_cM_y sigma_i_y sigma_h_y ...
    sigma_w_y sigma_h_w corr_hw

% Histogramas
figure;
vars = {sigma_y, sigma_cM_y, sigma_i_y, sigma_h_y, sigma_w_y, sigma_h_w};
titles = {'$\sigma_y$', '$\sigma_{cM}/\sigma_y$', '$\sigma_i/\sigma_y$', ...
          '$\sigma_h/\sigma_y$', '$\sigma_w/\sigma_y$', '$\sigma_h/\sigma_w$'};

for j = 1:6
    subplot(2,3,j);
    histogram(vars{j}, 50, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'white');
    xline(mean(vars{j}), '--r', 'LineWidth', 1.5);
    title(titles{j}, 'Interpreter', 'latex'); grid on;
end

sgtitle('Simulación Monte Carlo - Extensión 4: Producción en el hogar', ...
        'FontSize', 13, 'Interpreter', 'latex');

set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 11 8]);
print(gcf, '6. Histograma_RBC_Hansen_Ex4', '-dpdf');
