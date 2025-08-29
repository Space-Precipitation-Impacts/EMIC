;  Program to Calculate Dynamic Cross Power
; and Cross Phase plots with the option of Log10
; or linear power, Time or Freq. Domain Smoothing
;
; C. Waters
; Canadian Network for Space Research
; University of Alberta
; Edmonton, Alberta, CANADA
; January, 1994
;
; Modification History :
;
; March, 1996 : Added Xph Index Rej Routine : CW
; Nov., 1996 : Added point shift simulation : CW
; July, 1997 : Added routine so point shift could cycle thru colours : CW
;
FUNCTION XTLab,axis,index,value
Ti=value
Hour=Long(Ti)/3600
Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
Function Tim,Sec
 Hr=Long(Sec)/3600
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end
;
;   Main Program Starts Here
;
Print,'Dynamic Cross Spectral Analysis'
IFmt=1  ; 0=JCS, 1=CLW
!P.Multi=0
RaDeg=180.0/3.14159
XFName=''
YFName=''
XStaL=''
YStaL=''
Print,'Enter Equatorial Station Data File Name : '
FTtle='Select EQUATORIAL Data'
XFName=PickFile(/READ,Title=FTtle,Filter='*.*')
OpenR,u,XFName,/Get_Lun
; Samson
If IFmt EQ 0 Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
  XStaL,XYear,XDay,XHour,XMin,XSec,XSInt,XPnts
 XDte=String(XDay,XYear,$
 Format="(I3.2,'/',I4.2)")
end
; Waters Data Format
If IFmt EQ 1 Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  XStaL,XYear,XMonth,XDay,XHour,XMin,XSec,XSInt,XPnts
 XDte=String(XDay,XMonth,XYear,$
  Format="(I2.2,'/',I2.2,'/',I4.2)")
end
XDat=DblArr(XPnts)
ReadF,u,XDat
Free_Lun,u
Print,'Enter Poleward Station Data File Name : '
FTtle='Select POLEWARD Data'
YFName=PickFile(/READ,Title=FTtle,Filter='*.*')
OpenR,u,YFName,/Get_Lun
; Samson
If IFmt EQ 0 Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
  YStaL,YYear,YDay,YHour,YMin,YSec,YSInt,YPnts
 Dte=String(YDay,YYear,$
  Format="(I3.2,'/',I4.2)")
end
; Waters
If IFmt EQ 1 Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  YStaL,YYear,YMonth,YDay,YHour,YMin,YSec,YSInt,YPnts
 YDte=String(YDay,YMonth,YYear,$
  Format="(I2.2,'/',I2.2,'/',I4.2)")
