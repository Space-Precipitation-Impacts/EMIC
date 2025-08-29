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


PRO eph_data_write,state,cm_eph,cm_val,ff
common orbinfo,orb,orb_binfile,orb_date
FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)

;window,7,xsize=420,ysize=420,title='Ephmerius Plot'
;set_plot,'ps'
;device,filename=FName,yoffset=3, ysize=23
;!P.charsize=1.0
;!Y.style=3
;!P.ticklen=0.04
;!P.MULTI = 0                     ;                     ;
openw,u,FName,/get_lun
nname = tag_names(cm_eph)
nname = STRLOWCASE(nname)
ff = STRLOWCASE(ff)
print,ff
for ii=0, n_tags(cm_eph) -1 do $
 if ff EQ nname[ii] then $
 begin
 printf,u,'Orbit'+string(orb)+' '+string(orb_date)
 printf,u,'File: '+string(orb_binfile)+'.0ep'
 printf,u,strupcase(nname[ii]),strupcase(nname[34]),strupcase(nname[1]),$
 Format="(A12,7X,A7,3X,A6)"
 ;CMEPHSTRING=strING(cm_eph.(ii))
 ;CMEPHLEN=STRLEN(strING(cm_eph.(ii)))
 ;PRINT,CMEPHLEN[0]
 ;AA='a'+string(cmephlen[0])
 for i=0, n_elements(cm_eph.(34))-1 do $
 printf,u,cm_eph.(ii)[i],cm_eph.(34)[i],cm_eph.(1)[i]
 WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))+'  '+$
 string(strupcase(nname[34]))+'  '+string(strupcase(nname[1]))
    print,ii
    PRINT,CM_EPH.(8)[0]/CM_EPH.(34)[0]
endif
free_lun,u
end