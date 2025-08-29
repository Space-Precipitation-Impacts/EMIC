;  Program to print (PS) Dynamic power and
; Cross Phase Plots after being saved by
; the various programs
;
; C. Waters September, 1993
;
; Last Modified:
; * May, 1994 to take B/W Plots
; through Ghostscript and the LaserJet
; * Dec 1995 for Fine Structure plots
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
FUNCTION YFLab,value
 Fr=value
 If fr LE 1e-6 then lb=0.0
 If fr GT 1e-6 then lb=1.0/Fr
RETURN,String(lb,Format="(F4.1)")
end
;
Function YLab,Val
Return,String(Val,Format="(F5.1)")
End
;
; Main Program
;
Pro Gdpicps
XSz=12   ; Picture is this [cm] wide, not including axes and colour bar
YSz=8    ; Picture height
XOffs=2    ; cm
YOffs=IntArr(2)
YOffsp=IntArr(2)
YOffs(0)=2   ; cm   ; First Picture Y Pos
YOffs(1)=14  ; cm   ; Second Picture
YOffsp=1000*YOffs
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels
;
Print,'PostScript Print Spectra Program'
Print,'How Many Plots [1 or 2] :'
Read,NPlts
OutF=' '
Print,'Enter Output File Name : [*.PS]'
Read,OutF
PTTle=' '
;Print,'Enter Picture Title : '
;Read,PTTle
PCol=1
Set_Plot,'PS'
!P.Charthick=3.0  ; Set PS Character Thickness
Device,Filename=OutF,/Portrait
Device,XSize=18  ; cm
Device,YSize=24  ; cm
Device,/color  ;Set for both
Device,XOffset=XOffs
Device,YOffset=YOffs(0)
!p.noerase=1
NCol=!d.N_Colors
;
For kk=0,NPlts-1 do $
Begin
 Print,'Colour [=1] or B/W Plot [=2]'
 Read,PCol
 FName=''
 Ttle=''
 XTtle=''
 YTtle=''
 XRngL=Long(1) & XRngH=Long(1)
 YRngL=1.0 & YRngH=1.0
 Print,'The bottom Picture is File 1'
 Print,'Enter Input Data File Name ',kk+1
 FName=PickFile(/READ,Filter='*.*')
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
 Print,'3=X:Re & Y:Frequency [Fine Structure Plots]'
 Print,'4=Azimuth'
 Print,'5=Ellipticity'
 Print,'6=FFT of Power Spectra'
 Print,'Enter Selection [0-6]:'
 Read,PltTyp
 If (PltTyp GE 2) Then LC=!d.N_Colors
 CbTtle=''
 Case PltTyp of
  0:Begin $
     Print,'Enter Colour Bar Label for this File :'
     Read,CbTtle
    end
  1:CbTtle='Phase [Degrees]'
  2:CbTtle='Density [H+/cm^3]'
  3:Begin $
     Print,'Enter Colour Bar Label for this File:'
     Read,CbTtle
    end
 4:CbTitle='Azimuth'
 5:CbTtle='Ellipticity'
 6:Begin $
    CbTtle='FFT[Power]'
    YRngL=YRngL*1000.
    YRngH=YRngH*1000.
   end
 end
 If (PCol EQ 1) Then $
 Begin
  If (PltTyp EQ 0) Then LoadCT,20
  If (PltTyp EQ 6) Then LoadCT,20
  If (PltTyp EQ 1) Then GetPhCps
  If (PltTyp EQ 3) Then LoadCT,27
  If (PltTyp EQ 2) Then $
  Begin
   LoadCT,27
   TVLCT,r,g,b,/get
   r(11)=10 & g(11)=10 & b(11)=10
   r(20)=10 & g(20)=10 & b(20)=10
   r(29)=10 & g(29)=10 & b(29)=10
   r(39)=10 & g(39)=10 & b(39)=10
   r(48)=10 & g(48)=10 & b(48)=10
   TVLCT,r,g,b
  end
  If (PltTyp EQ 4) OR (PltTyp EQ 5) Then $  ; Azi/Elli
  Begin
   LoadCT,10
   TVLCT,[255],[255],[255],0
   TVLCT,[0],[0],[0],!D.N_Colors
  end
 End
 If (PCol EQ 2) Then $
 Begin
  DoinBW   ; Load Black/White Linear
  LC=NCol
 End
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
 ; Print picture
 Tv,Congrid(DispArr,500,300,/Interp,/Minus_one),$
 XOffs,YOffs(kk),XSize=XSz,YSize=YSz,/CENTIMETERS
 Wait,0.5
 If Plttyp EQ 2 then $
 begin
  Filnam = Pickfile (Title = ' FootPrint Filename', Filter = '*.*')
  Pnts = 0
  OpenR,u,Filnam,/Get_Lun
  ;Begin
   ;Repeat Begin
    ;ReadF,u,m1,m2
    ;Pnts = Pnts+1

   ;EndRep Until eof(u)
  ;Endelse
  ;Pnts = Pnts -1
   Pnts = 41
  Point_Lun,u,0
  Xm = Fltarr(Pnts) ; time
  Ym = Fltarr(Pnts) ; latitude
  For j=0, Pnts -1 do $
  Begin
   ReadF, u, m1,m2
   Xm(j)=m1
   Ym(j)=m2
  end
  Free_lun,u
  XFac=XSz*1000.*3600./(XRngH-XRngL)
  YFac=YSz/(YRngH-YRngL)
  For ii=0,Pnts-1 do $
  Begin
   Xp=(Xm(ii)-XRngL/3600.)*XFac+XOffsp
   Yp=(Ym(ii)-YRngL*1000.)*YFac+YOffsp(kk)
   If Xm(ii) GE XRngL/3600. Then $
    If Xm(ii) LE XRngH/3600. Then $
     If Ym(ii) GE YRngL*1000. Then $
      If Ym(ii) LE YRngH*1000. Then $
       XYOuts,Xp,Yp,'*',/Device,Color= 100
  end
 end
 ;
 ; Do Colour Bar
 ;
 CScl=IntArr(1,!d.n_colors)
 For i=0,!d.n_colors-1 do $
  CScl(0,i)=i
 XOffscl=XOffs+XSz+0.5 ; Set bar X position
 XSzb=1         ; Colour bar width in cm
 YSzb=YSz       ; Colour bar height in cm
 Tv,Congrid(CScl,10,300,/Interp),$
  XOffscl,YOffs(kk),XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ;
 ; Change Colour for AXES etc.
 ;
 LoadCT,0
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffsp(kk),YOffsp(kk)+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffsp(kk),YOffsp(kk)+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffsp(kk),YOffsp(kk)],/Device,Color=LC
 If PltTyp EQ 6 Then $
 Begin
  RngH=RngH/1.e7
  RngL=RngL/1.e7
 end
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
 CBy=YOffsp(kk)
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
 YPos=YOffsp(kk)+Fix(YSzbp/2)-Fix(CbLng/2)-50
 XYOuts,XRHp+1500,YPos,CbTtle,Orientation=90,/Device,Color=LC
 ;
 Print,'Printing Axes...'
 Plots,XOffsp,YOffsp(kk),/Device,Color=LC
