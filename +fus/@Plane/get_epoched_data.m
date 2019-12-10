function D = get_epoched_data(obj,series,window,asDelta)
% D = get_epoched_data(obj,series,window,asDelta)
%
% Returns peri-event onset data of size MxNxPxQ, where M and N
% are the number of pixels in X and Y dimensions of the plane,
% P is the number of peri-event samples relative to stimulus onset, 
% and Q is the number of stimuli.
%
% Samples from outside the bounds of the data are returned as
% NaN values.

% TO DO: Add filter by values and value logic

if isnumeric(series)
assert(isscalar(series) ...
    && series >= 1 && series <= length(obj.EventSeries), ...
    'fus.Plane:get_epoched_data:series must be a scalar integer >= 1 and <= length(fus.Plane.EventSeries)');
else
    i = ismember({obj.EventSeries.Name},series);
    assert(any(i),'fus.Plane:get_epoched_data:series must be a scaler integer or name of an EventSeries')
    series = i;
end

S = obj.EventSeries(series);

% sidx: samples X events
sidx = S.get_epochs(window);
sz = size(sidx);

% D2d: pixels X samples 
D2d = obj.data2D;

% D: pixels X samples X events
D = nan([size(D2d,1) size(sidx)],'like',obj.Data(1));

indOoB = sidx < 1 | sidx > size(D2d,2);
sidx(indOoB) = 1;


if asDelta
    onIdx = S.onsetsIdx;
    for j = 1:size(D,1)
        y = reshape(D2d(j,sidx),sz);
        y(indOoB) = nan;
        ty = y(sidx < onIdx);
        ty = reshape(ty,length(ty)/sz(2),sz(2));
        D(j,:,:) = y - mean(ty,1,'omitnan');
    end
else
    for j = 1:size(D,1)
        y = reshape(D2d(j,sidx),sz);
        y(indOoB) = nan;
        D(j,:,:) = y;
    end
end



n = size(obj.Data);

% D: x X y X samples X events
D = reshape(D,[n(1:2) size(sidx)]);

obj.Manifest.add('EXTERNAL','fus.Plane:get_epoched_data', ...
    sprintf('series: %d\nSeries: %s\nwindow: %s', ...
    series,S.Name,mat2str(window)));


