; Program to Postscript print (PS) dynamic spectra plots
; after being saved as *.PIC files
; This program was modified from GDPICPS.PRO
; to take 6 pictures and plot them in a 2 x 3 pattern
; on a portrait A4 page for IAGA, Uppsala, Sweden
;
; C. Waters, July, 1997
;
FUNCTION XTLab,value
Ti=value
Hour=Long(Ti)/3600
If Hour GT 24 Then Hour=Hour-24
RETURN,String(Hour,Format="(I2.2)")
end
;
Function YFLab,Val
Return,String(Val,Format="(I2)")
End
;
; Main Program
;   Input Data
;
Print,'PostScript Print Spectra Program'
NPlts=1  ; Number of Plots in 2 x 3 pattern
YPicOffs=DblArr(3)
YPicOffs(0)=4.0 & YPicOffs(1)=12.0 & YPicOffs(2)=20.0
XPicOffs=DblArr(2)
XPicOffs(0)=2.0 & XPicOffs(1)=12.0
XPicSz=6.0     ; Spectra size (excluding colour bar) cm
YPicSz=5     ; Spectra Height in cm
XPicSzp=XPicSz*1000 ; Spectra length in pixels
YPicSzp=YPicSz*1000 ; Spectra height in pixels
;
OutF=' ' & YAx=0
;Print,'Enter Output File Name : [*.PS]'
;Read,OutF
FN=StrArr(6)
;FN(0)='C:\CANOPUS\950204\FEB4IPPH.PIC'
;FN(1)='C:\CANOPUS\950204\FEB4GIPH.PIC'
;FN(2)='C:\CANOPUS\950204\FEB4BGPH.PIC'
;FN(3)='C:\CANOPUS\950204\FEB4FBPH.PIC'
;FN(4)='C:\CANOPUS\950204\FEB4EFPH.PIC'
;FN(5)='C:\CANOPUS\950204\FEB4REPH.PIC'
OutF='C:\CLW\GP6.PS'
For kk=0,NPlts-1 do $
Begin
 FName=''
 Ttle=''
 XTtle=''
 YTtle=''
 Print,'The Bottom LH Picture is File 1'
 FTtle='Select Input Data'
 FName=PickFile(Title=Fttle,Filter='*.PIC')
 FN(kk)=FName
; FName=FN(kk)
 Print,'KK = ',kk
 Print,'Working with ',FN(kk)
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
 If (kk EQ 0) Then $  ; First plot
 Begin
  PCol=1
  Set_Plot,'PS'
  Device,Filename=OutF,/Portrait
  Print,'Colour [=1] or B/W Plot [=2]'
;  Read,PCol
  Device,/color  ;Set for both
  LC=!P.COLOR
  If (PltTyp EQ 2) Then LC=!d.N_Colors
  XSzpg=18     ; cm
  YSzpg=26     ; cm
  Device,XSize=XSzpg
  Device,YSize=YSzpg
  Device,Bits_per_pixel=8    ; set to 8 for final
  Device,Font_Size=10
  Device,XOffset=0
  Device,YOffset=0
  !p.noerase=1
  NCol=!d.N_Colors
 End  ; if first plot
 If (PCol EQ 1) Then $
 Begin
  If (PltTyp EQ 0) Then LoadCT,20
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
 ;  Sort out order of placing pictures
 If KK LE 2 Then $   ; RH edge
 Begin
  XPicOffsp=XPicOffs(1)*1000   ; in pixels
  YPicOffsp=YPicOffs(kk)*1000  ; in pixels
 end
 If KK GT 2 Then $  ; LH edge
 Begin
  XPicOffsp=XPicOffs(0)*1000
  YPicOffsp=YPicOffs(kk-3)*1000
 end
 XPicPos=XPicOffsp/1000
 YPicPos=YPicOffsp/1000
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
; Draw Spectrum here
;
 Tv,Congrid(DispArr,500,300,/Interp,/Minus_one),$
  XPicPos,YPicPos,XSize=XPicSz,YSize=YPicSz,/CENTIMETERS
 Wait,0.5
;
; Do Colour Bar Now so Axes can be done in black
;
 CScl=IntArr(1,!d.n_colors)
 For i=0,!d.n_colors-1 do CScl(0,i)=i
 XOffsb=XPicPos+XPicSz+0.3
 XSzb=0.5         ; Colour Bar width (cm)
 YSzb=YPicSz         ; Colour bar height
 YSzbp=Yszb*1000  ; Colour bar size in Pixels
 Tv,Congrid(CScl,10,300,/Interp),$
  XOffsb,YPicPos,XSize=XSzb,YSize=YSzb,/CENTIMETERS
 ; Set B/W here for Axes etc.
 LoadCT,0
 LC=0
 XPos=Long((XOffsb+XSzb)*1000)
 Plots,[XPos,XPos],[YPicOffsp,YPicOffsp+YSzbp],/Device,Color=LC
 Rng=RngH-RngL
 PPRng=YSzbp/Rng
 RngD=Rng/10.0
 Inc=10.0
 Print,'Current Increment [for 10 Divs] is ',RngD
 Print,'Enter Required Increment : '
 Read,Inc
 PInc=Fix(PPRng*Inc)
 NDiv=Fix(Rng/Inc)
 X11=XPos
 X12=XPos+200
 X22=XPos+250
 Yp=YPicOffsp
 For ii=0,NDiv-1 do $
 Begin
  Lab=RngL+ii*Inc
  If (Lab LE RngH) Then $
  Begin
   If (ABS(Lab) LE 1.0) Then $
    SMn=String(Lab,Format="(F4.1)") Else $
    SMn=String(Lab,Format="(I3)")
   If (PltTyp EQ 1) Then SMn=String(Lab,Format="(F5.0)")
   If (PltTyp EQ 5) Then SMn=String(Lab,Format="(F5.0)")
   Plots,[X11,X12],[Yp,Yp],/Device,Color=LC
   XYOuts,X22,Yp-100,SMn,Orientation=0,/Device,Color=LC
   Yp=Yp+PInc
  end
 End
