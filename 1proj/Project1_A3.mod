#-------------------------------------------
# Modelfile for Project 1 -- Assignment 3
#-------------------------------------------

#-------------------------------------------------------------------------------
# In Assignment 3, we now consider a planning horizon over multiple time steps
#-------------------------------------------------------------------------------

param T;						# Number of time periods

param Tcost_F2D;					# Transportation cost Factory to DC
param Tcost_D2C;					# Transportation cost DC to Customer


set FACTORIES;						# Set of Factories
set D_CENTERS;						# Set of Distribution Centers
set USED_DC	within D_CENTERS;			# Set of opened DCs

set CUSTOMAREAS;					# Set of Custom Areas
set PRODUCTS;						# Set of Products
set COMPONENTS;						# Set of Components
set PROD_USING_COMPONENTS{COMPONENTS};			# Set of Products using Components

set CAPACITY    := 0..3;				# Set of Assembly Capacity Levels
set EXCESSLEVEL := 1..3;				# Set of excess sales levels

param RevScale{EXCESSLEVEL};				# Excess sales revenue reduction
param ExcessLimit{EXCESSLEVEL};				# Excess sales intervals

param AssemblyCost{D_CENTERS, PRODUCTS, 1..T};		# Assembly costs at DCs
param CompCost{FACTORIES, COMPONENTS, 1..T};		# Component prices
param Revenue{CUSTOMAREAS, PRODUCTS, 1..T};		# Selling reward
 
param Supply{FACTORIES, COMPONENTS, 1..T};		# Supply at Factories
param Demand{CUSTOMAREAS, PRODUCTS, 1..T}; 		# Demand at Customer areas

param AssemblyTime{D_CENTERS, PRODUCTS, 1..T};		# Time needed to assemble one 
							# product at DCs

param DC_CapCost{D_CENTERS,CAPACITY};			# Capacity costs and capacities 
param DC_Capacity{D_CENTERS,CAPACITY};			# for Distribution centers

param HoldCost_Comp;					# Inventory holding costs Components
param HoldCost_Prod;					# Inventory holding costs Products



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

# var x
var SubComp{FACTORIES, COMPONENTS, 1..T} integer >= 0;
var DelProd_DC{USED_DC, PRODUCTS, CUSTOMAREAS, 1..T} integer >= 0;
var Produced{PRODUCTS, USED_DC, 1..T} integer >= 0;
var DelComp{FACTORIES, USED_DC, COMPONENTS, 1..T} integer >=0;
var ExcessDemand{CUSTOMAREAS, PRODUCTS, EXCESSLEVEL, 1..T} integer >= 0; #Excess demand at customer areas
var DC_STORAGE_P{PRODUCTS, USED_DC, 0..T} integer >= 0;
var DC_STORAGE_C{COMPONENTS, USED_DC, 0..T} integer >= 0;
var CAPACITY_UTILIZED{USED_DC, 1..T, CAPACITY} binary;



#-----------------------------------------------------------------------------------------------
# Objective function
#-----------------------------------------------------------------------------------------------

# maximize TotalProfit
maximize z: sum{k in CUSTOMAREAS, p in PRODUCTS, t in 1..T}  Revenue[k,p,t]*(Demand[k,p,t]  	# Min efterfråga 
			+ sum{e in EXCESSLEVEL} RevScale[e]*ExcessDemand[k,p,e,t])				# Excess som vi skickar vart vi vill
			- sum{f in FACTORIES, c in COMPONENTS, t in 1..T} CompCost[f,c,t]*SubComp[f,c,t]		# Kostnad för utlego
			- sum{p in PRODUCTS, d in USED_DC, t in 1..T} AssemblyCost[d,p,t]*Produced[p,d,t]
			-  (
					 sum{f in FACTORIES, d in USED_DC, c in COMPONENTS,t in 1..T} Tcost_F2D*distFD[f,d]*DelComp[f,d,c,t]
				   + sum{d in USED_DC, k in CUSTOMAREAS, p in PRODUCTS,t in 1..T} Tcost_D2C*distDC[d,k]*DelProd_DC[d,p,k,t]
				   )
			- sum{d in USED_DC, l in CAPACITY, t in 1..T} DC_CapCost[d,l]*CAPACITY_UTILIZED[d,t,l]
			- sum{d in USED_DC, t in 1..T, p in PRODUCTS} DC_STORAGE_P[p,d,t]*HoldCost_Prod
			- sum{d in USED_DC, t in 1..T, c in COMPONENTS} DC_STORAGE_C[c,d,t]*HoldCost_Comp;
#-----------------------------------------------------------------------------------------------
# Constraints
#-----------------------------------------------------------------------------------------------

subject to 

conSupply{f in FACTORIES, c in COMPONENTS, t in 1..T}: 
			sum{d in USED_DC} DelComp[f,d,c,t] <= Supply[f,c,t] + SubComp[f,c,t];

FulfillDemand{k in CUSTOMAREAS, p in PRODUCTS, t in 1..T}:
			sum{d in USED_DC} DelProd_DC[d,p,k,t] = Demand[k,p,t] + (sum{e in EXCESSLEVEL} ExcessDemand[k,p,e,t]);

ExcessConstraint{k in CUSTOMAREAS, e in EXCESSLEVEL, p in PRODUCTS, t in 1..T}: 
			ExcessDemand[k,p,e,t] <= ExcessLimit[e]*Demand[k,p,t];

DCTimeConstraint{d in USED_DC, t in 1..T}: 
			sum{p in PRODUCTS} Produced[p,d,t]*AssemblyTime[d,p,t] <= sum{l in CAPACITY} DC_Capacity[d,l]*CAPACITY_UTILIZED[d,t,l];

ComponentStorageConstraint{d in USED_DC, c in COMPONENTS, t in 1..T}:
			DC_STORAGE_C[c,d,t-1] + sum{f in FACTORIES} DelComp[f,d,c,t] - sum{p in PROD_USING_COMPONENTS[c]} Produced[p,d,t] = DC_STORAGE_C[c,d,t];

ProductStorageConstraint{d in USED_DC, p in PRODUCTS, t in 1..T}:
			DC_STORAGE_P[p,d,t-1] + Produced[p,d,t] - sum{k in CUSTOMAREAS} DelProd_DC[d,p,k,t] = DC_STORAGE_P[p,d,t];

StorageZeroConstraintProducts{p in PRODUCTS, d in USED_DC}:
			DC_STORAGE_P[p,d,0] = 0;

StorageZeroConstraintComponents{c in COMPONENTS, d in USED_DC}:
			DC_STORAGE_C[c,d,0] = 0;

CapBinaryConstraint{d in USED_DC, t in 1..T}:
			sum{l in CAPACITY} CAPACITY_UTILIZED[d,t,l] = 1;