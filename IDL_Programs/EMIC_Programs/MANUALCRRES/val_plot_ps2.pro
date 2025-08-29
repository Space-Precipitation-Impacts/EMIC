;PROCEDURE:
;			val_plot_ps.pro
;
;AUTHOR: Paul Manusiu, 10 March 20001
;
;PURPOSE: Plots time series data to file as postscript
;
;CALLING SEQUENCE: Called by Dat_menu_event event handler
;				   subroutine within CRRES_WIDGET.pro
;
;INPUT:
;		     state: Control Widget structure
;	        cm_eph: Ephmerius data structure
;	        cm_val: Telemetry data structure
;		 	  dat5: Name of variable to plot (e.g. 'EX')
;eph_inter.pro: Interpolates ephmerius over time interval
;
;OUTPUT:
;		Plots time series for E, B and S
;
;
;MODIFICATION HISTORY: 15 March 2001 by Paul Manusiu
;					   Included call to eph_inter.pro
;					   routine to overplot ephermius data
;					   on x-axis.
;
;
 Function XTLaba,Axis,Index,Value		;Function to format x axis into hours:minutes:seconds.frac
 common namm,nn,ttt					;Reference ttt array in main, call ttt index nn
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
;**********************************
 ;Search for xtickformat index
 ;
 tmp1=float(msec-min(ttt))
 tmp2=float(max(ttt)-min(ttt))
 ind=long(tmp1/tmp2*n_elements(ttt))	;if found take ind index of ttt array closes to xtickformat
 nn(index)=ind						;Pass ind to nn array for reference in main
 ;
 ;**********************************
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end


PRO val_plot_ps,state,cm_eph,cm_val,Dat5
common orbinfo,orb,orb_binfile,orb_date
common namm,nn,ttt
common Power, DispArr
common Power_again, DispArr_again
common CPow, CPArr
common Poyntpow, PoyntArr
common ptext,plottext
common SBangle, anglel
common dens,val_inter_dens
COMMON DENS_ALF_PHA, alf_vel,phase_vel
common reflcoef, neg_sz, pos_sz
;stop
nname = tag_names(cm_val)
 PI=3.14159265359
!P.Multi=0
fNAME=''
FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)
IF FName NE '' then $
begin
WIDGET_CONTROL, state.file_info,get_value=fil_info
if fil_info EQ 'TIME DOMAIN' then $
begin
nn=lonarr(4)
ttt=cm_val.(0)
set_plot,'ps'
device,filename=FName,yoffset=14, ysize=15
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.04

if dat5 EQ 'ALL BPC5' then $
begin
;!p.multi=0
;congrid(cm_val.(0),n_elements(cm_val.(0)
widget_control,state.text,$
set_value=string(cm_val.(15)[0:100])+string(cm_val.(16)[0:100])+string(cm_val.(17)[0:100])
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[15]))+' '+string(strupcase(nname[16]))+' '+string(strupcase(nname[17]))
!P.multi=[0,1,3]
for iyi=15,17 do $
begin
 plot,congrid(cm_val.(0),long(n_elements(cm_val.(0))/2.)),$
 congrid(cm_val.(iyi),long(n_elements(cm_val.(iyi))/2.)),$
 ytitle=string(nname(iyi))+'(nT)',$
 xtickformat='Xtlaba',xticks=3,title='Orbit'+string(orb)+'  '+string(orb_date),$
 xstyle=1,xcharsize=2.0,ycharsize=2.0,ymargin=7.0,xmargin=18.0
xrr=lonarr(4041)
yrr=fltarr(4041)

for ii=0,4040 do $
begin
xrr[ii]=17527000
yrr[ii]=ii-2000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=17810000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=18056000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=18305000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=42102000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=42394000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=42754000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=43273000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=43639000
end
oplot,xrr,yrr,LINESTYLE=2

xrr=lonarr(4041)
yrr=fltarr(4041)

for ii=0,4040 do $
begin
xrr[ii]=41434000
yrr[ii]=ii-2000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=41674000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=42257000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=42600000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=43070000
end
oplot,xrr,yrr,LINESTYLE=0
end

