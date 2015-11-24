% Example of a matrix representation of routes. We also calculate the total
% customer demand for each route in order to decide if the solution is
% feasible or not


% Load the SMALL problem instance
load('SMALL');

% The number of customers
nrCust      = SMALL.nrCustomers;

% Calculate the maximum number of customers on a route
maxStops    = SMALL.Capacity/min(SMALL.Demand);


% Create a matrix representing routes. We use one row for each possible
% route, and one column for each customer on the route (plus the depot)

A = zeros(nrCust, maxStops+1);


% Define the same 4 routes as in the given example
r1 = [-1 2 4 6 5 1];             % Depo 1 -> Customers 2-4-6-5-1
r2 = [-2 15 7 8 9 11 16 14];     % Depo 2 -> Customers 15-7-8-9-11-16-14
r3 = [-2 24 25 23 18];           % Depo 2 -> Customers 24-25-23-18
r4 = [-3 20 19 21 22];           % Depo 3 -> Customers 20-19-21-22


% Save all routes in matrix A. It is possible to have empty rows, i.e.
% delete routes.

A(1,1:length(r1)) = r1;
A(2,1:length(r2)) = r2;
A(5,1:length(r3)) = r3;
A(7,1:length(r4)) = r4;


% Plot this partial solution
plotSolution(SMALL,A,2);


% Add two more routes to cover the remaining customers
A(3,1:4) = [-3 12 13 17];        % Depo 3 -> Customers 12-13-17
A(4,1:3) = [-1 3 10];            % Depo 1 -> Customers 3-10

% Plot solution
plotSolution(SMALL,A,2);



% Is the solution feasible (with respect to capacity)?

% Define an empty vector, the same number of rows as A
RouteDemand = zeros(nrCust,1);

% Calculate the total demand on each route
for k = 1:nrCust
   
   % Check if row k contains a route
   if A(k,1) ~= 0
      
      % Find the number of customers on the route (this is done by finding
      % the first position on row k which is a 0. This information should
      % probably already be stored and available in a vector.
      lastCustIdx = find( A(k,:) == 0, 1);
      
      % Extract the route
      % depoNr   = A(k,1);
      route    = A(k,2:lastCustIdx-1);
      
      % Calculate and store the route's demand
      RouteDemand(k) = sum(SMALL.Demand(route));
      
   end
   
end


% Display the demand for each route
disp(RouteDemand);

% Check if any route exceeds the truck capacity
find( RouteDemand > SMALL.Capacity )

