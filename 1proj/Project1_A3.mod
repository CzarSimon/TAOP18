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



#-----------------------------------------------------------------------------------------------
# Objective function
#-----------------------------------------------------------------------------------------------

# maximize TotalProfit



#-----------------------------------------------------------------------------------------------
# Constraints
#-----------------------------------------------------------------------------------------------

subject to 

# conSupply



