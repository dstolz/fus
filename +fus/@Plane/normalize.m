function obj = normalize(obj,varargin)
    
if ~obj.data_is_loaded, return; end

obj.Data = normalize(obj.Data,3,varargin{:});

obj.Manifest.add('MANIPULATION','normalize',varargin);