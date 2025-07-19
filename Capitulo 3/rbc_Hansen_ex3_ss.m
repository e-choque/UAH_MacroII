function [ys, check] = rbc_Hansen_ex3_ss(~)

% Estado estacionario - Extensión 3: Modelo RBC con gasto público (Hansen & Wright, 1992)

% --- Parámetros calibrados ---
alpha = 0.36;      % participación del capital
beta  = 0.99;       % factor de descuento
delta = 0.025;      % tasa de depreciación
h_ss  = 1/3;         % horas trabajadas

% Nuevo parámetro: gasto público como fracción del PIB
gamma_g = 0.18;      % tomado del paper: g/y = 18%

% --- Cálculos del estado estacionario ---

% 1. Tasa de retorno del capital
r_ss = 1 / beta - 1 + delta;

% 2. Ratio capital/horas (FOC)
k_h_ratio = (alpha / r_ss)^(1 / (1 - alpha));
k_ss = k_h_ratio * h_ss;

% 3. Producción agregada
y_ss = k_ss^alpha * h_ss^(1 - alpha);

% 4. Gasto público
g_ss = gamma_g * y_ss;

% 5. Inversión y consumo
i_ss = delta * k_ss;
c_ss = y_ss - i_ss - g_ss;

% 6. Remuneraciones factoriales
w_ss = (1 - alpha) * y_ss / h_ss;
rental = alpha * y_ss / k_ss;  % opcional

% 7. Calibración de A (cond. intratemporal)
A = w_ss * (1 - h_ss) / c_ss;

% --- Salida para Dynare (vector de 9 variables) ---
ys = zeros(9,1); % y, c, k, h, z, r, w, i, g
ys(1) = y_ss;
ys(2) = c_ss;
ys(3) = k_ss;
ys(4) = h_ss;
ys(5) = 0;      % z = 0 en ss
ys(6) = r_ss;
ys(7) = w_ss;
ys(8) = i_ss;
ys(9) = g_ss;

check = 0;

% --- Resultados ---
fprintf('\n--- Estado estacionario: Extensión 3 (Gasto Público) ---\n');
fprintf('k = %.4f\ny = %.4f\nc = %.4f\ni = %.4f\ng = %.4f\nh = %.4f\nr = %.4f\nw = %.4f\nA = %.4f\n', ...
    k_ss, y_ss, c_ss, i_ss, g_ss, h_ss, r_ss, w_ss, A);
fprintf('---------------------------------------------------------\n');

end
