function obj = normalize(obj,varargin)
    
obj.Data = normalize(obj.Data,3,varargin{:});


obj.Manifest.add('MANIPULATION','normalize',varargin);