% Gráficos IRF para la Extensión 3: Gasto público de Hansen & Wright

load rbc_Hansen_ex3_results.mat  % Carga los resultados generados por Dynare
T = 20;  % Horizonte IRF

vars = {'y','c','i','k','h','g','r','w'};
titles = {'Producción','Consumo','Inversión','Capital','Horas trabajadas','Gasto público','Tasa de interés','Salario real'};

figure;
for i = 1:length(vars)
    subplot(3,3,i);
    plot(1:T, oo_.irfs.([vars{i} '_eps']), 'LineWidth', 1.8);
    title(titles{i}, 'Interpreter','latex');
    xlabel('Periodos');
    ylabel('Respuesta IRF');
    grid on;
end
sgtitle('Funciones de Respuesta al Impulso - Extensión 3: Gasto público', 'FontSize', 14);

% Ajustar tamaño del gráfico para exportar
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 9 6]);

% Guardar como PDF
print(gcf, '4. RBC_Hansen_Ex3_IRF', '-dpdf');
