% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Author: Christos Bampis
% This code implements various methods described in:
% 
% 1. C. G. Bampis, P. Maragos and A. C. Bovik, "Graph-Driven Diffusion 
% and Random Walk Schemes for Image Segmentation," in IEEE Transactions
% on Image Processing, vol. 26, no. 1, pp. 35-50, Jan. 2017
% 
% 2. C. Bampis and P. Maragos, "Unifying the random walker algorithm and
% the SIR model for graph clustering and image segmentation", in Proc.
% IEEE Int'l Conf. Image Processing (ICIP), Sept. 2015.
% 
% If you use this code, please consider citing these two works.
% 
% v2: Dec. 2016
% For any questions/comments: cbampis@gmail.com or bampis@utexas.edu
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function [f, I] = diffusion_NLRW(L, I, seedsnod, seeds_other, classes)

I = transpose(I' - L * I');

for i = 1 : classes

    I(i, seedsnod{1, i}) = 1;
    I(i, seeds_other{1, i}) = 0;
    
end;

[~, f] = max(I, [], 1);

f(sum(I, 2) == 0) = 0;

end

