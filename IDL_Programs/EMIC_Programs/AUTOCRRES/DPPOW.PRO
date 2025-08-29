;  Program Single Dyn Power Spectra Program
; that calculates the dynamic power spectra of
; the power spectrum. Used to detect Fine Structure in
; Low latitude data sets
;
; C. Waters Aug, 1993
;
FUNCTION XTLab,axis,index,value
Ti=value
Hour=Long(Ti)/3600
Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
FUNCTION YFLab,axis,index,value
 Fr=value
 If fr LE 1e-6 then lb=0.0
 If fr GT 1e-6 then lb=1.0/Fr
RETURN,String(lb,Format="(F4.1)")
end
;
;   Main Program
;
Print,'Single Channel FFT Power Program'
FName=StrArr(1)
StaL=''
IFmt=1  ; 1=CLW, 2=JCS
Ttle='Enter Input Data File Name'
FName=PickFile(Title=Ttle,Filter='*.*')
OpenR,u,FName,/Get_Lun
;
; My Format
;
If IFmt EQ 1 Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  StaL,Year,Month,Day,Hour,Min,Sec,SInt,Pnts
end
;
; John Samson Format
;
If IFmt EQ 2 Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
 StaL,Year,Day,Hour,Min,Sec,SInt,Pnts
 Month='10'
