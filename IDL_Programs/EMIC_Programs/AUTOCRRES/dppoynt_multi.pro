

Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end

;Function Tim,Sec
; Hr=Long(Sec)/3600
; Mn=Long(Sec-3600*Hr)/60
; Sc=Sec Mod 60
;Return,String(hr,mn,sc,$
;   Format="(I2.2,':',I2.2,':',i2.2)")
;end
;
;
; Main Program
;
Pro DPpoynt_multi,cm_eph,cm_val,state,Dat5
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
;Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common poynt_data,data0,data1,data2,data3
common orbinfo,orb,orb_binfile,orb_date
common Poyntpow, PoyntArr
Ttle=["","",""]
MnPow=dblarr(3)
MxPow=dblarr(3)
;common CPow, MxCPow, MnCPow,CPthres,CPArr
;common CPow,CPArr

print,Dat5
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
;stop
XDat=DblArr(NPnts)
ttt=lonarr(Npnts)
ttt=cm_val.(0)
MnT=cm_val.(0)[0]
MxT=cm_val.(0)[n_elements(cm_val.(0))-1]
	data0=dblarr(n_elements(cm_val.(0))-1)
		data1=dblarr(n_elements(cm_val.(0))-1)
		data2=dblarr(n_elements(cm_val.(0))-1)
		data3=dblarr(n_elements(cm_val.(0))-1)

TArr=DblArr(NPnts)
TArr=ttt
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
piI = 3.1415926535898
u = 4*PiI
Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;stop
;stop
;
; Set up Analysis parameters
datt5=["SX","SY","SZ"]
Set_Plot,'WIN'

!P.multi=[0,1,3]
Window,2,XSize=700,YSize=650
Erase
;Px1=[0.05,0.05,0.05]
;Px2=[0.95,0.95,0.95]
Py1=[0.3,0.3,0.4]
Py2=[1.0,1.0,2.0]
Px1=[0.05,0.05,0.05]
Px2=[1.,1.,1.]
;
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=1200
;PnTres=200
;NyqF=1000.0/(2.0*SInt)
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=5.0
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
DelF=1.0/(FFTN*SINT)

NFr=Fix(MxF/DelF)+1
TRes=200

;MxFr=(NFr-1)*DelF
;stop
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(4,FFTN)    ; Time Series Array
TrArr=DblArr(4,FFTN)    ; FFT Array
;REPEAT Begin
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
;stop
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=TArr(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr,3)
PoyntArr=DblArr(NBlocs,NFr,3)
for q=0,2 do $
begin
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
;For i=0,FFTN-1 do TsArr(i)=XDat(i)
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
;stop
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array


;********************************************************************************
if q EQ 0 then $
	begin
		data0=cm_val.(2)
		data1=cm_val.(6)
		data2=cm_val.(5)
		data3=cm_val.(3)
end
if q EQ 1 then $
	begin
		data0=-cm_val.(1)
		data1=cm_val.(6)
		data2=-cm_val.(4)
		data3=cm_val.(3)
end
if q EQ 2 then $
	begin
		data0=cm_val.(1)
		data1=cm_val.(5)
		data2=cm_val.(4)
		data3=cm_val.(2)
end


 For i=long(0),FFTN-1 do TsArr(0,i)=data0(i)
 For i=long(0),FFTN-1 do TsArr(1,i)=data1(i)
 For i=long(0),FFTN-1 do TsArr(2,i)=data2(i)
 For i=long(0),FFTN-1 do TsArr(3,i)=data3(i)
