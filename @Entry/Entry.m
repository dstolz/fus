classdef (AllowedSubclasses = ?Manifest) Entry
    
    properties
        Type
        Title
        Comments
    end
    
    properties (SetAccess = immutable)
        Date
    end
    
    methods
        function obj = Entry(Type,Title,Comments)
            obj.Date = datestr(now);
            if nargin >= 1, obj.Type  = Type;       end
            if nargin >= 2, obj.Title = Title;      end
            if nargin >= 3, obj.Comments = Comments; end
        end
        
    end
    
end
