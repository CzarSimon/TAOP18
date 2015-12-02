
function f = func(sortedList, problem)
    depot = 1;
    routeMatrices{1,1}(1,1) = 48;
    routeMatrices{1,1}(1,2) = sortedList{1,1}(1,1);
    routeMatrices{1,1}(1,3) = sortedList{1,1}(1,2);
    routeMatrices{1,1}(1,4) = sortedList{1,1}(4,1);
    routeMatrices{1,1}(1,5) = sortedList{1,1}(4,2);
    routeMatrices{1:end,1:end}

        route = 1;
        routeMatrices{depot,route}(1,1) = problem.Capacity;
        

        for improve = 1:size(sortedList{depot},1)
            
            new = [sortedList{depot}(improve, 1), sortedList{depot}(improve, 2)];
            
            temp = zeros(2,2);
            % Loop through all routes
            for r = 1:route
                
                % takes nodes from row 1:
                node1 = find(routeMatrices{depot,r}(1,2:size(routeMatrices{depot,r},2)) == new(1,1), 1, 'first'); 
                node2 = find(routeMatrices{depot,r}(1,2:size(routeMatrices{depot,r},2)) == new(1,2), 1, 'first');
                
                %if node1 exists in route r
                if node1
                    % if it is places first in route
                    if node1 == 1
                        temp(1,2) = 1;
                    %If it is placed last in route
                    elseif node1 == size(routeMatrices{depot,r},2) - 1
                        temp(1,2) = 2;
                    %If exists in middle or route, no connection can be
                    %made so skip
                    else
                        disp('In the middle so duck')
                        continue;
                    end
                    disp('------------Yes--Node1')
                    new
                    temp(1,1) = r;
                end
                if node2
                    if node2 == 1
                        temp(2,2) = 1;
                    elseif node2 == size(routeMatrices{depot,r},2) - 1
                        temp(2,2) = 2;
                    else
                        continue;
                    end
                    disp('------------Yes--Node2')
                    new
                    temp(2,1) = r;
                else
                    disp('No')
                end
               
                temp
                if temp(1,1) == temp(2,1) && temp(1,1)~=0
                    disp('both exists in same route so duck off')
                else
                    disp('send to concat routes function')
                end
                
            end
            
            
        end

    f = 1;
    
end