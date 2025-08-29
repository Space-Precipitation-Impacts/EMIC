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
Pro static_power8,xdat,ydat                            ;Start of main body
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
common fft_results,freq,ff1,ff2,ff12,FF,m,a
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
Y=YDat
;
csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
;Window,0, Xsize=500,Ysize=500
;!P.charsize=1.0

end