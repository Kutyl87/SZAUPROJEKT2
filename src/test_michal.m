data_train = load("dane.txt");
data_valid = load("dane_wal.txt");
u_valid = data_valid(:,1);
y_valid = data_valid(:,2);
u_train = data_train(:,1);
y_train = data_train(:,2)

M = [u_train(2:end-5) u_train(1:end-6) y_train(6:end-1) y_train(5:end-2)]

W = M\y_train(7:end)
W = W'
y(1:length(u_valid)) = 0;

for k=7:length(y_valid)
    y(k) = W(1)*u_valid(k-5)+W(2)*u_valid(k-6)+W(3)*y(k-1)+W(4)*y(k-2);
end
E= 0;
for k = 6:length(u_valid)
    E = E + (y(k) - y_valid(k))^2;
end
E
figure
plot(y, 'DisplayName', 'Sygnał wyjściowy procesu')
hold on
plot(y_valid, 'DisplayName', 'Sygnał wyjściowy modelu ')
hold off
title('Symulacja modelu');
% Dodanie osi X i Y z podpisami


% Dodanie legendy
legend('show');
matlab2tikz('zad2.8valid.tex' , 'showInfo' , false)

for k=7:length(y_train)
    y(k) = W(1)*u_train(k-5)+W(2)*u_train(k-6)+W(3)*y(k-1)+W(4)*y(k-2);
end
Etra= 0;
for k = 6:length(u_valid)
    Etra = Etra + (y(k) - y_train(k))^2;
end
Etra

figure
plot(y, 'DisplayName', 'Sygnał wyjściowy procesu')
hold on
plot(y_train, 'DisplayName', 'Sygnał wyjściowy modelu ')
% Dodanie osi X i Y z podpisami


% Dodanie legendy
legend('show');
title('Symulacja modelu');
hold off
matlab2tikz('zad2.8train.tex' , 'showInfo' , false)