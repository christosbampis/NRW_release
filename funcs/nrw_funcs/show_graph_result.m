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

function show_graph_result(I, labels_RW, labels_NRW, class_List, ...
    points, seedsloc, colors)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This function displays the graph results for RW and NRW
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

classes = length(class_List);

figure

subplot(1,2,1)
imshow(I), hold on

for k = 1 : classes
    
    fl = find(labels_RW == class_List(k));
    scatter(points(fl, 1), points(fl, 2), 10, 'fill', 'MarkerFaceColor', colors(k, :))
    temp = seedsloc{k};
    scatter(temp(:, 1), ...
        temp(:, 2), 25, 'fill', 'MarkerFaceColor', colors(k+4, :));
    
end;

hold off;

title('Graph-based RW')

subplot(1, 2, 2)
imshow(I), hold on

for k = 1 : classes
    
    fl = find(labels_NRW == class_List(k));
    scatter(points(fl, 1), points(fl, 2), 10, 'fill', 'MarkerFaceColor', colors(k, :))
    temp = seedsloc{k};
    scatter(temp(:,1), ...
        temp(:, 2), 25, 'fill', 'MarkerFaceColor', colors(k+4, :));
    
end;

hold off;

title('Graph-based NRW')

% saveas(gcf, 'result_g2.png')

end

