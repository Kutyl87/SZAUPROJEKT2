clear;
%% Parametry zadania
Upp = 0;
Ypp = 0;
Umin= -1;
Umax = 1;
Tp=0.5;

%% Parametry regulatora PID
%Random
% Kp = 1.7;
% Ti =13;
% Td = 0.9;

%Ziegler-Nichols
Kp = 0.5;
Ti = 5;
Td = 0.4 ;

%Ziegler-Nichols Updated
% Kp = 3.9;
% Ti = 10.5;
% Td = 2.625;

%% Wyznaczone wartości r1,r2,r0
r1 = Kp*((Tp/(2*Ti)) -2 *(Td/Tp) -1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti)) + (Td/Tp));

%% Inicjalizacja wektorów
kk=1000;
u(1:kk)=Upp;
y(1:kk)=Ypp;
e(1:kk)=0;

%% Przykładowe wartości zadanej yzad
yzad(1:260)=-1.33;
yzad(261:451)= -0.35;
yzad(452:700) = 0.62;
yzad(701:1000) = -0.5;
%% Parametry z zadania 2
alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
x1(1:kk) =0;
x2(1:kk) = 0;
%% Pętla regulatora
for k=6:kk
g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
y(k) = g2;
 e(k)=yzad(k)-y(k);
 u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);

%% Skalowanie wartości u

% Sprawdzenie czy skok znajduje się w przedziale
% deltau = u(k) - u(k-1);
% u(k) = u(k-1) + min(abs(deltau), abs(deltaumax)) * sign(deltau);

% Sprawdzenie czy U znajduje się w przedziale, ew. ścięcie
u(k) = max(min(u(k),Umax),Umin);
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
stairs(t,y,'LineWidth',1.5);
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="northwest")
matlab2tikz ('zad5dodPID.tex' , 'showInfo' , false)