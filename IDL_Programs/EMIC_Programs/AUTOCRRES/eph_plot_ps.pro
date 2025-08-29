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


PRO eph_plot_ps,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common datafiles, data_files,no_data,para_struct

nname = tag_names(cm_eph)
nname = STRLOWCASE(nname)
ff = 'mlt'
print,ff
cd,res_path[0]
;fname=strmid(para_struct[3].filename,0,strlen(para_struct[3].filename)-4)+'_orbit_'+string(ff)+'.ps'
fname='Orb'+orb+'_orbita.ps'
for ii=0, n_tags(cm_eph) -1 do $
 if ff EQ nname[ii] then $
 begin
 widget_control,state.text,set_value=string(cm_eph.(ii))+string(cm_eph.(34))+$
 string(cm_eph.(1))
 WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))+'  '+$
 string(strupcase(nname[34]))+'  '+string(strupcase(nname[1]))
  IF (ff NE 'julian')  then $
    begin
   IF (ff EQ 'localtime') OR  (ff EQ 'localtimegsm') OR  (ff EQ 'localtimesm') $
   OR  (ff EQ 'mlt') then $
     begin
     cm=0L
     for i=1, n_elements(cm_eph.(34))-1 do $
     if cm_eph.(34)[i] EQ max(cm_eph.(34)) then $
         cm=i
    test_pol_ps,state,nname(ii)
    oPLOT,/polar,cm_eph.(34)[0:cm],$
    cm_eph.(ii)[0:cm]/max(cm_eph.(ii))*2.*!PI,psym=0,symsize=1.0;,color=256
    oPLOT,/polar,cm_eph.(34)[cm+1:n_elements(cm_eph.(34))-2],$
    cm_eph.(ii)[cm+1:n_elements(cm_eph.(34))-2]/$
    max(cm_eph.(ii))*2.*!PI,psym=1,symsize=0.5


    xyouts,-10,-9,'______ Ascending',charsize=0.8
    xyouts,-10,-10,'++++ Descending',charsize=0.8
	device,/close

	set_plot,'ps'

	fname='Orb'+orb+'_epha.ps'
	device,filename=FName,yoffset=3, ysize=23
	!P.multi=[0,1,2]
    print,nname(ii)
     PLOT,cm_eph.(1),cm_eph.(15),xtitle=string(STRUPCASE(nname(1))),$
    ytitle=string(strupcase(nname[15])),xticks=3,yrange=[min(cm_eph.(15)),$
    max(cm_eph.(15))],title='Crres Orbit'+string(orb)+' '+string(orb_date),xstyle=1,$
    xtickformat='XTLab'
    oplot,cm_eph.(34)
     PLOT,cm_eph.(1),cm_eph.(35),xtitle=string(STRUPCASE(nname(1))),$
    ytitle=string(strupcase(nname[35])),xticks=3,yrange=[min(cm_eph.(35)),$
    max(cm_eph.(35))],title='Crres Orbit'+string(orb)+' '+string(orb_date),xstyle=1,$
    xtickformat='XTLab'
    device,/close
    endif else begin

	set_plot,'ps'
	device,filename=FName,yoffset=3, ysize=23

	!P.MULTI = 0                     ;                     ;
    PLOT,cm_eph.(1),cm_eph.(ii),xtitle=string(STRUPCASE(nname(1))),$
    ytitle=string(strupcase(nname[ii])),xticks=3,yrange=[min(cm_eph.(ii)),$
    max(cm_eph.(ii))],title='Crres Orbit'+string(orb)+' '+string(orb_date),xstyle=1,$
    xtickformat='XTLab'
    oplot,cm_eph.(34);,/YNOZERO
	device,/close
    endelse
   endif

endif

set_plot,'win'
cd,idl_path[0]
end