end
YDat=DblArr(YPnts)
ReadF,u,YDat
Free_Lun,u
Print,'Num. Points in Equatorial Data : ',XPnts
Print,'Num. Points in Poleward Data : ',YPnts
NPnts=XPnts
If (XPnts GT YPnts) Then NPnts=YPnts
Print,'Working with ',NPnts,' Data Points'
;
If (ABS(XSInt-YSInt) LT 0.01) Then $
Begin
 SInt=XSInt
 Print,'Enter Required FFT Length : '
 Read,FFTN
 NyqF=1000.0/(2.0*SInt)
 Print,'The Nyquist is ',NyqF,' mHz'
 Print,'Enter the Maximum Frequency Required (mHz):'
 Read,MxFr
 YRngH=MxFr
 DFr=1000.0/(FFTN*SInt)
 NFreqs=Fix(MxFr/DFr)+1
 MxFr=(NFreqs-1)*DFr
 Print,'The Nyquist is ',NyqF,' mHz.'
 Print,'The Frequency Resolution is ',DFr,' mHz.'
 Print,'Enter EQUATORIAL File START Point [1=First]: '
 Read,EqStrt
 Print,'Enter POLEWARD File START Point [1=First] : '
 Read,PlStrt
 NPnts=NPnts-EqStrt+1
 If (PlStrt GT EqStrt) Then NPnts=NPnts-PlStrt+1
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
 T(0)=Long(XHour)*3600+Long(XMin)*60+Long(XSec)
 T(0)=T(0)+EqStrt-1
 Print,'Start Time = ',Tim(T(0))
 For i=1,NBlocs-1 do $
  T(i)=T(i-1)+Long(TmRes*SInt)
 XRngL=Min(T)
 XRngH=Max(T)
 DispArr=DblArr(NBlocs,NFreqs)
 XTsArr=DblArr(FFTN)    ; Time Series Array
 YTsArr=DblArr(FFTN)
 For i=0,FFTN-1 do $
 Begin
  XTsArr(i)=XDat(i+EqStrt-1)   ; Load First FFTN of Data
  YTsArr(i)=YDat(i+PlStrt-1)
 End
 SpTyp=1
 Print,'Enter Plot Type [1=Cross Power, 2=Cross Phase] : '
 Read,SpTyp
 If (SpTyp LT 1) Then SpTyp=1
 If (SpTyp GT 2) Then SpTyp=2
 WndT=1
 Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
 Read,WndT
 If (WndT LT 1) Then WndT=1
 If (WndT GT 2) Then Wndt=2
 If (WndT EQ 2) Then $
 Begin
  ism=1
  Print,'Enter the Smoothing [ism] : '
  Read,ism
  Wnd=DblArr(5*ism)
  Sum1=0.0
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
; Controls for Cross Power Plot
;
 If (SpTyp EQ 1) Then $
 Begin
  Wsp=0.0
  Print,'Enter Spectral Weighting [n in f^n] : '
  Read,WSp
  Wght=DblArr(NFreqs)
  For i=0,NFreqs-1 do Wght(i)=Float(i)^WSp
  PTyp=1
  Print,'Cross Power Type [1=Linear, 2=Log10] : '
  Read,PTyp
  If (PTyp LT 1) Then PTyp=1
  If (PTyp GT 2) Then PTyp=2
 end
;
; Controls for Cross Phase Plot
;
 If (SpTyp EQ 2) Then $  ; Cross Phase
 Begin
  CPow=DblArr(NBlocs,NFreqs) ; CPower Array
  TmpCPhArr=DblArr(NBlocs,NFreqs)
  Print,'Enter Phase Range for "coherence" rejection :'
  Read,PhRng
  Print,'Enter Cross Phase Correlation Index : '
  Read,Indx
  MxPh=180.0
  MnPh=-180.0
  EnPh=0
  Print,'Enhance Phase ? [1=YES]'
  Read,EnPh
 end
