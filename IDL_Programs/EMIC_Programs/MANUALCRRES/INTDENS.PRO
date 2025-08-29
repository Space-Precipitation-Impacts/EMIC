; Program to Interpolate and plot
; density data from FLR
;
;
FUNCTION XTLab,axis,index,value
Ti=value*3600
Hour=Ti/3600
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
;   Main Program
;
NPnts=76     ; SEE File List Below
ARZ=50        ; Z Rotation Angle [30]
ChSz=1.5      ; Character Size
PiSz=50       ; Size of interpolated array
Ttle='Plasma Density [June 7, 1990]'
;Ttle='Resonant Frequency [June 7, 1990]'
XTtle='Time (UT)'
YTtle='Distance (Re)'
ZTtle='Density /cm^3' ;'Frequency (mHz)'
Xs=FltArr(NPnts)  ; Time
Ys=FltArr(NPnts)  ; Zgsm=0, L
Wr=FltArr(NPnts)  ; Res Freq
Zs=FltArr(NPnts)  ; Density
;OpenR,u,'C:\IDL\LIB\COLIN\orb878.txt',/Get_Lun  ;39
;OpenR,u,'C:\IDL\LIB\COLIN\d158fr.TXT',/Get_Lun  ;70
;OpenR,u,'C:\IDL\LIB\COLIN\OCT693.PLA',/Get_Lun  ;111
;OpenR,u,'C:\IDL\LIB\COLIN\OCT793.PLA',/Get_Lun  ;261
OpenR,u,'C:\IDL\LIB\COLIN\JN790.PLA',/Get_Lun   ;76
For i=0,NPnts-1 do $
Begin
 ReadF,u,n1,n2,n3,n4
 Xs(i)=n1    ; Time
 Wr(i)=n2    ; Resonant Frequency
 Ys(i)=n3    ; Distance
 Zs(i)=n4    ; Density
end
Free_lun,u
MnX=Min(Xs)
MxX=Max(Xs)
XSp=(MxX-MnX)/PiSz
MnY=Min(Ys)
MxY=Max(Ys)
YSp=(MxY-MnY)/PiSz
x=FltArr(PiSz)
y=FltArr(PiSz)
yb=FltArr(PiSz)
For i=0,PiSz-1 do $
Begin
 x(i)=MnX+i*XSp
 y(i)=MxY-i*YSp
 yb(i)=MnY+i*YSp
end
Triangulate,Xs,Ys,Tr
; If subtract R^-4 then
sr=0
Print,'Subtract R^-4 from Data [1=YES] :'
Read,sr
If sr EQ 1 Then $
Begin
 Rzer=10.427
 rho0=0.66
 For i=0,NPnts-1 do $
 Begin
  r1=(Rzer/ys(i))^4
  zs(i)=zs(i)-rho0*r1
 end
end
IArr=FltArr(PiSz,PiSz)
JArr=Trigrid(xs,ys,zs,Tr,/QUINTIC)
For ii=0,PiSz-1 do $
Begin
 For jj=0,PiSz-1 do IArr(ii,jj)=JArr(ii,jj)
end
PTyp=1
Print,'Enter Plot Type'
Print,'1=3-D BW, 2=2D Colour, 3=Contour :'
Read,PTyp
Set_Plot,'WIN'
If (PTyp EQ 1) Then $
Begin
 Window,0
 Erase
 Loadct,0
 Shade_surf,IArr,x,y,AZ=ARZ,XStyle=6,$
  YStyle=6,YRange=[Min(y),Max(y)],ZStyle=5
 Shade_surf,IArr,x,y,/nodata,/noerase,$
  Title=Ttle,$
  XTitle=XTtle,XStyle=2,$
  YTitle=YTtle,YRange=[Max(y),Min(y)],YStyle=2,$
  ZTitle=ZTtle,ZStyle=1,$
  AZ=ARZ,CharSize=ChSz
  Lv=IntArr(21)
  For i=0,20 do Lv(i)=i
   contour,IArr,x,yb,levels=Lv,$
   XRange=[MnX,MxX],XStyle=1,YRange=[MnY,MxY],$
   XTitle=XTtle,YTitle=YTtle,Title=Ttle,/C_Annotation,/spline,/noerase
end
If (PTyp EQ 2) Then $
Begin
 Scl=1
 REPEAT Begin
  PAgn=0
  Print,'Minimum Z is ',Min(zs)
  Print,'Maximum Z is ',Max(zs)
  Print,'Enter Minimum for Plot :'
  Read,RngL
  Print,'Enter Maximum for Plot :'
  Read,RngH
  Window,0
  Erase
  LoadCT,27
  DYNTV,IArr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
   XRange=[MnX,MxX],YRange=[MnY,MxY],$
   Scale=Scl,Range=[RngL,RngH],Aspect=1.5
  Print,'Another Plot at Different Colour Range [0=YES]'
  Read,Agn1
  PAg=Agn1 NE 0
 end UNTIL PAg
 DoCur=0
 Print,'Activate CURSOR [1=YES] :'
 Read,DoCur
 If (DoCur EQ 1) Then $
 Begin
  Print,'Press LEFT Button to Get Values'
  Print,'Press RIGHT Button when Finished'
  Lb=' '
  Tme=0.0
  XAp=1
  YAp=1
  REPEAT Begin
   Cursor,x1,y1,/data,/down
   XYOuts,10,10,color=[0],Lb,/device    ; Black
   XAp=Fix((x1-MnX)/XSp)
   If XAp LT 0 Then XAp=0
   If XAp GE PiSz Then XAp=PiSz-1
   YAp=Fix((y1-MnY)/YSp)
   If YAp LT 0 Then YAp=0
   If YAp GE PiSz Then YAp=PiSz-1
   Dens=IArr(XAp,YAp)
   Tme=x1*3600.0
   TLab=Tim(Tme)
   Lb=TLab+' '+StrTrim(String(y1),2)+' Re ' $
      +StrTrim(String(Dens),2)+' H per cc'
   color=!d.n_colors-1
   XYOuts,10,10,color=[235],Lb,/device   ; White
   GOut=(!err EQ 4)
  End UNTIL GOut
 End
end
If (PTyp EQ 3) Then $
Begin
 Window,0
 Erase
 MxLv=20
 MnLv=0
 LvInc=1
 NLvs=Fix((MxLv-MnLv)/LvInc)+1
 Lv=IntArr(NLvs)
 Lv(0)=MnLv
 For jj=1,NLvs-1 do Lv(jj)=Fix(jj)*LvInc
 NCol=!D.n_colors
 Loadct,0
 TVLCT,[255,0],[255,0],[255,0]
 !P.color=1
 contour,IArr,x,yb,levels=Lv,$
   XRange=[MnX,MxX],XStyle=1,YRange=[MnY,MxY],$
   XTitle=XTtle,YTitle=YTtle,Title=Ttle,/C_Annotation
end
PicYN=0
Print,'Write Picture to File ? [1=YES] :'
Read,PicYN
If (PicYN EQ 1) Then $
Begin
 FName=''
 Print,'Enter Output File Name : '
 Read,FName
 OpenW,u,FName(0),/Get_Lun
 PrintF,u,PiSz,PiSz
 PrintF,u,Ttle
 PrintF,u,XTtle
 PrintF,u,YTtle
 PrintF,u,MnX*3600,MxX*3600
 PrintF,u,MnY/1000.0,MxY/1000.0
 PrintF,u,Scl
 PrintF,u,RngL,RngH
 PrintF,u,IArr
 Free_Lun,u
End
Print,'Finished'
end