;  X axis  ( TIME )
 Plots,[XOffsp,XOffsp+XSzp],[YOffsp(kk),YOffsp(kk)],/Device,Color=LC
 Plots,XOffsp,YOffsp(kk),/Device,Color=LC
 LbSkip=1
 If (PltTyp NE 3) Then $   ; Time Axis
 Begin
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
 end
 Inf1=0.0
 If (PltTyp EQ 3) Then $  ; Earth Radii [Re] Axis
 Begin
  RRng=XRngH-XRngL
  PxPerRng=Float(XSzp/RRng)
  Inf1=(1.5-XRngL)*PxPerRng   ; Pixels in from 1.5Re
  NTics=17
  TicInc=Fix((XSzp-Inf1)/17.0)
  NLabs=8
  TInc=1.0
  LbSkip=2
  Tme=1.5
 end
 For i=0,NTics do $
 Begin
  j=XOffsp+Inf1+i*TicInc
  Plots,[j,j],[YOffsp(kk),YOffsp(kk)-100],/Device,Color=LC  ; Tic Marks
 End
 For i=0,NLabs do $
 Begin
  j=XOffsp+Inf1+(i*TicInc*LbSkip)
  Plots,[j,j],[YOffsp(kk),YOffsp(kk)-200],/Device,Color=LC
  If (PltTyp EQ 3) Then $
  Begin
   TLab=StrTrim(String(Tme,Format="(f4.1)"))
  end Else $
  TLab=XTLab(Tme)
  XYOuts,j-50,YOffsp(kk)-600,TLab,Alignment=0.5,/Device,Color=LC  ; X Axis Labels [Re]
  Tme=Tme+TInc
 end
