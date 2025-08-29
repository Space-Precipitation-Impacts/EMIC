; Program to DeSpike Time Series Data
;
;  C Waters Sept 1995
;
Function Tim,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I0)")
end
;
; Main
pro Despike5,cm_eph,cm_val,state
common orbinfo,orb,orb_binfile,orb_date
Strt=1
Strt=Strt-1
numcmv=1
lim=0.25
leng = n_elements(cm_val.(numcmv))
NPnts=Leng
XDat=FltArr(NPnts)
XDat=cm_val.(numcmv)

Print,'Finished.'
stop
static_power2
stop
End