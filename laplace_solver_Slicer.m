function [LP] = laplace_solver_Slicer(labelmap,fglabel,sourcelabel,sinklabel,maxiters)
% solves Laplace's equation
%
% maxiters: varies depending on distance between source and sink. see
% below (iterative averaging filter)

% LP: solved Laplacian equation values at foreground
% iter_change: sum of changes per iteration (from iterative averaging filter)

% implementation first initializes using volumetric fast marching from
% source and sink, then weights and combines the two. Next, 
% iterative finite-differences approach to obtain better solution 
% settings, by using a 26-neighbour average to compute the updated potential 
% field, and terminating when the potential field change is below a specified 
% threshold (sum of changes < 0.001%) or a maximum iteration is reached

%% crop the image
orig_labelmap = labelmap;

[x,y,z] = ind2sub(size(orig_labelmap),find(orig_labelmap>0));
cropping = false(size(orig_labelmap)); %initialize
cropping(min(x)-1:max(x)+1,min(y)-1:max(y)+1,min(z)-1:max(z)+1) = true;
labelmap = zeros(max(x)-min(x)+3,max(y)-min(y)+3,max(z)-min(z)+3); %+3 because 2 come from expanding min and max domain by 1;
labelmap(:) = orig_labelmap(cropping==1);

%%

fg = labelmap==fglabel;
source = labelmap==sourcelabel;
sink = labelmap==sinklabel;

total_vol = sum(fg(:));
change_threshold = total_vol/100000; %change threshold should depend on total volume - greater volumes require more

%filter set-up (26 nearest neighbours)
hl=ones(3,3,3);
nelem=numel(hl);
hl=hl./nelem;
hl=hl+hl(2,2,2)./(nelem-1); hl(2,2,2)=0;

bg=(~source & ~sink & ~fg);

%set up vel
vel = zeros(size(labelmap));
vel(fg) = 0.5; %initial guess
vel(source)=0;
vel(sink)=1;
iter_change = zeros(1,maxiters);

% apply filter
iters = 0;
while iters < maxiters %max iterations
    iters = iters+1;
    
    velup = imfilter(vel,hl,'replicate','conv'); %apply averaging filter
    
    %insulate the grey matter so gradient doesn't pass between folds -
    %inspired by ndnanfilter
    insulate_correction = imfilter(double(~bg),hl,'replicate','conv');
    velup = velup./insulate_correction; 
    velup(bg|source)=0;
    velup(sink)=1;
    
    %stopping condition
    iter_change(iters) = nansum(abs(vel(fg)-velup(fg))); %compute change from last iteration
    vel = velup;
    if iter_change(iters)<change_threshold
        break
    end
end
vel = vel./max(vel(:));
vel(~fg) = nan;

LP = nan(size(orig_labelmap));
LP(cropping==1) = vel;