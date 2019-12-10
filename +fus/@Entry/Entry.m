classdef Entry
    
    properties
        Type        (1,:) char
        Title       (1,:) char
        Info        (1,:) char
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
        
        function t = summary(obj)
            t = sprintf(['Timestamp: %s\nType: %s\nTitle: %s\nInfo: %s' ...
                '>Calling file: %s\n>Calling name: %s\n>Calling line: %d\n'], ...
                datestr(obj.Timestamp),obj.Type,obj.Title,obj.Info, ...
                obj.Stack(1).file,obj.Stack(1).name,obj.Stack(1).line);
        end
        
    end
    
end
