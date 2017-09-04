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
clc

% add to path the required functions/files
addpath(genpath('funcs'));
addpath(genpath('images'));
addpath(genpath('seeds'));

% beta is 1/sigma
beta = 90;
% number of infections/labels
classes = 4;
% additional colors for different infections/labels and their seeds
colors = distinguishable_colors(30);
% give your own seeds, else use test seeds
test_seeds = 0;

if test_seeds 
    load test_seedsloc4.mat
else
    seedsloc = [];
end;

%%%% read original image
I = imread('241004.jpg');

%%%% create graph
[edges, PixelRegionList2ind, PixelRegionList1ind, ...
    points, new_erasezeroList, SpecialzeroList, BIG, intens, f, nodes] = ...
    getEdges(I);

%%%% get seeds and labels
[seedsnod, seedsloc, classes] = GetSeeds(I, ...
    seedsloc, points, classes);
labels = CreateLabels(seedsnod);

%%%% run RW
labels_RW = random_walker(I,edges, intens, [seedsnod{:}], labels, beta, ...
    'RW', 1);

%%%% run NRW
labels_NRW = random_walker(I, edges, intens, [seedsnod{:}], labels, beta, ...
    'NRW', 1);

%%%% show graph-based results
class_List = 1 : classes;
show_graph_result(I, labels_RW, labels_NRW, class_List, points, seedsloc, colors)

%%%% create output images
tic
Iout_RW = createfinal(I, labels_RW, PixelRegionList2ind, ...
    colors, BIG, f, new_erasezeroList, ...
    SpecialzeroList);
time_rw = toc;
disp(['RW output image created in ' num2str(toc) ' seconds'])

tic
Iout_NRW = createfinal(I, labels_NRW, PixelRegionList2ind, ...
    colors, BIG, f, new_erasezeroList, ...
    SpecialzeroList);
time_nrw = toc;
disp(['NRW output image created in ' num2str(toc) ' seconds'])

%%%% show pixel-based results
show_pixel_result(Iout_RW, Iout_NRW, seedsloc, colors, classes)


