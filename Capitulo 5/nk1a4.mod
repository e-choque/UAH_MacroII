% NK Current Rule: Taylor Rule with Current Values
% Based on Gali (2015), Chapter 3
% Dynare 4.5 or higher required

var pi y_gap y_nat y r_nat i n z a;
varexo eps_a eps_z;

parameters alppha betta rho_a rho_z siggma varphi phi_pi phi_y epsilon theta;

// Parametrización (Gali, 2015, Capítulo 3)
siggma = 1;
varphi = 5;
phi_pi = 1.5;    // φ_π = 1.5
phi_y  = 1;  // φ_y = 1
theta = 3/4;
rho_z = 0.5;
rho_a = 0.9;
betta = 0.99;
alppha = 1/4;
epsilon = 9;

// Ecuaciones del modelo
model(linear);
    // Parámetros compuestos
    #Omega = (1 - alppha)/(1 - alppha + alppha*epsilon);
    #psi_n_ya = (1 + varphi)/(siggma*(1 - alppha) + varphi + alppha);
    #lambda = (1 - theta)*(1 - betta*theta)/theta*Omega;
    // kappa: Slope of the New Keynesian Phillips Curve (see Gali, 2015, Eq. 3.33)
    #kappa = lambda*(siggma + (varphi + alppha)/(1 - alppha));
    
    // NK Phillips Curve
    pi = betta*pi(+1) + kappa*y_gap;
    
    // Dynamic IS Curve
    y_gap = -1/siggma*((i - pi(+1)) - r_nat) + y_gap(+1);
    
    // Taylor Rule (CURRENT VALUES)
    i = phi_pi*pi + phi_y*y_gap;
    
    // Natural rate and output
    r_nat = -siggma*psi_n_ya*(1 - rho_a)*a + (1 - rho_z)*z;
    y_nat = psi_n_ya*a;
    y_gap = y - y_nat;
    
    // Production and shocks
    y = a + (1 - alppha)*n;
    a = rho_a*a(-1) + eps_a;
    z = rho_z*z(-1) + eps_z;
end;

// Varianza de shocks
shocks;
    var eps_a = 1;  // Choque tecnológico
    var eps_z = 1;  // Choque de preferencias
end;

steady;
stoch_simul(order=1, irf=20, periods=200);