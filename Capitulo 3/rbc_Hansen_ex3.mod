// Extensión 3: Modelo RBC con gasto público

var y c k h z r w i g;       // Variables endógenas
varexo eps;                  // Shock tecnológico

parameters beta alpha delta rho sigma A gamma_g;  // Parámetros

// --- Calibración ---
alpha   = 0.36;
delta   = 0.025;
beta    = 0.99;
rho     = 0.95;
sigma   = 0.007;
A       = 2.235;
gamma_g = 0.18;      // gasto público como fracción del PIB

model;
  // Producción
  y = exp(z) * k(-1)^alpha * h^(1 - alpha);

  // Remuneraciones
  r = alpha * y / k(-1);
  w = (1 - alpha) * y / h;

  // Restricción de recursos
  c + i + g = y;

  // Acumulación de capital
  k = (1 - delta) * k(-1) + i;

  // Ecuación de Euler
  1 = beta * (c / c(+1)) * (1 - delta + r(+1));

  // Condición intratemporal
  A * c = w * (1 - h);

  // Gasto público como fracción del producto
  g = gamma_g * y;

  // Proceso tecnológico
  z = rho * z(-1) + eps;
end;

steady_state_file = rbc_Hansen_ex3_ss;

shocks;
  var eps; stderr sigma;
end;

stoch_simul(order=1, periods=200, irf=20);
