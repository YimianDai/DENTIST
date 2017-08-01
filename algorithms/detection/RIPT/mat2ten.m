function ten = mat2ten(mat, size_arr, i)

% 2017-07-31
% This matlab code implements the RIPT model for infrared target-background 
% separation.
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics  

perm_size = size_arr;
perm_size(i) = [];
perm_size = [size_arr(i), perm_size];
perm_ten = reshape(mat, perm_size);
N = length(size_arr);
order = 2:N;
if i == N
    order = [order, 1];
elseif i == 1
    order = [1, order];
else       
    order = [order(1:i-1), 1, order(i:end)];    
end
ten = permute(perm_ten, order);
