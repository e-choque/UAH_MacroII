
// Hansen & Wright (1992) - Modelo RBC base

var y c k h z r w i;

varexo eps;

parameters beta alpha delta rho sigma A;

// Calibración
alpha  = 0.36;      // participación del capital
delta  = 0.025;     // tasa de depreciación trimestral
beta   = 0.99;      // tasa de descuento
rho    = 0.95;      // persistencia del shock tecnológico
sigma  = 0.007;     // desviación estándar del shock
A      = 2.235;     // calibrado para h_ss = 1/3

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

  // Condición intratemporal de trabajo
  A * c = w * (1 - h);

  // Proceso AR(1) del shock tecnológico
  z = rho * z(-1) + eps;
end;

steady_state_file = rbc_Hansen_1992_ss;

shocks;
  var eps; stderr sigma;
end;

stoch_simul(order=1, periods=200, irf=20);