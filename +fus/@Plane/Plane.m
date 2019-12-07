classdef Plane
    
    
    properties
        filename      (1,:) char
        pixelSize     (1,3) double {mustBeNonempty,mustBePositive,mustBeFinite} = [.1 .1 .4];
        realWordCoord (1,3) double {mustBeNonempty,mustBeFinite} = [0 0 0];

        Condition     (1,:) char
    end
    
    properties (SetAccess = protected)
        Data
        Manifest (1,1) fus.Manifest
    end
    
    properties (SetAccess = private)
        originalSize
        Fs
    end
    
    properties (Dependent)
        size % lengths of dimensions
        dataDimensions

        xVec
        yVec
        tVec
    end
    
    properties (SetAccess = private, Transient)
        dataAs2D % pixels x time
    end
    
    methods
        obj = detrend(obj,args);
        obj = normalize(obj,args)
        
        % Constructor
        function obj = Plane(filename)
            if nargin >= 1, obj.filename = filename; end
            obj.Manifest = obj.Manifest.add('OBJECT','Plane','Plane object created');
        end
        
        
        
        function obj = set.Data(obj,data)
            obj.Data = data;
            obj.Manifest = obj.Manifest.add('DATA','set.Data','Data updated');
        end
        

        function v = get.xVec(obj)
            v = 0:obj.pixelSize(1):(obj.size(1)-1)*obj.pixelSize;
        end
        
        function v = get.yVec(obj)
            v = 0:obj.pixelSize(2):(obj.size(2)-1)*obj.pixelSize;
        end
        
        function v = get.tVec(obj)
            v = 0:obj.pixelSize(3):(obj.size(3)-1)*obj.pixelSize;
        end
        


        function D = get.dataAs2D(obj)
            D = reshape(obj.Data,prod(obj.size(1:2)),obj.size(3));
        end
        
        
        
        
        
        function F = get.dataDimensions(obj)
            switch length(obj.size)
                case 2
                    F = 'pixels_time';
                case 3
                    F = 'x_y_time';
                case 4
                    F = 'x_y_z_time'; % support using superclass
            end
        end
        
        
        function s = get.size(obj)
            s = size(obj.Data);
        end
        
        
        function obj = set.filename(obj,fn)
            assert(exist(fn,'file') == 2,'File not found: %s',fn)
            obj.filename = fn;
        end
        
        
        
        
        
        
        
        % Overloaded functions
        
        
        function obj = load(obj)
            n = length(obj.filename);
            f = obj.filename(max(n-50,1):end);
            if length(f) < n, f = ['...' f]; end
            
            fprintf('loading "%s" ...',f)
            
            load(obj.filename,'Acquisition','-mat')
            
            obj.Manifest = obj.Manifest.add('FILE','load',sprintf('Loaded: %s',obj.filename));
            
            obj.Data = squeeze(Acquisition.Data);
            obj.originalSize = obj.size;
            obj.Fs = diff(Acquisition.T(1:2));
            
            obj.pixelSize = [diff(Acquisition.U(1:2)) ...
                             diff(Acquisition.W(1:2)) ...
                             1/obj.Fs];

            fprintf(' done\n')
        end
        
        
        
        
        
    end
    
end