function FIG = plotDepotAssignment(PROB,depotIdx,nrFLAG,onlyDepot)
%
% Plot function that shows which customers are assigned to each depot
%
% plotDepotAssignment(PROB,depotIdx,nrFLAG)
%
% Input arguments:
%
%  PROB      - Problem structure
%
%  depotIdx  - Vector of size (1,nrCustomers), where the value is the 
%              depot number to which is has been assigned. Values outside
%              the depot numbers 1:nrDepots are disregarded
%
%  nrFLAG    - 0  show no numbers (default)
%              1  show depot numbers
%              2  show customer numbers
%
%  onlyDepot - Vector specifying a subset of depots to be plotted. 
%              Optional, default is [] which means plot all depots.
%

if nargin < 2
   plotProblem(PROB);
end
if nargin < 3
   nrFLAG = 0;
end
if nargin < 4
   onlyDepot = [];
end

% Depot color scheme
depotColors = {'r','b','k','g','c','m','y'};

% Safeguard input of depot index
depotIdx = depotIdx(:)';

% Find the number of unique depots
DEPOT = unique(depotIdx);
DEPOT = DEPOT( ismember(DEPOT,1:PROB.nrDepots) );

% Plot only a given subset of depots?
if ~isempty(onlyDepot)
   DEPOT = intersect(DEPOT,onlyDepot);
end

% If no depots left, do nothing
if isempty(DEPOT)
   disp('No feasible depots')
   return
end


% LegendString
legendString   = cell(1,length(DEPOT));
legendHandle   = zeros(1,length(DEPOT));

for k = 1:length(DEPOT)
   legendString{k} = ['Depot ' int2str(DEPOT(k))];
end

% Create a new, empty figure
FIG = figure(); hold; box;

kk = 0;
for k = DEPOT
   
   custIdx  = find(depotIdx == k );
   colorStr = depotColors{k};
   
   % Plot Depot
   plot(PROB.Coord.Depo(1,k), PROB.Coord.Depo(2,k), ...
                              [colorStr 's'], 'MarkerSize', 22);
%    plot(PROB.Coord.Depo(1,k), PROB.Coord.Depo(2,k), ...
%                               [colorStr '.'], 'MarkerSize', 20)
   
   % Plot Depo numbers?
   if nrFLAG > 0
%      text(PROB.Coord.Depo(1,k)+3, PROB.Coord.Depo(2,k)+3, ...
%          int2str(k), 'Color', colorStr, 'FontSize', 12 );
      text(PROB.Coord.Depo(1,k), PROB.Coord.Depo(2,k), int2str(k), ...
      'Color', colorStr, 'FontSize', 13, 'HorizontalAlignment', 'center' );
   end
   
   
   % Plot Customers
   h = plot(PROB.Coord.Cust(1,custIdx), PROB.Coord.Cust(2,custIdx), ...
                              [colorStr '.'], 'MarkerSize', 12);
   
   % Plot Customer numbers?
   if nrFLAG > 1
      text(PROB.Coord.Cust(1,custIdx)+1, PROB.Coord.Cust(2,custIdx)-1, ...
         int2str(custIdx'), 'Color', colorStr, 'FontSize', 10 );
   end
   
   kk = kk+1;
   legendHandle(kk) = h;
end




% Find bounding box
LBD   = min( [PROB.Coord.Cust PROB.Coord.Depo] , [] , 2);
UBD   = max( [PROB.Coord.Cust PROB.Coord.Depo] , [] , 2);

dx    = 0.1*( UBD(1) - LBD(1) );
dy    = 0.1*( UBD(2) - LBD(2) );

xlim([LBD(1)-dx,UBD(1)+dx]);
ylim([LBD(2)-dy,UBD(2)+dy]);

% Set axis properties
axis square

grid on;


% Legend
legend(legendHandle, legendString, 'FontSize', 14, 'Location','NorthEastOutside')


end
