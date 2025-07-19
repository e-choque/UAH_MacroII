function [ys, check] = rbc_Hansen_ex4_ss(~)

% Estado estacionario - Extensión 3: Modelo RBC con producción en el hogar (Hansen & Wright, 1992)


% --- Parámetros calibrados del modelo ---
alpha  = 0.36;     % participación del capital en producción de mercado
delta  = 0.025;    % depreciación del capital
beta   = 0.99;     % factor de descuento
phi    = 0.5;      % peso del consumo de mercado en la utilidad (φ en el paper)
h_ss   = 1/3;      % tiempo trabajado (calibrado)
X_ss   = 1 - h_ss; % tiempo no trabajado (se usa en home production)

% --- Ecuaciones del estado estacionario ---
% 1. Tasa de retorno al capital
r_ss = 1/beta - 1 + delta;

% 2. Ratio k/h
k_h_ratio = (alpha / r_ss)^(1/(1 - alpha));
k_ss = k_h_ratio * h_ss;

% 3. Producción de mercado
y_ss = k_ss^alpha * h_ss^(1 - alpha);

% 4. Inversión y consumo de mercado
i_ss = delta * k_ss;
cM_ss = y_ss - i_ss;

% 5. Producción doméstica: función Cobb-Douglas con K (=0) y X
% Se asume producción doméstica: cH = X (sin capital doméstico)
cH_ss = X_ss;  % simplificado: 1:1 entre horas no trabajadas y producción doméstica

% 6. Total de consumo efectivo
c_total = phi * cM_ss + (1 - phi) * cH_ss;

% 7. Remuneraciones
w_ss = (1 - alpha) * y_ss / h_ss;

% 8. A calibrado con utilidad marginal
A = w_ss * X_ss / c_total;

% --- Vector de estado estacionario ---
ys = zeros(9,1);  % [y cM k h z r w i X]
ys(1) = y_ss;
ys(2) = cM_ss;
ys(3) = k_ss;
ys(4) = h_ss;
ys(5) = 0;        % z
ys(6) = r_ss;
ys(7) = w_ss;
ys(8) = i_ss;
ys(9) = X_ss;

check = 0;

% --- Resultados ---
fprintf('\n--- Estado estacionario: Extensión 4 (Home Production) ---\n');
fprintf('k = %.4f\ny = %.4f\ncM = %.4f\ncH = %.4f\ncTotal = %.4f\n', k_ss, y_ss, cM_ss, cH_ss, c_total);
fprintf('i = %.4f\nh = %.4f\nX = %.4f\nr = %.4f\nw = %.4f\nA = %.4f\n', ...
        i_ss, h_ss, X_ss, r_ss, w_ss, A);
fprintf('----------------------------------------------------------\n');

end
