
clear;
kk=1000;
Upp = 0;
Ypp =0;
u(1:kk)=Upp;
y(1:kk)=Ypp;
e(1:kk) = 0;
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
w10(1,1)=-7.5439464038e-001; w1(1,1)=-2.4729260747e-001; w1(1,2)=2.1618095860e-001; w1(1,3)=1.3359820237e-001; w1(1,4)=-5.8677024284e-001; 
w10(2,1)=4.4940855926e-002; w1(2,1)=-1.1527615738e+000; w1(2,2)=-3.0334457972e-002; w1(2,3)=-6.2598120076e-001; w1(2,4)=3.4160399221e-001; 
w10(3,1)=-8.9519937766e-001; w1(3,1)=1.9962520740e+000; w1(3,2)=3.2069660162e-001; w1(3,3)=7.6220186302e-001; w1(3,4)=-5.2518129694e-001; 
w10(4,1)=-2.1199101214e-001; w1(4,1)=1.8592984543e-001; w1(4,2)=-3.1615014427e-001; w1(4,3)=-1.5501919643e+000; w1(4,4)=1.2909028419e+000; 
w10(5,1)=6.9720807584e-001; w1(5,1)=-9.7487164023e-002; w1(5,2)=1.1623968610e-001; w1(5,3)=-5.5126805074e-002; w1(5,4)=-5.2284139926e-001; 
w10(6,1)=-1.7680498293e-001; w1(6,1)=-3.9689581962e-001; w1(6,2)=-1.5263336482e-001; w1(6,3)=-5.2756825763e-001; w1(6,4)=5.6212207388e-001; 
w10(7,1)=2.6054205492e-001; w1(7,1)=1.6637103093e+000; w1(7,2)=2.4489524567e+000; w1(7,3)=3.7552421676e-002; w1(7,4)=-3.3059585842e-002; 
w10(8,1)=-5.7468889881e-001; w1(8,1)=2.4135554671e+000; w1(8,2)=-6.9066250808e-002; w1(8,3)=6.0784960052e-001; w1(8,4)=-8.3426547907e-001; 
w20=-3.8317011942e-001; w2(1)=-1.2014429213e+000; w2(2)=-4.8003235080e-002; w2(3)=-6.1687596498e-002; w2(4)=-1.1175435762e+000; w2(5)=-9.3511553201e-001; w2(6)=3.6100482489e-001; w2(7)=2.5383062952e-002; w2(8)=7.3579113574e-002;
delta = 1e-3;
d(1:kk) = 0;
teta = 5;
y_ob(1:kk) = 0;
D = 100;
N = 300;
Nu=60;
%% Pętla regulatora
lambda = 10;
Umax =1;
Umin = -1;

for k=7:kk
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y_ob(k) = g2;
    q(k,:) =  [u(k-teta) u(k-teta-1) y_ob(k-1) y_ob(k-2)];
    q1(k,:) = [u(k-teta)+delta u(k-teta-1) y_ob(k-1) y_ob(k-2)];
    q2(k,:) = [u(k - teta) u(k-teta-1)+delta y_ob(k-1) y_ob(k-2)];
    q3(k,:) = [u(k-teta) u(k-teta-1) y_ob(k-1)+delta y_ob(k-2)];
    q4(k,:) = [u(k-teta) u(k-teta-1) y_ob(k-1) y_ob(k-2)+delta];
    y(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
    b5 =  (w20 + w2*tanh(w10 + w1*q1(k,:)') - y(k))/delta;
    b6 =  (w20 + w2*tanh(w10 + w1*q2(k,:)') - y(k))/delta;
    b = [0,0,0,0,b5,b6];
    a1 =  - (w20 + w2*tanh(w10 + w1*q3(k,:)') - y(k))/delta;
    a2 =  - (w20 + w2*tanh(w10 + w1*q4(k,:)') - y(k))/delta;
    a = [a1,a2];
    d(k) = y_ob(k) -y(k);
    Y_swobodne(1:N) = 0 ;
    for i=1:N
        if i>=3
            q_pred = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) Y_swobodne(i-1) Y_swobodne(i-2)];
        elseif i==2
            q_pred = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) Y_swobodne(i-1) y_ob(k)];
        else
            q_pred = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) y_ob(k-1+i) y_ob(k-2+i)];
        end
        Y_swobodne(i) = w20 + w2*tanh(w10 + w1*q_pred')+ d(k);
    end
    s(1:N) = 0;
    for j=1:N
        b_czlon = 0;
        a_czlon = 0;
        for i=1:min(j,length(b))
            b_czlon = b_czlon + b(i);
        end
        for p = 1:min(j-1,length(a))
             a_czlon = a_czlon + (a(p) * s(j-p));
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
        dU = K * (Yzadk - Y_swobodne');
        u(k) = dU(1) + u(k-1);
        u(k) = max(min(u(k), Umax), Umin);
        e(k) = (yzad(k) -y_ob(k));
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
hold on
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
title('Charakterystyki y,y_{zad}');
xlabel('k - number próbki');
ylabel('Wartość')
legend("Wartość na wyjściu y", "Wartość zadana y_{zad}",Location="northwest")
matlab2tikz ('zad5dodPID.tex' , 'showInfo' , false)