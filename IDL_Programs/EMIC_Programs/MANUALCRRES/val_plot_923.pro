;PROCEDURE:
;			val_plot.pro
;
;AUTHOR: Paul Manusiu, 01 March 20001
;
;PURPOSE: Plots time series data to the screen
;
;CALLING SEQUENCE: Called by Dat_menu_event event handler
;				   subroutine within CRRES_WIDGET.pro
;
;INPUT:
;		     state: Control Widget structure
;	        cm_eph: Ephmerius data structure
;	        cm_val: Telemetry data structure
;		 	  dat5: Name of variable to plot (e.g. 'EX')
;eph_inter_win.pro: Interpolates ephmerius over time interval
;
;OUTPUT:
;		Plots time series for E, B and S
;
;
;MODIFICATION HISTORY: 11 March 2001 by Paul Manusiu
;					   Included call to eph_inter_win.pro
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
;
;Beginning of main prgram
;
PRO val_plot_923,state,cm_eph,cm_val,Dat5
common orbinfo,orb,orb_binfile,orb_date
common namm,nn,ttt
common dens,val_inter_dens
common reflcoef, neg_sz, pos_sz
nn=lonarr(4)
ttt=cm_val.(0)
nname = tag_names(cm_val)
 PI=3.14159265359
set_plot,'win'
!P.Multi=0
;stop
;
;**********************************************************************************
;Plots all E fields
;
if dat5 EQ 'ALL E FIELDS' then $
begin
 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)

 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[1]))+' '+string(strupcase(nname[2]))+' '+$
 string(strupcase(nname[3]))
!P.multi=[0,1,3]
!P.charsize=2.0
window,8,xsize=500,ysize=500
 plot,cm_val.(0),cm_val.(1),ytitle=string(nname(1))+'mV/m',xtickformat='Xtlaba',xticks=3,$
 title=string(nname(1)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
ystyle=1, ymargin=[0,4],/device
 plot,cm_val.(0),cm_val.(2),ytitle=string(nname(2))+'mV/m',xtickformat='XTLaba',xticks=3,$
 title=string(nname(2)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0],ystyle=1,/device
 plot,cm_val.(0),cm_val.(3),ytitle=string(nname(3))+'mV/m',xtickformat='XTLaba',xticks=3,$
 title=string(nname(3)),xstyle=9,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ystyle=1,ymargin=[10.5,-4],/device
 !P.charsize=1.0
 ;stop
 ;print,min(cm_val.(3))
 ;print,'hello'
; !p.multi=0
;stop
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(1)[0:100])+$
string(cm_val.(2)[0:100])+string(cm_val.(3)[0:100])

endif
;
;***********************************************************************************
;Plots E field
;
for ii=1,3 do $
  if dat5 EQ nname(ii) then $
	begin
widget_control,state.text,$
set_value='Plotting.... '+string(dat5)

	window,8,xsize=500,ysize=500
        plot,cm_val.(0),cm_val.(ii),ytitle='Amplitude',xtickformat='XTLaba',xticks=3,$
        title=string(nname(ii))+'mV/m',xstyle=1,nsum=2,$
        xrange=[cm_val.(0)[0],max(cm_val.(0))], ymargin=10.5
         widget_control,state.text,set_value=string(cm_val.(0)[0:500])+$
         string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase(nname[ii]))
;stop
endif
;
;************************************************************************************
;Plots all dB fields
;
if dat5 EQ 'ALL DB FIELDS' then $
 begin