xyouts,4700,15600,'1     2              3      4           5',/device
xyouts,4700,15300,'a  b  a  b  c d                         a        b',/device

!p.multi=0
!P.charsize=1.0

endif

if dat5 EQ 'ALL EPCLONG' then $
begin
;!p.multi=0
;congrid(cm_val.(0),n_elements(cm_val.(0)
widget_control,state.text,$
set_value=string(cm_val.(18)[0:100])+string(cm_val.(19)[0:100])+string(cm_val.(20)[0:100])
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[18]))+' '+string(strupcase(nname[19]))+' '+string(strupcase(nname[20]))
!P.multi=[0,1,3]
for ii=18,20 do $
 plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 congrid(cm_val.(ii),fix(n_elements(cm_val.(ii))/2.)),$
 ytitle=string(nname(ii))+'(mV/m)',$
 xtickformat='Xtlaba',xticks=3,title='Orbit'+string(orb)+'  '+string(orb_date),$
 xstyle=1,xcharsize=2.0,ycharsize=2.0,ymargin=7.0,xmargin=18.0
!p.multi=0
!P.charsize=1.0
endif


if dat5 EQ 'ALL E FIELDS' then $
begin
;!p.multi=0
;congrid(cm_val.(0),n_elements(cm_val.(0)
widget_control,state.text,$
set_value=string(cm_val.(1)[0:100])+string(cm_val.(2)[0:100])+string(cm_val.(3)[0:100])
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[1]))+' '+string(strupcase(nname[2]))+' '+string(strupcase(nname[3]))
!P.multi=[0,1,3]
for ii=1,3 do $
 plot,congrid(cm_val.(0),long(n_elements(cm_val.(0))/2.)),$
 congrid(cm_val.(ii),long(n_elements(cm_val.(ii))/2.)),$
 ytitle=string(nname(ii))+' (mV/m)',$
 xtickformat='Xtlaba',xticks=3,title='Orbit'+string(orb)+'  '+string(orb_date),$
 xstyle=1,xcharsize=2.0,ycharsize=2.0
!p.multi=0
!P.charsize=1.0
endif

for ii=1,3 do $
  if dat5 EQ nname(ii) then $
	begin
        plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(ii),fix(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(nname(ii))+'mV/m',xtickformat='Xtlaba',xticks=3,$
        title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1
         widget_control,state.text,set_value=string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))
  endif

if dat5 EQ 'ALL DB FIELDS' then $
 begin


