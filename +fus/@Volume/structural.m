function Z = structural(obj,threshold,display)
% Z = structural(obj,threshold)
% 
% Returns a quick easy "structural" which is just a thresholded average
% across all time samples.
% 
% threshold is simply the number of standard deviations for each pixel over
% time.

if nargin < 2 || isempty(threshold), threshold = 2; end
if nargin < 3 || isempty(display), display = true; end

S = arrayfun(@(a) structural(a,threshold,false),obj.Planes,'uni',0);
n = size(S{1});
Z = reshape(cell2mat(S'),[n length(S)]);

if display
    figure('color','k')
    colormap bone
    nrows = ceil(sqrt(obj.numPlanes));
    ncols = ceil(obj.numPlanes/nrows);
    for i = 1:obj.numPlanes
        x = obj.Planes(1).xVec;
        y = obj.Planes(1).yVec;
        subplot(nrows,ncols,i);
        imagesc(x,y,Z(:,:,i));
        axis image
        h = title(obj.Planes(i).Name);
        h.Color = 'w';
        h.Interpreter = 'none';
        set(gca,'xtick',[],'ytick',[]);
        drawnow
    end
end

if nargout == 0, clear Z; end