widget_control,state.text,$
set_value='Plotting.... '+string(dat5)
;stop
WIDGET_CONTROL, state.dat_info,$
SET_VALUE = string(strupcase(nname[4]))+' '+string(strupcase(nname[5]))+' '$
+string(strupcase(nname[6]))
!P.multi=[0,1,3]
window,9,xsize=500,ysize=500
!p.charsize=2.0
 plot,cm_val.(0),cm_val.(4),ytitle=string(nname(4))+'nT',xtickformat='XTLaba',$
 xticks=3,$
 title=string(nname(4)),xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  ymargin=[2,2];,/device
 plot,cm_val.(0),cm_val.(5),ytitle=string(nname(5))+'nT',xtickformat='XTLaba',$
 xticks=3,$
 title=string(nname(5)),xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  ymargin=[4,0];,/device
 plot,cm_val.(0),cm_val.(6),ytitle=string(nname(6))+'nT',xtickformat='XTLaba',$
 xticks=3,$
 title=string(nname(6)),xstyle=9,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
  ymargin=[10.5,-3];,/device
!p.charsize=1.0
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(4)[0:100])+$
string(cm_val.(5)[0:100])+string(cm_val.(6)[0:100])

endif
;
;*******************************************************************************
;Plots all B main fields
;
if dat5 EQ 'ALL B FIELDS' then $
 begin
 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)

WIDGET_CONTROL, state.dat_info,$
SET_VALUE = string(strupcase(nname[7]))+' '+string(strupcase(nname[8]))+' '$
+string(strupcase(nname[9]))
!P.multi=[0,1,3]
window,9,xsize=500,ysize=500
!P.charsize=2.0
 plot,cm_val.(0),cm_val.(7),ytitle=string(nname(7))+'(nT)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(7))+'nT',xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[2,2],yrange=[min(cm_val.(7))-1.0,max(cm_val.(7))+1.0];,/device
 plot,cm_val.(0),cm_val.(8),ytitle=string(nname(8))+'(nT)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(8))+'nT',xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0],yrange=[min(cm_val.(8))-1.0,max(cm_val.(8))+1.0];,/device
 plot,cm_val.(0),cm_val.(9),ytitle=string(nname(9))+'(nT)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(9))+'nT',xstyle=9,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[10.5,-3],yrange=[min(cm_val.(9))-1.0,max(cm_val.(9))+1.0];,/device
 !P.charsize=1.0
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(7)[0:100])+string(cm_val.(8)[0:100])$
+string(cm_val.(9)[0:100])

endif
;*****************************************************************************
;Plots alpha angle
;
  if dat5 EQ 'Alpha Angle' then $
	begin
	widget_control,state.text,$
	set_value='Plotting.... '+string(dat5)

        plot,cm_val.(0),$
        cm_val.(10)/PI*180.0,ytitle='Degrees (!Uo!n)',$
        xtickformat='XTLaba',xticks=3,$
        title=string('Alpha Angle'),xstyle=1,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        yrange=[min(cm_val.(10)/PI*180.0)-10.0,max(cm_val.(10)/PI*180.0)+10.0],$
        ymargin=10.5
        widget_control,state.text,set_value=string(cm_val.(0)[0:500])+$
        string(cm_val.(10)[0:500])
         WIDGET_CONTROL, state.dat_info, SET_VALUE = string(strupcase('Alpha Angle') )
endif
;
;******************************************************************************
;Plots individual B main or dB field
;
for ii=4,9 do $
  if dat5 EQ nname(ii) then $
	begin
	widget_control,state.text,$
	set_value='Plotting.... '+string(dat5)

	window,9,xsize=500,ysize=500
        plot,cm_val.(0),cm_val.(ii),ytitle=string(dat5)+'(nT)',$
        xtickformat='XTLaba',xticks=3,$
        title=string(dat5),xstyle=1,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        ymargin=10.5,yrange=[min(cm_val.(ii))-2.,max(cm_val.(ii))+2.]
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
        ; stop
endif
;******************************************************************************
;Plots individual Poynting vectors
;
for ii=11,13 do $
  if dat5 EQ nname(ii) then $
	begin
		window,9,xsize=500,ysize=500
        plot,cm_val.(0),cm_val.(ii),ytitle=string(dat5)+'(uW/m!U2!n)',$
        xtickformat='XTLaba',xticks=3,$
        title=string(dat5),xstyle=1,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        ymargin=10.5
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
        ; stop
