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
;Function YFLab,Val
;Return,String(Val,Format="(F5.1)")
;end
;
;FUNCTION XTLab,axis,index,value
;Ti=value
;Hour=Long(Ti)/3600
;Minute=Long(Ti-3600*Hour)/60
;RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;

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
Pro dpcrosspower,cm_eph,cm_val,state,Dat5
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common poynt,data0,data1,data2,data3
common orbinfo,orb,orb_binfile,orb_date
;common CPow, MxCPow, MnCPow,CPthres,CPArr
common CPow, CPArr
COMMON factR,FACMAX,I0MAX
print,Dat5
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
XDat=DblArr(NPnts)
ttt=lonarr(Npnts)
data4=dblarr(Npnts)
data5=dblarr(npnts)
ttt=cm_val.(0)
MnT=cm_val.(0)[0]
MxT=cm_val.(0)[n_elements(cm_val.(0))-1]
;********************************************************************************
		data4=cm_val.(4)
		data5=cm_val.(5)
		DXMAX=MAX(cm_val.(4))
		DYMAX=MAX(cm_val.(5))
		FACMAX=abs(DYMAX*DXMAX)
		;stop
TArr=DblArr(NPnts)
TArr=ttt
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
piI = 3.1415926535898
u = 4*PiI
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
;NyqF=1000.0/(2.0*SInt)
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=5.0
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
DelF=1.0/(FFTN*SINT)

NFr=Fix(MxF/DelF)+1
;MxFr=(NFr-1)*DelF
;stop
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(2,FFTN)    ; Time Series Array
TrArr=DblArr(2,FFTN)    ; FFT Array
;REPEAT Begin
 Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=150
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
;stop
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
Ans=1
 Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=TArr(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
;DispArr=DblArr(NBlocs,NFr)
CPArr=DblArr(NBlocs,NFr)
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
;For i=0,FFTN-1 do TsArr(i)=XDat(i)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
 Smo=2
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
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
;stop
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
 For i=0,FFTN-1 do TsArr(0,i)=data4(i)
 For i=0,FFTN-1 do TsArr(1,i)=data5(i)
;
;end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN
 DTrend,TsArr(1,*),FFTN

 ;DTrend,TsArr(2,*),FFTN
 If (WndT EQ 1) Then $
 Begin
  For jj=0,1 do $
  Begin
   For i=0,FFTN-1 do TsArr(jj,i)=TsArr(jj,i)*Wnd(i)  ; Hanning
  end
 end
 TrArr(0,*)=FFT(TsArr(0,*),1)
 TrArr(1,*)=FFT(TsArr(1,*),1)

 CP=fltarr(n_elements(TrArr(1,*)))
 for yy=0, n_elements(TrArr(1,*)) -1 do $
 	begin
 		CP[yy]=TrArr(0,yy)*conj(TrArr(1,yy))
 endfor
 For i=0,NFr-1 do $
	Begin
  		V1=(abs(CP[i]));^2.
  		V2=Float(FFTN)
  		SpArr(i)=V1/(V2*V2) ;Units or nT^2/Hz
 end
;stop
;*********************************************************
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   CPArr(Bloc,i)=SpArr(i)*Wght(i)
  If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
  If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
  ;CPArr(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
;********************************************************
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
 For i=0,iLFr-1 do $
  Begin
   CPArr(Bloc,i)=SpArr(i)*Wght(i)
	  If (CPArr(Bloc,i) LT 1e-6) Then CPArr(Bloc,i)=1e-6
    ;  CPArr(Bloc,i)=20*ALOG10(CPArr(Bloc,i))
  end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   CPArr(Bloc,i)=SpArr(i)*Wght(i)
     If (CPArr(Bloc,i) LT 1e-6) Then CPArr(Bloc,i)=1e-6
    ; CPArr(Bloc,i)=20*ALOG10(CPArr(Bloc,i))
  end
  For i=iLFr,NFr-1-ism do $
  Begin
   CPArr(Bloc,i)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    CPArr(Bloc,i)=CPArr(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   CPArr(Bloc,i)=CPArr(Bloc,i)*Wght(i)
		If (CPArr(Bloc,i) LT 1e-6) Then CPArr(Bloc,i)=1e-6
   	;	CPArr(Bloc,i)=20*ALog10(CPArr(Bloc,i))

  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=long((long(Bloc+1))*TRes)
 ;For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
 For i=long(0),FFTN-1 do TsArr(0,i)=data4(Posn+i)
 For i=long(0),FFTN-1 do TsArr(1,i)=data5(Posn+i)
End    ; end Bloc Loop
;
print,TRes
MnnCPRng=Min(CPArr)
MxxCPRng=Max(CPArr)
fac=(FACMAX)/max(CPArr)
;print,fac
;fac=7.1
CPArr=fac*CPArr
MnCPRng=Min(CPArr)
MxCPRng=Max(CPArr)
;stop
;MxxRng=Max(DispArr)

CPthres=MnCPRng;+0.001*(MxCPRng-MnCPRng)
;if abs(MxCPRng) GE abs(MnCPRng) then $
;MnCPRng=-MxCPRng else $
;MxCPRng=abs(MnCPRng)
;*********************************************************************************
CPArr=10*Alog(CPArr)
;*********************************************************************************
MnCPRng=Min(CPArr)
MxCPRng=Max(CPArr)

;
;
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Cross Power is ',Min(CPArr)
 Print,'Maximum Cross Power is ',Max(CPArr)
print,Min(CPArr)
print,Max(CPArr)
;CP,Min(CPArr)
;print,Max(CPArr)
 print,CPthres
; stop
 Window,11,XSize=500,YSize=400
 Erase
 Device,Decomposed=0
   ;13
 LoadCT,13
   TVLCT,r,g,b,/get
 tvlct,r,g,b

 Ttle='Orbit'+orb+' '+orb_date+' BXY '+Dat5+' Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1
 !P.multi=0
; stop
 DYNTV_crres,CPArr,Title=Ttle,YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnCPRng,MxCPRng],Aspect=1.5,ymargin=10.5,dat5=dat5
eph_inter_win,cm_eph,cm_val,state,Dat5
PntRes=TRes
MnPow=MnCPRng
MxPow=MxCPRng
He_cycl_freq ,state,cm_eph,cm_val,Dat5
;stop
DPChoice3,Dat5
;stop

;*********************************************************************************
Print,'Finished'
;stop
end
