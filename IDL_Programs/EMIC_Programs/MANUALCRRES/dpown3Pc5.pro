;  Program to Compute Single Data Channel Dyn Power
;
; C.L. Waters :  August, 1993
; Canadian Network for Space Research
; The University of Alberta
; Edmonton, Alberta
; Canada
;
; If you make changes to this code, please document them
;
; Modification list :
; * Added Smoothing in the Freq. Domain { Sept, 1994, CW}
; * Altered to take STD2IDL data format { Oct, 1995, CW }
; * Added mouse coordinate locating { Oct, 1995, CW }
; * Added B/W Printout support through Network LPT2 {Nov, 1996, CW}
; * Added PICKFILE {Nov, 1996, CW}
; * Put PSPrintBW into a separate file called PSPRINBW.PRO (Dec, 1996, CW)
; * Blanked out high frequency end where no smoothing is done (July, 97, CW)
; * Corrected Colin's Smoothing routine 06/13/01 and included dB power scale
;
;FUNCTION XTLabps,value
; Ti=value
; Hour=Long(Ti)/3600
; Minute=Long(Ti-3600*Hour)/60
; Secn=Ti-3600*Hour-60*Minute
; RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;
Function YFLab,Val
Return,String(Val,Format="(F5.1)")
end
;
;FUNCTION XTLab,axis,index,value
;Ti=value
;Hour=Long(Ti)/3600
;Minute=Long(Ti-3600*Hour)/60
;RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;

;Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
; mSec=long(Value)
 ;milsec=long(mSec) Mod 1000
; seci=Long(mSec/1000)
; secf = long(seci) mod 60
; mni=Long(seci)/60
; mnf = long(mni) mod 60
; hr = Long(mni/60)
; Return,String(hr,mnf,$
;  Format="(I2.2,':',I2.2)")
;end

;Function Tim,Sec
; Hr=Long(Sec)/3600
; Mn=Long(Sec-3600*Hr)/60
; Sc=Sec Mod 60
;Return,String(hr,mn,sc,$
;   Format="(I2.2,':',I2.2,':',i2.2)")
;end
;
;
; Main Program
;
Pro DPOWN3Pc5,cm_eph,cm_val,state,Dat5
;stop
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
;Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common orbinfo,orb,orb_binfile,orb_date
common dat55, dat555
common Power, DispArr
common ptext,plottext
COMMON factR,FACMAX,I0MAX
plottext=' '
;stop
dat555=dat5
print,Dat5
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
XDat=DblArr(NPnts)
ttt=lonarr(Npnts)
ttt=cm_val.(0)
MnT=cm_val.(0)[0]
MxT=cm_val.(0)[n_elements(cm_val.(0))-1]

;stop
;********************************************************************************
;Determine which component to plot
;
for i=0, n_elements(valnames) -1 do $
  if Dat5 EQ valnames[i] then $
	;BEGIN
	XDat=cm_val.(i)
	;PRINT,I
;END
;********************************************************************************
IF Dat5 EQ 'DBX' or Dat5 EQ 'DBY' or Dat5 EQ 'DBZ' THEN $
BEGIN
	DXMAX=MAX(ABS(cm_val.(4)));
	DYMAX=MAX(ABS(cm_val.(5)))
	DZMAX=MAX(ABS(cm_val.(6)))
END
IF Dat5 EQ 'EX' or Dat5 EQ 'EY' or Dat5 EQ 'EZ' THEN $
BEGIN
	DXMAX=MAX(ABS(cm_val.(1)))
	DYMAX=MAX(ABS(cm_val.(2)))
	DZMAX=MAX(ABS(cm_val.(3)))
END

IF Dat5 EQ 'BXPC5' or Dat5 EQ 'BYPC5' or Dat5 EQ 'BZPC5' THEN $
BEGIN
	DXMAX=MAX(ABS(cm_val.(15)))
	DYMAX=MAX(ABS(cm_val.(16)))
	DZMAX=MAX(ABS(cm_val.(17)))
END
;	IF DXMAX^2.0 GE DYMAX^2.0 AND DXMAX^2.0 GE	DZMAX^2.0 THEN $
;		I0MAX = DXMAX ELSE $
;	IF DYMAX^2.0 GE DXMAX^2.0 AND DYMAX^2.0 GE	DZMAX^2.0 THEN $
;		I0MAX = DYMAX ELSE $
;	IF DZMAX^2.0 GE DYMAX^2.0 AND DZMAX^2.0 GE	DXMAX^2.0 THEN $
;		I0MAX = DZMAX

