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
pro spectralps,cm_eph,cm_val,state,Dat5,BB,noi
;
;Common blocks
;
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
common orbinfo,orb,orb_binfile,orb_date
common pow_multi, disparr_multi
;common Power, DispArr
common CPow, CPArr
;common CPow, MxCPow, MnCPow,CPthres,CPArr
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common datafiles, data_files,no_data,para_struct
common logs, filename1,filename2
common fre_timres, fft_limit, timres_limit
fname=strmid(para_struct[noi].filename,0,strlen(para_struct[noi].filename)-4)+string(BB)+'.ps'
DispArr=CPArr
cd,res_path[0]
;Picture spectifications
;
XSz=12   ; Picture is this [cm] wide, not including axes and colour bar
YSz=8    ; Picture height
XOffs=2    ; cm
YOffs=2
YOffsp=IntArr(2)
YOffs(0)=2   ; cm   ; First Picture Y Pos
;YOffs(1)=14  ; cm   ; Second Picture
YOffsp=1000*YOffs
XSzp=XSz*1000
YSzp=YSz*1000
XOffsp=XOffs*1000  ; in pixels

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
Device,YOffset=YOffs(0)
!p.noerase=1
NCol=!d.N_Colors
;
kk=0
;For kk=0,NPlts-1 do $
;Begin
 ;Print,'Colour [=1] or B/W Plot [=2]'
 ;Read,PCol
PCol=1
 XRngL=cm_val.(0)[0]
 XRngH=cm_val.(0)[n_elements(cm_val.(0))-1]
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
 XOffs,YOffs,XSize=XSz,YSize=YSz,/CENTIMETERS
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
  XOffscl,YOffs,XSize=XSzb,YSize=YSzb,/CENTIMETERS
 Xsclp=Xoffscl*1000
 YSzbp=YSzb*1000
 ;
 ; Change Colour for AXES etc.
 ;
 LoadCT,0
 LC=0
 ; Draw LH vertical line on colour bar
 Plots,[XSclp,Xsclp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
 ; Draw RH vertical line on colour bar
 XRHp=XSclp+XSzb*1000
 Plots,[XRHp,XRHp],[YOffsp,YOffsp+YSzbp],/Device,Color=LC
 ; Draw line along bottom of colour bar
 Plots,[XSclp,XRHp],[YOffsp,YOffsp],/Device,Color=LC
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
 CBy=YOffsp
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
 YPos=YOffsp+Fix(YSzbp/2)-Fix(CbLng/2)-50
 XYOuts,XRHp+1800,YPos,CbTtle,Orientation=90,/Device,Color=LC
 ;
;Print,'Printing Axes...'
;Plots,XOffsp,YOffsp,/Device,Color=LC
;  X axis  ( TIME )
; Plots,[XOffsp,XOffsp+XSzp],[YOffsp,YOffsp],/Device,Color=LC
;Plots,XOffsp,YOffsp,/Device,Color=LC
Plot,cm_val.(0),findgen(n_elements(cm_val.(0))-1),$
xtickformat='XTLab',xticks=3,xstyle=1,$
pos=[XOffsp,YOffsp,XOffsp+XSzp,YOffsp+YSzbp],$
/nodata,/noerase,ystyle=4,/device
He_cycl_freqps ,state,cm_eph,cm_val,Dat5,XOffsp,YOffsp,XSzp,YSzbp,MxF

;
;XYouts,XPos+700,YOffsp(kk)-1700,'(b)',/Device,Color=LC
;
TTle='CRRES '+string(TTLe)
FFT_TRes_text='Length: '+string(Npnts,format="(I0)")+$
'  FFT: '+string(FFTN,format="(I0)")+$
'  Time: '+string(PntRes,format="(I0)")
LnTtle=StrLen(TTle)*200
XPos=XOffsp+Fix(XSzp/2)-Fix(LnTtle/2)
XYOuts,XPos,YOffsp+9000,TTle,/Device,Color=LC
XYOuts,XPos,YOffsp+8500,FFT_Tres_text,/Device,Color=LC
Plots,XOffsp,YOffsp,/Device,Color=LC
;
; Y Axis
;
 Plots,[XOffsp,XOffsp],[YOffsp,YOffsp+Yszp],/Device,Color=LC
Plots,[XOffsp+Xszp,XOffsp+Xszp],[YOffsp,YOffsp+Yszp],/Device,Color=LC
 Plots,XOffsp,YOffsp,/Device,Color=LC

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
     j=YOffsp+(i-1)*Fix(PixperRe)
     Plots,[XOffsp,XOffsp-200],[j,j],/Device,Color=LC  ;Tic marks
     FrLab=YLab(Fre)
     XYOuts,XOffsp-1300,(j-100),FrLab,Orientation=0,/Device,Color=LC
     Fre=Fre+(FreInc/10.)
;stop
    End

  End
XYOuts,XOffsp-1500,YOffsp(kk)+YSzp/2-1200,YTtle,$
Orientation=90,/Device,Color=LC
print,XOffsp
print,YOffsp
eph_inter_spectral2,cm_eph,cm_val,state,Dat5,XOffsp,YOffsp
device,/close
;stop
set_plot,'win'
!P.MULTI = 0
!p.noerase=0
WIDGET_CONTROL, state.text,SET_VALUE='Plotted to file: '+string(fname),/append,/show
cd,idl_path[0]
!P.Charthick=1.0
end
