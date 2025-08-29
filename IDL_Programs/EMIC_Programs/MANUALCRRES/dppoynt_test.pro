;DATE: 10/06/00
;TITLE: dpown_test.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: Generates pre-post_dump test data.
;Inputs: Header from any pre-post_dump data file (e.g. orb115b.val).
;Outputs: Header, generated data including time tags and index to file ( eg sample5.dat).
;MODIFICATIONS:
;
Function Tim,mSec
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

Function XTLabbb,Axis,Index,Value
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

Pro dppoynt_test
;Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
;Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
;Common BLK2,SpW,SpTyp,Smo
;Common BLK4,MnPow,MxPow
;common orbinfo,orb,orb_binfile,orb_date
orbinfo=' '
orb=' '
orbbinfile=' '
orb_date=' '

PI=3.14159265359
u = 4*Pi
ct=1000
index=INDGEN(8)
indx=[7,6,5,4,3,2,1,0]
Ex = dblarr(ct)
Ey = dblarr(ct)

Ez = dblarr(ct)

Bx = dblarr(ct)
By = dblarr(ct)

Bz = dblarr(ct)

tims_32=lonarr(ct)
for i=0,ct-1 do $
          begin
             tims_32[i] = long(10000010) + long(64)*i
             Ex[i] = 3.0*sin(2.*Pi*5.*i/ct+0.1);+Pi/2.0)
             Ey[i] =3.0*sin(2.*Pi*5.*i/ct);+(Pi/2.0))
			 Ez[i] = 1.0*sin(2.*Pi*5.*i/ct)
             Bx[i] =3.0*sin(2.*Pi*5.*i/ct);
             By[i] = 3.0*sin(2.*Pi*5.*i/ct);+Pi/2.0)
             Bz[i] =1.0*sin(2.*Pi*5.*i/ct);
endfor
count=long(0)

