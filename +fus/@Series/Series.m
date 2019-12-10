classdef Series < handle

    properties
        Events      (:,1) fus.Event

        Name        (1,:) char {mustBeNonempty} = 'Series';
        Description (1,:) char
        
        Fs          (1,1) double {mustBeNonempty,mustBePositive,mustBeFinite} = 1;
        Properties  (1,1) struct    

        plotStyle   (1,:) char {mustBeMember(plotStyle,{'block','patch','verticalLine'})} = 'block';
        hLineProps  (1,1) 
    end

    properties (Dependent)
        Time
        Samples
        eventOnsets
        eventOffsets
        eventValues
        eventOnsetsSamples
        eventOffsetsSamples
        N
    end
    
    properties (SetAccess = private)
        
    end


    methods
        function obj = Series(Name,onsets,durations,values,Fs)

            narginchk(4, 5);

            obj.Name = Name;
            
            if nargin == 5 && ~isempty(Fs), obj.Fs = Fs; end
            
            if isscalar(durations)
                durations = repmat(durations,size(onsets));
            end
            assert(length(onsets)==length(durations),'length(onsets) ~= length(durations)')
            

            if isscalar(values) 
                values = repmat(values,size(values));
            end
            assert(length(onsets)==length(values),'length(onsets) ~= length(values)')
            
            
            onsets    = onsets(:);
            durations = durations(:);
            values    = values(:);

            obj.Events = arrayfun(@(a,b,c) fus.Event(obj.Name,a,b,c,obj.Fs),values,onsets,durations);
        end

        function n = get.N(obj)
            n = length(obj.Events);
        end


        function v = get.Time(obj)
            v = min(obj.eventOnsets):1/obj.Fs:max(obj.eventOffsets)-1/obj.Fs;
        end

        function s = get.Samples(obj)
            s = round(obj.Fs*obj.Time);
        end
        
        function t = get.eventOnsets(obj)
            t = [obj.Events.Onset];
        end
        
        function t = get.eventOffsets(obj)
            t = [obj.Events.Offset];
        end
        
        function v = get.eventValues(obj)
            v = {obj.Events.Value};
        end
        
        
        function s = get.eventOffsetsSamples(obj)
            s = round(obj.Fs*obj.eventOffsets);
        end
        
        function s = get.eventOnsetsSamples(obj)
            s = round(obj.Fs*obj.eventOnsets);
        end
        
        
        function e = getEpochs(obj,window)
            narginchk(2,2);
            if isscalar(window), window = [0 window]; end
            assert(length(window)==2,'fus.Series:getEpochs:window must have 2 values')
            window = sort(window);
            swin = round(obj.Fs*window);
            e = obj.eventOnsetsSamples(:)+(swin(1):swin(2));
        end
        
        
        
        
        
        
        
%         function set.hLineProps(obj,lh)
%             % update all Events with new info
%             
%             assert(isa(lh,'matlab.graphics.primitive.Line'),'Must be matlab.graphics.primitive.Line')
%             
%             % properties(matlab.graphics.primitive.Line)
%             p = {'Color','LineStyle','LineWidth','Marker','MarkerSize', ...
%                 'MarkerEdgeColor','MarkerFaceColor','Clipping','AlignVertexCenters',...
%                 'LineJoin','Parent','Visible','UIContextMenu','ButtonDownFcn', ...
%                 'BusyAction','Interruptible','CreateFcn','DeleteFcn', ...
%                 'Tag','HitTest','PickableParts'};
%             
%             for n = p
%                 cn = char(n);
%                 for i = 1:obj.N
%                     obj.Events(i).hLineProps.(cn) = lh.(cn);
%                 end
%             end
%         end
        
        
        function h = plot(obj,ax)
            
            if nargin < 2 || isempty(ax), ax = gca; end
            
            obj.ax = ax;
            
            tOn  = obj.eventOnsets;
            tOff = obj.eventOffsets;
            val  = obj.eventValues;
            
            y = ax.YLim;
            
            % NOTE: MAYBE THE GRAPHICS OBJECTS SHOULD NOT BE CONTAINED IN
            % THE EVENT OBJECT IN THE CASE THE USER WOULD PLOT INTO
            % MULTIPLE AXES USING THE SAME SERIES OBJECT
                                
            switch obj.plotStyle
                case 'block'
                    
                    
                case 'patch'
                    
                case 'verticalLine'
                    set([obj.Events.hAll], 'Parent',ax);
                    for i = 1:obj.N
                        set(obj.Events(i).hOnset,'XData',[tOn(i) tOn(i)],'YData',y);
                        set(obj.Events(i).hOffset,'XData',[tOff(i) tOff(i)],'YData',y);
                    end
            end
            
            h = obj.ax.Children;
        end
        
        
        function u = unique(obj)
            u = unique({obj.Events.Name});
        end
        
    end


end