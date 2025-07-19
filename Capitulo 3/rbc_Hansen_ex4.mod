// Extensión 4: Producción en el hogar

var y cM k h z r w i X;       // Variables endógenas
varexo eps;                   // Shock tecnológico

parameters beta alpha delta rho sigma A phi;  // Parámetros

// --- Calibración ---
alpha  = 0.36;     // participación del capital
delta  = 0.025;    // tasa de depreciación trimestral
beta   = 0.99;     // tasa de descuento
rho    = 0.95;     // persistencia del shock tecnológico
sigma  = 0.007;    // desviación estándar del shock
phi    = 0.5;      // peso del consumo de mercado en la utilidad
A      = 2.235;    // calibrado para h = 1/3

model;
  // Producción agregada de bienes de mercado
  y = exp(z) * k(-1)^alpha * h^(1 - alpha);

  // Restricción de recursos (producción = consumo de mercado + inversión)
  cM + i = y;

  // Acumulación de capital
  k = (1 - delta) * k(-1) + i;

  // Remuneraciones factoriales
  r = alpha * y / k(-1);
  w = (1 - alpha) * y / h;

  // Ocio
  X = 1 - h;

  // Ecuación de Euler
  1 = beta * (cM / cM(+1)) * (1 - delta + r(+1));

  // Consumo total y condición intratemporal
  A * (phi * cM + (1 - phi) * X) = w * X;

  // Shock tecnológico AR(1)
  z = rho * z(-1) + eps;
end;

steady_state_file = rbc_Hansen_ex4_ss;

shocks;
  var eps; stderr sigma;
end;

stoch_simul(order=1, periods=200, irf=20);
