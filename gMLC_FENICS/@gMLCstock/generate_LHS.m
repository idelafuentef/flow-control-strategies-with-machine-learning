function gMLC_stock=generate_LHS(gMLC_stock,gMLC_table,gMLC_parameters)
% gMLCbasket class generate method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    SS = gMLC_parameters.stock_size;
    N_ope = gMLC_parameters.MaxIterations;
    init = gMLC_parameters.initialization;
    explo_IC = gMLC_parameters.explo_IC;

%% Create the stock
if VERBOSE > 2, fprintf('     Generation of the stock\n'),end

    % Initialize properties
      labels = zeros(SS,1);

    % Create the stock
      % Number of individuals to create
        Nfill = SS;
      % Create adequate individuals
        for p=1:Nfill
          is_ok = false;
          compt = 0;
          while not(is_ok) && (compt<N_ope) % Test
            Ind = gMLCind;
            Ind.generate(gMLC_parameters,explo_IC&&(p==1));
            Ind.description.init = init;

            % is_ok1 = init(Ind,gMLC_parameters);
            is_ok2 = Ind.duplicate_test(gMLC_table,gMLC_parameters);
            % is_ok3 = Ind.other_test(gMLC_parameters);
            is_ok = is_ok2 ;%is_ok1 && is_ok2 && is_ok3;
            compt = compt+1;
          end
          ID=gMLC_table.add(Ind,gMLC_parameters);
          labels(p) = ID;
        end

    % Update properties
        gMLC_stock.labels = labels;
        gMLC_stock.evaluated = zeros(SS,1);

if VERBOSE > 2, fprintf('     End of stock generation\n'),end

end %method
