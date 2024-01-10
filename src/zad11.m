% % % net = feedforwardnet(10);
% % % net.layers{1}.transferFcn = 'poslin';
% % % net.layers{2}.transferFcn = 'siglog';
load sieci/dane.txt
input_delay = 5:6;
output_delay = 1:2;
neuron_number = 8;
net = narxnet(5:6, 1:2, neuron_number);
X = dane(:, 1);
Y = dane(:, 2);
X = tonndata(X,false,false);
Y = tonndata(Y,false,false);
[Xs,Xi,Ai,Ts] = preparets(net,X,{},Y);
net.trainFcn = 'trainlm';
narx_net.divideFcn = '';
net.trainParam.epochs = 400;
net.layers{1}.transferFcn = 'tansig';  % Dodanie funkcji aktywacji tanh do pierwszej warstwy
net = train(net, Xs, Ts, Xi, Ai);  
Y_pred = sim(net, Xs, Xi, Ai);
figure;
plot(cell2mat(Ts), '-');
hold on;
plot(cell2mat(Y_pred), '-'); 
legend("Dane trenujące","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór weryfikujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
legend('show');
legend('Actual', 'Predicted');
load sieci/dane_wal.txt
X_val = dane_wal(:, 1);
Y_val = dane_wal(:, 2);
X_val = tonndata(X_val,false,false);
Y_val = tonndata(Y_val,false,false);
[X_val, Xi_val, Ai_val, Ts_val] = preparets(net, X_val,{}, Y_val);
Y_pred_val = sim(net, X_val, Xi_val, Ai_val);
figure;
plot(cell2mat(Ts_val), '-');
hold on;
plot(cell2mat(Y_pred_val), '-');
legend("Dane Walidacyjne","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór weryfikujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
legend('show');
