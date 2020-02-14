function obj = detrend(obj,varargin)
% objPlane = detrend(objPlane,varargin)

if ~obj.dataIsLoaded, return; end

D = obj.data2D;

for i = 1:size(D,1)
    D(i,:) = detrend(D(i,:),varargin{:});
end

obj.Data = reshape(D,obj.originalSize);

obj.Manifest.add('MANIPULATION','detrend','');