;
;end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN
 DTrend,TsArr(2,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(3,*),FFTN

 ;DTrend,TsArr(2,*),FFTN
 If (WndT EQ 1) Then $
 Begin
  For jj=0,3 do $
  Begin
   For i=0,FFTN-1 do TsArr(jj,i)=TsArr(jj,i)*Wnd(i)  ; Hanning
  end
 end
 TrArr(0,*)=FFT(TsArr(0,*),1)    ; FFT - BACKWARD so NO 1/N
 TrArr(1,*)=FFT(TsArr(1,*),1)
 TrArr(2,*)=FFT(TsArr(2,*),1)    ; FFT - BACKWARD so NO 1/N
 TrArr(3,*)=FFT(TsArr(3,*),1)

 ;TrArr(2,*)=FFT(TsArr(2,*),1)
 Poynt=dblarr(n_elements(TrArr(1,*)))
 ;CP=fltarr(n_elements(TrArr(1,*)))
;stop
 for yy=long(0), n_elements(TrArr(1,*)) -long(1) do $
 	begin
 		Poynt[yy]=(10./u)*[TrArr(0,yy)*conj(TrArr(1,yy))-TrArr(2,yy)*conj(TrArr(3,yy))]
 ;		CP[yy]=(10./u)*TrArr(1,yy)*conj(TrArr(3,yy))
 endfor
 ;microwatts/square meter
 ;stop
 V2=Float(FFTN)
  For i=long(0),NFr-1 do $
  	Begin
  		V1=0.5*double(Poynt(i))
  		SpArr(i)=V1/V2
  ;		CP[i]=Cp[i]/(V2*V2)
  end

;*********************************************************
 ;If (WndT EQ 1) Then $   ; Time Domain Window
 ;Begin
 ; For i=0,NFr-1 do $
 ; Begin
 ;  DispArr(Bloc,i)=SpArr(i)*Wght(i)
  ; If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
  ; If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
  ; DispArr(Bloc,i)=20*ALog10(SpArr(i))
 ; end    ; end of i Loop
 ;end      ; end of If WndT = 1
;********************************************************
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do DispArr(Bloc,i,q)=SpArr(i)*Wght(i)
  ;For i=0,iLFr-1 do CPArr(Bloc,i)=abs(CP(i))*Wght(i)
  For i=NFr-1-ism,NFr-1 do DispArr(Bloc,i,q)=SpArr(i)*Wght(i)
  ;For i=NFr-1-2*ism,NFr-1 do CPArr(Bloc,i)=abs(CP(i))*Wght(i)

  For i=iLFr,NFr-1-ism do $
    Begin
   DispArr(Bloc,i,q)=0.0
   ;CPArr(Bloc,i)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i,q)=DispArr(Bloc,i,q)+Wnd(iWn)*SpArr(j)
	;CPArr(Bloc,i)=CPArr(Bloc,i)+Wnd(iWn)*abs(CP(j))
   end    ; end of J loop
   DispArr(Bloc,i,q)=DispArr(Bloc,i,q)*Wght(i)
   ;CPArr(Bloc,i)=CPArr(Bloc,i)*Wght(i)
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=long((long(Bloc)+1)*TRes)
;print,Posn
;print,i
;print,Bloc
 ;For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
 For i=long(0),FFTN-long(1) do TsArr(0,i)=data0(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(1,i)=data1(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(2,i)=data2(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(3,i)=data3(Posn+i)
End    ; end Bloc Loop
print,TRes
endfor

for q=0,2 do $
BEGIN
;
MnRng=Min(DispArr[*,*,q])

MxRng=Max(DispArr[*,*,q])
if abs(MxRng) GE abs(MnRng) then $
MnRng=-MxRng else $
MxRng=abs(MnRng)

;********************************************************************************


;*********************************************************************************
;Poynting Flux Spectral Plot
;
;Set_Plot,'WIN'
 PAgn=0
 Print,'Minimum Poynting Flux is ',Min(DispArr[*,*,q])
 Print,'Maximum Poynting Flux is ',Max(DispArr[*,*,q])
 ;Erase
 Device,Decomposed=0
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

 for ii=0,127 do $
  begin
   r(255-ii)=128+ii
 end
 tvlct,r,g,b

 Ttle[q]='Orbit'+orb+' '+orb_date+' '+Datt5[q]+' Poynting Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1
 ;!P.multi=0
 ;window,2,xsize=500,ysize=400
 DYNTV_crres1,DispArr[*,*,q],Title=Ttle[q],YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=5.0,dat5=datt5[q],$
 Px1=Px1[q],Px2=Px2[q],Py1=Py1[q],Py2=Py2[q]

PoyntArr[*,*,q]=DispArr[*,*,q]

PntRes=TRes
MnPow[q]=double(MnRng)
MxPow[q]=double(MxRng)
He_cycl_freq ,state,cm_eph,cm_val,Datt5[q]
;stop
ENDFOR
;FName='test.ps'
;stop
DispArr=0.0
eph_inter_win_multi,cm_eph,cm_val,state,Datt5
;spectralpoyntps_multi,cm_eph,cm_val,state,Dat5,PoyntArr,Fname
;stop
DPChoice_poynt_multi,Dat5
Print,'Finished'

;stop
end
