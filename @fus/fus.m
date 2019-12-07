classdef fus
    
    
    properties
        filename char
        pixelSize (1,:) double {mustBePositive,mustBeFinite}
    end
    
    properties (SetAccess = protected)
        Data
        Manifest
    end
    
    properties (SetAccess = private)
        originalSize
        dataModified
    end
    
    properties (Dependent)
        size % lengths of dimensions
        Time
        dataDimensions
    end
    
    properties (SetAccess = private, Transient)
        dataAs2D % pixels x time
    end
    
    methods
        obj = detrend(obj,detrendArgs);
        
        
        % Constructor
        function obj = fus(filename)
            if nargin >= 1, obj.filename = filename; end
            
            obj.Manifest = Manifest;
        end
        
        
        
        function obj = set.Data(obj,data)
            obj.Data = data;
            obj.dataModified = now;
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
        
        
        function size = get.size(obj)
            size = size(obj.Data);
        end
        
        
        function obj = set.filename(obj,fn)
            assert(exist(fn,'file') == 2,'File not found: %s',fn)
            obj.filename = fn;
        end
        
        
        function obj = set.pixelSize(obj,px)
            assert(length(px) == length(obj.size),
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
            obj.Noriginal = obj.size;
            obj.pixelSize = [diff(Acquisition.U(1:2)) diff(Acquisition.W(1:2))];
            obj.Time = Acquisition.T;
            
            fprintf(' done\n')
        end
        
        
        
        
        
    end
    
end