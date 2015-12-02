function [returnList] = f(depotCust, CostC2C, CostD2C)

    for i = 1:size(depotCust,1)
        index = find(depotCust(i,:) ~= 0, 1, 'last');
        numOfCombinations = (index-1).*(index/2);
        arrOfCostMatrices1{i} = zeros(numOfCombinations,3);
        arrOfCostMatrices2{i} = zeros(numOfCombinations,3);

        row = 1;
        for j = 1:index
            n = 1;
            while (j+n) <= index
                cust1 = depotCust(i, j);
                cust2 = depotCust(i, j+n);
                arrOfCostMatrices1{i}(row,1) = cust1;
                arrOfCostMatrices1{i}(row,2) = cust2;
                arrOfCostMatrices1{i}(row,3) = CostD2C(i, cust1) + CostD2C(i, cust2) - CostC2C(cust1, cust2);
                row = row + 1;
                n = n + 1;
                returnList{i} = sortrows(arrOfCostMatrices1{i}, -3);
            end 

        end

    end
    
end