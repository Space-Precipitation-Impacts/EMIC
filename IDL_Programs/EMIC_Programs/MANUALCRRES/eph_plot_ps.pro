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


PRO eph_plot_ps,state,cm_eph,cm_val,ff
common orbinfo,orb,orb_binfile,orb_date

nname = tag_names(cm_eph)
nname = STRLOWCASE(nname)
ff = STRLOWCASE(ff)
print,ff
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

    print,nname(ii)
    ;oPLOT,/polar,cm_eph.(34),cm_eph.(ii)/max(cm_eph.(ii))*2.*!PI,psym=2
    ;oPLOT,/polar,cm_eph.(17),cm_eph.(ii)/max(cm_eph.(ii))*2.*!PI;,psym=10
    ;,xtitle=string(STRUPCASE(nname(34))),$
    ;ytitle=string(strupcase(nname[ii])),xticks=3,xstyle=4,ystyle=4,yrange=[-12,12];,/YNOZERO
    device,/close
    endif else begin
    ;window,8,xsize=420,ysize=420,title='Ephmerius Plot'
      FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)

	;window,7,xsize=420,ysize=420,title='Ephmerius Plot'
	set_plot,'ps'
	device,filename=FName,yoffset=3, ysize=23
	;!P.charsize=1.0
	;!Y.style=3
	;!P.ticklen=0.04
	!P.MULTI = 0                     ;                     ;
    PLOT,cm_eph.(1),cm_eph.(ii),xtitle=string(STRUPCASE(nname(1))),$
    ytitle=string(strupcase(nname[ii])),xticks=3,yrange=[min(cm_eph.(ii)),$
    max(cm_eph.(ii))],title='Crres Orbit'+string(orb)+' '+string(orb_date),xstyle=1,$
    xtickformat='XTLab'
    oplot,cm_eph.(34);,/YNOZERO
	device,/close
    endelse
   endif
    print,ii
    PRINT,CM_EPH.(8)[0]/CM_EPH.(34)[0]
endif

set_plot,'win'
end