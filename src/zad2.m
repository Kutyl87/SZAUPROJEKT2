clear
umin = -1;
umax = 1;
x = [];
y = [];
alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
sym_length = 2000;
separ = 50;
y = [];
u = [];
split_sep = 3;
x1(1:sym_length) =0;
x2(1:sym_length) = 0;
u(1:sym_length) = 0;
rng(42)
for k = 6:sym_length
    % Wyznaczenie u w chwili obecnej za w sposób pseudolosowy
    if mod(k,separ) == k && k <51
        u_curr = u(k);
    elseif mod(k,separ) == 1 && k >=51
        
        u_curr = rand()*2 -1;
    end
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y(k) = g2;
    % Przypisanie wyznaczonego sterowania w obecnej chwili do wektora u
    u(k) = u_curr;
end

% plot(y_valid);
t = 1:2000
plot_data = [u' y']
save('sieci/dane.txt','plot_data','-ascii')
scatter(t,y);
y = [];
u = [];
split_sep = 3;
x1(1:sym_length) =0;
x2(1:sym_length) = 0;
u(1:sym_length) = 0;
rng(3)
for k = 6:sym_length
    % Wyznaczenie u w chwili obecnej za w sposób pseudolosowy
    if mod(k,separ) == k && k <51
        u_curr = u(k);
    elseif mod(k,separ) == 1 && k >=51
        
        u_curr = rand()*2 -1;
    end
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y(k) = g2;
    % Przypisanie wyznaczonego sterowania w obecnej chwili do wektora u
    u(k) = u_curr;
end
figure
plot_data = [u' y']
save('sieci/dane_wal.txt','plot_data','-ascii')
t = 1:2000
scatter(t,y);