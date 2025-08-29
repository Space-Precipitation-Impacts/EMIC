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
FUNCTION XTLabps,value
 Ti=value
 Hour=Long(Ti)/3600
 Minute=Long(Ti-3600*Hour)/60
 Secn=Ti-3600*Hour-60*Minute
 RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
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

Function Tim,Sec
 Hr=Long(Sec)/3600
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end
;
;
; Main Program
;
Pro DPOWN2
openr,/get_lun,us,'orb115c.val
tt=strarr(1)
Npnts=long(0)
for i=0, 14 do $
readf,us,tt
;head=tt
while(NOT eof(us)) do $
begin
readf,us,tt
Npnts=Npnts+1;
endwhile
stop
ttt=lonarr(Npnts)
Ez=dblarr(Npnts)
;dBz=dblarr(4959)
Ey=dblarr(Npnts)
i=long(0)
tt=strarr(1)
point_lun,us,0
for i=0, 14 do $
readf,us,tt
head=tt
for i=long(0), Npnts-1 do $
begin
readf,us,tt
;stop
 ttt[i]=long(strmid(tt(0),0,8))       ;Store time data in array ttt
Ez[i]=double(strmid(tt(0),29,8))
;dBz[i]=double(strmid(tt(0),65,10))
Ey[i]=double(strmid(tt(0),16,6))
endfor
free_lun,us
stop
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
stop
XDat=DblArr(NPnts)
XDat=Ey
;
; Set up Analysis parameters
;
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
Print,'Enter the FFT Analysis Length : '
Read,FFTN
NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
Print,'Enter the Maximum Frequency Required (mHz):'
Read,MxFr
DFr=1000.0/(FFTN*SINT)
NFreqs=Fix(MxFr/DFr)+1
MxFr=(NFreqs-1)*DFr
Print,'The Frequency Resolution is ',DFr,' mHz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
REPEAT Begin
 Ans1=0
 Print,'Enter the Time Resolution (Points) :'
 Read,TmRes
 NBlocs=Fix((NPnts-FFTN)/TmRes)
 Print,'The Time Resolution is ',TmRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 Print,'Is this O.K ? [0=No]'
 Read,Ans
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
T=LonArr(NBlocs)
T(0)=ttt(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
DispArr=DblArr(NBlocs,NFreqs)
Wsp=0.0
Print,'Enter the Spectral Weighting, n [f^n] : '
Read,WSp
Wght=DblArr(NFreqs)
For i=0,NFreqs-1 do Wght(i)=Float(i)^WSp
WndT=1
Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
Read,WndT
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0
For i=0,FFTN-1 do TsArr(i)=XDat(i)
If (WndT EQ 2) Then $
Begin
 Print,'Enter the amount of Smoothing [Usually 2] : '
 Read,ism
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
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 If (WndT EQ 1) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFreqs-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end;
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFreqs-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)
   If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
   If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
   DispArr(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
   If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
   DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
  end
  For i=NFreqs-1-2*ism,NFreqs-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
   If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
   DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
  end
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
   If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
   DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TmRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End    ; end Bloc Loop
;
Set_Plot,'WIN'
REPEAT Begin
 PAgn=0
 Print,'Minimum Power is ',Min(DispArr)
 Print,'Maximum Power is ',Max(DispArr)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,0,XSize=500,YSize=400
 Erase
 Device,Decomposed=0
 LoadCT,13  ;13
 Ttle=StaL+' Power Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 DYNTV,DispArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
old_x=!x
old_y=!y
DoCur=0
Print,'Activate MOUSE LOCATION Routine [1=YES] :'
Read,DoCur
If (DoCur EQ 1) Then $
Begin
 Ny=NFreqs
 Print,'Press LEFT Button to Get Values'
 Print,'Press RIGHT Button when Finished'
; Print,!P.Color
 PAx=DblArr(Ny)
 FInc=(MxFr-YRngL)/(Ny-1)
 For i=0,Ny-1 do PAx(i)=YRngL+i*FInc
 Dm1=Float(Max(T)-Min(T))
 Lb=' '
 REPEAT Begin
  WSET,0
  !x=old_x & !y=old_y
  Cursor,x,y,/Data,/down
  GOut=(!err EQ 4)
  If (GOut EQ 0) Then $
  Begin
   Dm=Float(x-Min(T))/Dm1
   ArrP=Fix(Dm*(NBlocs-1))
   If ArrP LT 0 Then ArrP=0
   If ArrP GT NBlocs-1 Then ArrP=NBlocs-1
   XYOuts,10,10,color=[0],Lb,/device    ; Black
   TLab=Tim(x)
   Lb=TLab+' '+StrTrim(String(y),2)+' mHz'
   color=!d.n_colors-1
   XYOuts,10,10,color=[235],Lb,/device
  End
 end UNTIL GOut
end
HrdC=2
Print,'Laser Print ? [1=YES] :'
Read,HrdC
If (HrdC EQ 1) Then $
Begin
 PSPrintBW,Min(T),Max(T),YRngL,MxFr,MnRng,MxRng,NBlocs,NFreqs,DispArr
 Spawn,'copy C:\TEMP\DPOW.PS LPT2'
end
PicYN=0
Print,'Write Picture to File ? [1=YES] :'
Read,PicYN
If (PicYN EQ 1) Then $
Begin
 FName=''
 Print,'Enter Output File Name : '
 Read,FName
 OpenW,u,FName,/Get_Lun
 PrintF,u,NBlocs,NFreqs
 PrintF,u,Ttle
 PrintF,u,XTtle
 PrintF,u,YTtle
 PrintF,u,Min(T),Max(T)
 PrintF,u,YRngL,MxFr/1000.0
 PrintF,u,Scl
 PrintF,u,MnRng,MxRng
 PrintF,u,DispArr
 Free_Lun,u
End
Print,'Finished'
end
