Pro Poynt,cm_eph,cm_val,state
;
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
common logs, filename1,filename2
;********************************************************************************
common val_header, header
;********************************************************************************
common datafiles, data_files,no_data,para_struct

WIDGET_CONTROL, state.text,SET_VALUE = 'Calculating poynting vector in time domain'
WIDGET_CONTROL, state.text,SET_VALUE = 'Done',/append
openw,lg,filename1,/get_lun,/append
printf,lg,'Calculating poynting vector in time domain'
Free_lun,lg

E_x=cm_val.(1)
E_y=cm_val.(2)
E_z=cm_val.(3)
B_x=cm_val.(4)
B_y=cm_val.(5)
B_z=cm_val.(6)
S_x=cm_val.(11)
S_y=cm_val.(12)
S_z=cm_val.(13)
;Calculation of Poynting flux: Note that all values are in units of microWatts
;
 piI = 3.1415926535898
 u = 4*PiI
for i=long(0), n_elements(cm_val.(0)) -long(1) do $
	begin
    	S_z[i] = 10.0*(1.0/u)*(E_x[i]*B_y[i] - B_x[i]*E_y[i])
    	S_x[i] = 10.0*(1.0/u)*(E_y[i]*B_z[i] - B_y[i]*E_z[i])
    	S_y[i] = 10.0*(1.0/u)*(E_z[i]*B_x[i] - B_z[i]*E_x[i])
endfor
cm_val.(11)=S_x
cm_val.(12)=S_y
cm_val.(13)=S_z
E_x=0.0
E_y=0.0
E_z=0.0
B_x=0.0
B_y=0.0
B_z=0.0

end