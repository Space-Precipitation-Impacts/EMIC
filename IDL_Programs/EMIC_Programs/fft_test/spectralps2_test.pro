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
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I2.2)")
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
pro spectralps2_test,tims_32,Dat5,DispArr,Fname
;
;Common blocks
;

Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
common orbinfo,orb,orb_binfile,orb_date
common sinewave,data_32,tim_len,perd
;common Power, DispArr
;common CPow, MxCPow, MnCPow,CPthres,CPArr
;Picture spectifications
;
XSz=12   ; Picture is this [cm] wide, not including axes and colour bar
YSz=8    ; Picture height
XOffs=2    ; cm
;YOffs=2
YOffs=IntArr(2)
YOffs(0)=12   ; cm   ; First Picture Y Pos
;YOffs(1)=14  ; cm   ; Second Picture
YOffsp=1000*YOffs(0)
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels
;Fname='testt.ps'
;
;Print,'PostScript Print Spectra Program'
;Print,'How Many Plots [1 or 2] :'
;Read,NPlts
OutF=Fname
;Print,'Enter Output File Name : [*.PS]'
;Read,OutF
;PTTle=' '
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
Device,YOffset=4;YOffs(0)
!p.noerase=1
NCol=!d.N_Colors
;
kk=0
;For kk=0,NPlts-1 do $
;Begin
 ;Print,'Colour [=1] or B/W Plot [=2]'
 ;Read,PCol
PCol=1
;*****************************************
;pos=[XOffsp,YOffsp(0),XOffsp+XSz*1000,YOffsp(0)+YSz*1000],/noerase,ystyle=1,/device
;Window,0, Xsize=700,Ysize=600,title='Test Pattern Wave field'
    plot,tims_32,data_32,XStyle=1,Xticks =3,XTickFormat='XTLabbb',xtitle ='Time',$
    ytitle='Amplitude',$
    xmargin=[10,10],ymargin=[2,5],title='',$
    xrange=[tims_32[0],tims_32[500]],$
    pos=[XOffsp,Yoffsp,XOffsp+XSz*1000,Yoffsp+YSz*1000],/noerase,ystyle=1,/device
	Lnt= 'Data Length: 20000 points'
	Lntt=strlen(Lnt)*200
    XPos=XOffsp+Fix(XSzp/2)-Fix(LnTt/2)
xyouts,XPos,Yoffsp+YSz*1000+1500,'Data Length: 20000 points',/device
xyouts,XPos,Yoffsp+YSz*1000+1000,'Time Length: 21.3 minutes',/device
xyouts,XPos,Yoffsp+YSz*1000+500,'32 seconds of Sine Wave Time Series',/device
;Plot,cm_val.(0),$;
;	cm_val.(9),$
;	ytitle=string(nname(9)+yytt[1]),$
; xtickformat='Xtlab',xticks=3,xstyle=1,title=timttle[1],$
; yrange=[min(cm_val.(9))-1.0,max(cm_val.(9))+1.0],$
;pos=[XOffsp,YOffsp(1),XOffsp+XSz*1000,YOffsp(1)+YSz*1000],/noerase,ystyle=1,/device
;*****************************************
YOffs(0)=0   ; cm   ; First Picture Y Pos
;Device,XSize=10  ; cm
;Device,YSize=12  ; cm
;Device,/color  ;Set for both
;Device,XOffset=XOffs
Device,YOffset=YOffs(0)

 XRngL=tims_32[0]
 XRngH=tims_32[n_elements(tims_32)-1]
 ;stop
 YRngH=MxF
 ;stop
 Scl=1
 RngL=mnPow
 RngH=mxPow
 ;stop
 Nx=n_elements(DispArr(*,0))
 Ny=n_elements(DispArr(0,*))
; stop
 CbTtle='Energy Flux (uW/m!U2!n/Hz)'
 PltTyp=0
 ;If (PCol EQ 1) Then $
 ;Begin
 ; If (PltTyp EQ 0) Then LoadCT,20
;end
; If (PCol EQ 2) Then $
; Begin
;  DoinBW   ; Load Black/White Linear
;  LC=NCol
; End
;Device,Decomposed=0
   ;13
  LoadCT,17
 TVLCT,r,g,b,/get
 r(127)=255
 g(127)=255
 b(127)=255
 r(128)=255
 g(128)=255
 b(128)=255
 r(126)=255
 g(126)=255
 b(126)=255
 ;r(0)=0
 ;g(0)=0
 ;b(0)=0
 for ii=0,127 do $
  begin
   r(255-ii)=128+ii
 end
 tvlct,r,g,b

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
 XOffs,YOffs(0),XSize=XSz,YSize=YSz,/CENTIMETERS
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
  XOffscl,YOffs(0),XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ;
 ; Change Colour for AXES etc.
 ;
 LoadCT,0
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffs(0),YOffs(0)+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffs(0),YOffs(0)+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffs(0),YOffs(0)],/Device,Color=LC
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
 CBy=YOffs(0)
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
 YPos=YOffs(0)+Fix(YSzbp/2)-Fix(CbLng/2)-50
 XYOuts,XRHp+1800,YPos,CbTtle,Orientation=90,/Device,Color=LC
 ;
;Print,'Printing Axes...'
;Plots,XOffsp,YOffsp,/Device,Color=LC
;  X axis  ( TIME )
; Plots,[XOffsp,XOffsp+XSzp],[YOffsp,YOffsp],/Device,Color=LC
;Plots,XOffsp,YOffsp,/Device,Color=LC
Plot,tims_32,findgen(n_elements(tims_32)-1),$
xtickformat='XTLab',xticks=3,xstyle=1,$
pos=[XOffsp,YOffs(0),XOffsp+XSzp,YOffs(0)+YSzbp],$
/nodata,/noerase,ystyle=4,/device
;He_cycl_freqps ,state,cm_eph,cm_val,Dat5,XOffsp,YOffsp,XSzp,YSzbp,MxF

;
XYouts,XPos+1800,YOffs(0)-1000,'Time',/Device,Color=LC
;
TTle=string(TTLe)
FFT_TRes_text='Length: '+string(Npnts,format="(I0)")+$
'  FFT: '+string(FFTN,format="(I0)")+$
'  Step: '+string(PntRes,format="(I0)")
LnTtle=StrLen(TTle)*200
XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
XYOuts,XPos,YOffs(0)+9000,TTle,/Device,Color=LC
XYOuts,XPos,YOffs(0)+8500,FFT_Tres_text,/Device,Color=LC
Plots,XOffsp,YOffs(0),/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffs(0),YOffs(0)+Yszp],/Device,Color=LC
Plots,[XOffsp+Xszp,XOffsp+Xszp],[YOffs(0),YOffs(0)+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffs(0),/Device,Color=LC

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
     j=YOffs(0)+(i-1)*Fix(PixperRe)
     Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
     FrLab=YLab(Fre)
     XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
     Fre=Fre+(FreInc/10.)
;stop
    End

  End
XYOuts,XOffsp-1500,YOffs(0)+YSzp/2-1200,YTtle,$
Orientation=90,/Device,Color=LC
print,XOffsp
print,YOffs(0)
;eph_inter_spectral2,cm_eph,cm_val,state,Dat5,XOffsp,YOffsp
device,/close
;stop
set_plot,'win'
!P.MULTI = 0
!p.noerase=0
!P.charthick=1.0
end
