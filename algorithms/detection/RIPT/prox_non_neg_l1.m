function X_hat = prox_non_neg_l1(X, tau)
    X_hat = max(X - tau, 0);
end