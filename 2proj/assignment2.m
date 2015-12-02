% Dijkstras algoritm will be used as a constructive heuris

% plotDepotAssignment(problem, depoAssignment,
assignment1;

% Assigning customers to the nearest depot
depotCust = depotCustFunction(depoAssignment, Distances)

totalCost = 0;
CostC2C = problem.MileageCost.*problem.Dist.c2c;
CostD2C = problem.MileageCost.*problem.Dist.d2c;

%List sorted by clark wright arcs and their savings in decending order with
%highest savings first.
sortedList = sortedListFunction(depotCust, CostC2C, CostD2C);

something = clarkWriteRoutes(sortedList, problem);