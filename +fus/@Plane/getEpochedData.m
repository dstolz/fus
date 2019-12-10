function D = getEpochedData(obj,seriesIdx,window)
% D = getEpochedData(obj,seriesIdx,window)
%
% Returns peri-event onset data of size MxNxP, where M is the
% number of pixels, N is the number of events for seriesIdx,
% and P is the number of samples in the window.
%
% Samples from outside the bounds of the data are returned as
% NaN values.

assert(isscalar(seriesIdx) ...
    && seriesIdx >= 1 && seriesIdx <= length(obj.EventSeries), ...
    'fus.Plane:getEpochedData:seriesIdx must be a scalar integer >= 1 and <= length(fus.Plane.EventSeries)');

S = obj.EventSeries(seriesIdx);

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

D = reshape(D,[size(obj.Data,[1 2])

obj.Manifest.add('EXTERNAL','fus.Plane:getEpochedData', ...
    sprintf('seriesIdx: %d\nSeries: %s\nwindow: %s', ...
    seriesIdx,S.Name,mat2str(window)));
end


