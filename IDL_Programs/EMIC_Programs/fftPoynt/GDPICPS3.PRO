;  Program to print (PS) Dynamic Plots
; after being saved as *.PIC files
; This program was modified from GDPICPS.PRO
; for the 1996 Large ARC submission
;
; C. Waters February, 1996
;
FUNCTION XTLab,value
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
End
; Main Program
;   Input Data
;
Print,'PostScript Print Spectra Program'
;
NPlts=3  ; Number of Plots
;
OutF=' ' & YAx=0
!P.CharThick=3.0
Print,'Enter Output File Name : [*.PS]'
Read,OutF
For kk=1,NPlts do $
Begin
 FName=''
 Ttle=''
 XTtle=''
 YTtle=''
 FSt=FindFile('*.PIC')
 For i=0,N_Elements(Fst)-1 do $
  Print,FSt(i)
 Print,'There are ',i,' Files'
 Print,'The bottom Picture is File 1'
 FTtle='Select Input Data'
 FName=PickFile(Title=Fttle,Filter='*.PIC')
 OpenR,u,FName,/Get_Lun
 ReadF,u,Nx,Ny
 ReadF,u,Ttle
 ReadF,u,XTtle
 ReadF,u,YTtle
 ReadF,u,XRngL,XRngH
 ReadF,u,YRngL,YRngH
 ReadF,u,Scl
 ReadF,u,RngL,RngH
 DispArr=DblArr(Nx,Ny)
 ReadF,u,DispArr
 Free_Lun,u
 Print,'There are Several Plot Types :'
 Print,'0=Power'
 Print,'1=Cross Phase'
 Print,'2=Plasma Density'
 Print,'3=Azimuth'
 Print,'4=Ellipticity'
 Print,'5=SuperDARN Time/Range Plot'
 Print,'Enter Selection [0-5]:'
 Read,PltTyp
 CbTtle=''
 Case PltTyp of
  0:Begin $
     Print,'Enter Colour Bar Label for this File :'
     Read,CbTtle
    end
  1:CbTtle='Phase [Degrees]'
  2:CbTtle='Density [H+/cm^3]'
  3:CbTtle='Azimuth [Degrees]'
  4:CbTtle='Ellipticity'
  5:CbTtle='Velocity m/s'
 end
 If (kk EQ 1) Then $
 Begin
  PCol=1
  Set_Plot,'PS'
  Device,Filename=OutF,/Portrait
  Print,'Colour [=1] or B/W Plot [=2]'
  Read,PCol
  Device,/color  ;Set for both
  XOffspg=2.5  ; cm
  YOffspg=1.5    ; cm
  XSzpg=18     ; cm
  YSzpg=24     ; cm
  Device,/INCHES,XOffset=XOffspg/2.54
  Device,/INCHES,YOffset=YOffspg/2.54
  Device,/INCHES,XSize=XSzpg/2.54
  Device,/INCHES,YSize=YSzpg/2.54
  !p.noerase=1
  NCol=!d.N_Colors
 End
 If (PCol EQ 1) Then $
 Begin
  If (PltTyp EQ 0) Then LoadCT,20 ;13
  If (PltTyp EQ 1) Then GetPhCps
  If (PltTyp EQ 2) Then $
  Begin
   LoadCT,27
   TVLCT,r,g,b,/get
   r(11)=10
   g(11)=10
   b(11)=10
   r(20)=10
   g(20)=10
   b(20)=10
   r(29)=10
   g(29)=10
   b(29)=10
   r(39)=10
   g(39)=10
   b(39)=10
   r(48)=10
   g(48)=10
   b(48)=10
   TVLCT,r,g,b
  end
  If (PltTyp GE 3) Then $  ; Azi/Elli
  Begin
   LoadCT,10
   TVLCT,[255],[255],[255],0
   TVLCT,[0],[0],[0],!D.N_Colors
   LC=!d.n_colors
  end
  If PltTyp EQ 5 Then $
  Begin
   Loadct,6
   TVLCT,[255],[255],[255],0
   YAx=1
  end
 End
 If (PCol EQ 2) Then $
 Begin
  LoadCT,0   ; Load Black/White Linear
  Rd1=IntArr(NCol)
  Gr1=IntArr(NCol)
  Bl1=IntArr(NCol)
  TVLCT,Rd,Gr,Bl,/Get  ; Get Colour Tables
  For i=0,NCol-1 do $
  Begin
   Rd1(i)=Rd(NCol-1-i)
   Gr1(i)=Gr(NCol-1-i)
   Bl1(i)=Bl(NCol-1-i)
  End
  TVLCT,Rd1,Gr1,Bl1  ; Load Reversed B/W System
  LC=NCol
 End
 ;
 ; Set Y Offsets
 ;
 If (kk EQ 2) Then YOffspg=10.0
 If (kk EQ 3) Then YOffspg=18.5
 XSz=10     ; Spectra size (excluding colour bar) cm
 YSz=6.0      ; cm
 XSzp=XSz*1000
 YSzp=YSz*1000
 XOffsp=XOffspg*1000  ; in pixels
 YOffsp=YOffspg*1000  ; in pixels
 Device,Bits_per_pixel=8    ; set to 8 for final
 Bt=RngH-RngL
 Bt1=!D.Table_Size
 For i=0,Nx-1 do $
 Begin
  For j=0,Ny-1 do $
  Begin
   Nm=Bt1*(DispArr(i,j)-RngL)/Bt
   If (Nm LT 0) Then Nm=0
   If (Nm GE Bt1) Then Nm=Bt1-1
   DispArr(i,j)=Nm
  End
 End
 ;
 ; Print Picture in selected colour table
 ;
 Tv,Congrid(DispArr,500,300,/Interp,/Minus_one),$
  XOffspg,YOffspg,XSize=XSz,YSize=YSz,/CENTIMETERS
 ;
 ; Print Colour code bar
 ;
 CScl=IntArr(1,!d.n_colors)
 For i=0,!d.n_colors-1 do CScl(0,i)=i
 XOffscl=XOffspg+XSz+0.5 ; Set bar X position
 XSzb=1         ; Colour bar width in cm
 YSzb=YSz       ; Colour bar height in cm
 Tv,Congrid(CScl,10,300,/Interp),$
  XOffscl,YOffspg,XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ; Set colour to black for axes
 LoadCT,0
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffsp,YOffsp],/Device,Color=LC
 Rng=RngH-RngL
 PPRng=YSzbp/Rng
 RngD=Rng/10.0
 Inc=10.0
 Print,'Current Increment [for 10 Divs] is ',RngD
 Print,'Enter Required Increment : '
 Read,Inc
 PInc=Fix(PPRng*Inc)
 X11=XRHp
 X12=XRHp+100
 X22=XRHp+150
 NYTics=Fix(YSzbp/PInc)
 CBy=YOffsp
 For ii=0,NYTics do $
 Begin
  Lab=RngL+ii*Inc
  If (Lab LE RngH) Then $
  Begin
   If (ABS(Lab) LE 1.0) Then $
    SMn=String(Lab,Format="(F4.2)") Else $
    SMn=String(Lab,Format="(F4.0)")
   If (PltTyp EQ 1) Then SMn=String(Lab,Format="(F5.0)")
   Plots,[X11,X12],[CBy,CBy],/Device,Color=LC
   XYOuts,X22,CBy-100,SMn,Orientation=0,/Device,Color=LC
   CBy=Cby+PInc
  end
 End
