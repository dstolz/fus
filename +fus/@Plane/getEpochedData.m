function D = getEpochedData(obj,series,window)
% D = getEpochedData(obj,series,window)
%
% Returns peri-event onset data of size MxNxPxQ, where M and N
% are the number of pixels in X and Y dimensions of the plane,
% P is the number of stimuli, and Q is the number of peri-event 
% samples relative to stimulus onset.
%
% Samples from outside the bounds of the data are returned as
% NaN values.

% TO DO: Add filter by values and value logic

if isnumeric(series)
assert(isscalar(series) ...
    && series >= 1 && series <= length(obj.EventSeries), ...
    'fus.Plane:getEpochedData:series must be a scalar integer >= 1 and <= length(fus.Plane.EventSeries)');
else
    i = ismember({obj.EventSeries.Name},series);
    assert(any(i),'fus.Plane:getEpochedData:series must be a scaler integer or name of an EventSeries')
    series = i;
end

S = obj.EventSeries(series);

sidx = S.getEpochs(window);

d2d = obj.data2D;

% D: pixels X #events X #samples in peri-event onset window
D = nan(size(d2d,1),size(sidx,1),size(sidx,2),'like',obj.Data(1));

indOoB = sidx < 1 | sidx > size(d2d,2);
sidx(indOoB) = 1;

sz = size(sidx);

for j = 1:size(D,1)
    y = reshape(d2d(j,sidx),sz);
    y(indOoB) = nan;
    D(j,:,:) = y;
end

n = size(obj.Data);

% D: x X y X #events X #samples in peri-event onset window
D = reshape(D,[n(1:2) size(sidx)]);

obj.Manifest.add('EXTERNAL','fus.Plane:getEpochedData', ...
    sprintf('series: %d\nSeries: %s\nwindow: %s', ...
    series,S.Name,mat2str(window)));


