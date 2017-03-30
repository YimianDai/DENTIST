function img = get_infrared_img(setId, imgId, utilsPath)

% 2017-03-25
% This matlab code reads the image in DENTIST project.
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics

uId = strfind(utilsPath, 'utils');
prefix = [utilsPath(1:uId-1) 'dataset/Set_' num2str(setId) '/' num2str(imgId)];

if ismember(setId, [1, 2, 3, 4, 5, 8, 9])
    imgPath = [prefix '.jpg'];
elseif ismember(setId, [6, 7, 11])
    imgPath = [prefix '.bmp'];
elseif ismember(setId, [10])
    if ismember(imgId, [1:37, 91, 93:120])
        imgPath = [prefix '.png'];
    else
        imgPath = [prefix '.jpg'];
    end
else
    msg = ['Error occurred: Set ' num2str(setId) ' Fig ' num2str(imgId) ' does not exist!'];
    error(msg);
end

img = imread(imgPath);
if size(img, 3) > 1
    img = rgb2gray(img);
end
img = double(img);
        
% if ismember(setId, [1, 2, 3, 4, 5, 8, 9])
%     imgPath = ['D:\MyNutCloud\Bitbucket\PhDThesis\images\Infrared Small Target\SmallTarget' ...
%         num2str(setId) '\' num2str(imgId) '.jpg'];
% elseif ismember(setId, [6, 7, 11])
%     imgPath = ['D:\MyNutCloud\Bitbucket\PhDThesis\images\Infrared Small Target\SmallTarget' ...
%         num2str(setId) '\' num2str(imgId) '.bmp'];
% elseif ismember(setId, [10])
%     if ismember(imgId, [1:37, 91, 93:120])
%         imgPath = ['D:\MyNutCloud\Bitbucket\PhDThesis\images\Infrared Small Target\SmallTarget' ...
%             num2str(setId) '\' num2str(imgId) '.png'];
%     else
%         imgPath = ['D:\MyNutCloud\Bitbucket\PhDThesis\images\Infrared Small Target\SmallTarget' ...
%             num2str(setId) '\' num2str(imgId) '.jpg'];
%     end
% else
%     msg = ['Error occurred: Set ' num2str(setId) ' Fig ' num2str(imgId) ' does not exist!'];
%     error(msg);
% end