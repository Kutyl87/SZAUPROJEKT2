clear
umin = -1;
umax = 1;
x = [];
y = [];
alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
sym_length = 6000;
separ = 60;
y = [];
u_train = [];
u_valid = [];
y_train = [];
y_valid = [];
u = [];
split_sep = 3;
x1(1:sym_length) =0;
x2(1:sym_length) = 0;
u(1:sym_length) = 0;
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
% plot(y); 
for i = 1:length(y)
    if mod(i,split_sep) == 1
        u_valid = [u_valid, u(i)];
        y_valid = [y_valid, y(i)];
    else
        u_train = [u_train, u(i)];
        y_train = [y_train, y(i)];
    end
end
plot(y_valid);
% plot(y_valid);