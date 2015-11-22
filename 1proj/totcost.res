: _objname    _obj     :=
1   z        170069
;

sum{d in USED_DC, t in 1 .. T, p in PRODUCTS} DC_STORAGE_P[p,d,t]*
  HoldCost_Prod = 1837

sum{d in USED_DC, t in 1 .. T, c in COMPONENTS} DC_STORAGE_C[c,d,t]*
  HoldCost_Comp = 719

sum{d in USED_DC, t in 0 .. T} DC_CapCost[d,t] = 343700

