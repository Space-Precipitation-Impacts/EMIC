;AUTHOR: T. Loto'aniu
;DATE: June 2001
;PURPOSE: Initialization Display Widget
;
Pro Init_Crres_eph_Parameters_event,ev
WIDGET_CONTROL, ev.top, get_uvalue=state3,/HOURGLASS
WIDGET_CONTROL, state3.orb_info, set_value=' '
;******************************************************

end

Pro Init_Crres_eph_Parameters
common despike_para,des_limit,grad_limit
common init_struct,state2
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common datafiles, data_files,no_data,para_struct
common logs, filename1,filename2
common fre_timres, fft_limit, timres_limit
base_init=widget_base(/column,/ALIGN_bottom)
orb_info = WIDGET_LABEL(base_init,xsize=200,value='Initializing.....',/DYNAMIC_RESIZE)
geo= widget_info( base_init, /geo )
  x= 600- geo.xsize/2
  y= 300- geo.ysize/2
state3={base_init:base_init,orb_info:orb_info}
;**************************************************
widget_control, base_init, xoffset=x, yoffset=y
WIDGET_CONTROL, base_init, /REALIZE
;******************************************************
wait,0.5
WIDGET_CONTROL, state3.orb_info, set_value='Checking data directory....'
cd,data_path[0]
data_files=findfile('*.val')
no_data=n_elements(data_files)

;wait,0.5
WIDGET_CONTROL, state3.orb_info, set_value=string(no_data)+' data files'
;wait,0.5
for i=0,no_data-1 do $
begin
WIDGET_CONTROL, state3.orb_info, set_value=string(data_files[i])
;wait,0.5
end
WIDGET_CONTROL, state3.orb_info, set_value='Checking events directory....'
;wait,0.5
cd,eve_path[0]
No_eve=0L
text=''
j=0
A = CREATE_STRUCT('filename',' ','Orbit', ' ',$
	         'start_time',' ', 'end_time',' ',$
	         'event_freq',0.0,$
	         'max_freq', 0.0)
para_struct=REPLICATE(a, no_data)
openr,u,'events.val',/get_lun
while (not eof(u)) do $
 begin
  readf,u,text
  ;stop
   for i=0,no_data-1 do $
    if fix(strmid(text,0,4)) EQ fix(strmid(data_files[i],3,4)) then $
     begin
      WIDGET_CONTROL, state3.orb_info, set_value=string('Orb')+strmid(text,0,4)+' '+text
      wait,0.3
      ;stop
      if fix(strmid(text,0,4)) LT 100 then $
       begin
       if strmid(text,5,4) EQ  strmid(data_files[i],6,4) $
         and strmid(text,10,4) EQ  strmid(data_files[i],11,4) $
          then $
	       begin
	       ;stop
	        print,'Less then 100a',strmid(data_files[i],6,4)
	        print,'Less then 100b',strmid(data_files[i],11,4)
	        para_struct[j].(0) = data_files[i]
	        para_struct[j].(1) = strmid(text,0,4)
	        para_struct[j].(2) =strmid(text,5,4)
	        para_struct[j].(3) =strmid(text,10,4)
	        para_struct[j].(4) =FLOAT(strmid(text,15,3))
	        para_struct[j].(5) =FLOAT(strmid(text,15,3))+1.0
			j=j+1
        end
       end
      if (fix(strmid(text,0,4)) GE 100) and (fix(strmid(text,0,4)) LT 999) then $
       begin
        if strmid(text,5,4) EQ  strmid(data_files[i],7,4) $
         and strmid(text,10,4) EQ  strmid(data_files[i],12,4) $
          then $
	       begin
	       ;stop
	        print,'More then 100a',strmid(data_files[i],7,4)
	        print,'More then 100b',strmid(data_files[i],12,4)
	        ;stop
			para_struct[j].(0) = data_files[i]
			para_struct[j].(1) = strmid(text,0,4)
			para_struct[j].(2) =strmid(text,5,4)
			para_struct[j].(3) =strmid(text,10,4)
			para_struct[j].(4) =FLOAT(strmid(text,15,3))
			para_struct[j].(5) =FLOAT(strmid(text,15,3))+1.0
			j=j+1
        end
        end

		if fix(strmid(text,0,4)) GE 1000 then $
       begin
        if strmid(text,5,4) EQ  strmid(data_files[i],8,4) $
         and strmid(text,10,4) EQ  strmid(data_files[i],13,4) $
          then $
	       begin
	       ;stop
	        print,'More then 100a',strmid(data_files[i],8,4)
	        print,'More then 100b',strmid(data_files[i],13,4)
	        ;stop
			para_struct[j].(0) = data_files[i]
			para_struct[j].(1) = strmid(text,0,4)
			para_struct[j].(2) =strmid(text,5,4)
			para_struct[j].(3) =strmid(text,10,4)
			para_struct[j].(4) =FLOAT(strmid(text,15,3))
			para_struct[j].(5) =FLOAT(strmid(text,15,3))+1.0
			j=j+1
        end
        end

        ;stop

end
;j=j+1
  No_eve=No_eve+1
end
;stop
WIDGET_CONTROL, state3.orb_info, set_value='Initialization Complete....'
wait,0.5
;stop
print,'N_events ',No_eve
Point_Lun,u,0
wait,1.0
free_lun,u
cd,idl_path[0]

;
;****************************************
            ;Opening Main Log File
            ;
            WIDGET_CONTROL, state3.orb_info, set_value='Creating crres_widget.log file...'
            wait,0.5
 	        filename1=log_path[0]+'\crres_widget.log'
			openw,lg,filename1,/get_lun

			;
			;Opeing Error Log File
			;
			WIDGET_CONTROL, state3.orb_info, set_value='Creating crres_err.log file...'
            wait,0.5
			filename2=log_path[0]+'\crres_err.log'
			openw,lgerr,filename2,/get_lun
			;*****************************************
			;Write to file time of creation
			;
			printf,lg,systime(0)
			printf,lgerr,systime(0)
			;*****************************************
			printf,lg,' '
			printf,lg,'IDL Codes Directory: '+idl_path[0]
			printf,lg,'Telemetry Directory: '+data_path[0]
			printf,lg,'Ephermius Directory: '+eph_path[0]
			printf,lg,'Results Directory: '+res_path[0]
			printf,lg,'Events Paramters Directory: '+eve_path[0]
			printf,lg,'Logs Directory: '+log_path[0]
			printf,lg,'Spline Sigma: '+spl_int[0]
			printf,lg,'Frequency to Remove Spacecraft Phasing: '+fre_int[0]+'Hz'
			printf,lg,'FFT length: '+STRING(fft_limit)+' points'
			printf,lg,'FFT length: '+STRING(timres_limit)+' points'
			printf,lg,'Despike Limit (Points): '+des_limit[0]
			printf,lg,'Despike Limit (Normalized Gradient): '+grad_limit[0]
			printf,lg,' '
			printf,lg,'Number Data Files: '+string(no_data)
			printf,lg,' '
			for y=0,n_elements(data_files)-1 do $
			printf,lg,data_files[y]
			printf,lg,' '
			Free_lun,lg
			Free_lun,lgerr

;idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;****************************************
;stop
WIDGET_CONTROL, state3.base_init, /destroy
;stop
End