function z = structural(obj,threshold,display)

if nargin < 2 || isempty(threshold), threshold = 2; end
if nargin < 3 || isempty(display), display = true; end
        
dil = obj.dataIsLoaded;
if ~dil
    obj.Data = load(obj.Data);
end
dims = obj.dimPosition;
s = std(obj.Data,[],dims.time);
ind = s < threshold;
z = mean(obj.Data,3,'omitnan');
z(ind) = nan;
if ~dil
    obj.Data = unload(obj);
end


if display
    ax = gca;
    colormap(ax,'bone');
    x = obj.xVec;
    y = obj.yVec;
    
    imagesc(x,y,z);
    axis image
    h = title(sprintf('Plane %d',obj.Name));
    set(gca,'xtick',[],'ytick',[]);
    drawnow
end