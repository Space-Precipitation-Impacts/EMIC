Pro FiltCtrl2,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=0.0
 wc=float(2.0*Tan(CutFreq*pi))
 print,wc
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
end
Pro Filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 pi=3.1415926535898
 Print,'In 2nd Order Filter...'
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
Pro lowpass_test                            ;Start of main body
ct=1000
pI=3.1415926535898
freq = 16.0
FiltType=2              ;Low pass option
Order=2                 ;2nd order Butterworth
Cut=float(6.0/freq)     ;Cutoff freq 6.0Hz
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
;stop
FiltCtrl2,Y,dum,wc,Order,FiltType,Cut,ct,theta;,forXy
csd_power,X,forxy,freq,0,ff1,ff2,ff12,FF,m,a        ;Cross-Phase rsponse on reverse filter
csd_power,X,forXy,freq,0,fff1,fff2,fff12,FFf,mm,aa
;stop
av_phase = total(abs(a))/ct
ff_num_5Hz = n_elements(FF[0:5])
a_num_5Hz=a[0:ff_num_5Hz-1]
av_phase_5Hz = total(abs(a_num_5Hz))/ff_num_5Hz
;norm_m = m/mm
norm_m = ff2/ff1
decibel = 20.0*alog10(norm_m)
!P.Multi = [0,1,3]
set_plot,'WIN'
Window,0, Xsize=500,Ysize=500
plot,ff,ff2/ff1,title='Frequency response', $
xtitle='Frequency (Hz)',ytitle='Amplitude (V)',Xticks =8, $
XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
plot,ff,decibel,yrange=[-100,10],xtitle='Frequency (Hz)',Xticks =8,title='Frequency Response In Decibels', $
ytitle='Decibels (dB)',XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
plot,ff,a,yrange=[0,180],ytitle='Phase (Degrees)',Xticks =8, $
xtitle='Frequency (Hz)',XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
!P.charsize=1.0
stop
;set_plot,'ps'
;!P.charsize=1.5
;!P.Multi = [0,1,3]
;device, filename="c:\Paul\phd\crres\filter_test\lowpass_test1.ps", yoffset=3;, ysize=25
;plot,tims,X,title='(a) Random Input Signal',xtitle ='Time (UT)', $
;ytitle='Amplitude (V)',xstyle=1,Xticks =3,XTickFormat='XTLab'
;plot,ff,ff1,title='(b) Power Spectra of Random Signal', $
;xtitle='Frequency (Hz)',ytitle='Power (Watts)',Xticks =8, $
;XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
;plot,ff,ff2,title='(c) Power Spectra after Butterworth with 6Hz cuttoff filtering ', $
;xtitle='Frequency (Hz)',ytitle='Power (Watts)',Xticks =8, $
;;XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
;device,/close
;set_plot,'PS'
;!P.Multi = [0,1,3]
;device, filename="c:\Paul\phd\crres\filter_test\lowpass_test2.ps", yoffset=3;, ysize=25
plot,ff,decibel,yrange=[-100,10],xtitle='Frequency (Hz)',Xticks =8,title='(a) Frequency Response of Butterworth with 6Hz Cuttoff', $
ytitle='Decibels (dB)';,XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
plot,fff,aa,yrange=[0,180],ytitle='Phase (Degrees)',Xticks =8,$
title='(b) Phase Response of Butterworth with 6Hz Cuttoff', $
xtitle='Frequency (Hz)';,XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
plot,ff,a,yrange=[-10,10],ytitle='Phase (Degrees)',Xticks =8,$
title='(c) Phase Response after Reverse Butterworth with 6Hz Cuttoff', $
xtitle='Frequency (Hz)';,XTICKLEN=1.0,yTICKLEN=1.0,/ystyle
;device,/close
set_plot,'win'
end