
function [depotCust] = ca(depoAssignment, Distances)

    [NrCustomer, depot] = hist(depoAssignment, unique(depoAssignment));
    depotCust = zeros(size(Distances,1), max(NrCustomer));

    for i = 1:size(depoAssignment,2)
        idx = find(depotCust(depoAssignment(i),:) == 0, 1, 'first');
        depotCust(depoAssignment(i), idx) = i;
    end
end