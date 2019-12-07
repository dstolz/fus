classdef Entry
    
    properties
        Type        (1,:) char
        Title       (1,:) char
        Info    % any datatype
    end
    
    properties (SetAccess = immutable)
        Timestamp (1,1) double
        Stack
    end
    
    methods
        function obj = Entry(Type,Title,Info)
            obj.Timestamp = now;

            obj.Stack = dbstack(2);

            if nargin >= 1, obj.Type  = Type;        end
            if nargin >= 2, obj.Title = Title;       end
            if nargin >= 3, obj.Info = Info; end
           
        end
        
    end
    
end
