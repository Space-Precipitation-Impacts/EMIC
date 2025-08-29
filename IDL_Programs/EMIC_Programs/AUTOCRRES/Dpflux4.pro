;Program to compute Poynting flux from CRRES data
;
; C.L. Waters :  August, 1993
; University of Newcastle
; New South Wales
; Australia
;
;MODIFICATIONS: By Paul Manusiu 2001
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
; Main Program
;
Pro DPFlux4,tims,E,B
winnum=1
SInt=1./32.
sig=0.5  ; for interp. spline
winnum=1
SInt=1./32.
sig=0.5  ; for interp. spline
NPnts=n_elements(tims)
ExDat=DblArr(2,NPnts)
 ExDat(0,*)=tims/1000.
 ExDat(1,*)=E
EyDat=DblArr(2,NPnts)
 EyDat(0,*)=tims/1000.
 EyDat(1,*)=E
EzDat=DblArr(2,NPnts)
 EzDat(0,*)=tims/1000.
 EzDat(1,*)=E
 bxDat=DblArr(2,NPnts)
 bxDat(0,*)=tims/1000.
 bxDat(1,*)=B
 byDat=DblArr(2,NPnts)
 byDat(0,*)=tims/1000.
 byDat(1,*)=B
 bzDat=DblArr(2,NPnts)
 bzDat(0,*)=tims/1000.
 bzDat(1,*)=B
; Get Min Time
MnT=DblArr(6)
MnT(0)=Min(ExDat(0,*))
MnT(1)=Min(EyDat(0,*))
MnT(2)=Min(EzDat(0,*))
MnT(3)=Min(bxDat(0,*))
MnT(4)=Min(byDat(0,*))
MnT(5)=Min(bzDat(0,*))
MinTime=Min(MnT)
TotTime=Max(ExDat(0,*))-MinTime
NPnts=TotTime/SInt
TArr=DblArr(NPnts)
; Construct time base
For ii=0,NPnts-1 do TArr(ii)=MinTime+float(ii)*SInt
; Get space for PFLux in time domain
PFluxArr=DblArr(3,NPnts)
; Spline Time Domain Data onto Time Base
TmpEx=spline(ExDat(0,*),ExDat(1,*),TArr,sig)
TmpEy=spline(EyDat(0,*),EyDat(1,*),TArr,sig)
TmpEz=spline(EzDat(0,*),EzDat(1,*),TArr,sig)
Tmpbx=spline(bxDat(0,*),bxDat(1,*),TArr,sig)
Tmpby=spline(byDat(0,*),byDat(1,*),TArr,sig)
Tmpbz=spline(bzDat(0,*),bzDat(1,*),TArr,sig)
; Find S
PFluxArr(0,*)=TmpEy*Tmpbz-TmpEz*Tmpby  ; X
PFluxArr(1,*)=TmpEz*Tmpbx-TmpEx*Tmpbz  ; Y
PFluxArr(2,*)=TmpEx*Tmpby-TmpEy*Tmpbx  ; Z
; Set up Analysis parameters
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
TsArr=DblArr(3,FFTN)    ; Time Series Array
TrArr=DblArr(3,FFTN)    ; FFT Array
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
T(0)=TArr(0)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
DispArr=DblArr(3,NBlocs,NFreqs)
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
SpArr=DblArr(3,NFreqs+2*ism)   ; Double Prec. Spectral Array
For jj=0,2 do $
Begin
 For i=0,FFTN-1 do TsArr(jj,i)=PFluxArr(jj,i)
end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN
 DTrend,TsArr(2,*),FFTN
 If (WndT EQ 1) Then $
 Begin
  For jj=0,2 do $
  Begin
   For i=0,FFTN-1 do TsArr(jj,i)=TsArr(jj,i)*Wnd(i)  ; Hanning
  end
 end
 TrArr(0,*)=FFT(TsArr(0,*),1)    ; FFT - BACKWARD so NO 1/N
 TrArr(1,*)=FFT(TsArr(1,*),1)
 TrArr(2,*)=FFT(TsArr(2,*),1)
 V2=Float(FFTN)
 For jj=0,2 do $
 Begin
  For i=0,NFreqs-1 do $
  Begin
   V1=(TrArr(jj,i))
   SpArr(jj,i)=Double(V1)
  end
 end;
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For jj=0,2 do $
  Begin
   For i=0,NFreqs-1 do DispArr(jj,Bloc,i)=SpArr(jj,i)*Wght(i)
  end
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For jj=0,2 do $
  Begin
   For i=0,iLFr-1 do DispArr(jj,Bloc,i)=SpArr(jj,i)*Wght(i)
   For i=NFreqs-1-2*ism,NFreqs-1 do DispArr(jj,Bloc,i)=SpArr(jj,i)*Wght(i)
   For i=iLFr,NFreqs-1-2*ism do $
   Begin
    DispArr(jj,Bloc,i)=0.0
    Js=i-2*ism
    Je=i+2*ism
    iWn=-1
    For j=Js,Je do $
    Begin
     iWn=iWn+1
     DispArr(jj,Bloc,i)=DispArr(jj,Bloc,i)+Wnd(iWn)*SpArr(jj,j)
    end    ; end of J loop
    DispArr(jj,Bloc,i)=DispArr(jj,Bloc,i)*Wght(i)
   end     ; end of I loop
  end
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TmRes
 For jj=0,2 do $
 Begin
  For i=0,FFTN-1 do TsArr(jj,i)=PFluxArr(jj,Posn+i)
 end
End    ; end Bloc Loop
;
Set_Plot,'WIN'
Device,decomposed=0
REPEAT Begin
 PAgn=0
 Print,'Minimum S is ',Min(DispArr)
 Print,'Maximum S is ',Max(DispArr)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,winnum,XSize=500,YSize=400
 Erase
 LoadCT,13 ; 20
 Ttle=' Sx '
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 Ds=DblArr(NBlocs,NFreqs)
 For ii=0,NBlocs-1 do $
 Begin
  For jj=0,NFreqs-1 do Ds(ii,jj)=DispArr(0,ii,jj)
 end
 DYNTV,Ds,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 For ii=0,NBlocs-1 do $
 Begin
  For jj=0,NFreqs-1 do Ds(ii,jj)=DispArr(1,ii,jj)
 end
 Window,winnum+1,XSize=500,YSize=400
 Ttle=' Sy '
 DYNTV,Ds,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 For ii=0,NBlocs-1 do $
 Begin
  For jj=0,NFreqs-1 do Ds(ii,jj)=DispArr(2,ii,jj)
 end
 Window,winnum+2,XSize=500,YSize=400
 Ttle=' Sz '
 DYNTV,Ds,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[Min(T),Max(T)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
end UNTIL PAg
;PicYN=0
;Print,'Write Picture to File ? [1=YES] :'
;Read,PicYN
;If (PicYN EQ 1) Then $
;Begin
; FName=''
; Print,'Enter Output File Name : '
; Read,FName
; OpenW,u,FName,/Get_Lun
; PrintF,u,NBlocs,NFreqs
; PrintF,u,Ttle
; PrintF,u,XTtle
; PrintF,u,YTtle
; PrintF,u,Min(T),Max(T)
; PrintF,u,YRngL,MxFr/1000.0
; PrintF,u,Scl
; PrintF,u,MnRng,MxRng
; PrintF,u,DispArr
; Free_Lun,u
;End
Print,'Finished'
end
