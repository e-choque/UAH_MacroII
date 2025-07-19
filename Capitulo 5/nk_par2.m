clearvars; clc;

% Parámetros del modelo (Gali 2015)
siggma = 1; varphi = 5; alppha = 1/4;
epsilon = 9; theta = 3/4; betta = 0.99;

% Parámetros compuestos
Omega = (1 - alppha)/(1 - alppha + alppha*epsilon);
lambda = (1 - theta)*(1 - betta*theta)/(theta*Omega);

% Coeficientes de pérdida de bienestar
coeff_y = siggma + (varphi + alppha)/(1 - alppha);
coeff_pi = epsilon / lambda;

% Configuración de simulación
T = 200;
options_.irf = 0;
options_.nograph = 1;
options_.nodisplay = 1;
options_.nomoments = 1;
options_.order = 1;
options_.periods = T;

rules = {'nk1a', 'nk1b'}; % Taylor estándar y con expectativas
scenarios = {'Tecnología', 'Demanda'};
shock_configs = [1 0; 0 1]; % [var(eps_a), var(eps_z)]

results = zeros(length(rules), length(scenarios), 4);

for r = 1:length(rules)
    % Ejecutar modelo una vez
    evalin('base', sprintf('dynare %s.mod noclearall nolog;', rules{r}));
    
    for s = 1:length(scenarios)
        % Definir shocks: uno activo y otro apagado
        M_.Sigma_e = diag(shock_configs(s,:));
        
        % Llamar a stoch_simul sin generar figuras
        [~, oo_] = stoch_simul(M_, options_, oo_, []);
        
        % Extraer series
        y_series = oo_.endo_simul(strmatch('y', M_.endo_names, 'exact'), :)';
        y_gap_series = oo_.endo_simul(strmatch('y_gap', M_.endo_names, 'exact'), :)';
        pi_series = oo_.endo_simul(strmatch('pi', M_.endo_names, 'exact'), :)';
        
        % Estadísticos
        sigma_y = std(y_series);
        sigma_y_gap = std(y_gap_series);
        sigma_pi = std(pi_series);
        L = 0.5 * (coeff_y * var(y_gap_series) + coeff_pi * var(pi_series));
        
        results(r, s, :) = [sigma_y, sigma_y_gap, sigma_pi, L];
    end
end

% Mostrar resultados
fprintf('\nResultados con φ_π = 1.5 y φ_y = 0.125:\n');
for r = 1:length(rules)
    for s = 1:length(scenarios)
        fprintf('%s - %s: σ(y)=%.4f, σ(ỹ)=%.4f, σ(π)=%.4f, L=%.4f\n', ...
            rules{r}, scenarios{s}, results(r,s,1), results(r,s,2), results(r,s,3), results(r,s,4));
    end
end