S_z = 10.0*(1.0/u)*(Ex*By - Bx*Ey)
S_x = 10.0*(1.0/u)*(Ey*Bz - By*Ez)
S_y = 10.0*(1.0/u)*(Ez*Bx - Bz*Ex)
;stop
DXMAX=max(abs(S_z))
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(tims_32[1]-tims_32[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")

; Set up Analysis parameters
;
NPnts = ct
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=100
;PnTres=200
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=1.0
;Read,MxF
DelF=1.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr1=DblArr(FFTN)    ; Time Series Array
TsArr2=dBLARR(FFTN)
TsArr3=DblArr(FFTN)    ; Time Series Array
TsArr4=dBLARR(FFTN)
TsArr5=DblArr(FFTN)    ; Time Series Array
TsArr6=dBLARR(FFTN)

TrArr1=DblArr(FFTN)    ; FFT Array
TrArr2=DblArr(FFTN)
TrArr3=DblArr(FFTN)    ; FFT Array
TrArr4=DblArr(FFTN)
TrArr5=DblArr(FFTN)    ; FFT Array
TrArr6=DblArr(FFTN)

REPEAT Begin
 Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=16
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
Ans=1
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
T=LonArr(NBlocs)
T(0)=tims_32(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0.0
SpW=Wsp
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
SpTyp=2
WnDT=SpTyp
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0
For i=0,FFTN-1 do TsArr1(i)=Ex(i)
For i=0,FFTN-1 do TsArr2(i)=Ey(i)
For i=0,FFTN-1 do TsArr3(i)=Ez(i)
For i=0,FFTN-1 do TsArr4(i)=Bx(i)
For i=0,FFTN-1 do TsArr5(i)=By(i)
For i=0,FFTN-1 do TsArr6(i)=Bz(i)

If (WndT EQ 2) Then $
Begin
 Smo=2
ism=Smo
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=ism
 LFr=iLFr*DelF
end
;stop
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
;stop
; Major Loop Starts Here
;
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr1,FFTN     ; Call Linear Detrend
 DTrend,TsArr2,FFTN
 DTrend,TsArr3,FFTN     ; Call Linear Detrend
 DTrend,TsArr4,FFTN
 DTrend,TsArr5,FFTN     ; Call Linear Detrend
 DTrend,TsArr6,FFTN

 TrArr1=FFT(TsArr1,1)    ;Now implemented with backwards FFT
 TrArr2=FFT(TsArr2,1)
 TrArr3=FFT(TsArr3,1)    ;Now implemented with backwards FFT
 TrArr4=FFT(TsArr4,1)
 TrArr5=FFT(TsArr5,1)    ;Now implemented with backwards FFT
 TrArr6=FFT(TsArr6,1)


Poynt_z=(10./u)*[TrArr1*conj(TrArr5)-TrArr4*conj(TrArr2)]

 For i=0,NFr-1 do $
 Begin
  V1=Poynt_z(i)
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end
;
;***************************************************************
;
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=long(0),iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
      ;If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
  end
  For i=NFr-1-2*ism,NFr-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
  ;If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6

  end
  For i=iLFr,NFr-1-ism do $
  Begin
   DispArr(Bloc,i)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i)=DispArr(Bloc,i)+SpArr(j)*Wnd(iWn)
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
;			If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6

  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
;
;*********************************************************************
 Posn=(Bloc+1)*TRes
 For j=0,FFTN-1 do TsArr1(j)=Ex(Posn+j) ; New Data
For j=0,FFTN-1 do TsArr2(j)=Ey(Posn+j)
 For j=0,FFTN-1 do TsArr3(j)=Ez(Posn+j) ; New Data
For j=0,FFTN-1 do TsArr4(j)=Bx(Posn+j)
 For j=0,FFTN-1 do TsArr5(j)=By(Posn+j) ; New Data
For j=0,FFTN-1 do TsArr6(j)=Bz(Posn+j)

End    ; end Bloc Loop

;*********************************************************************
;index = where(abs(disparr) LT 0.01, count)
;for i=0, count-1 do $
;disparr[index] = 0.0
;
;*********************************************************************
;Multiplication factor due to IDL FFT routine.
;Amplitude Affect:Fourier Tranform results in halving of signal amplitude
;The "fac" is a multiplication factor to restore original power levels.
;Leakage Affect: Minimized through use of exponential window function.
;
;

fac=(DXMAX)/max(abs(Disparr))
;fac=1.0
Disparr =fac*Disparr

;
;
;*********************************************************************
index = where(abs(disparr) LT 0.2, count)
;for i=0, count-1 do $
disparr[index] = 0.0
;
;*********************************************************************
TsArr1=0   ;Now implemented with backwards FFT
TsArr2=0
TsArr3=0    ;Now implemented with backwards FFT
TsArr4=0
TsArr5=0    ;Now implemented with backwards FFT
TsArr6=0
TrArr1=0   ;Now implemented with backwards FFT
TrArr2=0
TrArr3=0    ;Now implemented with backwards FFT
TrArr4=0
TrArr5=0    ;Now implemented with backwards FFT
TrArr6=0

;S_z = 10.0*(1.0/u)*(Ex*By - Bx*Ey)

;*********************************************************************
;

Set_Plot,'WIN'
LoadCT,0
 PAgn=0
 !P.multi=[0,1,2]
 Print,'Minimum Poynting Flux is ',Min(DispArr)
 Print,'Maximum Poynting Flux is ',Max(DispArr)
 Window,0,XSize=700,YSize=600

 Erase
 Device,Decomposed=0
   ;13

;Disparr = Alog10(Disparr)
;MnRng=Min(DispArr)
;MxRng=Max(DispArr)
MnRng=Min(DispArr)

MxRng=Max(DispArr)
if abs(MxRng) GE abs(MnRng) then $
MnRng=-MxRng else $
MxRng=abs(MnRng)
;stop
 ;set_plot,'win'
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 ;Device,Decomposed=0
 ;LoadCT,13  ;13
 Ttle='Test Poynt Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
CbTtle='Flux (uW/m!U2!n/Hz)'
 YRngL=0
 Scl=1
;***********************************************************************************
;
Plot,tims_32,S_z,title='Time Series test Sinusiodal, 1000 points',xtickformat='XTLabbb',xstyle=1;,/device
;stop
 dat5='Sz'
 LoadCT,17
 TVLCT,r,g,b,/get
 r(127)=255
 g(127)=255
 b(127)=255
 r(128)=255
 g(128)=255
 b(128)=255
 r(126)=255
 g(126)=255
 b(126)=255

 for ii=0,127 do $
  begin
   r(255-ii)=128+ii
 end
 tvlct,r,g,b

 DYNTV_crres_test1,DispArr,CbTle=CbTtle,Title=Ttle,YTitle=YTtle,xtitle='Time (UT)',$
 XRange=[Min(tims_32[0]),Max(tims_32[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=3.0,ymargin=[4,0],xmargin=[10,5],dat5=dat5

PntRes=TRes
MnPow=MnRng
MxPow=MxRng
;
;***********************************************************************************
;Plots dynamic power to postscript device
;
;Dat5='xx'
;Fname='power_test_with_dtrend.ps'
;spectralps_test,tims_32,Dat5,DispArr,Fname
;************************************************

Print,'Finished'

;set_plot,'ps'
;!p.multi=[0,1,2]
;device,filename='window_function.ps',yoffset=3, ysize=23
;Plot,tims_32,Xdat,title='Time Series test Sinusiodal, 1000 points',xtickformat='XTLabbb',xstyle=1;,/device
;plot,wnd,xtitle='Frequency Domain Smoothing = 2',title='Exponential Window Function',/device
;device,/close
;set_plot,'win'
Print,'Max Disparr ',max(disparr)
Print,'Min Disparr ',min(disparr)
Print,'Max Sz ',max(S_z)
Print,'Min Sz ',min(S_z)
Loadct,0
stop
end
