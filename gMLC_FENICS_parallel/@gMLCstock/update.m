function [new_labels,gMLC_stock]=update(gMLC_stock,gMLC_table,gMLC_parameters)
% gMLCstock class update method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    SS = gMLC_parameters.stock_size;
    Nbl = length(gMLC_stock.labels);

if VERBOSE > 6, fprintf('     Update stock - Start\n'),end

    %% Update properties
        for p=1:SS
            % Retrieve the label if it exist
            if p> Nbl
                label = 0;
            else
                label = gMLC_stock.labels(p);
            end


            % Update individual if needed
            if label>0
              if gMLC_table.individuals(label).cost{1}>=0
                gMLC_stock.evaluated(p)=1; %% loop over the elements
              end


              if gMLC_stock.evaluated(p)==-1
                fprintf('Data base corrupted - better start over (update stock)\n')
                return
                Ind = gMLCind;
                Ind.generate(gMLC_parameters);
                % is_ok1 = stockt_test(Ind,gMLC_parameters);
                % is_ok2 = Ind.duplicate_test(gMLC_table,gMLC_parameters);
                % is_ok3 = Ind.other_test(gMLC_parameters);
                is_ok = true ;%is_ok1 && is_ok2 && is_ok3;
                ID=gMLC_table.add(Ind,gMLC_parameters);
                gMLC_stock.labels(p) = ID;
              end
            end
        end


if VERBOSE > 6, fprintf('     Update stock - End\n'),end

end %method
