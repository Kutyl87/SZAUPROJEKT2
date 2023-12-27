%% Identyfikacja opóźnienia
clear
umin = -1;
umax = 1;
x = [];
y = [];
alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
sym_length = 600;
y = [];
u_train = [];
u_valid = [];
y_train = [];
y_valid = [];
u = [];
split_sep = 3;
x1(1:sym_length) =0;
x2(1:sym_length) = 0;
u(1:30) = 0;
u(31:300) = 0.5;
u(301:600) = 1;
for k = 6:sym_length
    g1 = (exp(7.5 * u(k-5))-1)/(exp(7.5*u(k-5))+1);
    x1(k) = -alpha1 * x1(k-1) + x2(k-1) + beta1 * g1;
    x2(k) = -alpha2 * x1(k-1) + beta2 *g1;
    g2 = 1.2 * (1 - exp(-1.5 * x1(k)));
    y(k) = g2;
end
plot(y, "LineWidth",1);
hold on
plot(u, LineStyle="--", LineWidth=1)
ylim([0,1.3])
% plot(y_valid);