classdef Manifest < handle
    
    properties (SetAccess = private)
        Entries (:,1) fus.Entry
    end
    
    properties (Dependent)
        Types
    end
    
    properties (SetAccess = immutable)
        CreationDate
    end
    
    methods
        
        function obj = Manifest
            obj.CreationDate = datestr(now);
        end
        
        function obj = add(obj,varargin)
            obj.Entries(end+1) = fus.Entry(varargin{:});
        end
        
        function idx = find(obj,type)
            idx = find(ismember({obj.Entries.Type},type));
        end
        
        function t = get.Types(obj)
            t = unique({obj.Entries.Type});
        end
        
        function t = summary(obj)
            t = '';
            for i = 1:length(obj.Entries)
                t = sprintf('%s%s\n',t,obj.Entries(i).summary);
            end
        end

    end
    
    
end