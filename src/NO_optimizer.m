function [J] = NO_optimizer(yzad,y,u, U_predyktowane, teta,N, Nu, lambda, k, w1,w2,w10,w20,d)
Y_swobodne(1:N) = 0;
y_czlon = 0 ;
u_czlon = 0 ;
DU_pred(1:Nu) = 0;
    for i=1:N
        if i>=teta+1
            q_pred = [U_predyktowane(i-teta+1) U_predyktowane(i-teta) Y_swobodne(i-1) Y_swobodne(i-2)];
        elseif i==teta
            q_pred = [U_predyktowane(-teta+i+1) u(k-teta+i-1) Y_swobodne(i-1) Y_swobodne(i-2)];
        elseif i>=3 && i< teta
            q_pred = [u(k-teta+i) u(k-teta+i-1) Y_swobodne(i-1) Y_swobodne(i-2)];
        elseif i==2
            q_pred = [u(k-teta+i) u(k-teta+i-1) Y_swobodne(i-1) y(k)];
        else
            q_pred = [u(k-teta+i) u(k-teta+i-1) y(k-1+i) y(k-2+i)];
        end
        Y_swobodne(i) = w20 + w2*tanh(w10 + w1*q_pred')+ d(k);
        y_czlon = y_czlon + (yzad - Y_swobodne(i))^2;
    end
    for i=1:Nu
        if i==1
            DU_pred(i) = U_predyktowane(i) - u(k-1);
        else
            DU_pred(i) =  U_predyktowane(i) - U_predyktowane(i-1);
        end
        u_czlon = u_czlon + lambda*(DU_pred(i))^2;
    end
    J = y_czlon + u_czlon;
end