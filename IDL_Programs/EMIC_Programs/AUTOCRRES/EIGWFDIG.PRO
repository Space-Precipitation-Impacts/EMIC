; Pure State Analysis using a pure state detector and
; the cross phase.
; The detector is set for X latitudinally spaced
; magnetometers and writes the frequency where the
; detector AND Cross phase peaks with the associated
; FFT start time
; Run EIGSLC to get Eigenvector
;
; C. Waters, Dec, 1994
; Canadian Network for Space Research
; Edmonton, Alberta, Canada
;
FUNCTION XTLab,axis,index,value
Ti=value
Hour=Long(Ti)/3600
Minute=Long(Ti-3600*Hour)/60
RETURN,String(Hour,Minute,$
       Format="(I2.2,':',I2.2)")
end
;
; Main Program
;
Path2dat='C:\rsi\idl40\lib\colin\'
Print,'Pure State Data Analysis Program'
EVDet=ComplexArr(2)
;
; Detector Vector
;
EVDet(0)=complex(0.7,0.0)  ;Xs-Xn detector
EVDet(1)=complex(0.0,0.7)
;
; Normalise State Vector, Mult by Conj and sqrt
;
DRe=0.0
DIm=0.0
For ii=0,1 do $
Begin
 R1=Double(EVDet(ii))
 R2=Imaginary(EVDet(ii))
 DRe=DRe+R1*R1
 DIm=DIm+R2*R2
end
DMag=Sqrt(DRe+DIm)
For ij=0,1 do EVDet(ij)=EVDet(ij)/DMag
Print,'The Normalised Detector is : '
For kk=0,1 do Print,EVDet(kk)
;
NDimSq=Fix(4)
FName=''
StaL=''
IFmt=1
Print,'Enter Data Format [1=JCS, 2=CLW] : '
Read,IFmt
Print,'Using CLW Data Format'
If (IFmt LT 1) Then IFmt=1
If (IFmt GT 2) Then IFmt=2
NPnts=Long(0)
For II=0,1 do $
Begin
 Print,'Enter Input Data File Name for Dimension ',ii+1,' : '
 Read,FName
 OpenR,u,Path2dat+FName,/Get_Lun
;
; My Format
;
 If (IFmt EQ 2) Then $
 Begin
  ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  StaL,Year,Month,Day,Hour,Min,Sec,SInt,NPnts
  Dte=String(Day,Month,Year,$
  Format="(I2.2,'/',I2.2,'/',I4.2)")
 end
;
; Samson Format
;
 If (IFmt EQ 1) Then $
 Begin
  ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
  StaL,Year,Day,Hour,Min,Sec,SInt,NPnts
  Dte=String(Day,Year,$
  Format="(I3.2,'/',I4.2)")
 end;
;
; Define Data Arrays and read in data
;
 If (ii EQ 0) Then $
 Begin
  DatArr=DblArr(NPnts,2)
  NP1=NPnts
 end
 DmArr=DblArr(NPnts)
 ReadF,u,DmArr
 If (NP1 LT NPnts) Then NPnts=NP1
 For ll=Long(0),Long(NPnts-1) do DatArr(ll,ii)=DmArr(ll)
 Free_Lun,u
end
;
; Set up Analysis Parameters
;
NPnts=Long(NPnts)
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
Print,'Enter FFT Length : '
Read,FFTN
NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
Print,'Enter the Maximum Frequency Required (mHz):'
Read,MxFr
DFr=1000.0/(FFTN*SINT)
NFreqs=Fix(MxFr/DFr)+1
MxFr=(NFreqs-1)*DFr
Print,'The Frequency Resolution is ',DFr,' mHz.'
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
;Print,'Enter Maximum Phase :'
;Read,MxPh
MxPh=90.0
;Print,'Enter Minimum Phase :'
;Read,MnPh
MnPh=-90.0
;
; Set up Time Axis
;
T=LonArr(NBlocs)
T(0)=Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
;
; Define working Arrays and Output Array
;
DPol=2
TsArr=DblArr(FFTN,2)    ; Time Series Array
TrArr=ComplexArr(FFTN,2)    ; FFT Array
DetArr=DblArr(NBlocs,NFreqs)
CPhArr=DblArr(NBlocs,NFreqs)
;
; Read 1st Data Segment
;
For j=0,1 do $
Begin
 For i=0,FFTN-1 do TsArr(i,j)=DatArr(i,j)
end
;
; Construct Frequency Domain Smoothing Function
;
ism=1
Print,'Enter the Smoothing [ism] : '
Read,ism
Wnd=DblArr(5*ism)
Sum1=0.0
Sum2=0.0
For i=0,4*ism do $
Begin
 Wnd(i)=Exp(-(Float(i-2*ism)/Float(ism))^2)
 Sum1=Sum1+Wnd(i)
 Sum2=Sum2+Wnd(i)*Wnd(i)