;
; Main Loop starts here
;
 For Bloc=0,NBlocs-1 do $
 Begin
  DTrend,XTsArr,FFTN
  DTrend,YTsArr,FFTN
  If (WndT EQ 1) Then $
  Begin
   For i=0,FFTN-1 do XTsArr(i)=Wnd(i)*XTsArr(i)
   For i=0,FFTN-1 do YTsArr(i)=Wnd(i)*YTsArr(i)
  end
  XTrArr=FFT(XTsArr,1)    ; FFT - BACKWARD so NO 1/N
  YTrArr=FFT(YTsArr,1)
  If (SpTyp EQ 1) Then $  ; Power
  Begin
   CP=YTrArr*Conj(XTrArr)  ; Define CPower Array
   If (WndT EQ 1) Then $  ; Time Domain
   Begin
    If (PTyp EQ 1) Then $ ; Lin. Pow.
     For i=0,NFreqs-1 do DispArr(Bloc,i)=ABS(CP(i))*Wght(i)/FFTN
    If (PTyp EQ 2) Then $ ; Log10
    Begin
     For i=0,NFreqs-1 do $
     Begin
      CPw=ABS(CP(i))*Wght(i)/FFTN
      If (CPw GE 1e20) Then CPw=1e20
      If (CPw LT 1e-6) Then CPw=1e-6
      DispArr(Bloc,i)=20*ALog10(CPw)
     end   ; i Loop
    end    ; If Log
   end     ; If Time Wind.
   If (WndT EQ 2) Then $  ; Freq.
   Begin
    For i=0,iLFr-1 do $
    Begin
     DispArr(Bloc,i)=ABS(CP(i))*Wght(i)/FFTN
     If (PTyp EQ 2) Then $
     Begin
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
      DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
     end
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
      DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*ABS(CP(j))/FFTN
     end    ; end of J loop
     DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
     If (PTyp EQ 2) Then $
     Begin
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
      DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
     end    ; If PTyp = 2
    end     ; Freq loop
   end      ; If Freq. Filt.
  end       ; If CPow to be plotted
  If (SpTyp EQ 2) Then $  ; Phase
  Begin
   CP1=YTrArr*Conj(XTrArr); Cross Power
   If (WndT EQ 1) Then $  ; Time Wind.
   Begin
    For kk=0,NFreqs-1 do $
    Begin
     CPow(Bloc,kk)=20.0*ALog10(ABS(CP1(kk))/FFTN)                         ; CP Array
     Tp=Imaginary(CP1(kk))
     Bt=Double(CP1(kk))
     TmpCPhArr(Bloc,kk)=ATAN(Tp,Bt)*RaDeg    ; XPhase Array
    end
   end
   If (WndT EQ 2) Then $  ; Freq. Wnd.
   Begin
    For i=0,iLFr-1 do TmpCPhArr(Bloc,i)=-200.0
    For i=iLFr,NFreqs-1 do $
    Begin
     CPw=0.0
     Js=i-2*ism
     Je=i+2*ism
     iWn=-1
     For j=Js,Je do $
     Begin
      iWn=iWn+1
      CPw=CPw+Wnd(iWn)*CP1(j)
     end
     CPow(Bloc,i)=20.0*ALog10(ABS(CPw)/FFTN)                      ; Smoothed Cross Power
     Tp=Imaginary(CPw)
     Bt=Double(CPw)
     TmpCPhArr(Bloc,i)=ATAN(Tp,Bt)*RaDeg     ; Smoothed C. Ph.
    end     ; End Freq Loop
   end      ; If Freq Smoothing
  end       ; If Phase Plot
  PosnE=EqStrt-1+(Bloc+1)*TmRes
  PosnP=PlStrt-1+(Bloc+1)*TmRes
  For j=0,FFTN-1 do $
  Begin
   XTsArr(j)=XDat(PosnE+j)    ; New Data
   YTsArr(j)=YDat(PosnP+j)
  End
 End          ; End of Bloc Loop
 Wait,0.5
 Print,'Finished Main Loop'
;
 If (SpTyp EQ 2) Then $      ; Phase Plot
 Begin
  XPhCoh,TmpCPhArr,Indx,PhRng,MnPh-1 ; Do XPH neighbour rejection
  If (EnPh EQ 1) Then $
   TmpCPhArr(jj,i)=TmpCPhArr(jj,i)^3/MxPh^2
 end     ; Phase Plot
 Set_plot,'WIN'
 YRngL=0.0
 Scl=1
;
 If (SpTyp EQ 1) Then $  ; Cross Power
 Begin
  REPEAT Begin  ; Repeat for point shift
   PAgn=0
   TTle=XStaL+':'+YStaL+' Cross Power for '+XDte
   XTtle='Time (UT)'
   YTtle='Frequency (mHz)'
   Scl=1
   Print,'Minimum Power is ',Min(DispArr)
   Print,'Maximum Power is ',Max(DispArr)
   Print,'Enter Minimum for Plot :'
   Read,RngL
   Print,'Enter Maximum for Plot :'
   Read,RngH
   Window,0,XSiz=500,YSize=400
   Erase
   LoadCT,13
   DYNTV,DispArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
    XRange=[XRngL,XRngH],YRange=[YRngL,YrngH],$
    Scale=Scl,Range=[RngL,RngH],Aspect=1.5
   Print,'Another Plot at Different Colour Range [1=YES] '
   Read,Agn1
   PAg=Agn1 NE 0
  end UNTIL PAg
 end