endif
;
;******************************************************************************
;Plots all Poynting vectors
;
if dat5 EQ 'ALL FIELDS' then $
	begin

;******************************************************
indd=13

indexx=where(cm_val.(indd) LT double(0.0),countt)
indexx2=where(cm_val.(indd) GT double(0.0),countt2)
print,'-ve count is  ',countt
print,'+ve count is  ',countt2

neg_cm=fltarr(countt)
pos_cm=fltarr(countt2)
for i=long(0), countt - 1 do $
	begin
	 neg_cm[i]=cm_val.(indd)[indexx[i]]

end
for i=long(0), countt2 - 1 do $
	begin
	 pos_cm[i]=cm_val.(indd)[indexx2[i]]

end

neg_cm=total(neg_cm)
pos_cm=total(pos_cm)
tot_cm=abs(neg_cm)+abs(pos_cm)
pos_sz = abs(pos_cm/tot_cm)
neg_sz = abs(neg_cm/tot_cm)
print,tot_cm
print,neg_cm
print,pos_cm
print,'Reflection Coefficient positive/negative',abs(pos_cm/neg_cm)
print,'Reflection Coefficient Positive',abs(pos_cm/tot_cm)
print,'Reflection Coefficient Negative',abs(neg_cm/tot_cm)

;******************************************************

widget_control,state.text,$
set_value='+ Reflection Coeff Sz: '+string(pos_sz)
widget_control,state.text,$
set_value='- Reflection Coeff Sz:'+string(neg_sz),/append
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(11)[0:100])+$
string(cm_val.(12)[0:100])+string(cm_val.(13)[0:100]),/append
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[11]))+' '+string(strupcase(nname[12]))+' '$
 +string(strupcase(nname[13]))
!P.multi=[0,1,3]
!P.charsize=2.0


window,10,xsize=500,ysize=500
;congrid(cm_val.(0),n_elements(cm_val.(0))/100.0)
 plot,congrid(cm_val.(0),n_elements(cm_val.(0))/4.0),congrid(cm_val.(11),n_elements(cm_val.(0))/4.0),ytitle=string(nname(11))+'(uW/m!U2!n)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(11)),xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[2,2]
 plot,congrid(cm_val.(0),n_elements(cm_val.(0))/4.0),congrid(cm_val.(12),n_elements(cm_val.(0))/4.0),ytitle=string(nname(12))+'(uW/m!U2!n)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(12)),xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0]
 plot,congrid(cm_val.(0),n_elements(cm_val.(0))/4.0),congrid(cm_val.(13),n_elements(cm_val.(0))/4.0),ytitle=string(nname(13))+'(uW/m!U2!n)',$
 xtickformat='XTLaba',xticks=3,$
 title=string(nname(13)),xstyle=9,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[10.5,-3]
 !P.charsize=1.0
 ;!p.multi=0
endif
;
;********************************************************************************
;Plots Bz main, dBz and Sz
;
if dat5 EQ 'Z FIELDS' then $
	begin
widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(6)[0:100])+$
string(cm_val.(9)[0:100])+string(cm_val.(13)[0:100])
 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[6]))+' '+string(strupcase(nname[9]))+' '$
 +string(strupcase(nname[13]))
!P.multi=[0,1,4]
!p.charsize=2.0
!X.charsize=1.0
!Y.charsize=1.0

window,10,xsize=500,ysize=500
;for ii=11,13 do $

 plot,cm_val.(0),cm_val.(6),ytitle=string(nname(6))+'(nT)',$
 xtickformat='XTLaba',xticks=3,$
xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[0,1],title='Orbit'+orb+orb_date+Dat5
 plot,cm_val.(0),cm_val.(9),ytitle=string(nname(9))+'(nT)',$
 xtickformat='XTLaba',xticks=3,$
 xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0],yrange=[min(cm_val.(9)),max(cm_val.(9))]
 ;!p.multi=0
 plot,cm_val.(0),cm_val.(13),ytitle=string(nname(13))+'(uW/m!U2!n)',$
 xtickformat='XTLaba',xticks=3,$
 xstyle=5,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[6.5,-3.5]
 plot,congrid(cm_val.(0),n_elements(cm_val.(0))/500.0),$
 congrid(cm_val.(14),n_elements(cm_val.(14))/500.0),$
