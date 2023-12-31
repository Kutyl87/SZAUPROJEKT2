data_train = load("dane.txt");
data_valid = load("dane_wal.txt");
u_valid = data_valid(:,1);
y_valid = data_valid(:,2);
u_train = data_train(:,1);
y_train = data_train(:,2);

y(1:length(u_valid)) = 0;
q = zeros(length(u_valid),4);

for k = 7:length(u_valid)

    q(k,:) = [u_valid(k-5) u_valid(k-6) y(k-1) y(k-2)];
    y(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
end

E = 0;
for k = 6:length(u_valid)
    E = E + (y(k) - y_valid(k))^2;
end
E
t= 1:length(u_valid);

figure
plot(y, 'DisplayName', 'Sygnał wyjściowy procesu')
hold on
plot(y_valid, 'DisplayName', 'Sygnał wyjściowy modelu ')
hold off
title('Symulacja modelu');
% Dodanie osi X i Y z podpisami


% Dodanie legendy
legend('show');
matlab2tikz('zad2.7valid.tex' , 'showInfo' , false)
tested_w1 = [tested_w1; w1];
tested_w2 = [tested_w2; w2];
tested_w10 = [tested_w10; w10];
tested_w20 = [tested_w20; w20];
tested_er = [tested_er; E]


y(1:length(u_valid)) = 0;
q = zeros(length(u_valid),4);

for k = 7:length(u_valid)

    q(k,:) = [u_train(k-5) u_train(k-6) y(k-1) y(k-2)];
    y(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
end

E_train = 0;
for k = 6:length(u_valid)
    E_train = E_train + (y(k) - y_train(k))^2;
end

t= 1:length(u_valid);
figure
plot(y, 'DisplayName', 'Sygnał wyjściowy procesu')
hold on
plot(y_train, 'DisplayName', 'Sygnał wyjściowy modelu ')
% Dodanie osi X i Y z podpisami


% Dodanie legendy
legend('show');
title('Symulacja modelu');
matlab2tikz('zad2.7train.tex' , 'showInfo' , false)
tested_er_train = [tested_er_train; E_train]