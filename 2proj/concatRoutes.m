function concatRoutes = func(new, temp, routeMatrices, depot)    
    
    % temp(1,1) and (2,1) = what route node new(1,1) and (2,1) exists in
    % temp(1,2) and (2,2) = 1 if the node is first, or 2 if its last 
    
    if temp(1,1) == 0
        if temp(2,2) == 2
            routeMatrices{depot,temp(2,1)}(1,end + 1) = new(1,2)
        else
            newRoute(1,1) = routeMatrices{depot,temp(2,1)}(1,1);
            newRoute(1,2) = new(1,2);
            for i = 2:size(routeMatrices{depot,temp(2,1)},2)
                newRoute(1,i+1) = routeMatrices{depot,temp(2,1)}(1,i);
            end
            routeMatrices{depot,temp(2,1)} = newRoute
        end
    elseif temp(2,1) == 0
        disp('HEj')
        if temp(1,2) == 2
            routeMatrices{depot,temp(1,1)}(1,end + 1) = new(1,2)
            routeMatrices{depot,temp(1,1)}
        else
            newRoute(1,1) = routeMatrices{depot,temp(1,1)}(1,1);
            newRoute(1,2) = new(1,2);
            for i = 2:size(routeMatrices{depot,temp(1,1)},2)
                newRoute(1,i+1) = routeMatrices{depot,temp(1,1)}(1,i);
            end
            routeMatrices{depot,temp(1,1)} = newRoute
            routeMatrices{depot,temp(1,1)}
        end
    end
    
    concatRoutes = routeMatrices
     
end