; Colour bar Title
 XCl=X22+1500
 CbLng=StrLen(CbTtle)*200
 YPos=YOffsp+Fix(YSzbp/2)-Fix(CbLng/2)-50
 XYOuts,XRHp+1500,YPos,CbTtle,Orientation=90,/Device,Color=LC
;
 Print,'Printing Axes...'
 Plots,XOffsp,YOffsp,/Device,Color=LC
;
;  X axis  ( TIME )
;
 Plots,[XOffsp,XOffsp+XSzp],[YOffsp,YOffsp],/Device,Color=LC
 Plots,XOffsp,YOffsp,/Device,Color=LC
 TmDiff=(XRngH-XRngL)/3600.0           ; In Hours
 PxPerHr=Float(XSzp)/Float(TmDiff)
 If (TmDiff GT 6) Then $
 Begin
  TicInc=Fix(PxPerHr)      ; 1 Hour Incs
  TInc=3600
 End
 If (TmDiff LE 6) Then $
 Begin
  If (TmDiff GT 3) Then $
  Begin
   TicInc=Fix(PxPerHr/2)    ; 1/2 Hour Incs
   TInc=1800
  End
 End
 If (TmDiff LE 3) Then $
 Begin
  If (TmDiff GT 1) Then $
  Begin
   TicInc=Fix(PxPerHr/6)    ; 10 Min Incs
   TInc=600
  End
 End
 If (TmDiff LE 1) Then $
 Begin
  TicInc=Fix(PxPerHr/30)    ; 2 Min Incs
  TInc=120
 End
 NTics=Fix(XSzp/TicInc)
 NLabs=NTics
 If (TicInc LT 3000) Then $
 Begin
  LBSkip=Fix(3000/TicInc+0.9)
  NLabs=Fix(NLabs/LBSkip)
  TInc=TInc*LBSkip
 End
 Tme=XRngL
 For i=0,NTics do $
 Begin
  j=XOffsp+i*TicInc
  Plots,[j,j],[YOffsp,YOffsp-100],/Device,Color=LC
 End
 For i=0,NLabs do $
 Begin
  j=XOffsp+(i*TicInc*LBSkip)
  Plots,[j,j],[YOffsp,YOffsp-200],/Device,Color=LC
  TLab=XTLab(Tme)
  XYOuts,j,YOffsp-600,TLab,Alignment=0.5,/Device,Color=LC
  Tme=Tme+TInc
 end
