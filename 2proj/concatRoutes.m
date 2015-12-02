function concatRoutes = func(new, temp, routeMatrices, depot)
    concatRoutes = 1;
    
    occurances = histc(temp(:,1), [0]);
    
    if occurances == 1
        disp('!---only one---! ')
        newR
    else
        disp('//-none-//')
    end
    
    if temp(1,1) == 0
        if temp(2,2) == 2
            newRoute{depot,temp(2,1)}(1,end + 1) = new(1,2)
        else
            newRoute
    
    elseif temp(
        
end