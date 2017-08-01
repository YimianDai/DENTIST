function mat = ten2mat(ten, i)

% 2017-07-31
% This matlab code implements the RIPT model for infrared target-background 
% separation.
%
% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics  

N = ndims(ten);
order = 1:N;
order(i) = [];
order = [i, order];
perm_ten = permute(ten, order);
ten_size = size(perm_ten);
rows = ten_size(1);
cols = prod(ten_size(2:end));
mat = reshape(perm_ten, [rows, cols]);
