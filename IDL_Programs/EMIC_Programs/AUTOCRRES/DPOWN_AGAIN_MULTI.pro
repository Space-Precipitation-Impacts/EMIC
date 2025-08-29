; Main Program
;
pro DPOWN_AGAIN_MULTI
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
common factr_multi,fac_multi
DispArr=0
if dat555 EQ 'ALL E FIELDS' THEN $
datt5=["EX","EY","EZ"]
if dat555 EQ 'ALL DB FIELDS' THEN $
datt5=["DBX","DBY","DBZ"]
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
Set_Plot,'WIN'

!P.multi=[0,1,3]
Window,3,XSize=700,YSize=650
;Px1=[0.05,0.05,0.05]
;Px2=[0.95,0.95,0.95]
Py1=[0.3,0.3,0.4]
Py2=[1.0,1.0,2.0]
Px1=[0.05,0.05,0.05]
Px2=[1.,1.,1.]
;Py1=[0.0,0.0,0.0]
;Py2=[0.0,0.0,0.0]

Erase
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
Disparr_again=DblArr(NBlocs,NFr,3)
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
for q=0,2 do $
	begin
For i=0,FFTN-1 do TsArr(i)=XDat(i,q)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
ism=Smo
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.0))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=ism
 LFr=iLFr*DelF
end
;stop
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
;stop
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
 ;  Disparr_again(Bloc,i,q)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   Disparr_again(Bloc,i,q)=SpArr(i)*Wght(i)
   If (Disparr_again(Bloc,i,q) LT 1e-6) Then Disparr_again(Bloc,i,q)=1e-6
;   Disparr_again(Bloc,i,q)=20*ALOG10(Disparr_again(Bloc,i,q))
end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   Disparr_again(Bloc,i,q)=SpArr(i)*Wght(i)
   If (Disparr_again(Bloc,i,q) LT 1e-6) Then Disparr_again(Bloc,i,q)=1e-6
;   Disparr_again(Bloc,i,q)=20*ALOG10(Disparr_again(Bloc,i,q))
end
;end
  ;TmRes
  For i=iLFr,NFr-1-ism do $
  Begin
   Disparr_again(Bloc,i,q)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
  ; stop
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    Disparr_again(Bloc,i,q)=Disparr_again(Bloc,i,q)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
     Disparr_again(Bloc,i,q)=Disparr_again(Bloc,i,q)*Wght(i)
   If (Disparr_again(Bloc,i,q) LT 1e-6) Then Disparr_again(Bloc,i,q)=1e-6
;   Disparr_again(Bloc,i,q)=20*ALog10(Disparr_again(Bloc,i,q))
  end     ; end of I loop
;stop
 end      ; end of If Freq Domain Filt.
;stop
 Posn=(Bloc+1)*PnTRes
 ;TmRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j,q) ; New Data
;End    ; end Bloc Loop
end
endfor ;end q loop
;MxxRng=fltarr(q)
for q=0,2 do $
	begin

 ;MxxRng[q]=Max(DispArr_again[*,*,q])
 Disparr_again[*,*,q]=fac_multi[q]*Disparr_again[*,*,q]
Disparr_again[*,*,q] = 10.*Alog10(Disparr_again[*,*,q])
;Disparr_again[*,*,q] = 10*Alog10(Disparr_again[*,*,q]/Mxxrng[q])

 PAgn=0
 Print,'Minimum Power is ',Min(Disparr_again[*,*,q])
 Print,'Maximum Power is ',Max(Disparr_again[*,*,q])
 ;Erase
 ;Window,1,XSize=500,YSize=400
 Device,Decomposed=0
 LoadCT,13  ;13
 ;!P.multi=0
 DYNTV_crres1,Disparr_again[*,*,q],Title=Ttle[q],YTitle=YTtle,$
 XRange=[MnT,MxT],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow[q],MxPow[q]],Aspect=5.0,dat5=datt5[q],$
 Px1=Px1[q],Px2=Px2[q],Py1=Py1[q],Py2=Py2[q]
 Widget_control,state.dat_info, set_value=string('Re-plot done!')
 He_cycl_freq ,state,cm_eph,cm_val,Datt5[q]
 END
 eph_inter_win_multi,cm_eph,cm_val,state,Dat555
 ;where
 end
