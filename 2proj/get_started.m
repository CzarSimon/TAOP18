% This is a script file where the small problem instance is loaded and then
% plotted. Further, a cell ROUTE is created together with 4 routes. This
% partial solution is then plotted.

load('SMALL');
plotProblem(SMALL,2);

ROUTE = cell(1,4);
ROUTE{1} = [-1 2 4 6 5 1];
ROUTE{2} = [-2 15 7 8 9 11 16 14];
ROUTE{3} = [-2 24 25 23 18];
ROUTE{4} = [-3 20 19 21 22];

plotSolution(SMALL,ROUTE,2);


% Try the following commands
SMALL

SMALL.nrDepots

SMALL.Demand

SMALL.Dist.d2d
%SMALL.Dist.d2c
%SMALL.Dist.c2c
