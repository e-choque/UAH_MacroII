// Extensión 2: Trabajo indivisible

var y c k h z r w i c0 c1;
varexo eps;

parameters alpha beta delta rho sigma h_hat pi A;

// --- Calibración ---
alpha  = 0.36;
beta   = 0.99;
delta  = 0.025;
rho    = 0.95;
sigma  = 0.007;
h_hat  = 0.4;      // Horas trabajadas si empleado
pi     = 1/3;      // Probabilidad de estar empleado
A      = 2.235;    // Preferencia por ocio

model;
  // Producción
  y = exp(z) * k(-1)^alpha * h^(1 - alpha);

  // Remuneraciones factoriales
  r = alpha * y / k(-1);
  w = (1 - alpha) * y / h;

  // Restricción de recursos
  c + i = y;

  // Acumulación de capital
  k = (1 - delta) * k(-1) + i;

  // Ecuación de Euler
  1 = beta * (c / c(+1)) * (1 - delta + r(+1));

  // Empleo efectivo (agregado)
  h = pi * h_hat;

  // Seguro completo: consumo total
  c = pi * c1 + (1 - pi) * c0;

  // Condición de optimalidad entre agentes
  log(c1) - log(c0) = A * log((1 - h_hat) / (1 - 0));

  // Proceso AR(1) del shock tecnológico
  z = rho * z(-1) + eps;
end;

steady_state_file = rbc_Hansen_ex2_ss;

shocks;
  var eps; stderr sigma;
end;

stoch_simul(order=1, periods=200, irf=20);

