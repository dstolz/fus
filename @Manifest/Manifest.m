classdef Manifest
    
    properties (SetAccess = private)
        Entries (:,1) Entry
    end
    
    properties (SetAccess = immutable)
        CreationDate
    end
    
    methods
        
        function obj = Manifest
            obj.CreationDate = datestr(now);
        end
        
        function obj = add(obj,varargin)
            obj.Entries(end+1) = Entry(varargin{:});
        end
        
    end
    
    
end