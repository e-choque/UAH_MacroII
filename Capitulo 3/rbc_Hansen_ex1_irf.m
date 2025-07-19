% Gráficos IRF para la Extensión 1 : Ocio no separable de Hansen & Wright

load rbc_Hansen_ex1_results.mat  % Cargar resultados de Dynare
T = 20;  % Horizonte IRF

% Variables a graficar y sus títulos
vars = {'y','c','i','k','h','r','w','X','z'};
titles = {'Producción','Consumo','Inversión','Capital',...
          'Horas trabajadas','Tasa de interés','Salario real',...
          'Ocio efectivo $X_t$','Shock tecnológico'};

figure;
for i = 1:length(vars)
    subplot(3,3,i);
    plot(1:T, oo_.irfs.([vars{i} '_eps']), 'LineWidth', 1.8);
    title(titles{i}, 'Interpreter','latex');
    xlabel('Periodos');
    ylabel('Respuesta IRF');
    grid on;
end

sgtitle('Funciones de Respuesta al Impulso - Extensión 1: Ocio no separable',...
        'FontSize', 14, 'Interpreter', 'latex');

% Guardar como PDF
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 11 8]);
print(gcf, '4. RBC_Hansen_ex1_IRF', '-dpdf');
