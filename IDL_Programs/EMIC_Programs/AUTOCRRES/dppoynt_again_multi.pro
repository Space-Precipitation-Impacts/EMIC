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
;

;
;
; MAIN PROCEDURE STARTS HERE
;

; Main Program
;
pro DPpoynt_again_multi,dat5
common orbinfo,orb,orb_binfile,orb_date
common cm_crres,state,cm_eph,cm_val
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK4,MnPow,MxPow
;common CPow, MxCPow, MnCPow,CPthres;,CPArr
Common BLK2,SpW,SpTyp,Smo
;Common BLK3,FrRes,TRes,FBlks
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
common Data,XDat
common poynt_data,data0,data1,data2,data3
common Poyntpow, PoyntArr
datt5=["SX","SY","SZ"]
;
Widget_control,state.dat_info, set_value=string('Calculating Spectra with new parameters.....')
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
;SInt=(ttt[1]-ttt[0])/1000.
piI = 3.1415926535898
u = 4*PiI
Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")

;TmRes
;
; Set up Analysis parameters
;
!P.multi=[0,1,3]
Window,3,XSize=700,YSize=550
Erase
;Px1=[0.05,0.05,0.05]
;Px2=[0.95,0.95,0.95]
Py1=[0.3,0.3,0.4]
Py2=[1.0,1.0,2.0]
Px1=[0.05,0.05,0.05]
Px2=[1.,1.,1.]

Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
;FFTN=800
;PnTres=800
;NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
;MxF=5000
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
;MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(4,FFTN)    ; Time Series Array
TrArr=DblArr(4,FFTN)    ; FFT Array
;REPEAT Begin
; Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
;TRes=150
; NBlocs=Fix((NPnts-FFTN)/TRes)
 TmRes=PntRes*SInt
 Print,'The Time Resolution is ',TMRes,' Secs'
; stop
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
;Ans=1
; Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)

T(0)=MnT
;stop
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(PnTRes)
; stop
DispArr=DblArr(NBlocs,NFr,3)
PoyntArr=DblArr(NBlocs,NFr,3)
;stop
;CPArr=DblArr(NBlocs,NFr)
;Wsp=0.0

;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=SpW
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
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
for q=0,2 do $
begin
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
SpArr=DblArr(NFr+ism)   ; Double Prec. Spectral Array
For i=0,FFTN-1 do TsArr(0,i)=data0(i)
 For i=0,FFTN-1 do TsArr(1,i)=data1(i)
 For i=0,FFTN-1 do TsArr(2,i)=data2(i)
 For i=0,FFTN-1 do TsArr(3,i)=data3(i)
;
;end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN
 DTrend,TsArr(2,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(3,*),FFTN

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
 Poynt=fltarr(n_elements(TrArr(1,*)))
 ;CP=fltarr(n_elements(TrArr(1,*)))
;stop
  for yy=0, n_elements(TrArr(1,*)) -1 do $
 	begin
 		Poynt[yy]=(10./u)*[TrArr(0,yy)*conj(TrArr(1,yy))-TrArr(2,yy)*conj(TrArr(3,yy))]
 		;CP[yy]=TrArr(1,yy)*conj(TrArr(3,yy))
 endfor
 ;microwatts/square meter
 ;stop
 V2=Float(FFTN)
  For i=0,NFr-1 do $
  	Begin
  		V1=0.5*double(Poynt(i))
  		SpArr(i)=V1/V2
  end

;*********************************************************
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   DispArr(Bloc,i,q)=SpArr(i)*Wght(i)
  ; If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
  ; If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
  ; DispArr(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
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
  ; CPArr(Bloc,i)=CPArr(Bloc,i)*Wght(i)
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*PnTRes

 ;TmRes
 For i=0,FFTN-1 do TsArr(0,i)=data0(Posn+i)
 For i=0,FFTN-1 do TsArr(1,i)=data1(Posn+i)
 For i=0,FFTN-1 do TsArr(2,i)=data2(Posn+i)
 For i=0,FFTN-1 do TsArr(3,i)=data3(Posn+i)
End    ; end Bloc Loop
print,PnTRes
ENDFOR
;MnCPRng=Min(CPArr)
;MxCPRng=Max(CPArr)
;CPthres=MnCPRng+0.5*(MxCPRng-MnCPRng)
;for w=0,NBlocs -1 do $
;	begin
;		for m=0,NFr -1 do $
;			begin
				;Disparr[w,m]=(DispArr[w,m]-MnRng)*(254./(MxRng-MnRng))
;				if CPArr[w,m] LE CPthres then $
;					DispArr[w,m]=MxPow+10.
;		endfor
;endfor
;
;MnRng=Min(DispArr)
;MxRng=Max(DispArr)

 ;set_plot,'win'
; stop
FOR Q=0,2 DO $
BEGIN
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Power is ',Min(DispArr[*,*,q])
 Print,'Maximum Power is ',Max(DispArr[*,*,q])
 ;Window,8,XSize=500,YSize=400
 ;Erase
 Device,Decomposed=0
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
 ;b(fix(128-ii))=b(fix(ii/2))
 ;g(fix(128-ii))=g(fix(ii/2))
 ;r(fix(126+ii))=r(fix((254-ii/2)))
 ;b(fix(126+ii))=b(fix((254-ii/2)))
 ;g(fix(126+ii))=g(fix((254-ii/2)))
end
;FOR I=127,254 do $
;begin
;r(i)=110
;r(i)=170
;g(i)=i-1
;end
tvlct,r,g,b
; !P.multi=0
 DYNTV_crres1,DispArr[*,*,q],Title=Ttle[q],YTitle=YTtle,$
 XRange=[MnT,MxT],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnPow[q],MxPow[q]],Aspect=5.0,dat5=datt5[q],$
 Px1=Px1[q],Px2=Px2[q],Py1=Py1[q],Py2=Py2[q]
 Widget_control,state.dat_info, set_value=string('Re-plot done!')
 PoyntArr[*,*,q]=DispArr[*,*,q]
 He_cycl_freq ,state,cm_eph,cm_val,Datt5[q]
ENDFOR
eph_inter_win_multi,cm_eph,cm_val,state,Datt5
DispArr=0.0
 ;spectralpoyntps,cm_eph,cm_val,state,Dat5,DispArr
 ;stop
 end





