classdef Event < Atom

    properties
        Atoms (:,1) fus.Atom
    end


    methods
        function obj = Event(Name,Properties,Onset,Duration,Fs)
            if nargin >= 1, obj.Name = Name;             end
            if nargin >= 2, obj.Properties = Properties; end
            if nargin >= 3, obj.Onset = Onset;           end
            if nargin >= 4, obj.Duration = Duration;     end
            if nargin >= 5, obj.Fs = Fs;                 end
        end
    end

end