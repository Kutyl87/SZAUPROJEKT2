clear
umin = -1;
umax = 1;

alpha1 = -1.489028;
alpha2 = 0.535261;
beta1 = 0.012757;
beta2 = 0.010360;
u_sym  = linspace(umin,umax,1000);
y = [];
for i = 1:length(u_sym)
    g1 = (exp(7.5 * u_sym(i))-1)/(exp(7.5*u_sym(i))+1);
    y = [y, 1.2 * (1 - exp(-1.5 * ...
        ((beta2+beta1)*g1 / (1+alpha1+alpha2))))];
end
plot(u_sym,y, LineWidth=1, ...
    DisplayName="Charakterystyka Statyczna");
hold on
scatter(0, 0, 100, 'r', ...
    'DisplayName', 'Nominalny punkt pracy)');
legend('show');
xlabel("Wartość na wejściu - u")
ylabel("Wartość na wyjściu - y")
title("Charakterystyka statyczna")
matlab2tikz('chstat.tex' , 'showInfo' , false) 