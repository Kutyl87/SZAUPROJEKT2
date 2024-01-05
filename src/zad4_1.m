
clear;
kk=1000;
Upp = 0;
Ypp =0;
u(1:kk)=Upp;
y(1:kk)=Ypp;
e(1:kk)=0;
q = zeros(kk,4);
q4= zeros(kk,4);
q3= zeros(kk,4);
q2 = zeros(kk,4);
q1 = zeros(kk,4);
%% Przykładowe wartości zadanej yzad
yzad(1:260)=-1.33;
yzad(261:451)= -0.35;
yzad(452:700) = 0.62;
yzad(701:1000) = -0.5;
alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
x1(1:kk) =0;
x2(1:kk) = 0;
w10(1,1)=2.3702850742e-001; w1(1,1)=-1.7728801433e-001; w1(1,2)=3.6627785574e-001; w1(1,3)=3.3877675937e-001; w1(1,4)=2.8503273692e-001; 
w20=-3.4420435209e-001; w2(1)=1.5313608508e+000;
delta = 1e-5;
d(1:kk) = 0;
teta = 5;
y_ob(1:kk) = 0;
D = 400;
N = 60;
Nu=60;
nb = 6;
na=2;
%% Pętla regulatora
lambda = 300;
Umax =1;
Umin = -1;
for k=7:kk
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y_ob(k) = g2;
    q(k,:) = [u(k-teta) u(k-teta-1) y(k-1) y(k-2)];
    q1(k,:) = [u(k-teta)+delta u(k-teta-1) y(k-1) y(k-2)];
    q2(k,:) = [u(k - teta) u(k-teta-1)+delta y(k-1) y(k-2)];
    q3(k,:) = [u(k-teta) u(k-teta-1) y(k-1)+delta y(k-2)];
    q4(k,:) = [u(k-teta) u(k-teta-1) y(k-1) y(k-2)+delta];
    y(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
    b5 =  (w20 + w2*tanh(w10 + w1*q1(k,:)') - y(k))/delta;
    b6 =  (w20 + w2*tanh(w10 + w1*q2(k,:)') - y(k))/delta;
    b = [0,0,0,0,b5,b6];
    a1 =  - (w20 + w2*tanh(w10 + w1*q3(k,:)') - y(k))/delta;
    a2 =  - (w20 + w2*tanh(w10 + w1*q4(k,:)') - y(k))/delta;
    a = [a1,a2];
    d(k) = y(k) - y_ob(k);
    q_pred = zeros(N,4);
    ypred(1:N) =0;
    Y_swobodne(1:N) = 0 ;
    for i=1:N
        if i>=3
            q_pred(i,:) = [u(k-min(1,teta+i)) u(k-min(1,teta+i-1)) ypred(i-1) ypred(i-2)];
        elseif i==2
            q_pred(i,:) = [u(k-min(1,teta+i)) u(k-min(1,teta+i-1)) ypred(i-1) y(k)];
        else
            q_pred(i,:) = [u(k-min(1,teta+i)) u(k-min(1,teta+i-1)) y(k-1+i) y(k-2+i)];
        end
        Y_swobodne(i) = w20 + w2*tanh(w10 + w1*q_pred(i,:)')+ d(k);
    end
    s(1:D) = 0;
    for j=1:N
        b_czlon = 0;
        a_czlon = 0;
        for i=1:min(j,nb)
            b_czlon = b_czlon + b(i);
        end
        for i2 = 1:min(j-1,na)
             a_czlon = a_czlon + (a(i2) * s(j-i2));
        end
        s(j) = b_czlon - a_czlon;
    end
    M = zeros(N,Nu);
    % Macierz M
        for i = 1:N
            for j = 1:Nu
                if (i-j+1) > 0
                    M(i,j) = s(i-j+1);
                end
            end
        end
        Alpha = eye(Nu, Nu) * lambda;
        Yzadk = yzad(k) * ones(N, 1);
        K = inv(M' * M + Alpha) * M';
        dU = K * (Yzadk - Y_swobodne);
        u(k) = dU(1) + u(k-1);
        u(k) = max(min(u(k), Umax), Umin);
end

%% Przygotowanie wykresów i wizualizacja
t = linspace(1,kk,kk);
figure
subplot(2,1,2)
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie');
xlabel('k - number próbki');
ylabel("Wartość sterowania")
subplot(2,1,1)
% matlab2tikz ('zad4PID_u.tex' , 'showInfo' , false)
stairs(t,y_ob,'LineWidth',1.5);
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="northwest")
matlab2tikz ('zad5dodPID.tex' , 'showInfo' , false)