widget_control,state.text,$
set_value=string(cm_val.(4)[0:100])+string(cm_val.(5)[0:100])+string(cm_val.(6)[0:100])
WIDGET_CONTROL, state.dat_info,$
SET_VALUE = string(strupcase(nname[4]))+' '+string(strupcase(nname[5]))+' '+string(strupcase(nname[6]))
!P.multi=[0,1,3]
for ii=4,6 do $
 plot,congrid(cm_val.(0),long(n_elements(cm_val.(0))/2.)),$
 congrid(cm_val.(ii),long(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(nname(ii))+'nT',xtickformat='Xtlaba',xticks=3,$
 title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1,$
 xcharsize=2.0,ycharsize=2.0

endif
if dat5 EQ 'ALL B FIELDS' then $
 begin
widget_control,state.text,$
set_value=string(cm_val.(7)[0:100])+string(cm_val.(8)[0:100])+string(cm_val.(9)[0:100])
WIDGET_CONTROL, state.dat_info,$
SET_VALUE = string(strupcase(nname[7]))+' '+string(strupcase(nname[8]))+' '+string(strupcase(nname[9]))
!P.multi=[0,1,3]
for ii=7,9 do $
 plot,congrid(cm_val.(0),long(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(ii),long(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(nname(ii))+'(nT)',xtickformat='Xtlaba',xticks=3,$
 title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 xcharsize=2.0,ycharsize=2.0,yrange=[min(cm_val.(ii))-1.0,max(cm_val.(ii))+1.0]
 !p.multi=0

endif

;for ii=0,9 do $
  if dat5 EQ 'Alpha Angle' then $;
	begin;


        plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(10),fix(n_elements(cm_val.(10))/2.))/PI*180.0,ytitle='Degrees (!Uo!n)',xtickformat='Xtlaba',xticks=3,$
        title=string('Alpha Angle'),xstyle=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        yrange=[min(cm_val.(10)/PI*180.0)-10.0,max(cm_val.(10)/PI*180.0)+10.0]
        widget_control,state.text,set_value=string(cm_val.(10)[0:500]/PI*180.0)
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase('Alpha Angle'))

  endif

for ii=4,9 do $
  if dat5 EQ nname(ii) then $
	begin
      plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(ii),fix(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(dat5)+'(nT)',$
        xtickformat='Xtlaba',xticks=3,$
        title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1,xrange=[cm_val.(0)[0],max(cm_val.(0))]
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
        ; stop

endif
for ii=11,13 do $
  if dat5 EQ nname(ii) then $
	begin
        plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(ii),fix(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(dat5)+'(uW/m!U2!n)',$
        xtickformat='Xtlaba',xticks=3,$
        title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1,xrange=[cm_val.(0)[0],$
        max(cm_val.(0))]
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
        ; stop

endif
if dat5 EQ 'ALL FIELDS' then $
	begin
widget_control,state.text,$
set_value='+ Reflection Coeff Sz:'+string(pos_sz),/append
widget_control,state.text,$
set_value='- Reflection Coeff Sz:'+string(neg_sz),/append

widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(11)[0:100])+string(cm_val.(12)[0:100])+string(cm_val.(13)[0:100]),/append
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[11]))+' '+string(strupcase(nname[12]))+' '+string(strupcase(nname[13]))
!P.multi=[0,1,3]
;neg_sz, pos_sz
;window,10,xsize=500,ysize=500



for ii=11,13 do $
plot,congrid(cm_val.(0),long(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(ii),long(n_elements(cm_val.(ii))/2.)),$
 		ytitle=string(nname(ii))+'(uW/m!U2!n)',$
 xtickformat='Xtlaba',xticks=3,$
 title='Orbit'+string(orb)+'  '+string(orb_date),xstyle=1,xrange=[cm_val.(0)[0],$
 max(cm_val.(0))],$
 xcharsize=2.0,ycharsize=2.0
 !p.multi=0

endif


if dat5 EQ 'Z FIELDS' then $
	begin
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(6)[0:100])+string(cm_val.(9)[0:100])+string(cm_val.(13)[0:100])
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[6]))+' '+string(strupcase(nname[9]))+' '+string(strupcase(nname[13]))
!P.multi=[0,1,4]
;window,10,xsize=500,ysize=500
 plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(6),fix(n_elements(cm_val.(6))/2.)),$
 		ytitle=string(nname(6))+'(nT)',$
 xtickformat='Xtlab',xticks=3,$
 xstyle=5,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  xcharsize=2.0,ycharsize=2.0

 plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(9),fix(n_elements(cm_val.(9))/2.)),$
 		ytitle=string(nname(9))+'(nT)',$
 xtickformat='Xtlab',xticks=3,$
 xstyle=5,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  xcharsize=2.0,ycharsize=2.0
 ;!p.multi=0

 plot,congrid(cm_val.(0),fix(n_elements(cm_val.(0))/2.)),$
 		congrid(cm_val.(13),fix(n_elements(cm_val.(13))/2.)),$
 		ytitle=string(nname(13))+'(uW/m!U2!n)',$
 xtickformat='Xtlab',xticks=3,$
 xstyle=5,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  xcharsize=2.0,ycharsize=2.0
  plot,congrid(cm_val.(0),n_elements(cm_val.(0))/500.0),$
 congrid(cm_val.(14),n_elements(cm_val.(14))/500.0),$
yrange=[0,180],$
xstyle=9,xtickformat='XTLaba',$
ytitle='PhetaSB (!Uo!n)',ymargin=[3.8,-1],$
xticks=3,nsum=1,xcharsize=2.0,ycharsize=2.0
 !p.multi=0
