% Gráficos IRF para el modelo RBC base de Hansen & Wright

load rbc_Hansen_1992_e_results.mat  % Carga los resultados generados por Dynare
T = 20;  % Horizonte IRF

vars = {'y','c','i','k','h','r','w','z'};
titles = {'Producción','Consumo','Inversión','Capital','Horas trabajadas','Tasa de interés','Salario real','Shock tecnológico'};

figure;
for i = 1:length(vars)
    subplot(3,3,i);
    plot(1:T, oo_.irfs.([vars{i} '_eps']), 'LineWidth', 1.8);
    title(titles{i}, 'Interpreter','latex');
    xlabel('Periodos');
    ylabel('Respuesta IRF');
    grid on;
end
sgtitle('Funciones de Respuesta al Impulso - Shock Tecnológico', 'FontSize', 14);

% Ajustar tamaño del gráfico para exportar
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 9 6]);  % tamaño horizontal

% Guardar como PDF
print(gcf, '4. RBC_Hansen_1992_IRF', '-dpdf');  % nombre del archivo
