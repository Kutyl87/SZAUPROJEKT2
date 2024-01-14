%% Loadowanie danych
clear
load net4.mat
load sieci/dane_wal.txt
load sieci/dane.txt

%% Zamknięcie pętli sieci - konwersja w OE
net2 = closeloop(net);

%% Przygotowanie danych walidacyjnych
X_val = dane_wal(:, 1);
Y_val = dane_wal(:, 2);
X_val = tonndata(X_val,false,false);
Y_val = tonndata(Y_val,false,false);
[X_val, Xi_val, Ai_val, Ts_val] = preparets(net2, X_val,{}, Y_val);

%% Symulacja i predykcja
Y_pred_val = sim(net2, X_val, Xi_val, Ai_val);

%% Wizualizacja
figure;
plot(cell2mat(Ts_val), '--');
hold on;
plot(cell2mat(Y_pred_val), '-');
e_test = sum((cell2mat(Y_pred_val) -cell2mat(Ts_val)).^2);
legend("Dane Walidacyjne","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór weryfikujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
matlab2tikz ('net_OE.tex' , 'showInfo' , false)

%% Przygotowanie danych trenujących
X_train = dane(:, 1);
Y_train = dane(:, 2);
X_train = tonndata(X_train,false,false);
Y_train = tonndata(Y_train,false,false);
[X_train, Xi_train, Ai_train, Ts_train] = preparets(net2, X_train,{}, Y_train);

%% Symulacja i predykcja
Y_pred_train = sim(net2, X_train, Xi_train, Ai_train);

%% Wizualizacja danych
figure;
plot(cell2mat(Ts_train), '--');
hold on;
plot(cell2mat(Y_pred_train), '-');
legend("Dane Trenujące","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowe - zbiór trenujący")
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
matlab2tikz ('net_OE_4_train.tex' , 'showInfo' , false)
e_train = sum((cell2mat(Y_pred_train) -cell2mat(Ts_train)).^2);

%% Wykres relacji dla zbioru trenującego
figure;
scatter(cell2mat(Ts_train), cell2mat(Y_pred_train),12,'filled');
xlabel("Dane trenujące")
ylabel("Wyjście modelu")
title("Relacja pomiędzy obiektem - dane trenujące, a wyjściem modelu - OE")
matlab2tikz('net_OE_rel_train.tex' , 'showInfo' , false)

%% Wykres relacji dla zbioru walidacyjnego

figure;
scatter(cell2mat(Ts_val), cell2mat(Y_pred_val),12,'filled');
title("Relacja pomiędzy obiektem - dane walidujące, a wyjściem modelu - OE")
xlabel("Dane walidacyjny")
ylabel("Wyjście modelu")
matlab2tikz('net_OE_rel_val.tex' , 'showInfo' , false)