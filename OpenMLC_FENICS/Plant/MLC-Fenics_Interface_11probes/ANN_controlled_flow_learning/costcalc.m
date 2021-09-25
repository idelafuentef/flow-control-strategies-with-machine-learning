for i=1:20
    cost(i)=mlc.population(1,i).costs(1);
end

figure(1)
plot(1:20,cost)
title('Cost Evolution')
xlabel('Generation')
ylabel('J')
grid on