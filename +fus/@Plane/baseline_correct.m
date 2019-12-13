function ED = baseline_correct(obj,baselineWindow,responseWindow,seriesName,varargin)
% ED = baseline_correct(obj,baselineWindow,responseWindow,seriesName,['Name',Value,...])
%
% Returns Epoched Data from the responseWindow after it has been corrected
% by the mean baselineWindow.
% 
% Options:
%   'type'    ... 'percentChange' (default), 'subtractMean', 'dff'
%   'nanflag' ... 'omitnan' (default), 'includenan'
% 
% See also, fus.Plane.get_epoched_data



% set defaults
type = 'subtractMean';
nanflag = 'omitnan';

if nargin > 5
    for i = 1:2:length(varargin)
        switch lower(varargin{i})
            case 'type'
                type = varargin{i+1};
            case 'handlenan'
                nanflag = varargin{i+1};
        end
    end
end


dims = obj.dimPosition;

% ED: X x Y x Samples x Events
ED = obj.get_epoched_data(seriesName,responseWindow);

% baseline
EDb = obj.get_epoched_data(seriesName,baselineWindow);

switch lower(type)
    case 'subtractmean'
        EDb = mean(EDb,dims.time,nanflag);
        ED = ED - EDb;
        
    case 'percentchange'
        EDb = mean(EDb,dims.time,nanflag);
        ED = ED./EDb;
        
    case 'deltafoverf'
        EDb = mean(EDb,dims.time,nanflag);
        ED = (ED - EDb)./EDb;
end
