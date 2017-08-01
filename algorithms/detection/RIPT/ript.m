function [tenB, tenT] = ript(tenF, lambda, mu, structTenW)

% 2017-07-31
% This matlab code implements the RIPT model for infrared target-background 
% separation.
%
% Reference:
% Yimian Dai; Yiquan Wu, "Reweighted Infrared Patch-Tensor Model With Both 
% Nonlocal and Local Priors for Single-Frame Small Target Detection," in 
% IEEE Journal of Selected Topics in Applied Earth Observations and Remote 
% Sensing , vol.PP, no.99, pp.1-16 doi: 10.1109/JSTARS.2017.2700023
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics

% initialize
rho = 1.5;
tol = 10^(-7);
normF = norm(tenF(:));

N = ndims(tenF);
tenBs = cell(N);
tenT = zeros(size(tenF));
tenLambdas = cell(N);
for n = 1:N
    tenBs{n} = tenF;
    tenLambdas{n} = zeros(size(tenF));
end

preNumT = numel(tenT);

weightTen = ones(size(tenF)) .* structTenW;

iter = 0;
converged = false;
while ~converged
    iter = iter + 1;
    %% Update low-rank background tensor B
    for i = 1:N
        tempTen = tenF + mu * tenLambdas{i} - tenT;
        tempTenMat = ten2mat(tempTen, i);
        [UMat, SMat, VMat] = svd(double(tempTenMat), 'econ');
        THSMat = max(SMat-mu, 0);
        tenBs{i} = mat2ten(UMat*THSMat*VMat', size(tempTen), i);
    end        

    %% Update sparse target tensor T
    temp = zeros(size(tenF));
    for i = 1:N
        temp = temp + tenBs{i} - tenF - mu * tenLambdas{i};
    end
    tenT = prox_non_neg_l1(-1/N * temp, weightTen * mu * lambda / N);
    weightTen = 1 ./ (abs(tenT) + 0.01) .* structTenW;   

    % Update Lambda1, Lambda2, mu
    for i = 1:N
        tenLambdas{i} = tenLambdas{i} - 1 / mu * (tenBs{i} + tenT - tenF);
    end   
    mu = mu / rho;    

    %% Output
    accTen = zeros(size(tenF));
    for i = 1:N
        accTen = accTen + tenBs{i};
    end
    tenB = accTen / N;
    stopCriterion = norm(tenF(:) - tenB(:) - tenT(:)) / normF;  

    currNumT = sum(tenT(:) > 0); 
    if (stopCriterion < tol) || (currNumT == preNumT)
        converged = true;
    end          
    preNumT = currNumT; 
    disp(['#Iteration ' num2str(iter) ' |T|_0 ' ...
        num2str(sum(tenT(:) > 0)) ...
        ' stopCriterion ' num2str(stopCriterion)]);        
end