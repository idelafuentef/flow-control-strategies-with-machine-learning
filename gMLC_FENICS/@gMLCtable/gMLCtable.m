classdef gMLCtable < handle
% gMLCtable class definition file
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    individuals
    ControlPoints
    distance_list
    evaluated
    isamatrix
    number
    VIP
end

%% External methods
methods
    [obj,ID] = add(obj,individual,parameters);
    obj = add_distance(obj,distance_to_add);
    [J,obj] = evaluate(obj,ID,parameters,visu);
    [CIDS,obj] = costs(obj,IDs);
    % Best individual among
    ID = best_individuals(obj,IDs,EvalMat,PrintIndivs);
    % Sort
    sID = sort(obj,ID);
    % Substitute
    IDout = computesubstitute(IDin,obj,parameters);
    % Use cluster to compute the landscape
    LandscapeLabels = cluster_correlation(parameters,obj,labels,NLandscapeLabels);
    LandscapeLabels = cluster_distance(parameters,obj,labels,NLandscapeLabels);
    % Copy
    obj2 = copy(obj,gMLC_parameters);
end

%% Internal methods
methods
    % Constructor
    function obj = gMLCtable(parameters)
        % Initialize properties
            ind = gMLCind;
            table_size = parameters.basket_init_size+parameters.basket_size*10;
            obj.individuals = repmat(ind,[table_size,1]);
                N_EP = parameters.ControlLaw.ControlPointNumber;
                MI = parameters.ProblemParameters.OutputNumber;
                N_CP = N_EP*MI;
            obj.ControlPoints = NaN(table_size,N_CP);
                N_distances = table_size*(table_size-1)/2;
            obj.distance_list = 0;%transpose([1:N_distances;-1*ones(1,N_distances)]);
            obj.evaluated = -1*ones(table_size,1);
            obj.isamatrix = zeros(table_size,1);
            obj.number = 0;
            obj.VIP = struct('control_law',[],'ID',[],'ControlPoints',[],'distances',[],'status',[],'Name',[]);
    end

        % get
    function val = get(obj,prop)
      if (nargin < 1 || nargin > 2)
        print_usage ();
      end

      if (nargin ==1)
        val=obj;
      else
        if (~ ischar(prop))
          error ('@NumHandle/get: PROPERTY must be a string');
        end

        switch (prop)
          case 'individuals'
            val = obj.individuals;
          case 'ControlPoints'
            val = obj.ControlPoints;
          case 'distance_list'
            val = obj.distance_list;
          case 'evaluated'
            val = obj.evaluated;
          case 'isamatrix'
            val = obj.isamatrix;
          case 'number'
            val = obj.number;
          case 'VIP'
            val = obj.VIP;
          otherwise
            error ('@NumHandle/get: invalid PROPERTY "%s"',prop);
        end
      end
      end %get

      % set
    function pout = set (obj,varargin)
      if (numel (varargin) < 2 || rem (numel(varargin),2) ~=0)
        error ('@NumHandle/set: expecting PROPERTY/VALUE pairs');
      end
      pout = obj;
      while (numel (varargin) > 1)
        prop = varargin{1};
        val = varargin{2};
        varargin(1:2) = [];
        if (~ ischar(prop))
          error ('@NumHandle/set : invalid PROPERTY for LGPC class');
        end

        switch (prop)
            case 'individuals'
                pout.individuals = val;
            case 'ControlPoints'
                pout.ControlPoints = val;
            case 'distance_list'
                pout.distance_list = val;
            case 'evaluated'
                pout.evaluated = val;
            case 'isamatrix'
                pout.isamatrix = val;
            case 'number'
                pout.number = val;
             case 'VIP'
                pout.VIP = val;
            otherwise
            error ('@NumHandle/set: invalid PROPERTY for LGPC class');
        end
      end
    end %set
end

end %classdef
