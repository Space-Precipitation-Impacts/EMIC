;Program to compute Poynting flux from CRRES data
;
; C.L. Waters :  August, 1993
; University of Newcastle
; New South Wales
; Australia
;
;MODIFICATIONS: By Paul Manusiu 2001
Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end
;
; Main Program
;
Pro DPFluxnewa,timv,data1,data2
winnum=1
sig=0.5  ; for interp. spline
piI = 3.1415926535898
u = 4*PiI
text=strarr(1)
NPnts=Long(0)
NPnts=n_elements(data1)
ttt=timv
MnT=long(ttt[0])
MinTime=MnT
TotTime=long(ttt[Npnts-1]-ttt[0])
SInt=[ttt[1]-ttt[0]]/1000.
Sint=Sint[0]
;stop
;NPnts=TotTime/SInt
;stop
TArr=DblArr(NPnts)
TArr=ttt
;stop
; Construct time base
;For ii=0,NPnts-1 do TArr(ii)=MinTime+float(ii)*SInt
;stop
; Get space for PFLux in time domain
; PFluxArr=DblArr(3,NPnts)
; Spline Time Domain Data onto Time Base
;TmpEx=spline(Ex,ExDat(1,*),TArr,sig)
;Tmpby=spline(byDat(0,*),byDat(1,*),TArr,sig)
; Find S
;PFluxArr(0)=TmpEy*Tmpbz-TmpEz*Tmpby  ; X
;PFluxArr(1)=TmpEz*Tmpbx-TmpEx*Tmpbz  ; Y
;PFluxArr(2)=TmpEx*Tmpby-TmpEy*Tmpbx  ; Z
; Set up Analysis parameters
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
Print,'Enter the FFT Analysis Length : '
Read,FFTN
;FFTN=3000
NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
Print,'Enter the Maximum Frequency Required (mHz):'
Read,MxFr
;MxFr=100
DFr=1000.0/(FFTN*SINT)
NFreqs=Fix(MxFr/DFr)+1
MxFr=(NFreqs-1)*DFr
Print,'The Frequency Resolution is ',DFr,' mHz.'
TsArr=DblArr(2,FFTN)    ; Time Series Array
TrArr=DblArr(2,FFTN)    ; FFT Array
;REPEAT Begin
 ;Ans1=0
 Print,'Enter the Time Resolution (Points) :'
 Read,TmRes
 NBlocs=Fix((NPnts-FFTN)/TmRes)
 Print,'The Time Resolution is ',TmRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;stop
 ;Print,'Is this O.K ? [0=No]'
 ;Read,Ans
 ;Ans1=(Ans NE 0)
 ;endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=TArr(0)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
DispArr=DblArr(NBlocs,NFreqs)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0
Wght=DblArr(NFreqs)
For i=0,NFreqs-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
WndT=2
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
ism=2
 Wnd=DblArr(5*ism)
 For i=0,4*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-2*ism)/Float(ism))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,4*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=2*ism
 LFr=iLFr*DFr
end
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
SpArr=DblArr(NFreqs+2*ism)   ; Double Prec. Spectral Array
;For jj=0,1 do $
;Begin
 For i=0,FFTN-1 do TsArr(0,i)=data1(i)
 For i=0,FFTN-1 do TsArr(1,i)=data2(i)
;end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN
 ;DTrend,TsArr(2,*),FFTN
 If (WndT EQ 1) Then $
 Begin
  For jj=0,1 do $
  Begin
   For i=0,FFTN-1 do TsArr(jj,i)=TsArr(jj,i)*Wnd(i)  ; Hanning
  end
 end
 TrArr(0,*)=FFT(TsArr(0,*),1)    ; FFT - BACKWARD so NO 1/N
 TrArr(1,*)=FFT(TsArr(1,*),1)
 ;TrArr(2,*)=FFT(TsArr(2,*),1)
 Poynt=fltarr(n_elements(TrArr(1,*)))
;stop
 for yy=0, n_elements(TrArr(1,*)) -1 do $
 Poynt[yy]=TrArr(0,yy)*TrArr(1,yy)  ;microwatts/square meter
 ;stop
 V2=Float(FFTN)
  For i=0,NFreqs-1 do $
  Begin
  V1=double(Poynt(i))
  SpArr(i)=V1/(V2*V2)
  end
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
   For i=0,NFreqs-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
   For i=0,iLFr-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
   For i=NFreqs-1-2*ism,NFreqs-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
   For i=iLFr,NFreqs-1-2*ism do $
   Begin
    DispArr(Bloc,i)=0.0
    Js=i-2*ism
    Je=i+2*ism
    iWn=-1
    For j=Js,Je do $
    Begin
     iWn=iWn+1
     DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
    end    ; end of J loop
    DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
   end     ; end of I loop
  end
       ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TmRes
 ;For jj=0,2 do $
 ;Begin
 For i=0,FFTN-1 do TsArr(0,i)=Data1(Posn+i)
 For i=0,FFTN-1 do TsArr(1,i)=Data2(Posn+i)
 ;end
End    ; end Bloc Loop
;
Set_Plot,'WIN'
Device,decomposed=0
REPEAT Begin
 PAgn=0
 MnRng=Min(DispArr)
 MxRng=Max(DispArr)
 Print,'Minimum S is ',Min(DispArr)
 Print,'Maximum S is ',Max(DispArr)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,5,XSize=500,YSize=400
 Erase
 LoadCT,13 ; 20
 Ttle=' Sz '
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 Ds=DblArr(NBlocs,NFreqs)
 ;Window,1,XSize=500,YSize=400
 DYNTV,Disparr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[ttt(0),ttt(n_elements(ttt)-1)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
 ;if Agn1 EQ 0 then $
 ;begin

 ;endif
 end UNTIL PAg
 Print,'Finished'
end
