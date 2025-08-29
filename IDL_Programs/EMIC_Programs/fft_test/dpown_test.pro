;DATE: 10/06/00
;TITLE: dpown_test.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: Generates pre-post_dump test data.
;Inputs: Header from any pre-post_dump data file (e.g. orb115b.val).
;Outputs: Header, generated data including time tags and index to file ( eg sample5.dat).
;MODIFICATIONS:
;
Function Tim,mSec
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

Function XTLabbb,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',i2.2)")
end

Pro dpown_test
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
common orbinfo,orb,orb_binfile,orb_date
common sinewave,data_32,tim_len,perd
orbinfo=' '
orb=' '
orbbinfile=' '
orb_date=' '

PI=3.14159265359
ct=20000
index=INDGEN(8)
indx=[7,6,5,4,3,2,1,0]
data_32 = fltarr(ct)
tims_32=lonarr(ct)
for i=0,ct-1 do $
          begin
             tims_32[i] = long(00000010) + long(64)*i
             data_32[i] = 1.01*sin(2.*pi*200.*i/(ct/4.5))
endfor
count=long(0)
;stop
!P.Multi = [0,1,2]
set_plot,'WIN'
Window,0, Xsize=700,Ysize=600,title='Test Pattern Wave field'
    plot,tims_32,data_32,XStyle=1,Xticks =3,XTickFormat='XTLabbb',xtitle ='Time (UT)',$
    ytitle='Amplitude',$
    xmargin=[10,10],ymargin=[2,5],title='Test Signal Pure Sine Wave',$
    xrange=[tims_32[0],tims_32[500]]
index = where(abs(data_32) GE 1.0,long(count))
;print,index
;print,data_32[index]
tim_int = abs(long(tims_32[index[0]] - tims_32[index[1]]))
tim_len = abs(long(tims_32[n_elements(tims_32)-1] - tims_32[0]))
perd = tim_int/(1000.)*2.0
print,'Length in time :',tim(tim_len)
print,'Period of sample wave',perd,string(' s')
print,'Frequency of sample wave',1./(perd),string(' Hz')
Xdat=data_32
;stop
;for ii=0, n_elements(XDat)-1 do $
;		if XDat[ii]  GT 0.999 then $
;			print,Xdat[ii],' ',tim(tims_32[ii])
print,Xdat[100],'  ',tim(tims_32[100])

	DXMAX=MAX(ABS(Xdat));
