#-------------------------------------------
# Modelfile for Project 1 -- Assignment 2
#-------------------------------------------

#-------------------------------------------------------------------------------
# In Assignment 2 and 3, multiple components are used in order to manufacture
# one product. Hence we must also consider components!
#-------------------------------------------------------------------------------

param Tcost_F2D;					# Transportation cost Factory to DC
param Tcost_D2C;					# Transportation cost DC to Customer


set FACTORIES;						# Set of Factories
set D_CENTERS;						# Set of Distribution Centers
set CUSTOMAREAS;					# Set of Custom Areas
set PRODUCTS;						# Set of Products
set COMPONENTS;						# Set of Components
set PROD_USING_COMPONENTS{COMPONENTS};			# Set of Products using Components

set EXCESSLEVEL := 1..3;				# Set of excess sales levels

param RevScale{EXCESSLEVEL};				# Excess sales revenue reduction
param ExcessLimit{EXCESSLEVEL};				# Excess sales intervals

param AssemblyCost{D_CENTERS, PRODUCTS};		# Assembly costs at DCs
param CompCost{FACTORIES, COMPONENTS};			# Component prices
param Revenue{CUSTOMAREAS, PRODUCTS};			# Selling reward

param Supply{FACTORIES, COMPONENTS};        		# Supply at Factories
param Demand{CUSTOMAREAS, PRODUCTS}; 			# Demand at Customer areas

param AssemblyTime{D_CENTERS, PRODUCTS};		# Time needed to assemble one
							# product at DCs

param DC_Setup{D_CENTERS};				# Setup costs and capacities
param DC_Capacity{D_CENTERS};				# for Distribution Centers






#-----------------------------------------------------------------------------------------------
# Coordinates for Factories, Customer areas and Distribution centers
#-----------------------------------------------------------------------------------------------

param CoordFactory_x{FACTORIES};
param CoordFactory_y{FACTORIES};

param CoordDCenter_x{D_CENTERS};
param CoordDCenter_y{D_CENTERS};

param CoordCustomer_x{CUSTOMAREAS};
param CoordCustomer_y{CUSTOMAREAS};


#-----------------------------------------------------------------------------------------------
# Euclidian distances between Factories, DCs and Customers are calculated
#-----------------------------------------------------------------------------------------------

param distFC{i in FACTORIES, j in CUSTOMAREAS} :=
sqrt( (CoordFactory_x[i]-CoordCustomer_x[j])^2 + (CoordFactory_y[i]-CoordCustomer_y[j])^2 );

param distFD{i in FACTORIES, j in D_CENTERS} :=
sqrt( (CoordFactory_x[i]-CoordDCenter_x[j])^2  + (CoordFactory_y[i]-CoordDCenter_y[j])^2 );

param distDC{i in D_CENTERS, j in CUSTOMAREAS} :=
sqrt( (CoordDCenter_x[i]-CoordCustomer_x[j])^2 + (CoordDCenter_y[i]-CoordCustomer_y[j])^2 );




#-----------------------------------------------------------------------------------------------
# Your variables goes here ...
#-----------------------------------------------------------------------------------------------

var SubComp{FACTORIES, COMPONENTS} integer >= 0;
var DelProd_DC{D_CENTERS, PRODUCTS, CUSTOMAREAS} integer >= 0;
var DelComp{FACTORIES, D_CENTERS, COMPONENTS} integer >=0;
var open_DC{D_CENTERS} binary;
var ExcessDemand{CUSTOMAREAS, PRODUCTS, EXCESSLEVEL} >= 0; #Excess demand at customer areas
var DC_storage{PRODUCTS, D_CENTERS, T} >= 0;

#-----------------------------------------------------------------------------------------------
# Objective function
#-----------------------------------------------------------------------------------------------

# maximize TotalProfit
maximize z: sum{k in CUSTOMAREAS, p in PRODUCTS}  Revenue[k,p]*(Demand[k,p]  	# Min efterfråga
			+ sum{e in EXCESSLEVEL} RevScale[e]*ExcessDemand[k,p,e])				# Excess som vi skickar vart vi vill
			- sum{f in FACTORIES, c in COMPONENTS} CompCost[f,c]*SubComp[f,c]		# Kostnad för utlego
			- sum{k in CUSTOMAREAS, p in PRODUCTS, d in D_CENTERS} AssemblyCost[d,p]*DelProd_DC[d,p,k]
			-  (
					 sum{f in FACTORIES, d in D_CENTERS, c in COMPONENTS} Tcost_F2D*distFD[f,d]*DelComp[f,d,c]
				   + sum{d in D_CENTERS, k in CUSTOMAREAS, p in PRODUCTS} Tcost_D2C*distDC[d,k]*DelProd_DC[d,p,k]
				   )
			- sum{d in D_CENTERS} DC_Setup[d]*open_DC[d];

#-----------------------------------------------------------------------------------------------
# Constraints
#-----------------------------------------------------------------------------------------------

subject to

# conSupply
conSupply{f in FACTORIES, c in COMPONENTS}:
			sum{d in D_CENTERS} DelComp[f,d,c] <= Supply[f,c] + SubComp[f,c];

FulfillDemand{k in CUSTOMAREAS, p in PRODUCTS}:
			(sum{d in D_CENTERS} DelProd_DC[d,p,k]) = Demand[k,p] + (sum{e in EXCESSLEVEL} ExcessDemand[k,p,e]);

ExcessConstraint{k in CUSTOMAREAS, e in EXCESSLEVEL, p in PRODUCTS}:
			ExcessDemand[k,p,e] <= ExcessLimit[e]*Demand[k,p];

DCNodeBalance{d in D_CENTERS, c in COMPONENTS}:
			sum{k in CUSTOMAREAS, p in PROD_USING_COMPONENTS[c]} DelProd_DC[d,p,k] - sum{f in FACTORIES} DelComp[f,d,c] = 0;

DCTimeConstraint{d in D_CENTERS}:
			sum{p in PRODUCTS, k in CUSTOMAREAS} DelProd_DC[d,p,k]*AssemblyTime[d,p] <= DC_Capacity[d];

OnlyDeliverFromOpenDC{d in D_CENTERS}:
			sum{p in PRODUCTS, k in CUSTOMAREAS} DelProd_DC[d,p,k] <= open_DC[d]*1000000;
