function [ys,check] = rbc_Hansen_1992_ss(~)

% Parámetros de Hansen & Wright (1992)
alpha = 0.36;       % Participación del capital
beta = 0.99;        % Factor de descuento
delta = 0.025;      % Tasa de depreciación
h_ss = 1/3;         % Horas calibradas

%% --- Ecuaciones ---
% 1. Tasa de interés de estado estacionario
r_ss = (1/beta) - 1 + delta;

% 2. Ratio capital/horas
k_h_ratio = (alpha / (1/beta - 1 + delta))^(1/(1-alpha));

% 3. Capital total
k_ss = k_h_ratio * h_ss;

% 4. Producción (función Cobb-Douglas)
y_ss = k_ss^alpha * h_ss^(1-alpha);

% 5. Salario
w_ss = (1-alpha) * (y_ss / h_ss);

% 6. Inversión
i_ss = delta * k_ss;

% 7. Consumo
c_ss = y_ss - i_ss;

% 8. Parámetro A (verificación)
A = w_ss * (1 - h_ss) / c_ss;

%% --- Salida ---
ys = [y_ss; c_ss; k_ss; h_ss; 0; r_ss; w_ss; i_ss];
check = 0;

%% --- Verificación numérica ---
fprintf('--- RESULTADOS ---\n');
fprintf('y = %.4f\t c = %.4f\t k = %.4f\n', y_ss, c_ss, k_ss);
fprintf('h = %.4f\t w = %.4f\t r = %.4f\n', h_ss, w_ss, r_ss);
fprintf('A = %.4f\t i = %.4f\n', A, i_ss);
fprintf('---------------------------------------------\n');

% Verificación de consistencia
residuo = A*c_ss - w_ss*(1-h_ss); % Debe ser ≈0
assert(abs(residuo) < 1e-10, '¡Error en la condición intratemporal!');
end