function [ys,check] = rbc_Hansen_ex1_ss(~)

% Estado estacionario - Extensión 1: Modelo RBC con persistencia de ocio (Hansen & Wright, 1992)

% Parámetros calibrados
alpha = 0.36;
beta  = 0.99;
delta = 0.025;
h_ss  = 1/3;

% 1. Tasa de retorno del capital
r_ss = 1 / beta - 1 + delta;

% 2. k/h ratio
k_h_ratio = (alpha / r_ss)^(1/(1 - alpha));
k_ss = k_h_ratio * h_ss;

% 3. Producción
y_ss = k_ss^alpha * h_ss^(1 - alpha);

% 4. Salario y tasa de interés
w_ss = (1 - alpha) * y_ss / h_ss;
i_ss = delta * k_ss;
c_ss = y_ss - i_ss;

% 5. A y ocio
X_ss = 1 - h_ss;
A = w_ss * X_ss / c_ss;

% Output de estado estacionario para 9 variables
ys = zeros(9,1);  % y c k h z r w i X
ys(1) = y_ss;
ys(2) = c_ss;
ys(3) = k_ss;
ys(4) = h_ss;
ys(5) = 0;       % z
ys(6) = r_ss;
ys(7) = w_ss;
ys(8) = i_ss;
ys(9) = X_ss;

check = 0;

% Verificación
fprintf('\n--- Estado estacionario corregido para la Extensión 1 ---\n');
fprintf('k = %.4f\ny = %.4f\nc = %.4f\ni = %.4f\nh = %.4f\nX = %.4f\nr = %.4f\nw = %.4f\nA = %.4f\n', ...
    k_ss, y_ss, c_ss, i_ss, h_ss, X_ss, r_ss, w_ss, A);
fprintf('----------------------------------------------------------\n');
end
