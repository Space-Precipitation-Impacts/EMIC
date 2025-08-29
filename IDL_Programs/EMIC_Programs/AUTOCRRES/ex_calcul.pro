Pro Ex_calcul,cm_eph,cm_val,state,cut
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
common logs, filename1,filename2
;********************************************************************************
common val_header, header
;********************************************************************************
common datafiles, data_files,no_data,para_struct

;***********************************************************************************
WIDGET_CONTROL, state.text,SET_VALUE = 'Calculating Ex with alpha set at:'+string(cut)+'degrees',/append

openw,lg,filename1,/get_lun,/append
printf,lg,'Calculating Ex with alpha set at:'+string(cut)
Free_lun,lg

nn=long(0)
nn1=long(0)
 PI=3.14159265359
for i=long(0), n_elements(cm_val.(0)) - long(1) do $
	BEGIN
	if cm_val.(10)[i]/PI*180.0 LE cut then $
	 begin
	 nn=nn+1
	 nn1=nn1+1
	endif
endfor
tem1=dblarr(nn)
j=long(0)
for i=long(0), n_elements(cm_val.(0)) - long(1) do $
	BEGIN
	 if cm_val.(10)[i]/PI*180.0 LE cut then $
	   begin
         if(cm_val.(4)[i] EQ float(0.0)) then tem1[j] = 0.0 else $
		   begin
     	    tem1[j] = -(cm_val.(2)[i]*cm_val.(5)[i] + cm_val.(3)[i]*cm_val.(6)[i])$
     	    /cm_val.(4)[i]
     	    j=j+1
	     endelse
	endif
endfor
;***********************************************************************************
cm_val.(1) = congrid(tem1,n_elements(cm_val.(0)))
WIDGET_CONTROL, state.text,SET_VALUE = string(n_elements(cm_val.(0))),/append
WIDGET_CONTROL, state.text,SET_VALUE = string(nn),/append
WIDGET_CONTROL, state.text,SET_VALUE = string(nn1),/append
print,n_elements(cm_val.(0))
print,nn
print,nn1
WIDGET_CONTROL, state.text,SET_VALUE = 'Done',/append
end