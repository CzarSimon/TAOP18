function FIG = plotProblem(PROB,nrFLAG)
%
% Plot function for the problem instances.
%
% plotProblem(PROB,nrFLAG)
%
% Input arguments:
%
%  PROB      - Problem structure
%
%  nrFLAG    - 0  show no numbers (default)
%              1  show depot numbers
%              2  show customer numbers


if nargin < 2
   nrFLAG = 0;
end


% Create a new, empty figure
FIG = figure(); hold; box;


% Plot Depos
plot(PROB.Coord.Depo(1,:), PROB.Coord.Depo(2,:), 'r.','MarkerSize',20)

% Plot Depo numbers?
if nrFLAG > 0
   text(PROB.Coord.Depo(1,:)+3, PROB.Coord.Depo(2,:)+3, ...
      int2str((1:PROB.nrDepots)'), 'Color', 'red', 'FontSize', 12 );
end


% Plot Customers
plot(PROB.Coord.Cust(1,:), PROB.Coord.Cust(2,:), 'k.','MarkerSize',10)

% Plot Customer numbers?
if nrFLAG > 1
   text(PROB.Coord.Cust(1,:)+1, PROB.Coord.Cust(2,:)-1, ...
      int2str((1:PROB.nrCustomers)'), 'FontSize', 9 );
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

end