;
 If (SpTyp EQ 2) Then $  ; Cross Phase
 Begin
  PltN=0
  RngH=MxPh
  RngL=MnPh
  REPEAT Begin
   PhAgn=0
   TTle=XStaL+':'+YStaL+' Cross Phase for '+XDte
   GetPhCol
   If (PltN NE 0) Then $
   Begin
    Print,'Max Phase is ',MxPh
    Print,'Min Phase is ',MnPh
    Print,'Enter Max Phase for this Plot'
    Read,RngH
    Print,'Enter Min Phase for this Plot'
    Read,RngL
   end
   PShft=0.0
   Print,'Enter Point Shift Factor :'
   Read,PShft
   PShArr=DblArr(NFreqs)
   For kk=0,NFreqs-1 do PShArr(kk)=PShft*SInt*DFr*kk*0.360
   CPwRej=0.0
   Print,'Max Cross Power = ',Max(CPow)
   Print,'Min Cross Power = ',Min(CPow)
   Print,'Enter Cross Power Rejection Level :'
   Read,CPwRej
   DispArr=TmpCPhArr
   Print,'Sorting Through XPH Array...'
   For kk=0,NBlocs-1 do $
   Begin
    For mm=0,NFreqs-1 do $
    Begin
     CPMag=CPow(kk,mm)
     If (CPMag LE CPwRej) Then DispArr(kk,mm)=-200.0
     If (DispArr(kk,mm) GT MxPh) Then DispArr(kk,mm)=-200.0
     If (DispArr(kk,mm) LT MnPh) Then DispArr(kk,mm)=-200.0
     If (DispArr(kk,mm) GE -180.0) Then $
     Begin
      DispArr(kk,mm)=DispArr(kk,mm)+PShArr(mm)
      If DispArr(kk,mm) LT -180 Then DispArr(kk,mm)=DispArr(kk,mm)+360.
      If DispArr(kk,mm) GT 180 Then DispArr(kk,mm)=DispArr(kk,mm)-360.
     end
    end    ; Freq Loop
   end     ; Bloc Loop
   XTtle='Time (LT)'
   YTtle='Frequency (mHz)'
   Window,0,XSize=500,YSize=400
   DYNTV,DispArr,Title=TTle,XTitle=XTtle,YTitle=YTtle,$
    XRange=[XRngL,XRngH],YRange=[YRngL,YRngH],$
    Scale=Scl,Range=[RngL,RngH],Aspect=1.5
   PltN=PltN+1
   Print,'Another Plot to :'
   Print,'Change the Colour Range'
   Print,'Change the Point Shift'
   Print,'Change Cross Power Rejection Level'
   Print,'[1=YES] for any of these'
   Read,Agn1
   PhAgn=Agn1 NE 1
  end UNTIL PhAgn
 end
 DoCur=0
 Print,'Activate CURSOR [1=YES] :'
 Read,DoCur
 If (DoCur EQ 1) Then $
 Begin
  Print,'Press LEFT Button to Get Values'
  Print,'Press RIGHT Button when Finished'
  Print,!P.Color
  Lb=' '
  REPEAT Begin
   Cursor,x,y,/data,/down
   XYOuts,10,10,color=[0],Lb,/device    ; Black
   TLab=Tim(x)
   Lb=TLab+' '+StrTrim(String(y),2)+' mHz'
   color=!d.n_colors-1
   XYOuts,10,10,color=[235],Lb,/device   ; White
   GOut=(!err EQ 4)
  End UNTIL GOut
 End
 PicYN=0
 Print,'Write Picture to File ? [1=YES] :'
 Read,PicYN
 If (PicYN EQ 1) Then $
 Begin
  FName=''
  Print,'Enter Output File Name : '
  Read,FName
  OpenW,u,FName(0),/Get_Lun
  PrintF,u,NBlocs,NFreqs
  PrintF,u,Ttle
  PrintF,u,XTtle
  PrintF,u,YTtle
  PrintF,u,XRngL,XRngH
  PrintF,u,YRngL/1000.0,YRngH/1000.0
  PrintF,u,Scl
  PrintF,u,RngL,RngH
  PrintF,u,DispArr
  Free_Lun,u
 End
 Print,'Finished'
End
End
