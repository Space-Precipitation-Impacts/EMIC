;FUNCTION XTLabps,value
; Ti=value
; Hour=Long(Ti)/3600
; Minute=Long(Ti-3600*Hour)/60
; Secn=Ti-3600*Hour-60*Minute
; RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;
;Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
; mSec=long(Value)
; milsec=long(mSec) Mod 1000
; seci=Long(mSec/1000)
; secf = long(seci) mod 60
; mni=Long(seci)/60
; mnf = long(mni) mod 60
; hr = Long(mni/60)
; Return,String(hr,mnf,$
;  Format="(I2.2,':',I2.2)")
;end


; Main Program
;
pro DPOWN_AGAIN
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK4,MnPow,MxPow
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
common Data,XDat
common dat55, dat555
common Power, DispArr
common Power_again, DispArr_again
COMMON factR,FACMAX,I0MAX
DispArr=0
;stop
;
Widget_control,state.dat_info, set_value=string('Calculating Spectra with new parameters.....')
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
;SInt=(ttt[1]-ttt[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")

;TmRes
;
; Set up Analysis parameters
;
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
;FFTN=800
;PnTres=800
;NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
;MxF=5000
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
;stop
;MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
;REPEAT Begin
; Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
;TRes=150
; NBlocs=Fix((NPnts-FFTN)/TRes)
 TmRes=PntRes*SInt
 Print,'The Time Resolution is ',TMRes,' Secs'
; stop
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
;Ans=1
; Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
;stop
T=LonArr(NBlocs)

T(0)=MnT
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(PnTRes)
; stop
Disparr_again=DblArr(NBlocs,NFr)
;stop
;Wsp=0.0

;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=SpW
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
WnDT=SpTyp
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0

For i=0,FFTN-1 do TsArr(i)=XDat(i)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
ism=Smo
;Changed Wnd array from 5*ism to 2*ism+1
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
 ;Changed Wnd function from Float(i-2*ism)/Float(ism) to Float(i-ism)/Float(ism/2.0)
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.0))^2)
  Sum1=Sum1+Wnd(i)
 End
 ;Changed i from 4*ism to 2*ism
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 ;Changed iLFr=2*ism to iLFr=ism
 iLFr=ism
 LFr=iLFr*DelF
end
;stop
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
;Changed Sparr frpm NFr+2*ism to NFr+ism
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 If (WndT EQ 1) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N

 For i=0,NFr-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end

 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)
   If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
   If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
  ; Disparr_again(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 ;***********************************************************
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   Disparr_again(Bloc,i)=SpArr(i);*Wght(i)
   If (Disparr_again(Bloc,i) LT 1e-6) Then Disparr_again(Bloc,i)=1e-6
   ;Disparr_again(Bloc,i)=20*ALOG10(Disparr_again(Bloc,i))
end
;Changed i from 2*ism to ism
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   Disparr_again(Bloc,i)=SpArr(i)*Wght(i)

   If (Disparr_again(Bloc,i) LT 1e-6) Then Disparr_again(Bloc,i)=1e-6
   ;Disparr_again(Bloc,i)=20*ALOG10(Disparr_again(Bloc,i))
end
  ;Changed i from 2*ism to ism
  For i=iLFr,NFr-1-ism do $
  Begin
   Disparr_again(Bloc,i)=0.0
;Changed Js and Je from 2*ism to ism
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    Disparr_again(Bloc,i)=Disparr_again(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
     Disparr_again(Bloc,i)=Disparr_again(Bloc,i)*Wght(i)
   If (Disparr_again(Bloc,i) LT 1e-6) Then Disparr_again(Bloc,i)=1e-6
   ;Disparr_again(Bloc,i)=20*ALog10(Disparr_again(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=long((long(Bloc+1))*PnTRes)
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
;End    ; end Bloc Loop
end
;***********************************************************************
;calculate multiplication factor
;
fac=(FACMAX^2.0)/max(Disparr_AGAIN)
;print,fac
;fac=160.1
Disparr_Again=fac*Disparr_Again
MxxRng=Max(DispArr_Again)
;STOP
;
;**********************************************************************
;calculate dB for Power
;
Disparr_Again = 10.*Alog10(Disparr_Again)
;**********************************************************************
;**********************************************************************
;STOP
;Restrict Power dB to 0 -> -5
;
;for i=long(0),n_elements(Disparr_Again)-1 do $
;If Disparr_Again[i] LE -5.0 then $
;Disparr_Again[i]=-5.0
;
;MnRng=Min(DispArr_Again)
;MxRng=Max(DispArr_Again)
;
;*********************************************************************
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Power is ',Min(Disparr_again)
 Print,'Maximum Power is ',Max(Disparr_again)
 Erase
 Window,1,XSize=500,YSize=400
 Device,Decomposed=0
 LoadCT,13  ;13
 !P.multi=0
 DYNTV_crres,Disparr_again,Title=Ttle,YTitle=YTtle,$
 XRange=[MnT,MxT],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow,MxPow],Aspect=1.5,ymargin=10.5,dat5=dat555
 Widget_control,state.dat_info, set_value=string('Re-plot done!')
 eph_inter_win,cm_eph,cm_val,state,Dat555
 He_cycl_freq ,state,cm_eph,cm_val,Dat555
 H_cycl_freq ,state,cm_eph,cm_val,Dat555
 ;where
 end
