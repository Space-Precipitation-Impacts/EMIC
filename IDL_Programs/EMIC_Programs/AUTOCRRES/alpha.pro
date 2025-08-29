pro alpha, cm_eph,cm_val,state;,alph
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
common logs, filename1,filename2
;********************************************************************************
common val_header, header
;********************************************************************************
common datafiles, data_files,no_data,para_struct

WIDGET_CONTROL, state.text,SET_VALUE = 'Calculating Alpha Angle'
WIDGET_CONTROL, state.text,SET_VALUE = 'Done',/append
openw,lg,filename1,/get_lun,/append
printf,lg,'Calculating Alpha Angle'
Free_lun,lg
count=n_elements(cm_val.(0))
 PI=3.14159265359
alph=fltarr(count)
for i=long(0), count-long(1) do $
 begin
    if(cm_val.(4)[i] EQ float(0.0)) then alph =PI/2.0 else $
      begin
        alph[i] = Atan(sqrt(cm_val.(5)[i]*cm_val.(5)[i] + cm_val.(6)[i]*cm_val.(6)[i])/$
        abs(cm_val.(4)[i]))
    endelse
endfor
cm_val.(10)=alph
;*******************************************************************************
;*******************************************************************************
;Calculation of alpha angle
;print,'Calculating alpha angle......'
;ct=count
;
;alpha_angle = fltarr(ct) ;Initialize alpha angle handling array.
;n=long(0)
;n1=long(0)
;for m=long(0),ct-1 do $  ;Note: all perturb B fields have same array size so
; begin  				 ;using any of the data point counters will do
;      alpha_angle[m] = alpha(dBx[m],dBy[m],dBz[m])  ;Calling alpha function.
;     If (alpha_angle[m] GE 90.0/180.0*pI) then $;
;		n1=n1+long(1)
;      If alpha_angle[m] LE alph/180.0*pI then $
;      	n = n + long(1)
;      	;else print,alpha_angle[m]/pI*180.0
;endfor
;;
;print,format='(a24,I0)','The number of points is ',count0
;print,format='(a45,I0)','The number of points where alpha is valid is ',n
;print,' '
;*********************************************************************************

end