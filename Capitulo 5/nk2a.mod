/*
 Modelo Neokeynesiano según Gali (2015) Capítulo 4
 Implementa ambas reglas de Taylor con selector
*/
@#define taylor_rule = 1 // 1=Estándar; 2=Expectativas
@#define shock_type = 1  // 1=Tecnológico; 2=Demanda


var pi y_gap y_nat r_nat i a y z;
varexo eps_a eps_z;

parameters alpha beta rho_a rho_z sigma varphi phi_pi phi_y epsilon theta 
           Omega psi_n_ya lambda kappa;

// Calibración estándar (Gali 2015)
sigma = 1;        // Inverse EIS
varphi = 5;       // Inverse Frisch elasticity
phi_pi = 1.5;     // Respuesta a inflación
phi_y = 0.125;    // Respuesta a brecha de producto
theta = 3/4;      // Prob. de no ajuste de precios
rho_z = 0.5;      // Persistencia choque preferencias
rho_a = 0.9;      // Persistencia choque tecnología
beta = 0.99;      // Factor de descuento
alpha = 1/4;      // Participación del capital
epsilon = 9;      // Elasticidad de sustitución

// Parámetros compuestos (Gali 2015, pp. 60-63)
Omega = (1 - alpha) / ((1 - alpha) + alpha * epsilon);
psi_n_ya = (1 + varphi)/(sigma*(1 - alpha) + varphi + alpha);
model(linear);
    /* 1. Nueva Curva de Phillips */
    pi = beta*pi(+1) + kappa*y_gap;

    /* 2. Curva IS Dinámica */
    y_gap = (-1 / sigma) * (i - pi(+1) - r_nat) + y_gap(+1);

    /* 3. Regla de Taylor (selector) */
    @#if taylor_rule == 1
        /* Regla Estándar (valores corrientes) */
        i = phi_pi*pi + phi_y*y_gap;
    @#else
        /* Regla con Expectativas */
        i = phi_pi*pi(+1) + phi_y*y_gap(+1);
    @#endif

    /* 4. Tasa natural de interés */
    r_nat = -sigma*psi_n_ya*(1 - rho_a)*a + (1 - rho_z)*z;

    /* 5. Producción natural */
    y_nat = psi_n_ya*a;

    /* 6. Definición brecha de producto */
    y_gap = y - y_nat;

    /* 7. Procesos de choques */
    a = rho_a*a(-1) + eps_a;
    z = rho_z*z(-1) + eps_z;
end;

/* Configuración de choques */
shocks;
    @#if shock_type == 1
        /* Solo choque tecnológico */
        var eps_a = 1;
        var eps_z = 0;
    @#else
        /* Solo choque de demanda */
        var eps_a = 0;
        var eps_z = 1;
    @#endif
end;


//If only impulse response functions (IRFs) are needed, consider removing or reducing 'periods' to speed up computation.
stoch_simul(order=1, irf=20, periods=10000);