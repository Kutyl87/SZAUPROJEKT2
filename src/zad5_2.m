clear;
global teta
global global_k
global N
global Nu
global lambda
global y
global u
global yzad
global w1
global w2
global w10
global w20
global d

kk=1000;
Upp = 0;
Ypp =0;
u(1:kk)=Upp;
y_pre(1:kk)=Ypp;
e(1:kk) = 0;
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
w10(1,1)=-7.5439464038e-001; w1(1,1)=-2.4729260747e-001; w1(1,2)=2.1618095860e-001; w1(1,3)=1.3359820237e-001; w1(1,4)=-5.8677024284e-001; 
w10(2,1)=4.4940855926e-002; w1(2,1)=-1.1527615738e+000; w1(2,2)=-3.0334457972e-002; w1(2,3)=-6.2598120076e-001; w1(2,4)=3.4160399221e-001; 
w10(3,1)=-8.9519937766e-001; w1(3,1)=1.9962520740e+000; w1(3,2)=3.2069660162e-001; w1(3,3)=7.6220186302e-001; w1(3,4)=-5.2518129694e-001; 
w10(4,1)=-2.1199101214e-001; w1(4,1)=1.8592984543e-001; w1(4,2)=-3.1615014427e-001; w1(4,3)=-1.5501919643e+000; w1(4,4)=1.2909028419e+000; 
w10(5,1)=6.9720807584e-001; w1(5,1)=-9.7487164023e-002; w1(5,2)=1.1623968610e-001; w1(5,3)=-5.5126805074e-002; w1(5,4)=-5.2284139926e-001; 
w10(6,1)=-1.7680498293e-001; w1(6,1)=-3.9689581962e-001; w1(6,2)=-1.5263336482e-001; w1(6,3)=-5.2756825763e-001; w1(6,4)=5.6212207388e-001; 
w10(7,1)=2.6054205492e-001; w1(7,1)=1.6637103093e+000; w1(7,2)=2.4489524567e+000; w1(7,3)=3.7552421676e-002; w1(7,4)=-3.3059585842e-002; 
w10(8,1)=-5.7468889881e-001; w1(8,1)=2.4135554671e+000; w1(8,2)=-6.9066250808e-002; w1(8,3)=6.0784960052e-001; w1(8,4)=-8.3426547907e-001; 
w20=-3.8317011942e-001; w2(1)=-1.2014429213e+000; w2(2)=-4.8003235080e-002; w2(3)=-6.1687596498e-002; w2(4)=-1.1175435762e+000; w2(5)=-9.3511553201e-001; w2(6)=3.6100482489e-001; w2(7)=2.5383062952e-002; w2(8)=7.3579113574e-002;
d(1:kk) = 0;
teta = 5;
y(1:kk) = 0;
N = 210;
Nu=70;
global_k = 0;
%% Pętla regulatora
lambda = 5;
Umax =1;
Umin = -1;

for k=7:kk
    global_k = k;
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y(k) = g2;
    q(k,:) =  [u(k-teta) u(k-teta-1) y(k-1) y(k-2)];
    y_pre(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
    d(k) = y(k) -y_pre(k);
    U_predyktowane = zeros(1, N);
    u_predyktowane = fmincon(@dekorator, U_predyktowane, [], [], [], [], -ones(1, N), ones(1, N));
    u(k) = u_predyktowane(1);
    u(k) = max(min(u(k), Umax), Umin);
    e(k) = (yzad(k) -y(k));
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
hold on
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="northwest")
matlab2tikz ('zad5dodPID.tex' , 'showInfo' , false)

function [J] = dekorator(U_predyktowane)
    global teta
    global global_k
    global N
    global Nu
    global lambda
    global y
    global u
    global yzad
    global w1
    global w2
    global w10
    global w20
    global d
    J = NO_optimizer(yzad(global_k),y,u, U_predyktowane, teta,N, Nu, lambda, global_k, w1,w2,w10,w20,d);
end