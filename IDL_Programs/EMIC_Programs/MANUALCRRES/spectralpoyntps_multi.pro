;AUTHOR: Paul Manusiu
;
;PURPOSE: Program to print to (PS) postscript Poynting vector spectrum
;
;
Function XTLab,Axis,Index,Values	;Function to format x axis into hours:minutes:seconds.frac
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
pro spectralpoyntps_multi,cm_eph,cm_val,state,Dat5,DispArr,Fname
;
;Common blocks
;
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
common orbinfo,orb,orb_binfile,orb_date
;common Poyntpow, PoyntArr
;Picture spectifications
;
;stop
tempttle=ttle
;
XSz=12   ; Picture is this [cm] wide, not including axes and colour bar
YSz=6    ; Picture height
XOffs=2    ; cm
YOffs=[2,10,18]
YOffsp=1000*YOffs
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels
;

OutF=Fname
;Print,'Enter Output File Name : [*.PS]'
;Read,OutF
Set_Plot,'PS'
!P.Charthick=3.0  ; Set PS Character Thickness
Device,Filename=OutF,/Portrait
Device,XSize=18  ; cm
Device,YSize=24  ; cm
Device,/color  ;Set for both
Device,XOffset=XOffs
;DispArr=PoyntArr
;PoyntArr=0.0

for q=0,2 do $
	begin
Device,YOffset=YOffs(q)
PCol=1
 XRngL=cm_val.(0)[0]
 XRngH=cm_val.(0)[n_elements(cm_val.(0))-1]
 ;stop
 YRngH=MxF;/1000.0
!p.noerase=1
;NCol=256
NCol=!d.N_Colors

;Device,bits_per_pixel=8
;
;kk=0

 ;stop
 ;YRngH=MxF
 Scl=1
RngL=MnPow(q)
 RngH=MxPow(q)
 Nx=n_elements(DispArr(*,0,q))
 Ny=n_elements(DispArr(0,*,q))
; stop
 CbTtle='Poynting Flux [uW/m!u2!n]'
 PltTyp=0
;if q EQ 0 then $
;begin
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

;for ii=0,20 do $
; begin
; r(fix(129+ii))=r(fix(ii+132))
; b(fix(129+ii))=b(fix(ii+132))
; g(fix(129+ii))=g(fix(ii+132))
 ;r(fix(6+ii))=r(fix((254-ii/2)))
 ;b(fix(126+ii))=b(fix((254-ii/2)))
 ;g(fix(126+ii))=g(fix((254-ii/2)))
;end
;FOR I=127,254 do $
;begin
;r(i)=110
;r(i)=170
;g(i)=i-1
;end
 tvlct,r,g,b
;end
;gamma_ct,0.398
 ;Device,Bits_per_pixel=8    ; set to 8 for final
 Bt=RngH-RngL
 Bt1=!D.Table_Size
 For i=0,Nx-1 do $
 Begin
  For j=0,Ny-1 do $
  Begin
   Nm=Bt1*(DispArr(i,j,q)-RngL)/Bt
   If (Nm LT 0) Then Nm=0
   If (Nm GE Bt1) Then Nm=Bt1-1
   DispArr(i,j,q)=Nm
  End
 End
 ;
 ; Print picture
 Tv,Congrid(DispArr[*,*,q],500,300,/Interp,/Minus_one),$
 XOffs,YOffs[q],XSize=XSz,YSize=YSz,/CENTIMETERS
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
  XOffscl,YOffs[q],XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ;
 ; Change Colour for AXES etc.
 ;
 LoadCT,13
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffsp[q],YOffsp[q]+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffsp[q],YOffsp[q]+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffsp[q],YOffsp[q]],/Device,Color=LC
;Rng=long(0)
 Rng=RngH-RngL
 ;stop
 PPRng=YSzbp/Rng
;stop
 RngD=Rng/10.0
Tme=XRngL
;stop
 Inc=10.0

