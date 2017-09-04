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

function [edges, PixelRegionList2ind, PixelRegionList1ind, ...
    points, new_erasezeroList...
    , SpecialzeroList, BIG, intens, f, nodes] = getEdges(I)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This function creates the graph
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

tic

%%%% generate grayscale image
if size(I, 3) > 1
    Igray = rgb2gray(I);
    gr1=I(:,:,1);
    gr2=I(:,:,2);
    gr3=I(:,:,3);
else
    Igray = I;    
end;

%%%% apply gradient to the grayscale iamge and then watershed transform
f = double(watershed(imgradient(Igray)));

a = histc(f(:), unique(f));
[~, newindexes] = sort(f(:));
newList = mat2cell(newindexes, a', 1);

NL = newList(2:end);

%%%% generate image features (color or grayscale values averaged on R_i)
if size(I, 3) > 1
    
    intens1 = cell2mat(cellfun(@(x) mean(gr1(x)), ...
        NL,'UniformOutput', false));
    intens2 = cell2mat(cellfun(@(x) mean(gr2(x)), ...
        NL,'UniformOutput', false));
    intens3 = cell2mat(cellfun(@(x) mean(gr3(x)), ...
        NL,'UniformOutput', false));
    
    intens = [intens1 intens2 intens3];
    
else
    
    intens = cell2mat(cellfun(@(x) mean(Igray(x)), ...
        NL,'UniformOutput', false));
    
end;

%%%% number of nodes
nodes = size(intens, 1);

[k, l] = cellfun(@(x) ind2sub(size(f), x),...
    newList, 'UniformOutput', false);

snew = mat2cell(cell2mat([l k]), a', 2);

points = cell2mat(cellfun(@(x) mean(x), ...
    [l k], 'UniformOutput', false));
points(1, :)= [];

erasezeroList = newList(1);
grammes = size(f, 1);
erasezeroList = erasezeroList{:};
[erasezeroListgr, erasezeroListst] = ind2sub(size(f), erasezeroList);

t1 = and(erasezeroListgr > 1, ...
    erasezeroListgr < size(f, 1));
t2 = and(erasezeroListst > 1, ...
    erasezeroListst < size(f, 2));
new_erasezeroList = erasezeroList(and(t1, t2));

BIG = [new_erasezeroList - grammes - 1 new_erasezeroList - 1 ...
    new_erasezeroList + grammes-1 new_erasezeroList - grammes ...
    new_erasezeroList + grammes new_erasezeroList - grammes + 1 ...
    new_erasezeroList + 1 new_erasezeroList + grammes + 1];

edges = [f(BIG(:, 1)) f(BIG(:, 5)); ...
    f(BIG(:, 1)) f(BIG(:, 7)); ...
    f(BIG(:, 1)) f(BIG(:, 8)); ...
    f(BIG(:, 2)) f(BIG(:, 6)); ...
    f(BIG(:, 2)) f(BIG(:, 7)); ...
    f(BIG(:, 2)) f(BIG(:, 8)); ...
    f(BIG(:, 3)) f(BIG(:, 4)); ...
    f(BIG(:, 3)) f(BIG(:, 7)); ...
    f(BIG(:, 3)) f(BIG(:, 6)); ...
    f(BIG(:, 4)) f(BIG(:, 8)); ...
    f(BIG(:, 4)) f(BIG(:, 5)); ...
    f(BIG(:, 5)) f(BIG(:, 6))];

edges(edges(:, 1) == 0, :) = [];
edges(edges(:, 2) == 0, :) = [];
edges(edges(:, 1) == edges(:, 2), :) = [];
W = adjacency(edges);
edges = adjtoedges(W);
edges(edges(:, 1) == edges(:, 2), :) = [];
[~, edges2] = RegionAdjacencyGraph(f, 1);
edges = union(edges, edges2, 'rows');
PixelRegionList2ind = snew(2 : end);
PixelRegionList1ind = newList(2 : end);
SpecialzeroList = setdiff(erasezeroList, new_erasezeroList);

disp(['Graph created in ' num2str(toc) ' seconds'])

end

