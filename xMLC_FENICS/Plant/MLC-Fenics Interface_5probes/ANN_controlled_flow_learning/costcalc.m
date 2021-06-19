for i=1:25
    cost(i)=mlc.population(1,i).costs(1);
end

plot(1:25,cost)
title('Cost Evolution')
xlabel('Generation')
ylabel('J')
grid on