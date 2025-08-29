;DATE: 05/08/02
;TITLE: static_power.pro
;AUTHOR: Paul Manusiu
;DESRIPTION:


Function Tim,mSec
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci/60)
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

Function XTLab,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end
;
Pro static_power5,xdat                            ;Start of main body
common orbinfo,orb,orb_binfile,orb_date
;Declared global variables:
;	orb->orbit No.
;	orb_binfile->ephmerius file name.
;	orb_date->orbit date.
;**************************************************************************
common cm_crres,state,cm_eph,cm_val
;Declared global varibles:
;	state->structure holding child widgets and submenus.
;	cm_eph->structure holding ephmerius variables
;	cm_val->sturcture holding telemetry data
;**************************************************************************
common eph_ff, ffeph
;Declared global variable:
;	ffeph->hold ephmerius data
;**************************************************************************
common val_ff, ffval
;Declared global variable:
;	ffval->holds telemetry data
;**************************************************************************
;
common val_header, header
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
ct=n_elements(cm_val.(0))
pI=3.1415926535898
freq = 16.0
set_plot,'win'
window,1,xsize=700,ysize=700
!P.Multi = [0,1,2]

;!P.charsize=2.0
;!Y.style=3
;!P.ticklen=0.04
;X = cm_val.(3)
X=XDat
;X=cm_val.(4)
Y=cm_val.(17)
;
csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;Window,0, Xsize=500,Ysize=500
;!P.charsize=1.0
Plot,cm_val.(0),smooth(XDat,1200),title='Hibert Transform',XTitle='Time (UT)',$
YTitle='Amplitude (nT)',XStyle=1,ystyle=1,XTickFormat='XTLab',yrange=[-2,2]
oplot,cm_val.(0),cm_val.(17),linestyle=3
plot,ff,ff2,linestyle=1,Xticks =3,xrange=[0.001,0.01],xstyle=1,/ylog;yrange=[0.,1.0];,/ylog;,/ylog
oplot,ff,ff1*1.0;title='Orbit '+Orb+' '+tim(cm_val.(0)[0])+' - '+tim(cm_val.(0)[n_elements(cm_val.(0))-1])+' UT',$
;xtitle='Frequency (Hz)',ytitle='Log Electric Power (mV/m!U2!n/Hz)',xrange=[0.01,10],$
;yrange=[min(ff1/ff[1]),max(ff1/ff[1])],$
;/xlog;,/ylog

;plot,ff,alog(smooth(ff1/ff[1],100,/edge_truncate)),title='Orbit '+Orb+' '+tim(cm_val.(0)[0])+' - '+tim(cm_val.(0)[n_elements(cm_val.(0))-1])+' UT',$
;xtitle='Frequency (Hz)',ytitle='Magnetic Power (Watts)',xrange=[0.01,10],$
;yrange=[min(ff1/ff[1]),max(ff1/ff[1])],$
;/xlog;,/ylog


;plot,ff,smooth(ff1/ff[1],100,/edge_truncate),title='Orbit '+Orb+' '+tim(cm_val.(0)[0])+' - '+tim(cm_val.(0)[n_elements(cm_val.(0))-1])+' UT',$
;xtitle='Frequency (Hz)',ytitle='Magnetic Power (Watts)',xrange=[0.01,10],$
;yrange=[min(ff1/ff[1]),max(ff1/ff[1])],$
;/xlog,/ylog

end