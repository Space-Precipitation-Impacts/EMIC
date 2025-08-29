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
Pro static_power                            ;Start of main body
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
;stop
;FiltType=2              ;Low pass option
;Order=2                 ;2nd order Butterworth
;Cut=float(6.0/freq)     ;Cutoff freq 6.0Hz
;dum=fltarr(ct)          ;For B wave and E wave data
;Theta=fltArr(6)         ;dummy variable
;sample=fltarr(ct)
;tims=lonarr(ct)
;frq=fltarr(ct)
;X=fltarr(ct)
;for i=0,ct-1 do $
;  begin
;tims[i] = long(10000000) + long(64)*i
;endfor
;X = cm_val.(7)
;Y=X
;stop
;FiltCtrl,Y,dum,wc,Order,FiltType,Cut,ct,theta,forXy
;csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;csd_power,X,forXy,freq,0,fff1,fff2,fff12,FFf,mm,aa
;stop
;av_phase = total(abs(a))/ct
;ff_num_5Hz = n_elements(FF[0:5])
;a_num_5Hz=a[0:ff_num_5Hz-1]
;av_phase_5Hz = total(abs(a_num_5Hz))/ff_num_5Hz
;norm_m = m/mm
;norm_m = ff2/ff1
;decibel = 20.0*alog10(norm_m)
;!P.Multi = 0
;set_plot,'WIN'
;Window,0, Xsize=500,Ysize=500
;title='Response of 2nd order low pass Butterworth filter (6Hz cutoff) to noise'
;!P.charsize=1.0
;plot,cm_val.(0),X,title='Random Input Signal',xtitle ='Time (UT)', $
;ytitle='Amplitude (V)',xstyle=1,Xticks =3,XTickFormat='XTLab'
;plot,ff,ff1,title='Orbit '+Orb+' '+Orb_date+' Pc5 Power',linestyle=1, $
;xtitle='Frequency (Hz)',ytitle='Power (Watts)',Xticks =3,xrange=[0.001,1.0],yrange=[0,1.0],/xlog;,/ylog


;X = cm_val.(8)
;Y=X
;stop
;FiltCtrl,Y,dum,wc,Order,FiltType,Cut,ct,theta,forXy
;csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;oplot,ff,ff1,linestyle=2

;X = cm_val.(9)
;Y=X
;stop
;FiltCtrl,Y,dum,wc,Order,FiltType,Cut,ct,theta,forXy
;csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;oplot,ff,ff1,linestyle=0

;xyouts,400,400,'. . . . Bx',/device
;xyouts,400,360,'- - - By',/device
;xyouts,400,320,'_____ By',/device
;!P.charsize=1.0
;stop
;set_plot,'ps'
;!P.charsize=1.5
;!P.Multi = 0
;device, filename="c:\Paul\phd\crres\filter_test\wwww.ps", yoffset=3;, ysize=25


;!P.Multi = 0
;set_plot,'ps'
;fNAME=''
;FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)
set_plot,'win'
;device,filename=FName,yoffset=3, ysize=18
;!P.charsize=1.0
;!Y.style=3
;!P.ticklen=0.04
X = cm_val.(3)
Y=cm_val.(4)
csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;Window,0, Xsize=500,Ysize=500
;!P.charsize=1.0
plot,ff,ff1,title='Orbit '+Orb+' '+tim(cm_val.(0)[0])+' - '+tim(cm_val.(0)[n_elements(cm_val.(0))-1])+' UT', $
xtitle='Frequency (Hz)',ytitle='Magnetic Power (Watts)',Xticks =3,xrange=[0,2.];,yrange=[0.001,.01],linestyle=1,/xlog,/ylog


;X = cm_val.(8)
;Y=X
;csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;oplot,ff,ff2,linestyle=2

;X = cm_val.(5)
;Y=X
;csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;oplot,ff,ff1,linestyle=0

xyouts,13000,11000,'........... Bx MGSE',/device
xyouts,13000,10200,'- - - By MGSE',/device
xyouts,13000,9600,'______ Bz MGSE',/device

!P.charsize=1.0
;device,/close
set_plot,'win'
end