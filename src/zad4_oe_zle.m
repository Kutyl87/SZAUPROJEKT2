load sieci/dane_wal.txt
net2 = closeloop(net);
X_val = dane_wal(:, 1);
Y_val = dane_wal(:, 2);
X_val = tonndata(X_val,false,false);
Y_val = tonndata(Y_val,false,false);
[X_val, Xi_val, Ai_val, Ts_val] = preparets(net2, X_val,{}, Y_val);
Y_pred_val = sim(net2, X_val, Xi_val, Ai_val);
figure;
plot(cell2mat(Ts_val), '-');
hold on;
plot(cell2mat(Y_pred_val), '-');
legend("Dane Walidacyjne","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór weryfikujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
legend('show');