end
XDat=DblArr(Pnts)
Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
ReadF,u,XDat
Free_Lun,u
;
Print,'Enter FFT Length : '
Read,FFTN
NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
Print,'Enter the Maximum Frequency Required (mHz):'
Read,MxFr
DFr=1000.0/(FFTN*SINT)
NFreqs=Fix(MxFr/DFr)+1
MxFr=(NFreqs-1)*DFr
Print,'The Nyquist is ',NyqF,' mHz.'
Print,'The Frequency Resolution is ',DFr,' mHz.'
;
SpArr=DblArr(FFTN)
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
REPEAT Begin
 Ans1=0
 Print,'Enter the Time Resolution (Points) :'
 Read,TmRes
 NBlocs=Fix((Pnts-FFTN)/TmRes)
 Print,'The Time Resolution is ',TmRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 Print,'Is this O.K ? [0=No]'
 Read,Ans
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
;
T=LonArr(NBlocs)
T(0)=Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
;
Wsp=0.0
Print,'Enter Spectral Weighting [f^n]:'
Read,WSp
DArrLin=DblArr(NBlocs,NFreqs)
DArrLog=DblArr(NBlocs,NFreqs)
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
For i=0,FFTN-1 do TsArr(i)=XDat(i)
;
; Major Loop starts here
;
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN
 If Wndt EQ 1 Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFreqs-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2       ; Fourier Power
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2) ; Linear Power
 end
 If Wndt EQ 1 Then $  ; Time Window
 Begin
  For i=0,NFreqs-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)
   DArrLin(Bloc,i)=SpArr(i)
   If SpArr(i) GT 1e10 Then SpArr(i)=1e10
   If SpArr(i) LT 1e-6 Then SpArr(i)=1e-6
   DArrLog(Bloc,i)=20.*ALog10(SpArr(i))
  end
 end
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $ ; Low freqs.
  Begin
   SpArr(i)=SpArr(i)*Wght(i)
   DArrLin(Bloc,i)=SpArr(i)
   If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
   DArrLog(Bloc,i)=20*ALOG10(SpArr(i))
  end
  For i=NFreqs-1-2*ism,NFreqs-1 do $  ; High frequency range
  Begin
   SpArr(i)=SpArr(i)*Wght(i)
   DArrLin(Bloc,i)=SpArr(i)
   If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
   DArrLog(Bloc,i)=20*ALOG10(SpArr(i))
  end
  For i=iLFr,NFreqs-1-2*ism do $
  Begin
   DArrLin(Bloc,i)=0.0
   Js=i-2*ism
   Je=i+2*ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DArrLin(Bloc,i)=DArrLin(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DArrLin(Bloc,i)=DArrLin(Bloc,i)*Wght(i)
   If (DArrLin(Bloc,i) LT 1e-6) Then DArrLin(Bloc,i)=1e-6
   DArrLog(Bloc,i)=20*ALog10(DArrLin(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TmRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End     ; end Bloc Loop
;
Set_Plot,'WIN'
REPEAT Begin ; Log Power Window
 PAgn=0
 MnRng=0.0
 MxRng=10.0
 Print,'Minimum Log Power is ',Min(DArrLog)
 Print,'Maximum Log Power is ',Max(DArrLog)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,0,XSize=400,YSize=300
 Erase
 LoadCT,13
 Ttle=StaL+'Log Power Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 DYNTV,DArrLog,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
;
REPEAT Begin ; Linear Power Window
 PAgn=0
 MnRng=0.0
 MxRng=10.0
 Print,'Minimum Linear Power is ',Min(DArrLin)
 Print,'Maximum Linear Power is ',Max(DArrLin)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,1,XSize=400,YSize=300
 Erase
 LoadCT,13
 Ttle=StaL+'Linear Power Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 DYNTV,DArrLin,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
;
; Do FFT of Power Spectra
;
Print,'Doing FFT of Power Spectrum'
If WndT EQ 2 Then $ ; Frequency Window
Begin
 NFr=NFreqs-1-2*ism-iLFr
 NPnts2=Long(NBlocs)*Long(NFr)
 Strt2=iLFr
end
If WndT EQ 1 Then $       ; Time Domain Window
Begin
 NFr=NFreqs
 NPnts2=Long(NBlocs)*Long(NFreqs)
 Strt2=0
end
XDat=DblArr(NPnts2)
kk=Long(0)
YRngL=0.0
;
For jj=0,NBlocs-1 do $
Begin
 For ii=Strt2,NFr-1 do $
 Begin
  XDat(kk)=DArrLin(jj,ii)
  kk=Long(kk)+Long(1)
 end
end
FFTN2=1
Print,'The Sample Interval is ',DFr
Print,'Suggested FFT Length = ',NFr
Print,'Enter FFT LEngth : '
Read,FFTN2
NFreqs2=FFTN2/2 ; Plot up to Nyquist
YAx2=DblArr(NFreqs2)
TsArr2=DblArr(FFTN2)
FFRes2=1.0/(FFTN2*DFr)
For ii=0,NFreqs2-1 do YAx2(ii)=Float(ii)*FFRes2
TmRes2=Fix(0.2*FFTN2)  ; Set to 20% of FFT Length
NBlocs2=Fix((NPnts2-FFTN2)/TmRes2)
Print,'Num of Blocs to do = ',NBlocs2
Wsp2=0.0
Print,'Enter Spectral Weighting [f^n] :'
Read,Wsp2
Wght2=DblArr(NFreqs2)
For i=0,NFreqs2-1 do Wght2(i)=Float(i)^WSp2
DArrLin2=DblArr(NBlocs2,NFreqs2)
DArrLog2=DblArr(NBlocs2,NFreqs2)
SInt2=DFr
DFr2=1.0/(FFTN2*SInt2)
MxFr2=(NFreqs2-1)*DFr2
Sum1=0.0
If (WndT EQ 2) Then $
Begin
 Print,'Enter the amount of Smoothing [Usually 2] : '
 Read,ism2
 Wnd2=DblArr(5*ism2)
 For i=0,4*ism2 do $
 Begin
  Wnd2(i)=Exp(-(Float(i-2*ism2)/Float(ism2))^2)
  Sum1=Sum1+Wnd2(i)
 End
 For i=0,4*ism2 do Wnd2(i)=Wnd2(i)/Sum1
 iLFr2=2*ism2
 LFr2=iLFr2*DFr2
end
If (WndT EQ 1) Then Wnd2=Hanning(FFTN2)
For ii=0,FFTN2-1 do TsArr2(ii)=XDat(ii)
;
For Bloc=0,NBlocs2-1 do $
Begin
 DTrend,TsArr2,FFTN2
 If (WndT EQ 1) Then $
  For i=0,FFTN2-1 do TsArr2(i)=TsArr2(i)*Wnd2(i)  ; Hanning
 TrArr=FFT(TsArr2,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFreqs2-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2
  V2=Float(FFTN2)
  SpArr(i)=V1  ;/(V2*V2)
 end;
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFreqs2-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght2(i)
   DArrLin2(Bloc,i)=SpArr(i)
;   If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
;   If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
   DArrLog2(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   DArrLin2(Bloc,i)=SpArr(i)*Wght2(i)
;   If (DArrLin2(Bloc,i) LT 1e-6) Then DArrLin2(Bloc,i)=1e-6
   DArrLog2(Bloc,i)=20*ALOG10(DArrLin2(Bloc,i))
  end
  For i=NFreqs2-1-2*ism2,NFreqs2-1 do $
  Begin
   DArrLin2(Bloc,i)=SpArr(i)*Wght2(i)
;   If (DArrLin2(Bloc,i) LT 1e-6) Then DArrLin2(Bloc,i)=1e-6
   DArrLog2(Bloc,i)=20*ALOG10(DArrLin2(Bloc,i))
  end
  For i=iLFr2,NFreqs2-1-2*ism2 do $
  Begin
   DArrLin2(Bloc,i)=0.0
   Js=i-2*ism2
   Je=i+2*ism2
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DArrLin2(Bloc,i)=DArrLin2(Bloc,i)+Wnd2(iWn)*SpArr(j)
   end    ; end of J loop
   DArrLin2(Bloc,i)=DArrLin2(Bloc,i)*Wght2(i)
;   If (DArrLin2(Bloc,i) LT 1e-6) Then DArrLin2(Bloc,i)=1e-6
   DArrLog2(Bloc,i)=20*ALog10(DArrLin2(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn2=Long((Bloc+1))*Long(TmRes2)
 For j=0,FFTN2-1 do TsArr2(j)=XDat(Posn2+j) ; New Data
End       ; end of Bloc loop
;
REPEAT Begin  ; Log FFT of Power Spec
 PAgn=0
 Print,'Minimum of Log Plot ',Min(DArrLog2)
 Print,'Maximum of Log Plot ',Max(DArrLog2)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,2,XSize=400,YSize=300
 Erase
 LoadCT,13
 Ttle=StaL+'Log FFT of Power Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='Freq Diff in Power Spec.'
 YRngL=0
 Scl=1
 DYNTVFF,DArrLog2,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,Max(YAx2)],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
;
REPEAT Begin ; Linear FFT of Power Spec.
 PAgn=0
 Print,'Minimum of Linear Plot ',Min(DArrLin2)
 Print,'Maximum of Linear Plot ',Max(DArrLin2)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,3,XSize=400,YSize=300
 Erase
 LoadCT,13
 Ttle=StaL+'Linear FFT of Power Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='FFT of Power'
 YRngL=0
 Scl=1
 DYNTVFF,DArrLin2,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
 XRange=[Min(T),Max(T)],YRange=[YRngL,Max(YAx2)],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
PicYN=0
Print,'Write Linear FFT[FFT[Data]] to File ? [1=YES] :'
Read,PicYN
If (PicYN EQ 1) Then $
Begin
 Print,'Enter Output File Name : '
 Read,FName
 OpenW,u,FName,/Get_Lun
 PrintF,u,NBlocs2,NFreqs2
 PrintF,u,Ttle
 PrintF,u,XTtle
 PrintF,u,YTtle
 PrintF,u,Min(T),Max(T)
 PrintF,u,YRngL/1000.0,Max(YAx2)/1000.0
 PrintF,u,Scl
 PrintF,u,MnRng,MxRng
 PrintF,u,DArrLin2
 Free_Lun,u
End
Print,'Finished'
end
