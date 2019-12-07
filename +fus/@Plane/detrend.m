function obj = detrend(obj,varargin)


D = obj.dataAs2D;

for i = 1:size(D,1)
    D(i,:) = detrend(D(i,:),varargin{:});
end

obj.Data = reshape(D,obj.originalSize);

obj.Manifest.add('MANIPULATION','detrend',varargin);