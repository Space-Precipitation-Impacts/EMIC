Function XTLab,Axis,Index,Value
 mSec=long(Value)
 ;stop
 milsec=long(mSec) Mod 1000
;stop
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

Pro sample2
pi=3.14
ct=5000
index=8
TIM_E= lonarr(ct)
data1 = fltarr(ct)
data2 = fltarr(ct)
f= fltarr(ct)
T=0.0001
        f[0]=1.0/T

        for i=0,ct-1 do $
        begin
           data1[i] = sin(2.*!pi*i*T)
           data2[i] = sin(2.*!pi*i*T+!PI/2.)
    	   TIM_E[i]=10000000.+32.*i
    	   f[i]=i*T/(ct*0.032)
        end
        N=ct
    ;data1=data1*randomn(seed,ct)
        ;f[0]=1.0/T
        N21 = fix(N/2 + 1)
        ;F = INDGEN(N)
       ; F[N21] = N21 -N + FINDGEN(N21-2)
!P.Multi = 0
set_plot,'WIN'
Window,0, Xsize=300,Ysize=300,title='Wave fields'
plot,tim_e,data1,title='HI',xtickformat='XTLab',xticks=3,xstyle=1
Window,2, Xsize=300,Ysize=300,title='Wave fields'
plot,tim_e,data2,title='HI',xtickformat='XTLab',xticks=3,xstyle=1
data1fft=fft(data1,-1)
data2fft=fft(data2,1)
;data1fft=data1fft/(N*(10000000.+32.))
;power2,data1,data2,ct,ff12,f1,f2,1./T
;stop
Window,3, Xsize=300,Ysize=300,title='Wave fields'
;plot,f,abs(data1fft),xstyle=1
plot,f,abs(data1fft),xtitle='Frequency (Hz)';,$
;yrange=[0,max(data1ff1t)*20];im_e,data2,title='HI',xtickformat='XTLab',xticks=3,xstyle=1
;Window,4, Xsize=500,Ysize=500,title='Wave fields'
;plot,f,abs(data1fft),xstyle=1
;plot,shift(f*1000.,+n),abs(data2fft),xtitle='Frequency (mHz)';,$
;yrange=[0,max(data1fft)*20]
set_plot,'WIN'
!P.Multi=0
stop
DPflux4,TIM_E,data1,data2
;openw,u,'sample2.val',/get_lun
;for i=0,ct-1 do $
; begin
;   printf,u,FORMAT = '(I0,3X,F9.6,3X,F9.6)',TIM_E[i],data1[i],data2[i]
; endfor
;Free_lun,u
stop
end
