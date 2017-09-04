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

clear
close all
clc;

%%%% load required functions
addpath(genpath('funcs'));
addpath(genpath('images'));
addpath(genpath('seeds'));

%%%% read original image

%%%% to replicate paper result
% img = im2double(imread('axial_CT_slice.bmp'));
% img = img(80:150,105:165);
% load paper_loc.mat

%%%% swan example
img = im2double(imread('8068.jpg'));
%%%% make image small for demo purposes
img = rgb2gray(imresize(img,0.25));
seedsloc = [];

%%%% create graph
[edges, PixelRegionList2ind, PixelRegionList1ind, ...
    points, new_erasezeroList, SpecialzeroList, BIG, intens, f, ~] = ...
    getEdges(img);
colors=distinguishable_colors(30);

%%%% number of infections and scale-related parameter
classes = 2;
beta = 90;

%%%% get seeds and labels
[seedsnod, seedsloc, classes] = GetSeeds(img, ...
    seedsloc, points, classes);
labels = CreateLabels(seedsnod);
seeds_other = get_seeds_other(seedsnod, classes);

%%%% change colors for 2 infection case
if classes == 2
    colors(1, :) = [0 0 1];
    colors(2, :) = [1 0 0];
    colors(3, :) = [0 1 0];
    colors(4, :) = [1 1 0];
end;

%%%% setup weights
weights = makeweights(edges, intens, beta);

%%%% number of nodes
nodes = length(intens);

%%%% resistance parameter for NLRW iterative scheme
alpha = 0.99;

%%%% number of iterations (set to high value to see convergence)
v = 1 : 500000;

%%%% run RW
[labels_RW, probs_RW, Lrw, Drw, Wrw] = random_walker(img, edges, intens, [seedsnod{:}], labels, beta, ...
    'RW', []);

%%%% run NRW
[labels_NRW, probs_NRW, Lnrw, Dnrw, Wnrw] = random_walker(img, edges, intens, [seedsnod{:}], labels, beta, ...
    'NRW', []);

%%%% run NLRW
[labels_NLRW, probs_NLRW, Lnlrw, Dnlrw, Wnlrw] = random_walker(img, edges, intens, [seedsnod{:}], labels, beta, ...
    'NLRW', alpha);

figure

%%%% Plot steady states using the solution of RW, NRW, NLRW. Note that
%%%% the steady states correspond to solving the RW, NRW, NLRW iterative
%%%% schemes until convergence. The number of iterations needed to converge
%%%% varies a lot and can be very high in some cases

subplot(2, 3, 4)
imshow(img), hold on, title('RW steady state')

for j = 1 : classes
    scatter(points(labels_RW == j,1),points(labels_RW==j,2),45,'fill','MarkerFaceColor',colors(j, :))
    scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor',colors(j+classes, :))
end;

subplot(2, 3, 5)
imshow(img), hold on, title('NRW steady state')

for j = 1 : classes
    scatter(points(labels_NRW == j,1),points(labels_NRW==j,2),45,'fill','MarkerFaceColor',colors(j, :))
    scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor',colors(j+classes, :))
end;

subplot(2, 3, 6)
imshow(img), hold on, title('NLRW steady state')

for j = 1 : classes
    scatter(points(labels_NLRW == j,1),points(labels_NLRW==j,2),45,'fill','MarkerFaceColor',colors(j, :))
    scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor',colors(j+classes, :))
end;

%%%% initialize infection levels using reference values
I = zeros(classes, nodes);

for i = 1 : classes
    
    I(i, seedsnod{i}) = 1;
    
end;

%%%% initialize the 3 methods: RW, NRW, NLRW
Irw = I;
Inrw = I;
Inlrw = I;

%%%% for proper diffusion you need L_RW\D, L_RW = D - W
Lrw = speye(nodes) - Drw\Wrw;

for k = 1 : v(end) + 1
    
    [frw, Irw] = diffusion_RW(Lrw, Irw, seedsnod, ...
        seeds_other, classes);
    [fnrw, Inrw] = diffusion_NRW(Lnrw, Inrw, seedsnod, ...
        seeds_other, classes);
    [fnlrw, Inlrw] = diffusion_NLRW(Lnlrw, Inlrw, seedsnod, ...
        seeds_other, classes);
    
    %%%% show result every 5 iterations
    if mod(k, 5) == 0
        
        subplot(2, 3, 1)
        imshow(img),hold on, title(['RW: ' num2str(k)])
        
        for j = 1 : classes
            scatter(points(frw==j, 1),points(frw==j, 2), 45,'fill','MarkerFaceColor',colors(j, :))
            scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor', colors(j+classes, :))
        end;
        scatter(points(frw==0, 1),points(frw==0,2),45,'fill','MarkerFaceColor', 'k')
        
        subplot(2, 3, 2)
        imshow(img),hold on, title(['NRW: ' num2str(k)])
        
        for j = 1 : classes
            scatter(points(fnrw==j, 1),points(fnrw==j, 2), 45,'fill','MarkerFaceColor',colors(j, :))
            scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor', colors(j+classes, :))
        end;
        scatter(points(fnrw==0, 1),points(fnrw==0,2),45,'fill','MarkerFaceColor', 'k')
        
        subplot(2, 3, 3)
        imshow(img),hold on, title(['NLRW: ' num2str(k)])
        
        for j = 1 : classes
            scatter(points(fnlrw==j, 1),points(fnlrw==j, 2), 45,'fill','MarkerFaceColor',colors(j, :))
            scatter(points(seedsnod{1, j},1),points(seedsnod{1, j},2),45,'fill','MarkerFaceColor', colors(j+classes, :))
        end;
        scatter(points(fnlrw==0, 1),points(fnlrw==0,2),45,'fill','MarkerFaceColor', 'k')
        
        pause(0.001)
        
    end;
    
end;


