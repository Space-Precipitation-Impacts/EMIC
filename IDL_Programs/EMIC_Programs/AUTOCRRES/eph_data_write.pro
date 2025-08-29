;Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
; mSec=long(Value)
; milsec=long(mSec) Mod 1000
; seci=Long(mSec/1000)
; secf = long(seci) mod 60
; mni=Long(seci)/60
; mnf = long(mni) mod 60
; hr = Long(mni/60)
; Return,String(hr,mnf,secf,$
;  Format="(I2.2,':',I2.2,':',i2.2)")
;end


PRO eph_data_write,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common val_header, header
common datafiles, data_files,no_data,para_struct
;fname=strmid(para_struct[3].filename,0,strlen(para_struct[3].filename)-4)+'.eph'
cd,res_path[0]
 fname='Orb'+orb+'a.eph'       ;                     ;
openw,u,FName,/get_lun
nname = tag_names(cm_eph)
indut=where(nname EQ 'UT',count)
indlshell=where(nname EQ 'LSHELL',count)
indmlat=where(nname EQ 'MLAT',count)
indmlt=where(nname EQ 'MLT',count)
indlt=where(nname EQ 'LOCALTIME',count)
indbmin=where(nname EQ 'BMIN',count)
indbminlat=where(nname EQ 'BMINLAT',count)
indbminlong=where(nname EQ 'BMINLON',count)
indbalt=where(nname EQ 'BMINALT',count)

nname = STRLOWCASE(nname)
printf,u,'Orbit'+string(orb)+' '+string(orb_date)
printf,u,'Ephermius File: '+string(orb_binfile)+'.0ep'
printf,u,strupcase(nname[indut]),strupcase(nname[indlshell]),strupcase(nname[indmlat]),$
		strupcase(nname[indmlt]),strupcase(nname[indlt]),strupcase(nname[indbmin]),$
		strupcase(nname[indbminlat]),strupcase(nname[indbminlong]),strupcase(nname[indbalt]),$
Format="(A10,3X,A10,3X,A10,3X,A10,3X,A14,3X,A8,3X,A12,3X,A12,3X,A12)"
 ;
 for i=0, n_elements(cm_eph.(1))-1 do $
 begin
 printf,u,cm_eph.(indut[0])[i],cm_eph.(indlshell[0])[i],cm_eph.(indmlat[0])[i],$
 cm_eph.(indmlt[0])[i],cm_eph.(indlt[0])[i],cm_eph.(indbmin[0])[i],$
 cm_eph.(indbminlat[0])[i],cm_eph.(indbminlong[0])[i],cm_eph.(indbalt[0])[i],$
 format='(I10,2X,F12.6,2X,F12.6,2X,F12.6,2X,F12.6,2X,F12.6,2X,F12.6,2X,F12.6,2X,F12.6)'
 end
 ;
 ;WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))+'  '+$
 ;string(strupcase(nname[34]))+'  '+string(strupcase(nname[1]))
 ;   PRINT,CM_EPH.(8)[0]/CM_EPH.(34)[0]
free_lun,u
cd,idl_path[0]
;stop
end