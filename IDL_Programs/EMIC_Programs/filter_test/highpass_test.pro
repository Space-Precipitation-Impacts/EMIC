;DATE: 11/06/00
;TITLE: lowpass_test.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: This is used to test frequency and phase response of 2nd order Butterworth
;filter.
;Pre-conditions - Generated test frequencies existed.
;Post-conditions - Plot of frequency and phase response;
;
;MODIFICATIONS: ongoing!
;
Pro Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 pi=3.1415926535898
 ;Print,'In 1st Order Filter...'
 ;Wait,0.5
 a=float((wc-2)/(wc+2))
 c=float(wc/(wc+2))
 eta=1.0
 If (FiltType eq 1) then Begin
  zeta=float(-cos(2*pi*CutFreq))
  a=float(-(a-zeta)/(1-a*zeta))
  c=c*(1-zeta)/(1-a*zeta)
  eta=-1.0
 end
 YDat(0)=c*XDat(0)
 If (FiltType eq 1) Then YDat(0)=0.0
 i=Long(1)
 For i=Long(1),Long(LenX-1) do $
  YDat(i)=-a*YDat(i-1)+c*(XDat(i)+eta*XDat(i-1))
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
Pro Filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 pi=3.1415926535898
 ;Print,'In 2nd Order Filter...'
 ;Wait,0.5
 ar=float(wc*cos(tmp))  ; Pass Theta(m) as tmp
 ai=float(wc*sin(tmp))
 alp=float(-2*ar)
 bet=float(ar^2+ai^2)
 gamma=bet
; Bilinear Transform
 delt=1.0/(4.0+2.0*alp+bet)
 a=2.0*(bet-4.0)*Delt
 b=(4.0-2.0*alp+bet)*delt
 c=gamma*delt
 eta=2.0
 If (FiltType eq 1) Then Begin
  zeta=float(-cos(2.0*cutfreq*pi))
  V1=float(a-b*Zeta)
  V2=float(V1*Zeta)
  psi=float(1.0/(1.0-V2))
  c=psi*c*(1.0-zeta)^2
  bp=psi*((zeta-a)*zeta+b)
  a=psi*(2.0*zeta*(1.0+b)-a*(1.0+zeta^2))
  b=bp
  eta=-2.0
 end
 YDat(0)=c*XDat(0)
 YDat(1)=-a*YDat(0)+c*(XDat(1)+eta*XDat(0))
 For i=Long(2),Long(LenX-1) do Begin
  V1=float(-A*YDat(i-1)-B*YDat(i-2))
  V2=float(XDat(i)+Eta*XDat(i-1)+XDat(i-2))
  YDat(i)=float(V1+c*V2)
   ;print,Ydat,' ',i
 end
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
Pro FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=0.0
 ;Ydat = 0.0
 wc=float(2.0*Tan(CutFreq*pi))
 ;print,wc
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 ;Reverse,XDat,YDat,LenX
 For m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 ;Reverse,XDat,YDat,LenX
end

Pro Reverse,XDat,YDat,LenX
 Print,'Reversing Data...'
 Wait,0.5
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=XDat(LenX-i-1)
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end

Function Tim,mSec
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Function XTLab,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end
;
Pro highpass_test                            ;Start of main body
ct=1000
pI=3.1415926535898
freq = 16.0
FiltType=2              ;Low pass option
Order=2                 ;2nd order Butterworth
Cut=float(0.5/freq)     ;Cutoff freq 6.0Hz
dum=fltarr(ct)          ;For B wave and E wave data
Theta=fltArr(6)         ;dummy variable
sample=fltarr(ct)
tims=lonarr(ct)
frq=fltarr(ct)
X=fltarr(ct)
for i=0,ct-1 do $
  begin
tims[i] = long(10000000) + long(64)*i
endfor
X = randomu(seed,ct)
Y=X
FiltCtrl,Y,dum,wc,Order,FiltType,Cut,ct,theta
csd_power,X,Y,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
csd_power,X,X,freq,0,fff1,fff2,fff12,FFF,mm,aa  ;Auto-correlation
av_phase = total(abs(a))/ct
ff_num_5Hz = n_elements(FF[0:5])
a_num_5Hz=a[0:ff_num_5Hz-1]
av_phase_5Hz = total(abs(a_num_5Hz))/ff_num_5Hz
!P.Multi = [0,2,2]
Window,3, Xsize=800,Ysize=500, $
title='Response of 2nd order high pass Butterworth filter (0.5Hz cutoff) to noise'
plot,tims,X,title='Random Signal',ytitle='Amplitude (V)', $
XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,fff,mm*400.0,xtitle='Frequency (Hz)',title='Frequencies In Random Signal',ytitle='Amplitude (V)'
plot,ff,m/mm,title='Frequency response of Lowpass Butterworth filter', $
xtitle='Frequency (Hz)',ytitle='Amplitude (V)'
plot,ff,a,yrange=[-100,100],xrange=[min(ff),8.0],ytitle='Phase (Degrees)',title='Phasing after filter Reversal', $
xtitle='Frequency (Hz)'
end