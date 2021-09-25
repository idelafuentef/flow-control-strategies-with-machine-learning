function gMLC_basket=generate_random(gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCbasket class generate method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BIS = gMLC_parameters.basket_init_size;
    N_ope = gMLC_parameters.MaxIterations;
    init = gMLC_parameters.initialization;
    explo_IC = gMLC_parameters.explo_IC;

%% Fill the basket
if VERBOSE > 2, fprintf('     Generation of the basket\n'),end

    % Initialize properties
      labels = zeros(BIS,1);

    % Create the stock
      % Create adequate individuals
        for p=1:BIS
          is_ok = false;
          compt = 0;
          while not(is_ok) && (compt<N_ope) % Test
            Ind = gMLCind;
            Ind.generate(gMLC_parameters,explo_IC&&(p==1));
            Ind.description.type = init;

            % is_ok1 = init(Ind,gMLC_parameters);
            is_ok2 = Ind.duplicate_test(gMLC_table,gMLC_parameters);
            is_ok3 = Ind.other_test(gMLC_parameters);
            is_ok = is_ok2 && is_ok3;%is_ok1 && is_ok2 && is_ok3;
            compt = compt+1;
          end
          ID=gMLC_table.add(Ind,gMLC_parameters);
          labels(p) = ID;
          if VERBOSE > 4, fprintf('%i. ',ID),end
          if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
        end

    % Update properties
        gMLC_basket.initial_individuals.labels = labels;
        gMLC_basket.initial_individuals.evaluated = zeros(BIS,1);
        gMLC_table.isamatrix(labels) = 1;

if VERBOSE > 2, fprintf('     End of basket generation\n'),end

end %method
