;AUTHOR: Paul Manusiu
;
;PURPOSE: Program to print (PS) Dynamic power and
;
;
Function XTLab,Axis,Index,Values			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Values)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end

FUNCTION XTLabb,value
 seci=Long(Value)
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end
;
Function YLab,Val

Return,String(Val,Format="(F5.1)")
End
;
; Main Program
;
pro spectra_tim_Zps,cm_eph,cm_val,state,Dat5,PoyntArr,CPArr,Fname
;
;Common blocks
;
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4_Z,MnPow_Z,MxPow_Z
common orbinfo,orb,orb_binfile,orb_date
;common Power, DispArr
;common CPow, MxCPow, MnCPow,CPthres,CPArr
;Picture spectifications
;DispArr=0
;stop
OutF=Fname
set_plot,'ps'
tempttle=ttle
;stop
XSz=12   ; Picture is this [cm] wide, not including axes and colour bar
YSz=4    ; Picture height
XOffs=2    ; cm
;YOffs=2
;YOffsp=IntArr(2)
YOffs=[19,14]   ; cm   ; First Picture Y Pos
;YOffs(1)=10  ; cm   ; Second Picture
YOffsp=1000*YOffs
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels

;device,filename=FName,yoffset=3, ysize=23
Device,Filename=OutF,/Portrait,yoffset=3
Device,XSize=18  ; cm
Device,YSize=24  ; cm
Device,/color  ;Set for both
Device,XOffset=XOffs

tempttle=ttle
nname = tag_names(cm_val)

PCol=1
;Set_Plot,'PS'
!P.Charthick=3.0  ; Set PS Character Thickness
yytt=["",""]
yytt[0]='(!Uo!n)'
yytt[1]= '(nT)'
timttle=["",""]
timttle[0]='Orbit'+' '+orb+' '+orb_date+' '+Dat5
;for qq=0,1 do $
;begin
Plot,congrid(cm_val.(0),n_elements(cm_val.(0))/500.0),$
 congrid(cm_val.(14),n_elements(cm_val.(14))/500.0),$
	ytitle=string(nname(14)+yytt[0]),$
 xtickformat='Xtlab',xticks=3,xstyle=1,title=timttle[0],$
pos=[XOffsp,YOffsp(0),XOffsp+XSz*1000,YOffsp(0)+YSz*1000],/noerase,ystyle=1,/device
Plot,cm_val.(0),$
	cm_val.(17),$
	ytitle=string(nname(17)+yytt[1]),$
 xtickformat='Xtlab',xticks=3,xstyle=1,title=timttle[1],$
pos=[XOffsp,YOffsp(1),XOffsp+XSz*1000,YOffsp(1)+YSz*1000],/noerase,ystyle=1,/device
;stop
;
;end

YOffs=[8,2]   ; cm   ; First Picture Y Pos
;YOffs(1)=10  ; cm   ; Second Picture
YOffsp=1000*YOffs
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels
DispArr=dblarr(n_elements(CPArr(*,0)),n_elements(CPArr(0,*)),2)
DispArr[*,*,0]=CPArr
DispArr[*,*,1]=PoyntArr
for q=0,1 do $
 begin

Device,YOffset=YOffs(q)
!p.noerase=1
NCol=!d.N_Colors
PCol=1
 XRngL=cm_val.(0)[0]
 XRngH=cm_val.(0)[n_elements(cm_val.(0))-1]
 ;stop
 YRngH=MxF
 ;stop
 Scl=1
 RngL=mnPow_Z[q]
 RngH=mxPow_Z[q]


 Nx=n_elements(DispArr(*,0,q))
 Ny=n_elements(DispArr(0,*,q))
; stop
if q EQ 0 then $
 begin
CbTtle='Power (dB)'
PltTyp=0
 If (PCol EQ 1) Then $
 Begin
  If (PltTyp EQ 0) Then LoadCT,20
end
 If (PCol EQ 2) Then $
 Begin
  DoinBW   ; Load Black/White Linear
  LC=NCol
 End
 Device,Bits_per_pixel=8    ; set to 8 for final
 end else $
 begin
PltTyp=0
 CbTtle='Flux (!4l!3W/m!U2!n)' ;else $
LoadCT,17
TVLCT,r,g,b,/get
FOR I=0,127 do $
begin
;r(254-fix(i/2))=180+fix(i/4)

r(255-i)=128+i

;b(i)=255
end
r(127)=255
b(127)=255
g(127)=255
r(128)=255
b(128)=255
g(128)=255
r(126)=255
b(126)=255
g(126)=255


 tvlct,r,g,b
