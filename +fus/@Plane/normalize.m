function obj = normalize(obj,varargin)
% obj = normalize(obj,varargin)
% 
% Functions like the standard normalize function
    
if ~obj.dataIsLoaded, return; end

obj.Data = normalize(obj.Data,3,varargin{:});

obj.Manifest.add('MANIPULATION','normalize','');