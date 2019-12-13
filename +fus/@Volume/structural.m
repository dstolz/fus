function Y = structural(obj,threshold)
% Y = structural(obj,threshold)
% 
% Returns a quick easy "structural" which is just a thresholded average
% across all time samples.
% 
% threshold is simply the number of standard deviations for each pixel over
% time.

if nargin < 2 || isempty(threshold), threshold = 2; end

P = obj.Planes;
S = cell(size(P));
parfor i = 1:length(P)
    dil = P(i).data_is_loaded;
    if ~dil
        P(i) = load(P(i));
    end
    dims = P(i).dimPosition;
    s = std(P(i).Data,[],dims.time);
    ind = s < threshold;
    t = mean(P(i).Data,3,'omitnan');
    t(ind) = nan;
    if ~dil
        P(i) = unload(P(i));
    end
    S{i} = t;
end
n = size(S{1});
Y = reshape(cell2mat(S'),[n length(S)]);