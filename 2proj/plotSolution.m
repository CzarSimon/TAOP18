function plotSolution(PROB,ROUTE,nrFLAG)
%
% Plot function used to illustrate routes.
%
% plotSolution(PROB,ROUTE,nrFLAG)
%
% Input arguments:
%
%  PROB      - Problem structure
%
%  ROUTE     - Cell array representing the routes
%
%              OR
%
%            - Matrix representing the routes, one route per 
%              line starting with the depot number
%
%
%  nrFLAG    - 0  show no numbers (default)
%              1  show depot numbers
%              2  show customer numbers


if nargin < 3
   nrFLAG = 0;
end

if ~iscell(ROUTE)
   matrixRepresentationPlot(PROB,ROUTE,nrFLAG);
   return
end

% Plot the problem instance
FIG = plotProblem(PROB,nrFLAG);

% Number of routes
nrRoutes = max( size(ROUTE) );

figure(FIG);
for k = 1:nrRoutes
   % Get which depo and which customers
   depoNr   = abs( ROUTE{k}(1) );
   custNrs  = ROUTE{k}(2:end);
   
   % Get coordinates
   depoXY   = PROB.Coord.Depo(:,depoNr);
   custXY   = PROB.Coord.Cust(:,custNrs);
   
   % Concatenate route
   xy = [depoXY custXY depoXY];
   
   %plot route
   plot(xy(1,:),xy(2,:),'k');
end

end



function matrixRepresentationPlot(PROB,ROUTE,nrFLAG)
% Plot the problem instance
FIG = plotProblem(PROB,nrFLAG);

% Indices for non-empty rows (i.e. routes)
rowIdx = find( ~all(ROUTE == 0,2) );

% Number of routes
nrRoutes = length(rowIdx);

figure(FIG);
for k = 1:nrRoutes
   % Get which depo and which customers
   depoNr   = abs( ROUTE(rowIdx(k),1) );
   custNrs  = ROUTE(rowIdx(k),2:end);
   
   % Remove the tail of zeros
   custNrs( custNrs == 0 ) = [];
   
   % Get coordinates
   depoXY   = PROB.Coord.Depo(:,depoNr);
   custXY   = PROB.Coord.Cust(:,custNrs);
   
   % Concatenate route
   xy = [depoXY custXY depoXY];
   
   %plot route
   plot(xy(1,:),xy(2,:),'k');
end

end
