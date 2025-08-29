;  Program to print Fig of GRL paper, 1999
;
; C. Waters September, 1999
;
FUNCTION XTLab,value
Ti=value
Hour=Long(Ti)/3600
Minute=Long(Ti-3600*Hour)/60
Secn=Ti-3600*Hour-60*Minute
RETURN,String(Hour,Format="(I2)")
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
Pro fig4psb
XSz=5.7   ; Picture is this [cm] wide, not including axes and colour bar
YSz=4.7    ; Picture height
XOffs=3    ; cm
YOffs=5   ; cm   ; First Picture Y Pos
YOffsp=1000*YOffs*0
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000*0  ; in pixels

Pth='C:\paul\honours\canopus\programs\'
Print,'Colour [=1] or B/W Plot [=2]'
;Read,PCol
PCol=2
;
Print,'PostScript Print Spectra Program'
OutF=' '
;Print,'Enter Output File Name : [*.PS]'
;Read,OutF
OutF=Pth+'fig4b.ps'
PTTle=' '
;Print,'Enter Picture Title : '
;Read,PTTle
Set_Plot,'PS'
!P.Charthick=2.0  ; Set PS Character Thickness
!P.CharSize=0.8
Device,Filename=OutF,/Portrait
Device,XSize=XSz  ; cm
Device,YSize=YSz  ; cm
Device,/color  ;Set for both
Device,XOffset=XOffs
Device,YOffset=YOffs
!p.noerase=1
NCol=!d.N_Colors
;
FName=''
Ttle=''
XTtle=''
YTtle=''
XRngL=Long(1) & XRngH=Long(1)
YRngL=1.0 & YRngH=1.0
Print,'Enter Input Data File Name...'
FName=Pth+'fig4bdn.txt' ;PickFile(/READ,Filter='*.*')
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
YTtle='R!dE!n'
;
LC=!d.N_Colors
CbTtle=''
CbTtle='Density [H!u+!ncm!u-3!n]'
If (PCol EQ 1) Then $
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
;Disparr=disparr+30.

SZ = SIZE(Congrid(DispArr,500,300,/Interp,/Minus_one))
PX = !P.Position
PY = !P.Position
Xoffs=0
Yoffs=0
Tv,Congrid(DispArr,500,300,/Interp,/Minus_one),$
Xoffs,Yoffs,XSize=XSz,YSize=YSz,/CENTIMETERS
lev=[5.,10.,30.,100.,200.]
Contour,Congrid(DispArr,500,300,/Interp,/Minus_one),$
POSITION = [0,0, 1, 1],$
levels=lev,C_Labels=[1,1,1,0,0],YStyle=1,$
C_Linestyle=(lev lt 0.0),c_thick=2,c_charthick=2,$
c_colors=[200,200,200,200,200],c_charsize=0.6,/FOLLOW
Wait,0.5
;
Filnam=Pth+'fig4btr.txt'
Pnts = 0
OpenR,u,Filnam,/Get_Lun
;
Pnts = 41
;
Xm = Fltarr(Pnts) ; time
Ym = Fltarr(Pnts) ; latitude
m1=0.0 & m2=0.0
For j=0, Pnts -1 do $
Begin
 ReadF, u, m1,m2
 Xm(j)=m1
 Ym(j)=m2
end
Free_lun,u
; Plot CRRES Trace
XFac=XSz*1000.*3600./(XRngH-XRngL)
YFac=YSz/(YRngH-YRngL)
For ii=0,Pnts-1 do $
Begin
 Xp=(Xm(ii)-XRngL/3600.)*XFac;+XOffsp
 Yp=(Ym(ii)-YRngL*1000.)*YFac;+YOffsp
 If Xm(ii) GE XRngL/3600. Then $
 Begin
  If Xm(ii) LE XRngH/3600. Then $
  Begin
   If Ym(ii) GE YRngL*1000. Then $
   Begin
    If Ym(ii) LE YRngH*1000. Then $
    Begin
     XYOuts,Xp,Yp,'*',/Device,Color= 236
    end
   end
  end
 end
