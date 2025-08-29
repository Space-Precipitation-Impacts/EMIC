pro alphaa, cm_eph,cm_val,state,alpha
;********************************************************************************
count=n_elements(cm_val.(0))
alpha=fltarr(count)
for i=0, count-1 do $
 begin
    if(cm_val.(7)[i] EQ float(0.0)) then alph = 3.14159265359/2.0 else $
      begin
        alph[i] = Atan(sqrt(cm_val.(8)[i]*cm_val.(8)[i] + cm_val.(9)[i]*cm_val.(9)[i])/$
        abs(cm_val.(7)[i]))
    endelse
endfor
stop
;*******************************************************************************
end