;
; Print titles
;
; XYOuts,10,20,PTTle,/Device,Color=LC,charsize=3
;
; Do X Axis Title
 XTtle='Time [UT]'
 XLnTtle=StrLen(XTtle)*200
 XPos=XOffsp+Fix(XSzp/2)-Fix(XLnTtle/2)-50
 XYOuts,XPos,YOffsp(kk)-1200,XTtle,/Device,Color=LC
;
;XYouts,XPos+700,YOffsp(kk)-1700,'(b)',/Device,Color=LC
;
 LnTtle=StrLen(TTle)*200
 XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
 XYOuts,XPos,YOffsp(kk)-2000,TTle,/Device,Color=LC
 Plots,XOffsp,YOffsp(kk),/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffsp(kk),YOffsp(kk)+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffsp(kk),/Device,Color=LC
 If (PltTyp EQ 3) Then $    ; For [Re] Plots
 Begin
  FreInc=10.0
  Fre=0.0
  For i=1,7 do $
  Begin
   j=YOffsp(kk)+(i-1)*Fix(YSzp/7)
   Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC
   FrLab=YLab(Fre)
   XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
   Fre=Fre+FreInc
  end
 endif $       ; If Fine Structure Plots
 Else $
 If (PltTyp EQ 6) Then $
 Begin
  FreInc=(YRngH-YRngL)/10.0
  PixperRe=FreInc*YSzp/(YRngH-YRngL)
  Ntm=Fix(YSzp/PixperRe)+1
  Fre=YRngL
  For i=1,Ntm do $
  Begin
   j=YOffsp(kk)+(i-1)*Fix(PixperRe)
   Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
   FrLab=YFLab(Fre)
   XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
   Fre=Fre+FreInc
  End
 Endif $
 Else $
 Begin $
  If (Scl EQ 1) Then $     ; Linear Frequency Axis
  Begin
   If (PltTyp NE 3) Then $
   Begin
    FreInc=(YRngH-YRngL)*100.0    ; i.e. *1000/10
    If (PltTyp EQ 2) Then PixperRe=Ysz/(YRngH-YRngL) $
    Else PixperRe=FreInc*YSz/(YRngH-YRngL)
    Ntm=Fix(YSzp/PixperRe)+1
    Fre=YRngL*1000.0
    For i=1,Ntm do $
    Begin
     j=YOffsp(kk)+(i-1)*Fix(PixperRe)
     Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
     FrLab=YLab(Fre)
     XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
     Fre=Fre+FreInc
    End
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
    j=YOffsp(kk)+i*Fix(YSzp/(NumFr-1))
    Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC
    FrLab=YLab(FrAx(NumFr-1-i))
    XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
   End
  End
 end
; Y Axis Title Position
 XYOuts,XOffsp-1500,YOffsp(kk)+YSzp/2-1200,YTtle,Orientation=90,/Device,Color=LC
End
Device,/Close
!P.Charthick=1.0
Print,'Output File = ',OutF
Print,'Finished'
end