end
;
;Do Colour Bar
;
CScl=IntArr(1,!d.n_colors)
For i=0,!d.n_colors-1 do CScl(0,i)=i
;XOffscl=0+XSz+0.2 ; Set bar X position
XOffscl=XOffs+XSz+0.2 ; Set bar X position
XSzb=0.4         ; Colour bar width in cm
YSzb=YSz       ; Colour bar height in cm
Tv,Congrid(CScl,10,300,/Interp),$
;XOffscl,0,XSize=XSzb,YSize=YSzb,/CENTIMETERS
XOffscl,YOffs,XSize=XSzb,YSize=YSzb,/CENTIMETERS
Xsclp=Xoffscl*1000
YSzbp=YSzb*1000
;
; Change Colour for AXES etc.
;
LoadCT,0
LC=0
; Draw LH vertical line on colour bar
;Plots,[XSclp,Xsclp],[0,0+YSzbp],/Device,Color=LC
Plots,[XSclp,Xsclp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
; Draw RH vertical line on colour bar
XRHp=XSclp+XSzb*1000
;Plots,[XRHp,XRHp],[0,0+YSzbp],/Device,Color=LC
Plots,[XRHp,XRHp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
; Draw line along bottom of colour bar
;Plots,[XSclp,XRHp],[0,0],/Device,Color=LC
Plots,[XSclp,XRHp],[YOffsp,YOffsp],/Device,Color=LC
Rng=RngH-RngL
PPRng=YSzbp/Rng
RngD=Rng/10.0
;Inc=10.0
Print,'Current Increment [for 10 Divs] is ',RngD
Print,'Enter Required Increment : '
;Read,Inc
Inc=100.0
PInc=Fix(PPRng*Inc)
X11=XRHp
X12=XRHp+100
X22=XRHp+150
NYTics=Fix(YSzbp/PInc)
;CBy=YOffsp
CBy=0
;
RngL=0.
;
For ii=0,NYTics do $
Begin
 Lab=RngL+ii*Inc
 If (Lab LE RngH) Then $
 Begin
  If (ABS(Lab) LE 1.0) Then SMn=String(Lab,Format="(I1)") Else $
   SMn=String(Lab,Format="(I3)")
  Plots,[X11,X12],[CBy,CBy],/Device,Color=LC
  XYOuts,X22,CBy-100,SMn,Orientation=0,/Device,Color=LC
  CBy=Cby+PInc
 end
End
; Colour bar Title
XCl=X22+1500
CbLng=StrLen(CbTtle)*200
;YPos=0+Fix(YSzbp/2)-Fix(CbLng/2)+750
YPos=YOffsp+Fix(YSzbp/2)-Fix(CbLng/2)+750
XYOuts,XRHp+1000,YPos,CbTtle,Orientation=90,/Device,Color=LC
;
Print,'Printing Axes...'

;Plots,XOffsp,YOffsp,/Device,Color=LC
;  X axis  ( TIME )
Plots,[XOffsp,XOffsp+XSzp],[YOffsp,YOffsp],/Device,Color=LC
;Plots,XOffsp,YOffsp,/Device,Color=LC
LbSkip=1
; Time Axis
TmDiff=(XRngH-XRngL)/3600.0           ; In Hours
PxPerHr=Float(XSzp)/Float(TmDiff)
;
TicInc=Fix(PxPerHr)    ; 1 Hour Incs
TInc=3600
;
NTics=Fix(XSzp/TicInc)
NLabs=5
If (TicInc LT 3000) Then $
Begin
; LBSkip=Fix(3000/TicInc+0.9)
; NLabs=Fix(NLabs/LBSkip)
 LBSkip=3
 TInc=TInc*LBSkip
End
Tme=long(36000)   ; 0900 UT
Print,'XRange Values:',xrngl,xrngh
;
Inf1=0.3242*PxPerHr
;
For i=0,NTics-1 do $
Begin
 j=XOffsp+Inf1+i*TicInc
 Plots,[j,j],[YOffsp,YOffsp-100],/Device,Color=LC  ; Tic Marks
End
For i=0,NLabs-1 do $
Begin
 j=XOffsp+Inf1+(i*TicInc*LbSkip)
 Plots,[j,j],[YOffsp,YOffsp-200],/Device,Color=LC
 TLab=XTLab(Tme)
 XYOuts,j,YOffsp-450,TLab,Alignment=0.5,/Device,Color=LC  ; X Axis Labels [Re]
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
XYOuts,XPos,YOffsp-900,XTtle,/Device,Color=LC
;
;XYouts,XPos+700,YOffsp(kk)-1700,'(b)',/Device,Color=LC
;
;print,yszp
;print,xszp
LnTtle=StrLen(TTle)*200
XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
;XYOuts,XPos,YOffsp-2000,TTle,/Device,Color=LC
Plots,XOffsp,YOffsp,/Device,Color=LC
;
; Y Axis
;
Plots,[XOffsp,XOffsp],[YOffsp,YOffsp+Yszp],/Device,Color=LC
Plots,XOffsp,YOffsp,/Device,Color=LC
yinc=1.0
PixperRe=Ysz/(YRngH-YRngL)
Ntm=Fix(YSzp/PixperRe)+1
Print,'PixperRe=',PixperRe
Print,'YRange=',YRngL*1000.,YRngH*1000.
Print,'YSz=',Ysz
Fre=4.5
;
yof=0.0*pixperre
;
For i=1,Ntm do $
Begin
 j=YOffsp+(i-1)*Fix(PixperRe)*yinc+yof
 Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
 FrLab=YLab(Fre)
 XYOuts,XOffsp-1000,(j-100),FrLab,Orientation=0,/Device,Color=LC
 Fre=Fre+yinc
End
; Y Axis Title Position
XYOuts,XOffsp-800,YOffsp+YSzp/2-300,YTtle,Orientation=90,/Device,Color=LC
Device,/Close
!P.Charthick=1.0
Print,'Output File = ',OutF
Print,'Finished'
end
