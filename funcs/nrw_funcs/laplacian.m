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

function [L, D, W] = laplacian(edges, weights, option, alpha, N)

%If weights are not specified, use unity weighting
if nargin == 1
    weights = ones(size(edges, 1), 1);
end

%If N is not specified, use maximum values of edges
if nargin < 5
    N = max(max(edges));
end

if strcmp(option, 'NRW')
    W = adjacency(edges, weights, N);
    D = diag(sum(W));
    Dsqrt = diag(diag(D).^(-0.5));
    L = Dsqrt * (D - W) * Dsqrt;   
elseif strcmp(option, 'RW')
    W = adjacency(edges, weights, N);
    D = diag(sum(W));
    L = D - W;   
elseif strcmp(option, 'NLRW')
    W = alpha * adjacency(edges, weights, N);
    W = speye(N) * (1 - alpha) + W;
    D = diag(sum(W));
    Dsqrt = diag(diag(D).^(-0.5));
    L = Dsqrt * (D - W) * Dsqrt;
end;
