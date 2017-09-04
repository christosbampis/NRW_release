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

function draw_edges(img, points, edges)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This function displays the graph edges
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

imshow(img), hold on
scatter(points(:, 1), points(:, 2), 'k')

for i=1:size(edges,1)
    
    plot([points(edges(i, 1), 1) points(edges(i, 2), 1)], ...
        [points(edges(i, 1), 2) points(edges(i, 2), 2)], 'k');
    
end;

end