yrange=[0,180],$
xstyle=9,xtickformat='XTLaba',$
ytitle='PhetaSB (!Uo!n)',ymargin=[10.5,-6],$
xticks=3,nsum=1

 !P.charsize=1.0
endif

if dat5 EQ 'VG' then $
begin
!P.multi=0
	velg =dblarr(n_elements(cm_val.(0)))
	for i=0, n_elements(velg) -1 do $
	begin
	;if cm_val.(4)[i] EQ float(0.0) then $
	;velg[i]=0.0 else $
	velg[i] = - cm_val.(2)[i]/cm_val.(4)[i]
	end
	window,9,xsize=500,ysize=500
 plot,cm_val.(0),velg,ytitle=string(Dat5)+'(km/s)',$
 xtickformat='XTLaba',xticks=3,$
 xstyle=1,nsum=128,xrange=[cm_val.(0)[0],max(cm_val.(0))],ystyle=1$
 ,ymargin=10.5,title='Orbit'+orb+' '+orb_date+' '+Dat5,Psym=10,yrange=[-50,50]
 ;oplot,smooth(velg,7)
 ;stop
end
;
;**********************************************************************************
;Plots all BPC5 fields
;
if dat5 EQ 'ALL BPC5' then $
begin
 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)

 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[1]))+' '+string(strupcase(nname[2]))+' '+$
 string(strupcase(nname[3]))
!P.multi=[0,1,3]
!P.charsize=2.0
window,8,xsize=500,ysize=500
 plot,cm_val.(0),cm_val.(15),ytitle=string(nname(15))+' (nT)',xtickformat='Xtlaba',xticks=3,$
 title=string(nname(15)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
ystyle=1, ymargin=[0,4],/device
 plot,cm_val.(0),cm_val.(16),ytitle=string(nname(16))+' (nT)',xtickformat='XTLaba',xticks=3,$
 title=string(nname(16)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0],ystyle=1,/device
 plot,cm_val.(0),cm_val.(17),ytitle=string(nname(17))+' (nT)',xtickformat='XTLaba',xticks=3,$
 title=string(nname(17)),xstyle=9,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ystyle=1,ymargin=[10.5,-4],/device
 !P.charsize=1.0

widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(1)[0:100])+$
string(cm_val.(2)[0:100])+string(cm_val.(3)[0:100])

