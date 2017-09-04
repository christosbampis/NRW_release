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
% modified from Grady's implementation
%
% For any questions/comments: cbampis@gmail.com or bampis@utexas.edu
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function [mask, probabilities, L, D, W] = ...
    random_walker(img, edges, intens,...
    seeds, labels, beta, LaplacianVersion, alpha)

[X, Y, ~] = size(img);
seeds = fix(seeds);
[~,kl2] = unique(seeds);
duplic_ind = setdiff(1 : size(seeds, 2), kl2);
seeds(duplic_ind) = [];
labels(duplic_ind) = [];

exitFlag=0;

if(sum(isnan(img(:))) || sum(isinf(img(:)))) %Check for NaN/Inf image values
    disp('ERROR: Image contains NaN or Inf values - Do not know how to handle.')
    exitFlag=1;
end

%Check seed locations argument
if(sum(seeds<1) || sum(seeds>size(img,1)*size(img,2)) || (sum(isnan(seeds))))
    disp('ERROR: All seed locations must be within image.')
    disp('The location is the index of the seed, as if the image is a matrix.')
    disp('i.e., 1 <= seeds <= size(img,1)*size(img,2)')
    exitFlag=1;
end

if(sum(diff(sort(seeds))==0)) %Check for duplicate seeds
    disp('ERROR: Duplicate seeds detected.')
    disp('Include only one entry per seed in the "seeds" and "labels" inputs.')
    exitFlag=1;
end
TolInt=0.01*sqrt(eps);
if(length(labels) - sum(abs(labels-round(labels)) < TolInt)) %Check seed labels argument
    disp('ERROR: Labels must be integer valued.');
    exitFlag=1;
end
if(length(beta)~=1) %Check beta argument
    disp('ERROR: The "beta" argument should contain only one value.');
    exitFlag=1;
end

if(exitFlag)
    disp('Exiting...')
    [mask,probabilities]=deal([]);
    return
end

weights = makeweights(edges,intens,beta);

[L, D, W] = laplacian(edges, weights, LaplacianVersion, alpha);

%Determine which label values have been used
label_adjust=min(labels); labels=labels-label_adjust+1; %Adjust labels to be > 0
labels_record(labels)=1;
labels_present=find(labels_record);
number_labels=length(labels_present);

%Set up Dirichlet problem
boundary=zeros(length(seeds),number_labels);
for k=1:number_labels
    boundary(:,k)=(labels(:)==labels_present(k));
end

%Solve for random walker probabilities by solving combinatorial Dirichlet
%problem
probabilities=dirichletboundary(L,seeds(:),boundary);

%Generate mask
[~,mask]=max(probabilities,[],2);
mask=labels_present(mask)+label_adjust-1; %Assign original labels to mask