endif

if dat5 EQ 'PhetaSB' then $
	begin
  ;xcharsize=2.0,ycharsize=2.0

plot,congrid(cm_val.(0),n_elements(cm_val.(0))/100.0),congrid(anglel,n_elements(cm_val.(0))/100.0),$
yrange=[0,180],$
xstyle=1,xtickformat='XTLab',xtitle='UT',$
ytitle='PhetaSB (!Uo!n)
end
print,nname
print,Dat5

if dat5 EQ 'ALFVEN VELOCITY' then $
	begin
	!P.multi=[0,1,2]
	plot,cm_val.(0),val_inter_dens,xstyle=5,xtickformat='XTLab',title='Orbit'+string(orb)+$
	'  '+string(orb_date),$
ytitle='Number Density (cm!U3!n)';,xcharsize=2.0,ycharsize=2.0
	plot,cm_val.(0),phase_vel,xstyle=9,ytitle='Va(_ _) & Vp(. .) (km/s)',xtickformat='XTLab',$
ymargin=[3.8,-1],yrange=[0,2000.],YSTYLE=1,xticks=3,linestyle=1;,$;,XMARGIN=1.0
;xcharsize=2.0,ycharsize=2.0
oplot,cm_val.(0),alf_vel/1000,linestyle=5.;,xstyle=9,ytitle='Va (km/s)',xtickformat='XTLab',title='Alfven Velocity',$
ymargin=[3.8,-1]
	END

;*********************************************************************************
eph_inter,cm_eph,cm_val,state,Dat5
;*********************************************************************************
device,/close
set_plot,'win'
!P.multi=0
ENDIF ELSE $
BEGIN
;stop
if plottext EQ 'Plot Again' then $
begin
DispArr=0.0
;stop
if Dat5 EQ 'SX' or Dat5 EQ 'SY' or Dat5 EQ 'SZ' THEN $
spectralpoyntps,cm_eph,cm_val,state,Dat5,PoyntArr,Fname else $
if Dat5 EQ 'ALL E FIELDS' OR Dat5 EQ 'ALL DB FIELDS' THEN $
spectralps_multi,cm_eph,cm_val,state,Dat5,DispArr_Again,Fname else $
if Dat5 EQ 'ALL FIELDS' then $
spectralpoyntps_multi,cm_eph,cm_val,state,Dat5,PoyntArr,Fname else $
if Dat5 EQ 'CROSSPOWER' THEN $
spectralps,cm_eph,cm_val,state,Dat5,CPArr,Fname else $
if Dat5 EQ 'Z FIELDS' then $
spectra_tim_Zps,cm_eph,cm_val,state,Dat5,PoyntArr,CPArr,Fname else $
spectralps,cm_eph,cm_val,state,Dat5,DispArr_again,Fname
endif else $
if Dat5 EQ 'ALL E FIELDS' OR Dat5 EQ 'ALL DB FIELDS' THEN $
spectralps_multi,cm_eph,cm_val,state,Dat5,DispArr,Fname else $
if Dat5 EQ 'ALL FIELDS' then $
spectralpoyntps_multi,cm_eph,cm_val,state,Dat5,PoyntArr,Fname else $
if Dat5 EQ 'CROSSPOWER' THEN $
spectralps,cm_eph,cm_val,state,Dat5,CPArr,Fname else $
if Dat5 EQ 'SX' or Dat5 EQ 'SY' or Dat5 EQ 'SZ' THEN $
spectralpoyntps,cm_eph,cm_val,state,Dat5,PoyntArr,Fname else $
if Dat5 EQ 'Z FIELDS' then $
spectra_tim_Zps,cm_eph,cm_val,state,Dat5,PoyntArr,CPArr,Fname else $
spectralps,cm_eph,cm_val,state,Dat5,DispArr,Fname

ENDELSE
!P.multi=0

end else $
Result = DIALOG_MESSAGE('No file selected!')
end