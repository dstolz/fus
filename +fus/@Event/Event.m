classdef Event < handle

    properties
        Name        (1,:) char
        Description (1,:) char
        Onset       (1,1) double = 0;
        Duration    (1,1) double = 1;
        Value       (1,1) double = nan;

        Fs          (1,1) double {mustBeNonempty,mustBePositive,mustBeFinite} = 1;
        
        % graphics objects
        ax          (1,1)
        hOnset      (1,1)
        hOffset     (1,1)
    end

    properties (Dependent)
        hAll        (1,:)
        Offset
    end


    methods
        function obj = Event(Name,Value,Onset,Duration,Fs)
            narginchk(4,5);

            obj.Name = Name;        
            obj.Value = Value;       
            obj.Onset = Onset;       
            obj.Duration = Duration; 

            if nargin >= 5 || isempty(Fs), obj.Fs = Fs; end
            
        end

        function t = get.Offset(obj)
            t = obj.Onset + obj.Duration;
        end
        
        function h = get.ax(obj)
            if isempty(obj.ax) || ~isa(obj.ax,'axes')
                h = gca;
                obj.ax = h;
            else
                h = obj.ax;
            end
        end

        function h = get.hOnset(obj)
            if isempty(obj.hOnset) || ~isa(obj.hOnset,'line')
                h = line(obj.ax,nan,nan);
                obj.hOnset = h;
            else
                h = obj.hOnset;
            end
        end

        function h = get.hOffset(obj)
            if isempty(obj.hOffset) || ~isa(obj.hOffset,'line')
                h = line(obj.ax,nan,nan);
                obj.hOffset = h;
            else
                h = obj.hOffset;
            end
        end

        
        function h = get.hAll(obj)
            h = [obj.hOnset obj.hOffset];
        end
    end
end