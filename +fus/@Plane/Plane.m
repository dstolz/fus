classdef Plane < handle
    % P = fus.Plane([filename])
    %
    % Handles fus data planes
    
    properties
        filename      (1,:) char
        pixelSize     (1,3) double {mustBeNonempty,mustBePositive,mustBeFinite} = [.1 .1 .4];
        realWordCoord (1,3) double {mustBeNonempty,mustBeFinite} = [0 0 0];
        validPixels   (:,:) logical
        
        Mask          (:,:) logical 

        Name          (1,:) char % defaults to filename
        
        EventSeries   (:,1) fus.Series
        
        Fs            (1,1) double = 1;
        
    end
    
    properties (SetAccess = protected)
        Data
        Manifest (1,1) fus.Manifest
    end
    
    properties (Access = private)
        originalSize
        dimOrder
    end
    
    properties (Dependent)
       
        xVec
        yVec
        tVec
        
        dimPosition

        dataIsLoaded
    end
    
    properties (SetAccess = private, Transient)
        data2D % pixels x time
    end
    
    methods
        obj = detrend(obj,args);
        obj = normalize(obj,args);
        D = get_epoched_data(obj,seriesIdx,window,varargin);
        ED = baseline_correct(obj,baselineWindow,responseWindow,seriesName,varargin);
        mask = create_mask(obj,threshold)
         
        % Constructor
        function obj = Plane(filename)
            if nargin >= 1, obj.filename = filename; end
            obj.Manifest.add('OBJECT','Plane','Plane object created');
        end
        
        
        
        function obj = set.Data(obj,data)
            obj.Data = data;
            obj.Manifest.add('DATA','fus.Plane:set.Data','Data updated');
        end
        
        
        function v = get.xVec(obj)
            v = 0:obj.pixelSize(1):(size(obj.Data,1)-1)*obj.pixelSize;
        end
        
        function v = get.yVec(obj)
            v = 0:obj.pixelSize(2):(size(obj.Data,2)-1)*obj.pixelSize;
        end
        
        function v = get.tVec(obj)
            v = 0:obj.pixelSize(3):(size(obj.Data,3)-1)*obj.pixelSize;
        end
        
        
        function D = get.data2D(obj)
            n = size(obj.Data);
            D = reshape(obj.Data,n(1)*n(2),n(3));
        end

        function obj = set.Mask(obj,M)
            n = size(obj.Data);
            assert(isequal(size(M),n(1:2)),'fus:Plane:set.Mask','Size of a Mask must equal the size of the first 2 dimensions of Data')
            obj.Mask = M;
        end

        
        
        function tf = get.dataIsLoaded(obj)
            tf = ~isempty(obj.Data);
        end
        
        
        
        function d = get.dimOrder(obj)
            switch ndims(obj.Data)
                case 2
                    d = 'pixels_time';
                case 3
                    d = 'x_y_time';
                case 4
                    d = 'x_y_z_time'; % support using volume superclass
            end
        end
        
        function d = get.dimPosition(obj)
            c = textscan(obj.dimOrder,'%s','delimiter','_');
            c = c{1};
            for i = 1:length(c)
                d.(c{i}) = i;
            end
        end
        
        function obj = set.filename(obj,fn)
            assert(exist(fn,'file') == 2,'fus:Plane:set.filename','File not found: %s',fn)
            obj.filename = fn;
        end
        
        function n = get.Name(obj)
            if isempty(obj.Name)
                [~,obj.Name] = fileparts(obj.filename);
            end
            n = obj.Name;
        end

        function s = get_event_series(obj,name)
            ind = ismember({obj.EventSeries.Name},name);
            s = obj.EventSeries(ind);
        end
        
        
        function obj = unload(obj)
            obj.Data = [];
            obj.Manifest.add('DATA','fus.Plane:unload','');
        end
        
        
        % Overloaded functions
        function obj = load(obj)
            
            fprintf('loading "%s" ...',obj.Name)
            
            [pn,fn,ext] = fileparts(obj.filename);
            switch lower(ext)
                case '.mat' % Ali's format for today
                    load(obj.filename);
                    
                    obj.Data = Data.Allframes;
                    obj.originalSize = size(obj.Data);
                    obj.Fs = 1/diff(Data.Time(1:2));
                    
                    obj.pixelSize = [0.1 0.1 0.3]; % guessing because not included
                    
                case '.acq' % Ioconus file format
                    load(obj.filename,'Acquisition','-mat')
                    
                    obj.Data = permute(squeeze(Acquisition.Data),[2 1 3]);
                    obj.originalSize = size(obj.Data);
                    obj.Fs = 1/diff(Acquisition.T(1:2));
                    
                    obj.pixelSize = [diff(Acquisition.W(1:2)) ...
                        diff(Acquisition.U(1:2)) ...
                        1/obj.Fs];
            end
            
            % start a new Manifest
            obj.Manifest = fus.Manifest;
            
            obj.Manifest.add('FILE','fus.Plane:load',...
                sprintf('Loaded: %s',obj.filename));
            fprintf(' done\n')
        end
        
        
        
        
        
    end
    
end