;
; Print titles
;
 XTtle='Time [LT]'
 XLnTtle=StrLen(XTtle)*200
 XPos=XOffsp+Fix(XSzp/2)-Fix(XLnTtle/2)-50
 XYOuts,XPos,YOffsp-1100,XTtle,/Device,Color=LC
 Plots,XOffsp,YOffsp,/Device,Color=LC
 ; Graph Title
 LnTtle=StrLen(TTle)*200
 XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
 XYOuts,XPos,YOffsp-1700,TTle,/Device,Color=LC
 Plots,XOffsp,YOffsp,/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffsp,YOffsp+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffsp,/Device,Color=LC
 If YAx EQ 0 Then $
 Begin
  If (Scl EQ 1) Then $     ; Linear Frequency Axis
  Begin
   FreInc=(YRngH-YRngL)*100.0    ; i.e. *1000/10
   Fre=YRngL*1000.0
   For i=1,11 do $
   Begin
    j=YOffsp+(i-1)*Fix(YSzp/10)
    Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC
    FrLab=YFLab(Fre)
    XYOuts,XOffsp-1150,(j-100),FrLab,Orientation=0,/Device,Color=LC
    Fre=Fre+FreInc
   End
  End
 End
 If YAx EQ 1 Then $   ; SuperDARN Y Axis for Range-Time plot
 Begin
  FreInc=(YRngH-YRngL)/10
  Fre=YRngL
  For i=1,11 do $
  Begin
   j=YOffsp+(i-1)*Fix(YSzp/10)
   Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC
   FrLab=String(Fre,Format="(F5.0)")
   XYOuts,XOffsp-1150,(j-100),FrLab,Orientation=0,/Device,Color=LC
   Fre=Fre+FreInc
  End
 End
 If (Scl EQ 2) Then $
 Begin
  CFreq=YRngH
  NumFr=0
  REPEAT Begin
   NumFr=NumFr+1
   FLog=ALOG(CFreq)-0.25*ALOG(2)
   CFreq=Exp(FLog)
   End $
  UNTIL (CFreq LE YRngL)
  FrAx=DblArr(NumFr)
  WvC=0.25*ALOG(2)
  Fr=YRngH
  For ij=0,NumFr-1 do $
  Begin
   FrAx(ij)=Fr*1000.0
   Fr1=ALOG(Fr)-WvC
   Fr=Exp(Fr1)
  End
  For i=0,NumFr-1 do $
  Begin
   j=YOffsp+i*Fix(YSzp/(NumFr-1))
   Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC
   FrLab=YFLab(FrAx(NumFr-1-i))
   XYOuts,XOffsp-1150,(j-100),FrLab,Orientation=0,/Device,Color=LC
  End
 End
;
; Y Title
;
 YLnTtle=StrLen(YTtle)*200
 YPos=YOffsp+Fix(YSzp/2)-Fix(YLnTtle/2)-50
 XYOuts,XOffsp-1300,YPos,YTtle,Orientation=90,/Device,Color=LC
End
Device,/Close
Print,'Output File = ',OutF
!P.CharThick=1.0
Print,'Finished'
end
