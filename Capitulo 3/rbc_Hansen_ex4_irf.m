% Gráficos IRF para la Extensión 4: Home Production de Hansen & Wright

load rbc_Hansen_ex4_results.mat  % Cargar resultados
T = 20;  % Horizonte IRF

% Variables y títulos para graficar
vars = {'y','cM','i','k','h','r','w','X'};
titles = {'Producción','Consumo de mercado','Inversión','Capital', ...
          'Horas trabajadas','Tasa de interés','Salario real','Ocio'};

figure;
for i = 1:length(vars)
    subplot(3,3,i);
    plot(1:T, oo_.irfs.([vars{i} '_eps']), 'LineWidth', 1.8);
    title(titles{i}, 'Interpreter','latex');
    xlabel('Periodos'); ylabel('Respuesta IRF');
    grid on;
end

sgtitle('IRF - Shock Tecnológico - Extensión 4: Producción en el hogar', ...
        'FontSize', 14, 'Interpreter', 'latex');

% Ajustar tamaño del gráfico para exportar
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 11 7]);

% Guardar como PDF
print(gcf, '4. RBC_Hansen_Ex4_IRF', '-dpdf');
