// Hansen & Wright (1992) - Extensión 1: Ocio no separable

var y c k h z r w i X;       // Variables endógenas
varexo eps;                  // Shock tecnológico

parameters beta alpha delta rho sigma A a0;  // Parámetros del modelo

// --- Calibración ---
alpha  = 0.36;
delta  = 0.025;
beta   = 0.99;
rho    = 0.95;
sigma  = 0.007;
A      = 2.235;
a0     = 0.35;        // peso del ocio contemporáneo en X_t

model;
  // Producción agregada
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

  // Condición intratemporal (no separable en ocio)
  A * a0 * c = w * X;

  // Ley de evolución del ocio efectivo X_t
  X = a0 * (1 - h) + (1 - a0) * X(-1);

  // Proceso del shock tecnológico
  z = rho * z(-1) + eps;
end;

steady_state_file = rbc_Hansen_ex1_ss;

shocks;
  var eps; stderr sigma;
end;

stoch_simul(order=1, periods=200, irf=20);