End
DegFr=Sum1^2/Sum2
Wait,0.5
Print,'Smoothing Window Degrees of Freedom = ',DegFr
For i=0,4*ism do Wnd(i)=Wnd(i)/Sum1
iLFr=2*ism
LFr=iLFr*DFr
Print,'Calculating Spectrum.....'
Wait,0.5
;
; Define Temp. working Arrays and Spectral Matrix SMat
;
SMO=ComplexArr(NFreqs,2,2)
SMDm=ComplexArr(NFreqs)
SMat=ComplexArr(2,2)
MMDm=ComplexArr(2)
;
; Major Loop Starts Here
;
For Bloc=0,NBlocs-1 do $
Begin
;
; Detrend time series for all dimensions
;
 For Dmm=0,1 do $
 Begin
  DTrend,TsArr(*,Dmm),FFTN           ; Call Linear Detrend
  TrArr(*,Dmm)=FFT(TsArr(*,Dmm),-1)  ; FFT, has 1/FFTN
 end    ; of 2 FFTs
;
; Smooth the Spectra, generating the appropriate terms
; in the spectral matrix with Real and Imag. Parts Separate
;
 For k=0,1 do $   ; slow array index
 Begin
  For j=0,1 do $  ; fast array index
  Begin
   For i=0,NFreqs-1 do $
    SMDm(i)=Complex(TrArr(i,k)*Conj(TrArr(i,j)))
   SMO(0,j,k)=0.2*SMDm(0)      ; Get DC level direct
;
; Smooth below iLFr with moving boxcar average
;
   For i=1,iLFr-1 do $
    SMO(i,j,k)=(SMDm(i-1)+SMDm(i)+SMDm(i+1))/3.0
;
; Smooth the rest with Exponential taper
;
   For i=iLFr,NFreqs-1-2*ism do $
   Begin
    SMO(i,j,k)=0.0
    Js=i-2*ism
    Je=i+2*ism
    iWn=-1
    For jj=Js,Je do $
    Begin
     iWn=iWn+1
     SMO(i,j,k)=SMO(i,j,k)+Wnd(iWn)*SMDm(jj)
    end             ; end of jj loop
   end              ; end of i Loop [frequency]
  end               ; end of j Loop [fast array index]
 end                ; end of k Loop
;
; Form the Spectral Matrix at Each Frequency and
; Apply the state vector, EVDet
;
 For i=0,NFreqs-1 do $
 Begin
  For k=0,1 do $
  Begin
   For j=0,1 do $
    SMat(k,j)=Complex(SMO(i,k,j))   ; Form Spectral Matrix
  end
;
; Normalise Spectral Matrix
;
  Tr=0.0
  For ii=0,1 do Tr=Tr+SMat(ii,ii)
  For mm=0,1 do $
  Begin
   For nn=0,1 do $
   Begin
    If (ABS(Tr) GT 0.001) Then $
    SMat(mm,nn)=SMat(mm,nn)/Tr $               ; Normalise
    Else SMat(mm,nn)=0.0
   end
  end
  CPhArr(Bloc,i)=ATAN(SMat(1,0))*180.0/3.14159
  For k=0,1 do $   ; Apply State Vector here
  Begin
   MMDm(k)=complex(0.0,0.0)
   For j=0,1 do $
    MMDm(k)=MMDm(k)+EVDet(j)*SMat(k,j)
  end
  S1=complex(0.0,0.0)
  For k=0,1 do S1=S1+MMDm(k)*Conj(EvDet(k))
  DetArr(Bloc,i)=S1^4
 end                  ; End Freq Sweep
;
; Load next time series
;
 Posn=(Bloc+1)*TmRes
 For i=0,1 do $
 Begin
  For j=0,FFTN-1 do TsArr(j,i)=DatArr(Posn+j,i) ; New Data
 end
