% plot(numericData2, LineWidth=1);
figure
plot(yzad, LineWidth=1, LineStyle="--")
hold on
plot(actualData, LineWidth=1)
xlim([0,816])
title("Przebieg wartości na wyjściu dla regulatora DMC")
xlabel("Czas - [s]")
ylabel("Wartość temperatury °C")
matlab2tikz('DMC.tex' , 'showInfo' , false) 