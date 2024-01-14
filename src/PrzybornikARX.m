%% Loadowanie Danych treningowych
load sieci/dane.txt

%% Przygotowanie sieci

input_delay = 5:6;
output_delay = 1:2;
neuron_number = 8;
net = narxnet(input_delay, output_delay, neuron_number);

%% Przygotowanie danych i zamiana na macierz komórkowa
X = dane(:, 1);
Y = dane(:, 2);
X = tonndata(X,false,false);
Y = tonndata(Y,false,false);
[Xs,Xi,Ai,Ts] = preparets(net,X,{},Y);

%% Dobór parametrow sieci, funkcji aktywacji i funkcji aktywacji
net.divideFcn ='';
net.trainFcn = 'trainlm';
net.trainParam.min_grad = 1e-09;
net.trainParam.epochs = 400;
net.layers{1}.transferFcn = 'tansig';

%% Trenowanie i symulacja wraz z predykcją
net = train(net, Xs, Ts, Xi, Ai);  
Y_pred = sim(net, Xs, Xi, Ai);

%% Wizualizacja dla danych trenujących
figure;
plot(cell2mat(Ts), '--');
hold on;
e_tr = sum((cell2mat(Y_pred) -cell2mat(Ts)).^2);
plot(cell2mat(Y_pred), '-'); 
legend("Dane trenujące","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór trenujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
legend('show');
legend('Dane trenujące', 'Wyjścia modelu');
matlab2tikz ('net10_train.tex' , 'showInfo' , false)

%% Loadowanie danych walidacyjnych
load sieci/dane_wal.txt

%% Przygotowanie danych i zamiana na macierz komórkowa
X_val = dane_wal(:, 1);
Y_val = dane_wal(:, 2);
X_val = tonndata(X_val,false,false);
Y_val = tonndata(Y_val,false,false);
[X_val, Xi_val, Ai_val, Ts_val] = preparets(net, X_val,{}, Y_val);

%% Symulacja i predykcja
Y_pred_val = sim(net, X_val, Xi_val, Ai_val);

%% Wizualizacja
figure;
plot(cell2mat(Ts_val), '--');
hold on;
plot(cell2mat(Y_pred_val), '-');
e_test = sum((cell2mat(Y_pred_val) -cell2mat(Ts_val)).^2);
legend("Dane Walidacyjne","Wyjścia modelu", Location="northeast")
title("Wyjście sieci neuronowe - zbiór weryfikujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
matlab2tikz ('net10_test.tex' , 'showInfo' , false)
save("net10.mat", "net")


%% Wykres relacji dla zbioru trenującego
figure;
scatter(cell2mat(Ts_train), cell2mat(Y_pred_train),12,'filled');
xlabel("Dane trenujące")
ylabel("Wyjście modelu")
title("Relacja pomiędzy obiektem - dane trenujące, a wyjściem modelu - ARX")
matlab2tikz('net_ARX_rel_train.tex' , 'showInfo' , false)

%% Wykres relacji dla zbioru walidacyjnego
figure;
scatter(cell2mat(Ts_val), cell2mat(Y_pred_val),12,'filled');
title("Relacja pomiędzy obiektem - dane walidujące, a wyjściem modelu - ARX")
xlabel("Dane walidacyjny")
ylabel("Wyjście modelu")
matlab2tikz('net_ARX_rel_val.tex' , 'showInfo' , false)