End    ; end Bloc Loop
;
; Plot 2D Array
;
Set_Plot,'WIN'
;Set_Plot,'X'
LoadCT,13
REPEAT Begin
 PTyp=1
 Print,'Plot Type: 1=State Vector, 2=Cross Phase'
 Read,PTyp
 PAgn=0
 Ttle=StaL+' Spectrum for '+Dte
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 If (PTyp EQ 1) Then $  ; SV Spectrum
 REPEAT Begin
  PAgn=0 & Agn1=0
  Print,'Minimum is ',Min(DetArr)
  Print,'Maximum is ',Max(DetArr)
  Print,'Enter Minimum for Plot :'
  Read,MnRng
  Print,'Enter Maximum for Plot :'
  Read,MxRng
  Window,0,XSize=700,YSize=500
  WIndx=0
  Erase
  DYNTV,DetArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
  Print,'Another SV Plot at Different Colour Range ? [0=YES]'
  Read,Agn1
  PAg=Agn1 NE 0
 end UNTIL PAg
 If (PTyp EQ 2) Then $  ; Cross Phase
 Begin
  Indx=1 & PhRng=5.0
  CrPh=CPhArr   ;Create Temp Array
  EnPh=1   ; Enhance Phase Plot
  Print,'Enter Cross Phase Correlation Index [1 to 9] : '
  Read,Indx
  Print,'Enter the Cross Phase Resolution [eg. 5 deg] : '
  Read,PhRng
  Print,'Enter MAX Phase : '
  Read,MxPh
  Print,'Enter MIN Phase : '
  Read,MnPh
  Print,'Sorting through Cross Phase...'
  XPhCoh,CrPh,Indx,PhRng,MnPh-1  ; Do sort of Array
  For jj=0,NBlocs-1 do $
  Begin
   For i=0,NFreqs-1 do $
   Begin
    If (CrPh(jj,i) GT MxPh) Then CrPh(jj,i)=MnPh-1
    If (CrPh(jj,i) LT MnPh) Then CrPh(jj,i)=MnPh-1
    If (CrPh(jj,i) NE MnPh-1) Then $
     If (EnPh EQ 1) Then $
      CrPh(jj,i)=CrPh(jj,i)^3/MxPh^2
   end   ; Freq Loop
  end    ; Bloc Loop
  Window,2,XSize=700,YSize=500
  WIndx=2
  Erase
  DYNTV,CrPh,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnPh,MxPh],Aspect=1.5
 end
 O_x=!x & O_y=!y
 Print,'Another Plot [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
Ms=0
Print,'Activate Mouse [1=YES] :'
Read,Ms
If (Ms EQ 1) Then $
Begin
 WSet,WIndx
 DigiPic,Min(T),Max(T),NBlocs,YRngL,MxFr,NFreqs,O_x,O_y,TA,FA,NPnts
 Print,'Calculating Polynomial Function for Wr :'
 Print,'Values are for 1/4 Hour Intervals'
 NmSp1=0
 For jj=0,NPnts-2 do If (TA(jj+1)-TA(jj) GT 0.1) Then NmSp1=NmSp1+1
 XA=DblArr(NmSp1)
 YA=DblArr(NmSp1)
 nn=0
 For mm=0,NPnts-2 do $  ; Check monotonically increasing values
 Begin
  If (TA(mm+1)-TA(mm) GT 0.1) Then $
  Begin
   XA(nn)=TA(mm)
   YA(nn)=FA(mm)
   nn=nn+1
  end
 end
 NmSp=Fix((XA(NmSp1-1)-XA(0))/900)
 XAS=DblArr(NmSp+1)
 YAS=DblArr(NmSp+1)
 StTm=Long(FIX(TA(0)/900))*Long(900)
 For kk=0,NmSp do $    ; Setup 15 min X-Axis
  XAS(kk)=Long(StTm)+kk*Long(900)
 POrd=5
 IAgn=1
 REPEAT Begin
  XCof=POLY_FIT(XA,YA,POrd)
  Sz=Size(XAS)
  YTstS=DblArr(Sz(1))
  YMnSE=0.0
  For j=0,Sz(1)-1 do $ ; For 15min X-Axis Values
  Begin
   YAS(j)=0.0
   YTstS(j)=0.0
   jj=-1
   REPEAT Begin  ; Approx of Poly curve X-axis
    jj=jj+1
   end UNTIL XA(jj) GE XAS(j)
   XTst=XA(jj)
   YTst=YA(jj)
   For i=0,POrd do $
   Begin
    YAS(j)=YAS(j)+XCof(i)*XAS(j)^i ; Construct Polynomial
    YTstS(j)=YTstS(j)+XCof(i)*XTst^i
   end
   YMnSE=YMnSE+ABS(YTst-YTstS(j))
  end
  Print,'Poly. Order is ',POrd
  Print,'Poly. Fit Error = ',YMnSE
;  YAS=Spline(XA,YA,XAS)
  Window,1,XSize=400,YSize=300
  Plot,XA,YA,Title='Resonant Frequency',XTitle=XTtle,$
   YTitle=YTtle,XRange=[Min(T),Max(T)],$
   YRange=[YRngL,MxFr],XTickFormat='XTLab'
  OPlot,XAS,YAS  ; OPlot Modelled Data
  Print,'Redo Polynomial Fit [0=No] : '
  Read,IAgn
  If IAgn NE 0 Then $
  Begin
   Print,'Enter Polynomial Order [eg. 5] : '
   Read,POrd
  end
 end UNTIL IAgn EQ 0
 FName=''
 Print,'Enter Time/Freq Output File Name : '
 Read,FName
 OpenW,u,FName,/Get_Lun
 For jj=0,NmSp do $
  PrintF,u,XAS(jj)/3600.0,YAS(jj)
 Free_Lun,u
end   ; If Mouse
If Ms NE 1 Then Print,'Time/Freq File NOT Written'
Print,'Finished'
end
