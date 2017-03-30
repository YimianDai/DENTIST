function [hatA, hatE, iter] = nipps(D, lambda, xN)

% 2017-03-25
% This matlab code implements the NIPPS model for infrared target-background 
% separation.
%
% D - m x n patch-image (required input)
%
% lambda - weight on sparse error term in the cost function
%
% xN - ratio of N or N
%    - xN < 1, take it as ratio
%    - xN >= 1, take it as number
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics

[m, n] = size(D);
if ~exist('lambda', 'var')
    lambda = 1 / sqrt(min(m,n));
end

if ~exist('xN', 'var')
    N = 1;
elseif xN < 1    
    ratioN = xN;
    N = calc_N(D, ratioN);
else
    N = xN;
end

tol = 1e-7;
maxIter = 1000;
% initialize
Y = D;
norm_two = lansvd(Y, 1, 'L');
norm_inf = norm( Y(:), inf) / lambda;
dual_norm = max(norm_two, norm_inf);
Y = Y / dual_norm;

hatA = zeros( m, n);
hatE = zeros( m, n);
mu = 1.25 / norm_two; % this one can be tuned
muBar = mu * 1e7;
rho = 1.5;          % this one can be tuned
normD = norm(D, 'fro');

iter = 0;
converged = false;

while ~converged
    iter = iter + 1;
    
    % Target component T
    tempT = D - hatA + (1 / mu) * Y;
    hatE = max(tempT - lambda / mu, 0); % Non-negative constraint for the target 
        
    % Background component B
    [U, S, V] = svd(D - hatE + (1 / mu) * Y, 'econ');
    diagS = diag(S);
    [desS, sIdx] = sort(diagS, 'descend');
    [desU, desV] = deal(U(:, sIdx), V(:, sIdx));
    [U1, diagS1, V1] = deal(desU(:, 1:N), desS(1:N), desV(:, 1:N));
    [U2, diagS2, V2] = deal(desU(:, N+1:end), desS(N+1:end), desV(:, N+1:end));    
    threshS2 = max(diagS2-1/mu, 0);    
    hatA = U1*diag(diagS1)*V1' + U2*diag(threshS2)*V2';
    
    % Lagrange multiplier
    Z = D - hatA - hatE;    
    Y = Y + mu * Z;
    mu = min(mu * rho, muBar);
    
    %% stop Criterion
    stopC = norm(Z, 'fro') / normD;
    if stopC < tol, converged = true; end
    
    if mod( iter, 10) == 0
        disp(['#svd ' num2str(iter) ' r(A) ' num2str(rank(hatA))...
            ' |E|_0 ' num2str(length(find(abs(hatE)>0)))...
            ' stopC ' num2str(stopC)]);
    end
    
    if ~converged && iter >= maxIter
        disp('Maximum iterations reached') ;
        converged = 1 ;
    end
end

function N = calc_N(D, ratioN)
    [~, S, ~] = svd(D, 'econ');
    [desS, ~] = sort(diag(S), 'descend');
    ratioVec = desS / desS(1);
    idxArr = find(ratioVec < ratioN);
    if idxArr(1) > 1
        N = idxArr(1) - 1;
    else
        N = 1;
    end