;Program to compute Poynting flux from CRRES data
;
; C.L. Waters :  August, 1993
; University of Newcastle
; New South Wales
; Australia
;
;MODIFICATIONS: By Paul Manusiu 2001
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
;
; Main Program
;
Pro DPFluxnewc,cm_eph,cm_val,state,dat5
common orbinfo,orb,orb_binfile,orb_date
winnum=1
sig=0.5  ; for interp. spline
valnames=tag_names(cm_val)
Npnts=n_elements(cm_val.(0))
;XDat=DblArr(NPnts)
ttt=lonarr(Npnts)
;ttt=cm_val.(0)
;MnT=cm_val.(0)[0]
;MxT=cm_val.(0)[n_elements(cm_val.(0))-1]

;stop
;********************************************************************************
;Determine which component to plot
;
;for i=0, n_elements(valnames) -1 do $


;tp=where(XDat,count)
;print,count
;if count EQ 0 then $
;  Result = DIALOG_MESSAGE(string(Dat5)+' Component has no data !') else $
;  begin
;********************************************************************************
piI = 3.1415926535898
u = 4*PiI
text=strarr(1)
NPnts=Long(0)
NPnts=n_elements(cm_val.(0))
;ttt=timv
ttt=cm_val.(0)
MnT=long(ttt[0])
MinTime=MnT
TotTime=long(ttt[Npnts-1]-ttt[0])
SInt=[ttt[1]-ttt[0]]/1000.
Sint=Sint[0]
 if Dat5 EQ 'SX' then $
	begin
		data0=cm_val.(2)
		data1=cm_val.(6)
		data2=cm_val.(5)
		data3=cm_val.(3)
end
if Dat5 EQ 'SY' then $
	begin
		data0=-cm_val.(1)
		data1=cm_val.(6)
		data2=-cm_val.(4)
		data3=cm_val.(3)
end
if Dat5 EQ 'SZ' then $
	begin
		data0=cm_val.(1)
		data1=cm_val.(5)
		data2=cm_val.(4)
		data3=cm_val.(2)
end
;stop
;NPnts=TotTime/SInt
;stop
TArr=DblArr(NPnts)
TArr=ttt
; Set up Analysis parameters
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
Print,'Enter the FFT Analysis Length : '
Read,FFTN
;FFTN=3000
NyqF=1000.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
Print,'Enter the Maximum Frequency Required (mHz):'
Read,MxFr
;MxFr=100
DFr=1000.0/(FFTN*SINT)
NFreqs=Fix(MxFr/DFr)+1
MxFr=(NFreqs-1)*DFr

Print,'The Frequency Resolution is ',DFr,' mHz.'
TsArr=DblArr(4,FFTN)    ; Time Series Array
TrArr=DblArr(4,FFTN)    ; FFT Array
;REPEAT Begin
 ;Ans1=0
 Print,'Enter the Time Resolution (Points) :'
 Read,TmRes
 NBlocs=Fix((NPnts-FFTN)/TmRes)
 Print,'The Time Resolution is ',TmRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;stop
 ;Print,'Is this O.K ? [0=No]'
 ;Read,Ans
 ;Ans1=(Ans NE 0)
 ;endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=TArr(0)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TmRes*SInt)
DispArr=DblArr(NBlocs,NFreqs)
Wsp=0.0
;Print,'Enter the Spectral Weighting, n [f^n] : '
;Read,WSp
Wsp=0
Wght=DblArr(NFreqs)
For i=0,NFreqs-1 do Wght(i)=Float(i)^WSp
WndT=1
;Print,'Enter Windowing Option [1=Time, 2=Frequency Domain] : '
;Read,WndT
WndT=2
If (WndT LT 1) Then WndT=1
If (WndT GT 2) Then WndT=2
ism=0
Sum1=0.0
;stop
If (WndT EQ 2) Then $
Begin
 ;Print,'Enter the amount of Smoothing [Usually 2] : '
 ;Read,ism
ism=2
 Wnd=DblArr(5*ism)
 For i=0,4*ism do $
 Begin
  Wnd(i)=Exp(-(Float(i-2*ism)/Float(ism))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,4*ism do Wnd(i)=Wnd(i)/Sum1
 iLFr=2*ism
 LFr=iLFr*DFr
end
If (WndT EQ 1) Then Wnd=Hanning(FFTN)
;
; Major Loop Starts Here
;
SpArr=DblArr(NFreqs+2*ism)   ; Double Prec. Spectral Array
;For jj=0,1 do $
;Begin
 ;For i=0,FFTN-1 do TsArr(0,i)=data1(i)
 ;For i=0,FFTN-1 do TsArr(1,i)=data2(i)
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
;stop
 ;TrArr(2,*)=FFT(TsArr(2,*),1)
 Poynt=fltarr(n_elements(TrArr(1,*)))
;stop
 for yy=0, n_elements(TrArr(1,*)) -1 do $
 Poynt[yy]=(10./u)*[TrArr(0,yy)*TrArr(1,yy)-TrArr(2,yy)*TrArr(3,yy)]  ;microwatts/square meter
 ;stop
 V2=Float(FFTN)
  For i=0,NFreqs-1 do $
  Begin
  V1=double(Poynt(i))
  SpArr(i)=V1/(V2*V2)
  end
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
   For i=0,NFreqs-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
 end      ; end of If WndT = 1
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
   For i=0,iLFr-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
   For i=NFreqs-1-2*ism,NFreqs-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
   For i=iLFr,NFreqs-1-2*ism do $
   Begin
    DispArr(Bloc,i)=0.0
    Js=i-2*ism
    Je=i+2*ism
    iWn=-1
    For j=Js,Je do $
    Begin
     iWn=iWn+1
     DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
    end    ; end of J loop
    DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
   end     ; end of I loop
  end
       ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*TmRes
 ;For jj=0,2 do $
 ;Begin
 For i=0,FFTN-1 do TsArr(0,i)=data0(Posn+i)
 For i=0,FFTN-1 do TsArr(1,i)=data1(Posn+i)
 For i=0,FFTN-1 do TsArr(2,i)=data2(Posn+i)
 For i=0,FFTN-1 do TsArr(3,i)=data3(Posn+i)
 ;end
End    ; end Bloc Loop
;
Set_Plot,'WIN'
Device,decomposed=0
REPEAT Begin
 PAgn=0
 MnRng=Min(DispArr)
 MxRng=Max(DispArr)
 Print,'Minimum S is ',Min(DispArr)
 Print,'Maximum S is ',Max(DispArr)
 Print,'Enter Minimum for Plot :'
 Read,MnRng
 Print,'Enter Maximum for Plot :'
 Read,MxRng
 Window,10,XSize=500,YSize=400
 Erase
 LoadCT,13 ; 20
 Ttle='Orbit'+orb+' '+orb_date+' '+dat5+' Poynting Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (mHz)'
 YRngL=0
 Scl=1
 Ds=DblArr(NBlocs,NFreqs)
 ;Window,1,XSize=500,YSize=400
 DYNTV,Disparr,Title=Ttle,XTitle=XTtle,YTitle=YTtle,$
  XRange=[ttt(0),ttt(n_elements(ttt)-1)],YRange=[YRngL,MxFr],$
  Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5
 Print,'Another Plot at Different Colour Range [0=YES]'
 Read,Agn1
 PAg=Agn1 NE 0
 end UNTIL PAg
 Print,'Finished'
end