;stop
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(tims_32[1]-tims_32[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;stop
;XXdat=Xdat[0:199]
;DTrend,XXdat,200;n_elements(XXdat);FFTN;
;stop
;
; Set up Analysis parameters
;
NPnts = ct
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=800
;PnTres=200
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' Hz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=2.0
;Read,MxF
DelF=1.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' Hz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
REPEAT Begin
 Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=150
Tim_res = TRes*SInt

 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
Ans=10
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
T=LonArr(NBlocs)
T(0)=tims_32(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0.0
SpW=Wsp
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
SpTyp=2
WnDT=SpTyp
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0
For i=0,FFTN-1 do TsArr(i)=XDat(i)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
 Smo=2
ism=Smo
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=ism
 LFr=iLFr*DelF
end
;stop
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
;stop
; Major Loop Starts Here
;
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
;Ydat=fltarr(FFTN)
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 ;Reverse_test,Tsarr,Ydat,FFTN
 ;DTrend,TsArr,FFTN
 ;Reverse_test,Tsarr,Ydat,FFTN
 ;stop
 If (WndT EQ 1) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning

 TrArr=FFT(TsArr,1)    ;Now implemented with (+1) negative FFT requires 1/(N*N) factor.
 For i=0,NFr-1 do $
 Begin
 ;stop
  V1=(abs(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end
;******************************************************************************
;
; If (WndT EQ 1) Then $   ; Time Domain Window
; Begin
;  For i=long(0),NFr-1 do $
;  Begin
 ;  SpArr(i)=SpArr(i)*Wght(i)

 	;stop
;      If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
;      If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6

 ; end    ; end of i Loop
 ;end      ; end of If WndT = 1
 ;
 ;*******************************************************************************
 ;
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=long(0),iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
  end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
  If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6

  end
  For i=iLFr,NFr-1-ism do $
  Begin
   DispArr(Bloc,i)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i)=DispArr(Bloc,i)+SpArr(j)*Wnd(iWn)
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
			If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6

  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
;
;*********************************************************************
 Posn=(Bloc+1)*TRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End    ; end Bloc Loop

;*********************************************************************
;Multiplication factor due to IDL FFT routine.
;Amplitude Affect:Fourier Tranform results in halving of signal amplitude
;The "fac" is a multiplication factor to restore original power levels.
;Leakage Affect: Minimized through use of exponential window function.
;
;
fac=(DXMAX^2.0)/max(Disparr)
Disparr=7.0*Disparr

;
;
;*********************************************************************

Disparr = 10.*Alog10(Disparr)
MnRng=Min(DispArr)
MxRng=Max(DispArr)
;stop
 ;set_plot,'win'
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Power is ',Min(DispArr)
 Print,'Maximum Power is ',Max(DispArr)
 ;print,Disparr[0:10]
 ;Window,0,XSize=500,YSize=400
 ;Erase
 Device,Decomposed=0
 LoadCT,13  ;13
 Ttle='Test Power Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
CbTtle='Power (dB)'
 YRngL=0
 Scl=1
 ;!P.multi=0
 dat5='testing'
 DYNTV_crres_test,DispArr,Cbtle=CbTtle,Title=Ttle,YTitle=YTtle,xtitle='Time (UT)',$
 XRange=[Min(tims_32[0]),Max(tims_32[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=3.0,ymargin=[4,0],xmargin=[10,1],dat5=dat5
;endelse
PntRes=TRes
MnPow=MnRng
MxPow=MxRng
;stop
;************************************************
;Plots dynamic power to postscript device
;
Dat5='xx'
Fname='power.ps'
spectralps_test,tims_32,Dat5,DispArr,Fname
;************************************************
old_x=!x
old_y=!y
old_z=!z
DoCur=0
;Print,'Activate MOUSE LOCATION Routine [1=YES] :'
;Read,DoCur
;If (DoCur EQ 1) Then $
;Begin
; Ny=NFr
; Print,'Press LEFT Button to Get Values'
; Print,'Press MIDDLE Button when Finished'
; Print,!P.Color
; PAx=DblArr(Ny)
; FInc=(MxFr-YRngL)/(Ny-1)
; For i=0,Ny-1 do PAx(i)=YRngL+i*FInc
; Dm1=Float(Max(T)-Min(T))
; Lb=' '
; REPEAT Begin
;  WSET,0
;  !x=old_x & !y=old_y
;  !z=old_z
;  Cursor,x,z,/Data,/down
;  GOut=(!err EQ 4)
;  If (GOut EQ 0) Then $
;  Begin
;   Dm=Float(x-Min(T))/Dm1
;   ArrP=Fix(Dm*(NBlocs-1))
 ;  If ArrP LT 0 Then ArrP=0
 ;  If ArrP GT NBlocs-1 Then ArrP=NBlocs-1
 ;  XYOuts,10,10,color=[0],Lb,/device    ; Black
 ;  TLab=Tim(x)
 ;  Lb=TLab+' '+StrTrim(String(y),2)+' Hz';+' '+StrTrim(String(z),2)+' A^2/Hz''
   ;Lb=TLab+' '+StrTrim(String(z),2)+' A^2/Hz''

 ;  color=!d.n_colors-1
 ;  XYOuts,10,10,color=[235],Lb,/device
 ; End
 ;end UNTIL GOut
;end
;HrdC=2
Print,'Finished'

;set_plot,'ps'
;!p.multi=[0,1,2]
;device,filename='window_function.ps',yoffset=3, ysize=23
;Plot,tims_32,Xdat,title='Time Series test Sinusiodal, 1000 points',xtickformat='XTLabbb',xstyle=1,/device
;plot,wnd,xtitle='Frequency Domain Smoothing = 2',title='Exponential Window Function',/device
;device,/close
;set_plot,'win'
;stop
end
