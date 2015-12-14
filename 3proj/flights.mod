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



#----------------------------------------------------------------------
# Defines the Shortest Path sub-problem
#----------------------------------------------------------------------

problem ToD_Gen;

set NODES;
set ARCS within NODES cross NODES;
set FLIGHTS_IN_NODE{NODES};
param arcCost{ARCS};
param orgArcCost{ARCS};


# Include variables, objective function and constraints
# The sets FLIGHTS_IN_NODE are not needed here,
# only used in the command file (flight.run).


