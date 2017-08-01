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

clc;
clear;
close all;

utilsPath = '../../../utils';
addpath(utilsPath);
addpath('../../../label');

% setup parameters
patchSize = 30;
slideStep = 10;
lambdaL = 0.7;  % tuning
muCoef = 5;
h = 1;          % tuning

for setId = 2
    setImgNumArr = [3 100 100 100 100 5 32 3 1 120 30];
    setImgNum = setImgNumArr(setId);
    clear tarCube;
    
%     for imgId = 1:setImgNum
    for imgId = 2:10
        img = get_infrared_img(setId, imgId, utilsPath); % double 0-255                                
                
        tenF = gen_patch_ten(img, patchSize, slideStep);

        lambda = lambdaL / sqrt(min(size(tenF)));           
        mu = muCoef * std(tenF(:));

        [lambda1, lambda2] = structure_tensor_lambda(img, 'Gaussian', 3);
        diffLambda = exp(h * mat2gray(lambda1 - lambda2));
        structTenW = gen_patch_ten(diffLambda, patchSize, slideStep);
        
        [tenB, tenT] = ript(tenF, lambda, mu, structTenW);
        tarImg = res_patch_ten_mean(tenT, img, patchSize, slideStep);
       
%         tarCube(:, :, imgId) = tarImg;        
        figure; imshow(tarImg, []);
    end % imgId
%     savePath = '../../../outputs/detection/RIPT/sepData/';    
%     saveName = ['set_' num2str(setId) '_L_' num2str(lambdaL) '_N_' ...
%         num2str(N) '_Cube'];    
%     save([savePath saveName], 'tarCube');
end % setId