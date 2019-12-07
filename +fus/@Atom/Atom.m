classdef Atom

    properties
        Name        (1,:) char
        Description (1,:) char
        Onset       (1,1) double = 0;
        Duration    (1,1) double = 1;
        Fs          (1,1) double = 1;
        Properties  (1,1) struct    

        Style 
    end


    methods
        function obj = Instance(Name,Properties,Onset,Duration,Fs)
            if nargin >= 1, obj.Name = Name;             end
            if nargin >= 2, obj.Properties = Properties; end
            if nargin >= 3, obj.Onset = Onset;           end
            if nargin >= 4, obj.Duration = Duration;     end
            if nargin >= 5, obj.Fs = Fs;                 end
        end

        
    end
end