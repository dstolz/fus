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
        Onsets
        Offsets
        eventValues
        onsetsIdx
        offsetsIdx
        N
        valueIdx
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
            assert(length(onsets)==length(durations),'fus:Series','length(onsets) ~= length(durations)')
            

            if isscalar(values) 
                values = repmat(values,size(values));
            end
            assert(length(onsets)==length(values),'fus:Series','length(onsets) ~= length(values)')
            
            
            onsets    = onsets(:);
            durations = durations(:);
            values    = values(:);

            obj.Events = arrayfun(@(a,b,c) fus.Event(obj.Name,a,b,c,obj.Fs),values,onsets,durations);
        end

        function n = get.N(obj)
            n = length(obj.Events);
        end


        function v = get.Time(obj)
            v = min(obj.Onsets):1/obj.Fs:max(obj.Offsets)-1/obj.Fs;
        end

        function s = get.Samples(obj)
            s = round(obj.Fs*obj.Time);
        end
        
        function t = get.Onsets(obj)
            t = [obj.Events.Onset];
        end
        
        function t = get.Offsets(obj)
            t = [obj.Events.Offset];
        end
        
        function v = get.eventValues(obj)
            v = [obj.Events.Value];
        end
        
        
        function s = get.offsetsIdx(obj)
            s = round(obj.Fs*obj.Offsets);
        end
        
        function s = get.onsetsIdx(obj)
            s = round(obj.Fs*obj.Onsets);
        end
        
        
        function e = get_epochs(obj,window)
            % e = get_epochs(obj,window)
            % 
            % Returns time X events in samples

            narginchk(2,2);
            if isscalar(window), window = [0 window]; end
            assert(length(window)==2,'fus.Series:get_epochs','window must have 2 values')
            window = sort(window);
            swin = round(obj.Fs*window);
            e = obj.onsetsIdx(:)+(swin(1):swin(2));
            e = e';
        end
        
        
        function idx = get.valueIdx(obj)
            v = obj.eventValues;
            u = unique(v);
            
            idx = cell(size(u));
            for i = 1:length(u)
                idx{i} = find(u(i) == v);
            end
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
            
            tOn  = obj.Onsets;
            tOff = obj.Offsets;
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
            u = unique(obj.eventValues);
        end
        
    end


end