;
; Colour bar Title
;
 XCl=X22+1000
 CbLng=StrLen(CbTtle)*200
 YPos=YPicOffsp+Fix(YPicSzp/2)-Fix(CbLng/2)-50
 XYOuts,XCl,YPos,CbTtle,Orientation=90,/Device,Color=LC

;
 Print,'Printing Axes...'
;
;  X axis
;
 Plots,[XPicOffsp,XPicOffsp+XPicSzp],[YPicOffsp,YPicOffsp],/Device,Color=LC
 TmDiff=(XRngH-XRngL)/3600.0           ; In Hours
 PxPerHr=Float(XPicSzp)/Float(TmDiff)
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
 NTics=Fix(XPicSzp/TicInc)
 NLabs=NTics
 If (TicInc LT 1500) Then $
 Begin
  LBSkip=Fix(1200/TicInc+0.9)
  NLabs=Fix(NLabs/LBSkip)
  TInc=TInc*LBSkip
 End
 Tme=XRngL
 For i=0,NTics do $
 Begin
  j=XPicOffsp+i*TicInc
  Plots,[j,j],[YPicOffsp,YPicOffsp-100],/Device,Color=LC
 End
 For i=0,NLabs do $
 Begin
  j=XPicOffsp+(i*TicInc*LBSkip)
  Plots,[j,j],[YPicOffsp,YPicOffsp-200],/Device,Color=LC
  TLab=XTLab(Tme)
  XYOuts,j,YPicOffsp-600,TLab,Alignment=0.5,/Device,Color=LC
  Tme=Tme+TInc
 end
;
; Print X-Axis Title
;
 XLnTtle=StrLen(XTtle)*200
 XPos=XPicOffsp+Fix(XPicSzp/2)-Fix(XLnTtle/2)-50
 XYOuts,XPos,YPicOffsp-1100,XTtle,/Device,Color=LC
;
; Print Graph Title above Spectrum
;
LnTtle=StrLen(Ttle)*200
XPos=XPicOffsp+Fix(XPicSzp/2)-Fix(LnTtle/2)-50
YPos=YPicOffsp+YPicSzp+500
XYOuts,XPos,YPos,Ttle,/Device,Color=LC
;
; Y Axis
;
 Plots,[XPicOffsp,XPicOffsp],[YPicOffsp,YPicOffsp+YPicSzp],/Device,Color=LC
; Plots,XPicOffsp,YPicOffsp,/Device,Color=LC
 If YAx EQ 0 Then $
 Begin
  If (Scl EQ 1) Then $     ; Linear Frequency Axis
  Begin
   FreInc=(YRngH-YRngL)*50.0    ; i.e. *1000/20
   Fre=YRngL*1000.0
   For i=1,21 do $
   Begin
    j=YPicOffsp+(i-1)*Fix(YPicSzp/20)
    Plots,[XPicOffsp,XPicOffsp-100],[j,j],/Device,Color=LC
    If (i EQ 1) OR (i EQ 6) OR (i EQ 11) or (i EQ 16) or (i EQ 21) Then $
    Begin
     FrLab=YFLab(Fre)
     XYOuts,XPicOffsp-800,(j-90),FrLab,Orientation=0,/Device,Color=LC
    end
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
   j=YPicOffsp+(i-1)*Fix(YPicSzp/10)
   Plots,[XPicOffsp,XPicOffsp-200],[j,j],/Device,Color=LC
   FrLab=String(Fre,Format="(F5.0)")
   XYOuts,XPicOffsp-1150,(j-100),FrLab,Orientation=0,/Device,Color=LC
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
   Plots,[XPicOffsp,XPicOffsp-200],[j,j],/Device,Color=LC
   FrLab=YFLab(FrAx(NumFr-1-i))
   XYOuts,XPicOffsp-1150,(j-100),FrLab,Orientation=0,/Device,Color=LC
  End
 End
;
; Y Title
;
 YLnTtle=StrLen(YTtle)*200
 YPos=YPicOffsp+Fix(YPicSzp/2)-Fix(YLnTtle/2)-50
 XYOuts,XPicOffsp-1000,YPos,YTtle,Orientation=90,/Device,Color=LC
End
Device,/Close
Print,'Output File = ',OutF
Print,'Finished'
end