endelse
 Bt=RngH-RngL
 Bt1=!D.Table_Size
 For i=0,Nx-1 do $
 Begin
  For j=0,Ny-1 do $
  Begin
   Nm=Bt1*(DispArr[i,j,q]-RngL)/Bt
   ;stop
   If (Nm LT 0) Then Nm=0
   If (Nm GE Bt1) Then Nm=Bt1-1
   DispArr(i,j,q)=Nm
  End
 End
 ;
 ; Print picture
 Tv,Congrid(DispArr[*,*,q],500,300,/Interp,/Minus_one),$
 XOffs,YOffs(q),XSize=XSz,YSize=YSz,/CENTIMETERS
 ;Wait,0.5
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
  XOffscl,YOffs(q),XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ;
 ; Change Colour for AXES etc.
 ;
 LoadCT,0
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffsp(q),YOffsp(q)+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffsp(q),YOffsp(q)+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffsp(q),YOffsp(q)],/Device,Color=LC
;Rng=long(0)
 Rng=RngH-RngL
 ;stop
 PPRng=YSzbp/Rng
;stop
 RngD=Rng/10.0
Tme=XRngL
;stop
 Inc=10.0
 ;Print,'Current Increment [for 10 Divs] is ',RngD
 ;Print,'Enter Required Increment : '
 ;Read,Inc
Inc=RngD
 PInc=Fix(PPRng*Inc)
 X11=XRHp
 X12=XRHp+100
 X22=XRHp+150
 NYTics=Fix(YSzbp/PInc)
 CBy=YOffsp(q)
 For ii=0,NYTics do $
 Begin
  Lab=RngL+ii*Inc
  If (Lab LE RngH) Then $
  Begin
   If (ABS(Lab) LE 1.0) Then $
    SMn=String(Lab,Format="(F6.1)") Else $
    SMn=String(Lab,Format="(F6.1)")
   If (PltTyp EQ 1) Then SMn=String(Lab,Format="(F6.1)")
   Plots,[X11,X12],[CBy,CBy],/Device,Color=LC
   XYOuts,X22,CBy-100,SMn,Orientation=0,/Device,Color=LC
   CBy=Cby+PInc
  end
 End


; Colour bar Title
 XCl=X22+1500
 CbLng=StrLen(CbTtle)*200
 YPos=YOffsp(q)+Fix(YSzbp/2)-Fix(CbLng/2)-50
 if q EQ 0 then $
 XYOuts,XRHp+1800,YPos,CbTtle,Orientation=90,/Device,Color=LC $
else $
 XYOuts,XRHp+1800,YPos+1000,CbTtle,Orientation=90,/Device,Color=LC
;
;Print,'Printing Axes...'
;Plots,XOffsp,YOffsp,/Device,Color=LC
;  X axis  ( TIME )
; Plots,[XOffsp,XOffsp+XSzp],[YOffsp,YOffsp],/Device,Color=LC
;Plots,XOffsp,YOffsp,/Device,Color=LC


Plot,cm_val.(0),findgen(n_elements(cm_val.(0))-1),$
xtickformat='XTLab',xticks=3,xstyle=1,$
pos=[XOffsp,YOffsp(q),XOffsp+XSzp,YOffsp(q)+YSzbp],$
/nodata,/noerase,ystyle=4,/device;,Color=LC


He_cycl_freqps ,state,cm_eph,cm_val,Dat5,XOffsp,YOffsp(q),XSzp,YSzbp,MxF

;
;XYouts,XPos+700,YOffsp(kk)-1700,'(b)',/Device,Color=LC
;
TTTle=string(strmid(tempTTLe[q],20))
FFT_TRes_text='Length: '+string(Npnts,format="(I0)")+$
'  FFT: '+string(FFTN,format="(I0)")+$
'  Time: '+string(PntRes,format="(I0)")
LnTtle=StrLen(TTTle)*200
XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
if q EQ 0 then $
begin
XYOuts,XPos,YOffsp(q)+4500,TTTle,/Device,Color=LC
XYOuts,XPos,YOffsp(q)+4100,FFT_Tres_text,/Device,Color=LC
end else $
XYOuts,XPos,YOffsp(q)+4100,TTTle,/Device,Color=LC
Plots,XOffsp,YOffsp(q),/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffsp(q),YOffsp(q)+Yszp],/Device,Color=LC
Plots,[XOffsp+Xszp,XOffsp+Xszp],[YOffsp(q),YOffsp(q)+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffsp(q),/Device,Color=LC

  If (Scl EQ 1) Then $     ; Linear Frequency Axis
  Begin
    FreInc=(YRngH-YRngL);*100.0    ; i.e. *1000/10
;stop
   PixperRe=FreInc*100.0*YSz/(YRngH-YRngL)
    Ntmm=Fix([YSzp/PixperRe])+1
   Ntm=Ntmm(0)
    Fre=YRngL;*1000.0
;    print,Ntm
;stop
    For i=1,Ntm do $
    Begin
     j=YOffsp(q)+(i-1)*Fix(PixperRe)
     Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
     FrLab=YLab(Fre)
     XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
     Fre=Fre+(FreInc/10.)
;stop
    End

  End
XYOuts,XOffsp-1500,YOffsp(q)+YSzp/2-1200,YTtle,$
Orientation=90,/Device,Color=LC
print,XOffsp
print,YOffsp(q)
endfor

eph_inter_spectral2,cm_eph,cm_val,state,Dat5,XOffsp,YOffsp(1)
device,/close
;stop
set_plot,'win'
!P.MULTI = 0
!p.noerase=0
;stop
end
