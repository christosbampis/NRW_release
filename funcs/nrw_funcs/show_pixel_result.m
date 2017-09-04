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

function show_pixel_result(Iout_RW, Iout_NRW, seedsloc, colors, classes)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% This function displays the pixel results for RW and NRW
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure

subplot(1, 2, 1), imshow(Iout_RW), title('Converted graph-based RW'), hold on

for k = 1 : classes

    temp = seedsloc{k};
    scatter(temp(:, 1), ...
        temp(:, 2), 25, 'fill', 'MarkerFaceColor', colors(k+4, :));
    
end;

subplot(1, 2, 2), imshow(Iout_NRW), title('Converted graph-based NRW'), hold on

for k = 1 : classes

    temp = seedsloc{k};
    scatter(temp(:, 1), ...
        temp(:, 2), 25, 'fill', 'MarkerFaceColor', colors(k+4, :));
    
end;

% saveas(gcf, 'result_p2.png')

end

