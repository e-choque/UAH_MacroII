% Gráficos IRF para la Extensión 2: Trabajo indivisible de Hansen & Wright

load rbc_Hansen_ex2_results.mat  % Archivo generado por Dynare
T = 20;  % Horizonte temporal

% Variables a graficar y sus títulos
vars = {'y','c','i','k','h','r','w','c0','c1'};
titles = {'Producción','Consumo','Inversión','Capital','Horas trabajadas',...
          'Tasa de interés','Salario real','Consumo desempleado','Consumo empleado'};

figure;
for i = 1:length(vars)
    subplot(3, 3, i);
    plot(1:T, oo_.irfs.([vars{i} '_eps']), 'LineWidth', 1.8);
    title(titles{i}, 'Interpreter','latex');
    xlabel('Periodos');
    ylabel('Respuesta IRF');
    grid on;
end
sgtitle('Funciones de Respuesta al Impulso - Extensión 2 (Trabajo Indivisible)', 'FontSize', 14);

% Guardar como PDF
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 11 8]);
print(gcf, '4. RBC_Hansen_ex2_IRF', '-dpdf');
