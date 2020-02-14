classdef Volume < handle
    % V = fus.Volume([Planes])
    % 
    % Volume of fus Planes

    properties
        Planes (:,1) fus.Plane;
    end

    properties
        Name (1,:) char
    end
    
    properties (SetAccess = protected)
        Manifest (1,1) fus.Manifest
    end

    properties (Dependent)
        numPlanes
    end

    properties (Dependent, Hidden)
        Data3D
        Data4D
    end
    
    
    methods
        S = structural(obj,threshold);
        
        function obj = Volume(Planes)
            obj.Manifest.add('OBJECT','Volume','Volume object created');

            if nargin >= 1, obj.Planes = Planes; end
        end

        function obj = add_plane(obj,p)
            % obj = add_plane(obj,p)
            % 
            % Add new Plane(s) to the Volume
            % Input 'p' can be a filename, cell array of filenames, 
            % an array of Plane objects, or empty which will prompt 
            % the user to select a file with the Plane.
            % 
            % This function will not load the Plane object.

            if nargin == 1
                [fn,pn] = uigetfile( ...
                    {'*.acq';'*.mat', ...
                    'Iotonus Acquisition File (*.acq);', ...
                    'Matlab File (*.mat)'}, ...
                    'Select a Plane file');
                if isequal(pn,0), return; end
                p = fullfile(pn,fn);
            end

            if ischar(p)
                obj.Planes(end+1) = fus.Plane(p);

            elseif isstring(p)
                obj.Planes(end+1:end+length(p)) = cellfun(@fus.Plane,p);

            elseif isa(p,'fus.Plane')
                obj.Planes(end+1:end+length(p)) = p;
            end
        end


        function obj = load(obj,idx)
            if nargin == 1, idx = 1:obj.numPlanes; end
            obj.Planes = arrayfun(@load,obj.Planes(idx));
        end

        function d = get.Data4D(obj)
            d = cat(4,obj.Planes.Data);
        end
        
        function d = get.Data3D(obj)
            d = squeeze(nanmean(obj.Data4D,3));
        end

        function n = get.numPlanes(obj)
            n = numel(obj.Planes);
        end
        

        % Plane helpers
        function obj = detrend(obj,idx,varargin)
            if nargin == 1, idx = 1:obj.numPlanes; end
            obj.Planes = arrayfun(@(p) detrend(p,varargin{:}),obj.Planes(idx));
        end

        function obj = normalize(obj,idx,varargin)
            if nargin == 1, idx = 1:obj.numPlanes; end
            obj.Planes = arrayfun(@(p) normalize(p,varargin{:}),obj.Planes(idx));
            obj.Manifest.add('DATA','normalize',varargin);
        end
    end

end