function [ys,check] = rbc_Hansen_ex2_ss(~)

% Estado estacionario - Extensión 2: Modelo RBC con trabajo indivisible (Hansen & Wright, 1992)

% --- Parámetros calibrados ---
alpha = 0.36;
beta  = 0.99;
delta = 0.025;
h_hat = 0.4;        % horas trabajadas si empleado
pi_ss = 1/3;        % proporción de trabajadores activos

% 1. Horas efectivas trabajadas (agregadas)
h_ss = pi_ss * h_hat;

% 2. Tasa de retorno del capital
r_ss = 1 / beta - 1 + delta;

% 3. k/h ratio exacto
k_h_ratio = (alpha / r_ss)^(1 / (1 - alpha));
k_ss = k_h_ratio * h_ss;

% 4. Producción
y_ss = k_ss^alpha * h_ss^(1 - alpha);

% 5. Salario y tasa de interés
w_ss = (1 - alpha) * y_ss / h_ss;
i_ss = delta * k_ss;
c_ss = y_ss - i_ss;

% 6. Consumo de empleado y desempleado
c1_ss = c_ss / (pi_ss + (1 - pi_ss)^2 / pi_ss);  % empleado
c0_ss = (1 - pi_ss) / pi_ss * c1_ss;             % desempleado

% Output de estado estacionario para 11 variables
ys = zeros(11,1);  % y c k h z r w i pi c0 c1
ys(1)  = y_ss;
ys(2)  = c_ss;
ys(3)  = k_ss;
ys(4)  = h_ss;
ys(5)  = 0;          % z
ys(6)  = r_ss;
ys(7)  = w_ss;
ys(8)  = i_ss;
ys(9)  = pi_ss;
ys(10) = c0_ss;
ys(11) = c1_ss;

check = 0;

% Verificación
fprintf('\n--- Estado estacionario Extensión 2: Trabajo indivisible ---\n');
fprintf('k = %.4f\ny = %.4f\t c = %.4f\t i = %.4f\n', k_ss, y_ss, c_ss, i_ss);
fprintf('h = %.4f\t pi = %.4f\t h_hat = %.2f\n', h_ss, pi_ss, h_hat);
fprintf('r = %.4f\t w = %.4f\n', r_ss, w_ss);
fprintf('c1 = %.4f\t c0 = %.4f\n', c1_ss, c0_ss);
fprintf('------------------------------------------------------------\n');

end
