#-------------------------------------------
# Modelfile for Project 1 -- Assignment 1
#-------------------------------------------

#-------------------------------------------------------------------------------
# Remember that in Assignment 1, since only one component is needed in order to 
# manufacture one product, the model can be formulated by using only products!
#-------------------------------------------------------------------------------

param Tcost_F2C;					# Transportation cost Factory to Customer
param Tcost_F2D;					# Transportation cost Factory to DC
param Tcost_D2C;					# Transportation cost DC to Customer


set FACTORIES;						# Set of Factories
set D_CENTERS;						# Set of Distribution Centers
set CUSTOMAREAS;					# Set of Custom Areas
set PRODUCTS;						# Set of Products

set EXCESSLEVEL := 1..3;				# Set of excess sales levels

param RevScale{EXCESSLEVEL};				# Excess sales revenue reduction
param ExcessLimit{EXCESSLEVEL};				# Excess sales intervals

param AssemblyCost_F{FACTORIES, PRODUCTS};		# Assembly costs at Factories
param AssemblyCost_DC{D_CENTERS, PRODUCTS};		# Assembly costs at DCs
param CompCost{FACTORIES, PRODUCTS};			# Component prices
param Revenue{CUSTOMAREAS, PRODUCTS};			# Selling reward

param Supply{FACTORIES, PRODUCTS};			# Supply at Factories
param Demand{CUSTOMAREAS, PRODUCTS};			# Demand at Customer Areas

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

# var x
var SubComp{FACTORIES, PRODUCTS} >= 0;
var DelProd_F{FACTORIES, PRODUCTS, CUSTOMAREAS} >= 0;
var DelProd_DC{D_CENTERS, PRODUCTS, CUSTOMAREAS} >= 0;
var DelComp{FACTORIES, D_CENTERS, PRODUCTS} >=0;
var open_DC{D_CENTERS} binary;
var ExcessDemand{CUSTOMAREAS, PRODUCTS, EXCESSLEVEL} >= 0; #Excess demand at customer areas




#-----------------------------------------------------------------------------------------------
# Objective function
#-----------------------------------------------------------------------------------------------

# maximize TotalProfit
maximize z: sum{k in CUSTOMAREAS, p in PRODUCTS}  Revenue[k,p]*(Demand[k,p]  	# Min efterfråga 
			+ sum{e in EXCESSLEVEL} RevScale[e]*ExcessDemand[k,p,e])				# Excess som vi skickar vart vi vill
			- sum{f in FACTORIES, p in PRODUCTS} CompCost[f,p]*SubComp[f,p]		# Kostnad för utlego
			- sum{k in CUSTOMAREAS, p in PRODUCTS} (
					 sum{f in FACTORIES} AssemblyCost_F[f, p]*DelProd_F[f,p,k] 
				   + sum{d in D_CENTERS} AssemblyCost_DC[d, p]*DelProd_DC[d,p,k]
				   )
			- sum{p in PRODUCTS} (
					 sum{f in FACTORIES, d in D_CENTERS} Tcost_F2D*distFD[f,d]*DelComp[f,d,p]
				   + sum{d in D_CENTERS, k in CUSTOMAREAS} Tcost_D2C*distDC[d,k]*DelProd_DC[d,p,k]
				   + sum{f in FACTORIES, k in CUSTOMAREAS} Tcost_F2C*distFC[f,k]*DelProd_F[f,p,k]
				   )
			- sum{d in D_CENTERS} DC_Setup[d]*open_DC[d];



#-----------------------------------------------------------------------------------------------
# Constraints
#-----------------------------------------------------------------------------------------------

subject to 

# conSupply
conSupply{f in FACTORIES, p in PRODUCTS}: 
			#sum{k in CUSTOMAREAS} (DelProd_F[f,p,k] + DelProd_DC[d,p,k]) <= Supply[f,p] + SubComp[f,p];
			sum{k in CUSTOMAREAS} DelProd_F[f,p,k] + sum{d in D_CENTERS} DelComp[f,d,p] <= Supply[f,p] + SubComp[f,p];

FulfillDemand{k in CUSTOMAREAS, p in PRODUCTS}:
			(sum{f in FACTORIES} DelProd_F[f,p,k]) + (sum{d in D_CENTERS} DelProd_DC[d,p,k]) = Demand[k,p] + (sum{e in EXCESSLEVEL} ExcessDemand[k,p,e]);

OnlyFactoriesOrDC:
#			sum{p in PRODUCTS, f in FACTORIES, k in CUSTOMAREAS} DelProd_F[f,p,k] = 0 # Only active on 1a
#			sum{p in PRODUCTS, f in FACTORIES, d in D_CENTERS} DelComp[f,d,p] = 0;    #Only active on 1b

#------------------------Constraints between lines only active on 1c ----------------------------------
CanDeliverFromFactories:
			sum{p in PRODUCTS, f in FACTORIES, d in D_CENTERS} DelComp[f,d,p] >= 0;
CanDeliverFromDC:
			sum{p in PRODUCTS, f in FACTORIES, k in CUSTOMAREAS} DelProd_F[f,p,k] >= 0;
#----------------------------------------------------------

ExcessConstraint{k in CUSTOMAREAS, e in EXCESSLEVEL, p in PRODUCTS}: 
			ExcessDemand[k,p,e] <= ExcessLimit[e]*Demand[k,p];


DCNodeBalance{d in D_CENTERS, p in PRODUCTS}:
			(sum{f in FACTORIES} DelComp[f,d,p] - sum{k in CUSTOMAREAS} DelProd_DC[d,p,k]) = 0;

DCTimeConstraint{d in D_CENTERS}: 
			sum{p in PRODUCTS, k in CUSTOMAREAS} DelProd_DC[d,p,k]*AssemblyTime[d,p] <= DC_Capacity[d];

OnlyDeliverFromOpenDC{d in D_CENTERS}:
			sum{p in PRODUCTS, k in CUSTOMAREAS} DelProd_DC[d,p,k] <= open_DC[d]*1000000;