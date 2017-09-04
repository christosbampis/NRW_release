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

function [seedsnod, seedsloc, classes] = GetSeeds(I, seedsloc, points, classes)

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% This function gets user pixel seeds (or uses pre-loaded seeds)
% and transforms them to node seeds
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

seedsnod = cell(1, classes);

if isempty(seedsloc)
    
    for i=1:classes
        
        figure
        imshow(I)
        t = title(['Give seeds for class ' num2str(i)]);
        set(t, 'FontSize', 14);
        cnt=0;
        key=1;
        while key==1
            
            cnt=cnt+1;
            freehand=imfreehand('closed',false);
            s=getPosition(freehand);
            [~,~,key]=ginput(1);
            s=round(s);
            if cnt>1
                seedsloc{i}=[seedsloc{i} ; s];
            else
                seedsloc{i}=s;
            end;
            
        end
        close;
        
        seedsnod{i} = unique(knnsearch(points, seedsloc{i})');
        
    end;
    
else
    
    %%%% overwrite classes
    classes = size(seedsloc, 2);
    
    for i = 1 : classes
        seedsnod{i} = unique...
            (knnsearch(points, [seedsloc{i}])');
    end;
    
end;

end

