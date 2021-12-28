function recImg = res_patch_img_mean(patchImg, img, patchSize, slideStep)

% 2017-03-25
% This matlab code recovers the image from patch-image using 
% mean filter for the sake of speed.
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics

[imgHei, imgWid] = size(img);

rowPatchNum = ceil((imgHei - patchSize) / slideStep) + 1;
colPatchNum = ceil((imgWid - patchSize) / slideStep) + 1;
rowPosArr = [1 : slideStep : (rowPatchNum - 1) * slideStep, imgHei - patchSize + 1];
colPosArr = [1 : slideStep : (colPatchNum - 1) * slideStep, imgWid - patchSize + 1];

%% for-loop version
accImg = zeros(imgHei, imgWid);
weiImg = zeros(imgHei, imgWid);
k = 0;
onesMat = ones(patchSize, patchSize);
for col = colPosArr
    for row = rowPosArr
        k = k + 1;
        tmpPatch = reshape(patchImg(:, k), [patchSize, patchSize]);
        accImg(row : row + patchSize - 1, col : col + patchSize - 1) += tmpPatch;
        weiImg(row : row + patchSize - 1, col : col + patchSize - 1) += onesMat;
    end
end

recImg = accImg ./ weiImg;