endif
;
for iii=15,17 do $
  if dat5 EQ nname(iii) then $
	begin
	 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)
		window,9,xsize=700,ysize=500
        plot,cm_val.(0),cm_val.(iii),ytitle=string(dat5)+' (nT)',$
        xtickformat='XTLaba',xticks=3,$
        title=string(dat5),xstyle=1,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        ymargin=10.5
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(iii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
xrr=lonarr(4041)
yrr=fltarr(4041)

for ii=0,4040 do $
begin
xrr[ii]=22894500
yrr[ii]=ii-2000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=22862000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=22991000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=23560000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=23733500
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=23940000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=24116500
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=24356000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=24510000
end
oplot,xrr,yrr,LINESTYLE=2
for ii=0,4040 do $
begin
xrr[ii]=24645000
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=24750000
end
oplot,xrr,yrr,LINESTYLE=2


for ii=0,4040 do $
begin
xrr[ii]=24838000
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=24360000
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=25014500
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=25110000
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=25305000
end
oplot,xrr,yrr,LINESTYLE=2

for ii=0,4040 do $
begin
xrr[ii]=25602500
end
oplot,xrr,yrr,LINESTYLE=2

xrr=lonarr(4041)
yrr=fltarr(4041)

for ii=0,4040 do $
begin
xrr[ii]=22784000
yrr[ii]=ii-2000
end
oplot,xrr,yrr,LINESTYLE=0
;for ii=0,4040 do $
;begin
;xrr[ii]=17678000
;end
;oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=22784000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=22940000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=23480000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=23647000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=23880000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=24060000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=24280000
end
oplot,xrr,yrr,LINESTYLE=0
for ii=0,4040 do $
begin
xrr[ii]=24450000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=24590000
end
oplot,xrr,yrr,LINESTYLE=0


for ii=0,4040 do $
begin
xrr[ii]=24700000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=24800000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=24280000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=24969000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=25060000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=25170000
end
oplot,xrr,yrr,LINESTYLE=0

for ii=0,4040 do $
begin
xrr[ii]=25560000
end
oplot,xrr,yrr,LINESTYLE=0
;end

xyouts,3000,18500,'1ab 1c         2a  2b    2c   3   4af 4b 4c4d4e  5c5b5c       6';,/device
!p.multi=0
!P.charsize=1.0

        ; stop
endif

;***********************************************************************************
;**********************************************************************************
;Plots all EPCLONG fields
;
if dat5 EQ 'ALL EPCLONG' then $
begin
 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)

 WIDGET_CONTROL, state.dat_info,$
 SET_VALUE = string(strupcase(nname[1]))+' '+string(strupcase(nname[2]))+' '+$
 string(strupcase(nname[3]))
!P.multi=[0,1,3]
!P.charsize=2.0
window,8,xsize=500,ysize=500
 plot,cm_val.(0),cm_val.(18),ytitle=string(nname(18))+' (mV/m)',xtickformat='Xtlaba',xticks=3,$
 title=string(nname(18)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
ystyle=1, ymargin=[0,4],/device
 plot,cm_val.(0),cm_val.(19),ytitle=string(nname(19))+' (mV/m)',xtickformat='XTLaba',xticks=3,$
 title=string(nname(19)),xstyle=5,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ymargin=[4,0],ystyle=1,/device
 plot,cm_val.(0),cm_val.(20),ytitle=string(nname(20))+' (mV/m)',xtickformat='XTLaba',xticks=3,$
 title=string(nname(20)),xstyle=9,nsum=2,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
 ystyle=1,ymargin=[10.5,-4],/device
 !P.charsize=1.0

widget_control,state.text,$
set_value=string(cm_val.(0)[0:100])+string(cm_val.(18)[0:100])+$
string(cm_val.(19)[0:100])+string(cm_val.(20)[0:100])

endif
;
for ii=18,20 do $
  if dat5 EQ nname(ii) then $
	begin
	 widget_control,state.text,$
set_value='Plotting.... '+string(dat5)
		window,9,xsize=500,ysize=500
        plot,cm_val.(0),cm_val.(ii),ytitle=string(dat5)+' (mV/m)',$
        xtickformat='XTLaba',xticks=3,$
        title=string(dat5),xstyle=1,nsum=1,xrange=[cm_val.(0)[0],max(cm_val.(0))],$
        ymargin=10.5
        widget_control,state.text,$
        set_value=string(cm_val.(0)[0:500])+string(cm_val.(ii)[0:500])
         WIDGET_CONTROL, state.dat_info,$
          SET_VALUE = string(strupcase(dat5) )
        ; stop
endif

;***********************************************************************************


;*******************************************************************************
;
;if dat5 EQ 'ALFVEN VELOCITY' then $
;begin
;alfven_velocity,cm_eph,cm_val,state,Dat5
;vel_cal
;end
print,nname
   print,Dat5
   print,ii
;
;********************************************************************************
;Call routine to overplot ephmerius data on x-axis
;
eph_inter_win,cm_eph,cm_val,state,Dat5
;
;*********************************************************************************
;Reset plot window to zero
;
!p.multi=0
;*********************************************************************************
;Despike,cm_eph,cm_val,state
;stop
;end of procedure
 ;He_cycl_freq ,state,cm_eph,cm_val,Dat5
end