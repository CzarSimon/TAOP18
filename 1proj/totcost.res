: _objname    _obj      :=
1   z        91142.6
;

sum{d in D_CENTERS, k in CUSTOMAREAS, p in PRODUCTS} DelProd_DC[d,p,k] = 6014
'TOT PROD FR ALLA DC' = 'TOT PROD FR ALLA DC'

sum{d in D_CENTERS, k in CUSTOMAREAS} Tcost_D2C*distDC[d,k] = 14716.2
'TOT. DIST REST' = 'TOT. DIST REST'