Inc=RngD
 PInc=Fix(PPRng*Inc)
 X11=XRHp
 X12=XRHp+100
 X22=XRHp+150
 NYTics=Fix(YSzbp/PInc)
 CBy=YOffsp[q]
 For ii=0,NYTics do $
 Begin
  Lab=RngL+ii*Inc
  If (Lab LE RngH) Then $
  Begin
   If (ABS(Lab) LE 1.0) Then $
    SMn=String(Lab,Format="(F5.2)") Else $
    SMn=String(Lab,Format="(F5.1)")
   If (PltTyp EQ 1) Then SMn=String(Lab,Format="(F5.1)")
   Plots,[X11,X12],[CBy,CBy],/Device,Color=LC
   XYOuts,X22,CBy-100,SMn,Orientation=0,/Device,Color=LC
   CBy=Cby+PInc
  end
 End


; Colour bar Title
 XCl=X22+1500
 CbLng=StrLen(CbTtle)*200
 YPos=YOffsp[q]+Fix(YSzbp/2)-Fix(CbLng/2)-50
 XYOuts,XRHp+1800,YPos,CbTtle,Orientation=90,/Device,Color=LC
 ;

Plot,cm_val.(0),findgen(n_elements(cm_val.(0))-1),$
xtickformat='XTlab',xticks=3,xstyle=1,$
pos=[XOffsp,YOffsp[q],XOffsp+XSzp,YOffsp[q]+YSzbp],$
/nodata,/noerase,ystyle=4,/device
He_cycl_freqps ,state,cm_eph,cm_val,Dat5,XOffsp,YOffsp[q],XSzp,YSzbp,MxF
TTle='CRRES '+string(tempTTLe[q])
FFT_TRes_text='Length: '+string(Npnts,format="(I0)")+$
'  FFT: '+string(FFTN,format="(I0)")+$
'  Time: '+string(PntRes,format="(I0)")
LnTtle=StrLen(TTle)*200
XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
if q EQ 2 then $
begin
XYOuts,XPos,YOffsp[q]+7000,TTle,/Device,Color=LC
XYOuts,XPos,YOffsp[q]+6500,FFT_Tres_text,/Device,Color=LC
end else $
XYOuts,XPos,YOffsp[q]+6500,TTle,/Device,Color=LC
Plots,XOffsp,YOffsp[q],/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffsp[q],YOffsp[q]+Yszp],/Device,Color=LC
Plots,[XOffsp+Xszp,XOffsp+Xszp],[YOffsp[q],YOffsp[q]+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffsp[q],/Device,Color=LC

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
     j=YOffsp[q]+(i-1)*Fix(PixperRe)
     Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
     FrLab=YLab(Fre)
     XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
     Fre=Fre+(FreInc/10.)
;stop
    End

  End
XYOuts,XOffsp-1500,YOffsp[q]+YSzp/2-1200,YTtle,$
Orientation=90,/Device,Color=LC
print,XOffsp
print,YOffsp[q]
eph_inter_spectral2,cm_eph,cm_val,state,Dat5,XOffsp,YOffsp[q]
end
;!P.charsize=1.5
;xyouts,2100,19000,'f!dO+!n',/device
;xyouts,2100,20500,'f!dHe+!n',/device
;!P.charsize=1.0
;xyouts,2500,21500,' 1ab1c         2a 2b 2c  3 4af4b4c4d4e 5c5b5c  6',/device
;xyouts,3300,22500,'1a1b 2a2b2c  3  4 5a5b5c 6a6b6c 7  8      9 10',/device
;!P.charsize=1.0
;!P.charsize=2.0
xyouts,2300,YOffsp(2)+500,'f!dO+!n',charsize=2.0,/device
xyouts,2300,YOffsp(2)+1600,'f!dHe+!n',charsize=2.0,/device
;!P.charsize=1.0
;xyouts,3000,18500,'1ab 1c         2a  2b    2c   3   4af 4b 4c4d4e  5c5b5c       6',/device
xyouts,2500,YOffsp(2)+4500,'   1          2a2b 2c 2d    2e 2f2g     3     4   5',/device
device,/close
;stop
set_plot,'win'
!P.MULTI = 0
!p.noerase=0
q=0
;stop
end
