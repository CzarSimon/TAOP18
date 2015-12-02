Distances = problem.Dist.d2c;
supply = problem.Supply;
demand = problem.Demand;
depoAssignment = zeros(1,size(Distances,2));

for m = 1:size(Distances,2)
    i = 1 + size(Distances,2) - m;
    [M,I] = sort(Distances(:,i));
    
    for j = 1:size(I,1)
        if supply(I(j)) >= demand(i)
            depoAssignment(1,i) = I(j);
            supply(I(j)) = supply(I(j)) - demand(i);
            break;
        end            
    end    
end
