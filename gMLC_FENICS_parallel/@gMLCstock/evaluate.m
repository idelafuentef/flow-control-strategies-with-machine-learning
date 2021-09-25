function gMLC_stock=evaluate(gMLC_stock,gMLC_basket,gMLC_table,gMLC_parameters)
% gMLCstock class evaluate method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    SS = gMLC_parameters.stock_size;

%% Stock evaluate
  if VERBOSE > 2, fprintf('     Evaluation of the stock\n'),end
  cycle = gMLC_basket.status.cycle;
  for p=1:SS
    gMLC_table.evaluate(labels(p),gMLC_parameters,0);
    gMLC_table.individuals(labels(p)).evaluation_order = [cycle,p];
    if VERBOSE > 3, fprintf('\n'),end
  end

%% Update properties
  gMLC_stock.evaluated(:) = 1;
  if VERBOSE > 2, fprintf('     End of stock evaluation\n'),end
    
end %method
