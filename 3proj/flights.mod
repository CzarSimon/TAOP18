#----------------------------------------------------------------------
# Model file: flights.mod
#----------------------------------------------------------------------

#----------------------------------------------------------------------
# Defines the Set-covering problem (MP)
#----------------------------------------------------------------------

problem Set_Covering;

param nCol integer;
param nFlights integer;

set COLUMNS := 1..nCol;
set FLIGHTS := 1..nFlights;

param a {FLIGHTS,COLUMNS} integer >= 0;
param colCost{COLUMNS};

# Include variables, objective function and constraints

var routeUsed{COLUMNS} >= 0, binary;


#-------MP objective function-----#
minimize z: sum{j in COLUMNS} colCost[j]*routeUsed[j];

#------MP Constraints-----------#

subject to

columnConstraint{i in FLIGHTS}:
			sum{j in COLUMNS} a[i,j]*routeUsed[j] >= 1;


#----------------------------------------------------------------------
# Defines the Shortest Path sub-problem
#----------------------------------------------------------------------

problem ToD_Gen;

set NODES;
set STARTEND;
set NODESwithoutSTARTorEND;
set ARCS within NODES cross NODES;
set FLIGHTS_IN_NODE{NODES};
param arcCost{ARCS};
param orgArcCost{ARCS};

var nodeInRoute{ARCS} >= 0, binary;

#-------Objective Function---------#

			minimize w: sum{(i,j) in ARCS} arcCost[i,j]*nodeInRoute[i,j];

subject to
			
nodeBalanceConstraint{j in NODESwithoutSTARTorEND}:
			sum{(i,j) in ARCS} nodeInRoute[i,j] - sum{(j,k) in ARCS} nodeInRoute[j,k] = 0;
StartMustBeIncluded:
			sum{('START',j) in ARCS} nodeInRoute['START',j] = 1;
EndMustBeIncluded:
			sum{(i,'END') in ARCS} nodeInRoute[i,'END'] = 1;


# Include variables, objective function and constraints
# The sets FLIGHTS_IN_NODE are not needed here,
# only used in the command file (flight.run).