IF DAT5 EQ 'DBX' THEN $
	FACMAX = DXMAX
IF DAT5 EQ 'DBY' THEN $
	FACMAX = DYMAX
IF DAT5 EQ 'DBZ' THEN $
	FACMAX = DZMAX
IF DAT5 EQ 'EX' THEN $
	FACMAX = DXMAX
IF DAT5 EQ 'EY' THEN $;
	FACMAX = DYMAX
IF DAT5 EQ 'EZ' THEN $
	FACMAX = DZMAX

IF DAT5 EQ 'BXPC5' THEN $
	FACMAX = DXMAX
IF DAT5 EQ 'BYPC5' THEN $
	FACMAX = DYMAX
IF DAT5 EQ 'BZPC5' THEN $
	FACMAX = DZMAX

;******************************************************************************
tp=where(XDat,count)
;print,max(Xdat)
;stop
print,count
if count EQ 0 then $
  Result = DIALOG_MESSAGE(string(Dat5)+' Component has no data !') else $
  begin
;********************************************************************************
Widget_control,state.dat_info,$
 set_value=string('Calculcating power spectra with default values......')
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(ttt[1]-ttt[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;stop
;stop
;
; Set up Analysis parameters
;
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=800
;PnTres=200
NyqF=1000.0/(2.0*SInt);*1000.
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=1000.
;Read,MxF
DelF=1000.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
;REPEAT Begin
; Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=80
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
;Ans=1
; Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=ttt(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0
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
For i=long(0),FFTN-1 do TsArr(i)=XDat(i)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
 Smo=2
ism=Smo
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.))^2)
  ;WND(I)=1.0
  Sum1=Sum1+Wnd(i)
 End
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=ism
 LFr=iLFr*DelF
end
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 If (WndT EQ 1) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFr-1 do $
 Begin
 ;stop
  V1=(abs(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end
 ;stop
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)

 	;stop
      If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
      If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
       ;  DispArr(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 ;***************************************************************
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=long(0),iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
     ; DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
  end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
  If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
    ; DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
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
    DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
		If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
   	;	DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=long((long(Bloc)+long(1))*long(TRes))
 For j=long(0),FFTN-1 do TsArr(long(j))=XDat(long(Posn)+long(j)) ; New Data
End    ; end Bloc Loop
;
;MnRng=Min(DispArr)
;MxRng=Max(DispArr)
;***********************************************************************
;calculate multiplication factor
;
fac=(FACMAX^2.0)/max(Disparr)
;print,fac
;fac=7.1
Disparr=fac*Disparr
MxxRng=Max(DispArr)
;print,MxxRng
;stop
;
;**********************************************************************
;calculate dB for Power
;
Disparr = 10.*Alog10(Disparr)
;**********************************************************************
;Restrict Power dB to 0 -> -5
;
;for i=long(0),n_elements(Disparr)-1 do $
;If Disparr[i] LE -5.0 then $
;Disparr[i]=-5.0
;
MnRng=Min(DispArr)
MxRng=Max(DispArr)
;
;*********************************************************************
 ;set_plot,'win'
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Power is ',Min(DispArr)
 Print,'Maximum Power is ',Max(DispArr)
 Window,0,XSize=500,YSize=400
 Erase
 Device,Decomposed=0
 LoadCT,13  ;13
 Ttle='Orbit'+orb+' '+orb_date+' '+Dat5+' Power Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1
 !P.multi=0
 ;window,2,xsize=400,ysize=400
 DYNTV_crres,DispArr,Title=Ttle,YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5,ymargin=10.5,dat5=dat5
 Widget_control,state.dat_info,$
 set_value=string('Use the spectral widget if you wish to re-plot')
endelse
;FFTN=1200
PntRes=TRes
MnPow=MnRng
MxPow=MxRng
eph_inter_win,cm_eph,cm_val,state,Dat5
He_cycl_freq ,state,cm_eph,cm_val,Dat5
H_cycl_freq ,state,cm_eph,cm_val,Dat5

;Widget_control,state.text,$
 ;set_value=string(max(Disparr))+' '+string(FACMAX)+' '+string(Mxxrng)
;stop
;PRINT,'I0MAX =',I0MAX^2.0
;PRINT,'DISPARRMAX =',MXXRNG
;PRINT,'DXMAX =',DXMAX^2.0
;PRINT,'DYMAX =',DYMAX^2.0
;PRINT,'DZMAX =',DZMAX^2.0

DPChoice3,Dat5

Print,'Finished'
;spectralps,cm_eph,cm_val,state,Dat5,DispArr
end
