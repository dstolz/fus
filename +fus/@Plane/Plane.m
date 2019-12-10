classdef Plane
    % P = fus.Plane([filename])
    %
    % Handles fus data planes
    
    properties
        filename      (1,:) char
        pixelSize     (1,3) double {mustBeNonempty,mustBePositive,mustBeFinite} = [.1 .1 .4];
        realWordCoord (1,3) double {mustBeNonempty,mustBeFinite} = [0 0 0];
        validPixels   (:,:) logical
        
        Name     (1,:) char % defaults to filename
        
        EventSeries   (:,1) fus.Series
        
        Fs            (1,1) double = 1;
        
    end
    
    properties (SetAccess = protected)
        Data
        Manifest (1,1) fus.Manifest
    end
    
    properties (Access = private)
        originalSize
    end
    
    properties (Dependent)
        dataDimensions
        
        xVec
        yVec
        tVec
        
    end
    
    properties (SetAccess = private, Transient)
        data2D % pixels x time
    end
    
    methods
        obj = detrend(obj,args);
        obj = normalize(obj,args);
        D = getEpochedData(obj,seriesIdx,window);
        
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
        
        
        function tf = data_is_loaded(obj)
            tf = ~isempty(obj.Data);
            if ~tf
                warning('No data loaded for %s',obj.Name)
            end
        end
        
        
        
        function F = get.dataDimensions(obj)
            switch ndims(obj.Data)
                case 2
                    F = 'pixels_time';
                case 3
                    F = 'x_y_time';
                case 4
                    F = 'x_y_z_time'; % support using superclass
            end
        end
        
        
        function obj = set.filename(obj,fn)
            assert(exist(fn,'file') == 2,'fus.Plane:obj = set.filename:File not found: %s',fn)
            obj.filename = fn;
        end
        
        function n = get.Name(obj)
            if isempty(obj.Name)
                [~,obj.Name] = fileparts(obj.filename);
            end
            n = obj.Name;
        end
        
        
        
        
        
        % Overloaded functions
        function obj = load(obj)
            
            fprintf('loading "%s" ...',obj.Name)
            
            load(obj.filename,'Acquisition','-mat')
            
            obj.Data = squeeze(Acquisition.Data);
            obj.originalSize = size(obj.Data);
            obj.Fs = 1/diff(Acquisition.T(1:2));
            
            obj.pixelSize = [diff(Acquisition.U(1:2)) ...
                             diff(Acquisition.W(1:2)) ...
                             1/obj.Fs];
            
            % start a new Manifest
            obj.Manifest = fus.Manifest;
            
            obj.Manifest.add('FILE','fus.Plane:load',...
                sprintf('Loaded: %s',obj.filename));
            fprintf(' done\n')
        end
        
        
        
        
        
    end
    
end