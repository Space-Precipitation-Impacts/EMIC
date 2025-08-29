;  Program to Compute Single Data Channel Dyn Power
;
; Main Program
;
Pro DPOWN3_multi,cm_eph,cm_val,state,Dat5
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
;Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common orbinfo,orb,orb_binfile,orb_date
common dat55, dat555
common Power, DispArr
common ptext,plottext
COMMON factR,FACMAX,I0MAX
common factr_multi,fac_multi
plottext=' '
;stop
dat555=dat5
print,Dat5
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
;XDat=DblArr(NPnts)
Ttle=["","",""]
MxPow=dblarr(3)
MnPow=dblarr(3)
XDat=DblArr(NPnts,3)
ttt=lonarr(Npnts)
ttt=cm_val.(0)
MnT=cm_val.(0)[0]
MxT=cm_val.(0)[n_elements(cm_val.(0))-1]
DMAX=fltarr(3)
if dat5 EQ 'ALL E FIELDS' THEN $
BEGIN
datt5=["EX","EY","EZ"]
	XDat[*,0]=cm_val.(1)
	XDat[*,1]=cm_val.(2)
	XDat[*,2]=cm_val.(3)
	DMAX[0]=MAX(ABS(cm_val.(1)))
	DMAX[1]=MAX(ABS(cm_val.(2)))
	DMAX[2]=MAX(ABS(cm_val.(3)))


END
if dat5 EQ 'ALL DB FIELDS' THEN $
BEGIN
datt5=["DBX","DBY","DBZ"]
	XDat[*,0]=cm_val.(4)
	XDat[*,1]=cm_val.(5)
	XDat[*,2]=cm_val.(6)
	DMAX[0]=MAX(ABS(cm_val.(4)))
	DMAX[1]=MAX(ABS(cm_val.(5)))
	DMAX[2]=MAX(ABS(cm_val.(6)))

END

;stop
;********************************************************************************
;Determine which component to plot
;
;for i=0, n_elements(valnames) -1 do $
;  if Dat5 EQ valnames[i] then $;
;	XDat=cm_val.(i)
;	XDat[*,0]=cm_val.(4)
;	XDat[*,1]=cm_val.(5)
;	XDat[*,2]=cm_val.(6)

tp0=where(XDat[*,0],count0)
tp1=where(XDat[*,1],count1)
tp2=where(XDat[*,2],count2)

print,count0
print,count1
print,count2
;stop
if (count0 EQ 0) then $
  Result = DIALOG_MESSAGE(string(Dat5)+' Component has no data !') else $
  begin
;********************************************************************************
Widget_control,state.dat_info,$
 set_value=string('Calculcating power spectra with default values......')
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(ttt[1]-ttt[0])/1000.

Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;stop
;stop
;
; Set up Analysis parameters
;
Set_Plot,'WIN'

!P.multi=[0,1,3]
Window,1,XSize=700,YSize=650
;Px1=[0.05,0.05,0.05]
;Px2=[0.95,0.95,0.95]
Py1=[0.3,0.3,0.4]
Py2=[1.0,1.0,2.0]
Px1=[0.05,0.05,0.05]
Px2=[1.,1.,1.]
;Py1=[0.0,0.0,0.0]
;Py2=[0.0,0.0,0.0]

Erase
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=800
;PnTres=200
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=5.0
;Read,MxF
DelF=1.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
;REPEAT Begin
; Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=200
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
;Ans=1
; Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=ttt(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr,3)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0
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

for q=0,2 do $
	begin

For i=0,FFTN-1 do TsArr(i)=XDat(i,q)
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
 Smo=2
ism=Smo
 Wnd=DblArr(2*ism+1)
 For i=0,2*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-ism)/Float(ism/2.0))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,2*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=ism
 LFr=iLFr*DelF
end
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr,FFTN     ; Call Linear Detrend
 If (WndT EQ 1) Then $
  For i=0,FFTN-1 do TsArr(i)=TsArr(i)*Wnd(i)  ; Hanning
 TrArr=FFT(TsArr,1)    ; FFT - BACKWARD so NO 1/N
 For i=0,NFr-1 do $
 Begin
 ;stop
  V1=(abs(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)

 	;stop
      If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
      If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
       ;  DispArr(Bloc,i,q)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=long(0),iLFr-1 do $
  Begin
   DispArr(Bloc,i,q)=SpArr(i)*Wght(i)
      If (DispArr(Bloc,i,q) LT 1e-6) Then DispArr(Bloc,i,q)=1e-6
 ;     DispArr(Bloc,i,q)=20*ALOG10(DispArr(Bloc,i,q))
  end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i,q)=SpArr(i)*Wght(i)
  If (DispArr(Bloc,i,q) LT 1e-6) Then DispArr(Bloc,i,q)=1e-6
  ;   DispArr(Bloc,i,q)=20*ALOG10(DispArr(Bloc,i,q))
  end
  For i=iLFr,NFr-1-ism do $
  Begin
   DispArr(Bloc,i,q)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i,q)=DispArr(Bloc,i,q)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DispArr(Bloc,i,q)=DispArr(Bloc,i,q)*Wght(i)
		If (DispArr(Bloc,i,q) LT 1e-6) Then DispArr(Bloc,i,q)=1e-6
   ;		DispArr(Bloc,i,q)=20*ALog10(DispArr(Bloc,i,q))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j,q) ; New Data
End    ; end Bloc Loop
;
endfor

fac_multi=fltarr(3)
MnRng=fltarr(3)
MxRng=fltarr(3)
for q=0,2 do $
	begin
fac_multi[q]=(DMAX[q]^2.0)/max(Disparr[*,*,q])
Disparr[*,*,q]=fac_multi[q]*Disparr[*,*,q]
Disparr[*,*,q] = 10*Alog10(Disparr[*,*,q])
MnRng[q]=Min(DispArr[*,*,q])
MxRng[q]=Max(DispArr[*,*,q])
 PAgn=0
 Print,'Minimum Power is ',Min(DispArr[*,*,q])
 Print,'Maximum Power is ',Max(DispArr[*,*,q])
 Device,Decomposed=0
 LoadCT,13  ;13
 Ttle[q]='Orbit'+orb+' '+orb_date+' '+Datt5[q]+' Power Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1.0

 ;window,2,xsize=400,ysize=400
 DYNTV_crres1,DispArr[*,*,q],Title=Ttle[q],YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng[q],MxRng[q]],Aspect=5.0,dat5=datt5[q],$
 Px1=Px1[q],Px2=Px2[q],Py1=Py1[q],Py2=Py2[q];,dat5=dat5
 Widget_control,state.dat_info,$
 set_value=string('Use the spectral widget if you wish to re-plot')
He_cycl_freq ,state,cm_eph,cm_val,Datt5[q]
PntRes=TRes
MnPow[q]=MnRng[q]
MxPow[q]=MxRng[q]
endfor
endelse
;FFTN=1200
;PntRes=TRes
;MnPow=MnRng
;MxPow=MxRng
;endfor
eph_inter_win_multi,cm_eph,cm_val,state,Datt5
;He_cycl_freq ,state,cm_eph,cm_val,Dat5
;stop

DPChoice3_multi,Dat555
;stop
Print,'Finished'
;spectralps_multi,cm_eph,cm_val,state,Dat5,DispArr
;stop
end
