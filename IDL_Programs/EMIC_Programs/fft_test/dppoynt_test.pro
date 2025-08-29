;AUTHORS: C.L.Waters & T.Loto'aniu
;
;PURPOSE: Compute Poynting Flux in Spectral Domain
;
;MAIN FFT ALGORITHM:   C.L. Waters :  August, 1993
; 					   Canadian Network for Space Research
; 					   The University of Alberta
; 					   Edmonton, Alberta
; 					   Canada
;
;MODIFICATION HISTORY :
;
;C. L. Waters:
; * Added Smoothing in the Freq. Domain { Sept, 1994, CW}
; * Blanked out high frequency end where no smoothing is done (July, 97, CW)
;
;T. Loto'aniu:
; * Poynting Flux subroutines {May, 2001)
; * Calls Control Wigdet (Graphical User Interface) {May 2001}
; * Calls He+ cyclotron Freq subroutine {May 2001}
;
;
;FUNCTION XTLabps,value
; Ti=value
; Hour=Long(Ti)/3600
; Minute=Long(Ti-3600*Hour)/60
; Secn=Ti-3600*Hour-60*Minute
; RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;
;Function YFLab,Val
;Return,String(Val,Format="(F5.1)")
;end
;
;FUNCTION XTLab,axis,index,value
;Ti=value
;Hour=Long(Ti)/3600
;Minute=Long(Ti-3600*Hour)/60
;RETURN,String(Hour,Minute,$
;       Format="(I2.2,':',I2.2)")
;end
;

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

Function Tim,Sec
 Hr=Long(Sec)/3600
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end
;
;
; Main Program
;
Pro DPpoynt_test,cm_eph,cm_val,state,Dat5
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
data_32a = fltarr(ct)
tims_32=lonarr(ct)
;Y = [0.0, 0.1, 0.2, 0.5, 0.8, 0.9, $
;    0.99, 0.9, 0.8, 0.5, 0.2, 0.1, 0.0]
;
;vol = CONGRID(Y, 20000)
;stop
for i=0,ct-1 do $
          begin
             tims_32[i] = long(00000010) + long(64)*i
             data_32[i] = 1.01*sin(2.*pi*200.*i/(ct/4.5))
             data_32a[i] = 1.01*sin(2*pi*200*i/(ct/4.5));+Pi)
endfor
count=long(0)
;stop
!P.Multi = [0,1,2]
set_plot,'WIN'
Window,0, Xsize=700,Ysize=600,title='Test Pattern Wave field'
    plot,tims_32,data_32,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
    ytitle='Amplitude',$
    xmargin=[10,10],ymargin=[2,5],title='Test Signal Pure Sine Wave',$
    xrange=[tims_32[0],tims_32[500]]
;plot,tims_32,data_32a,XStyle=1,Xticks =3,XTickFormat='XTLabbb',xtitle ='Time (UT)',$
 ;   ytitle='Amplitude',$
  ;  xmargin=[10,10],ymargin=[2,5],title='Test Signal Pure Sine Wave',$
   ; xrange=[tims_32[0],tims_32[500]]


;stop
Tarr=tims_32
index = where(abs(data_32) GE 1.0,long(count))
;print,index
;print,data_32[index]
sam_int = abs(long(tims_32[1] - tims_32[0]))
tim_int = abs(long(tims_32[index[1]] - tims_32[index[0]]))
tim_len = abs(long(tims_32[n_elements(tims_32)-1] - tims_32[0]))

perd = tim_int/(1000.)*2.0
print,'sample interval:',sam_int/1000.,string(' s')
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
piI = 3.1415926535898
u = 4*PiI
poynt_32=10./u*[data_32*data_32a]; - data_32a*data_32]

plot,tims_32,poynt_32,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
    ytitle='Amplitude',$
    xmargin=[10,10],ymargin=[2,5],title='Poynting',$
    xrange=[tims_32[0],tims_32[500]]

;stop
;
; Set up Analysis parameters
;
Npnts=ct
Sint = sam_int/1000.
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=800
;PnTres=200
;NyqF=1000.0/(2.0*SInt)
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=2.0
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
DelF=1.0/(FFTN*SINT)

NFr=Fix(MxF/DelF)+1
;MxFr=(NFr-1)*DelF
;stop
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(2,FFTN)    ; Time Series Array
TrArr=ComplexArr(2,FFTN)    ; FFT Array
;REPEAT Begin
 Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=150
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
;stop
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
Ans=1
 Ans1=(Ans NE 0)
; endrep $
;UNTIL Ans1
T=LonArr(NBlocs)
T(0)=TArr(0);Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr)
;CPArr=DblArr(NBlocs,NFr)
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
 For i=long(0),FFTN-1 do TsArr(0,i)=data_32(i)
 For i=long(0),FFTN-1 do TsArr(1,i)=data_32a(i)
 ;For i=long(0),FFTN-1 do TsArr(2,i)=data2(i)
 ;For i=long(0),FFTN-1 do TsArr(3,i)=data3(i)
;
;end
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN
 ;DTrend,TsArr(2,*),FFTN     ; Call Linear Detrend
 ;DTrend,TsArr(3,*),FFTN

 ;DTrend,TsArr(2,*),FFTN
 If (WndT EQ 1) Then $
 Begin
  For jj=0,1 do $
  Begin
   For i=0,FFTN-1 do TsArr(jj,i)=TsArr(jj,i)*Wnd(i)  ; Hanning
  end
 end
 TrArr(0,*)=FFT(TsArr(0,*),-1)    ; FFT - BACKWARD so NO 1/N
 TrArr(1,*)=FFT(TsArr(1,*),-1)
 ;TrArr(2,*)=FFT(TsArr(2,*),1)    ; FFT - BACKWARD so NO 1/N
 ;TrArr(3,*)=FFT(TsArr(3,*),1)
;stop
 ;TrArr(2,*)=FFT(TsArr(2,*),1)
 ;Poynt=dblarr(n_elements(TrArr(1,*)))
 ;CP=fltarr(n_elements(TrArr(1,*)))
;stop
 ;for yy=long(0), n_elements(TrArr(1,*)) -long(1) do $
; 	begin
 		Poynt1=10.*(1.0/u)*TrArr(0,*)*conj(TrArr(1,*));-TrArr(2,yy)*conj(TrArr(3,yy))]
 ;		CP[yy]=(10./u)*TrArr(1,yy)*conj(TrArr(3,yy))
 ;endfor
 ;microwatts/square meter
 ;stop
  Poynt=complexarr(n_elements(TrArr(1,*)))
  For ii=long(0),n_elements(TrArr(1,*))-1 do $
  Poynt[ii] = Poynt1[*,ii]

 V2=Float(FFTN)
  For i=long(0),NFr-1 do $
  	Begin
  		V1=0.5*double(Poynt(i));^2.0
  		SpArr(i)=V1;/(V2*V2)
  ;		CP[i]=Cp[i]/(V2*V2)

  end
;stop
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
  For i=0,iLFr-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
  ;For i=0,iLFr-1 do CPArr(Bloc,i)=abs(CP(i))*Wght(i)
  For i=NFr-1-ism,NFr-1 do DispArr(Bloc,i)=SpArr(i)*Wght(i)
  ;For i=NFr-1-2*ism,NFr-1 do CPArr(Bloc,i)=abs(CP(i))*Wght(i)

  For i=iLFr,NFr-1-ism do $
  Begin
   DispArr(Bloc,i)=0.0
   ;CPArr(Bloc,i)=0.0
   Js=i-ism
   Je=i+ism
   iWn=-1
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
	;CPArr(Bloc,i)=CPArr(Bloc,i)+Wnd(iWn)*abs(CP(j))
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
   ;CPArr(Bloc,i)=CPArr(Bloc,i)*Wght(i)
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
 Posn=long((long(Bloc)+1)*TRes)
;print,Posn
;print,i
;print,Bloc
 ;For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
 For i=long(0),FFTN-long(1) do TsArr(0,i)=data_32(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(1,i)=data_32a(Posn+i)
 ;For i=long(0),FFTN-long(1) do TsArr(2,i)=data2(Posn+i)
 ;For i=long(0),FFTN-long(1) do TsArr(3,i)=data3(Posn+i)
End    ; end Bloc Loop
print,TRes
;
Disparr=Disparr*13.9
MnRng=Min(DispArr)

MxRng=Max(DispArr)
if abs(MxRng) GE abs(MnRng) then $
MnRng=-MxRng else $
MxRng=abs(MnRng)

;********************************************************************************


;*********************************************************************************
;Poynting Flux Spectral Plot
;
Set_Plot,'WIN'
 PAgn=0
 Print,'Minimum Poynting Flux is ',Min(DispArr)
 Print,'Maximum Poynting Flux is ',Max(DispArr)
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
 r(0)=255
 g(0)=255
 b(0)=255
 for ii=0,127 do $
  begin
   r(255-ii)=128+ii
 end
 tvlct,r,g,b
dat5='hello'
 Ttle='Orbit Poynting Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 CbTle='Energy Flux (uW/m!U2!n/Hz)'
 YRngL=0
 Scl=1
 !P.multi=0
 window,2,xsize=500,ysize=400
 DYNTV_crres_test,DispArr,Cbtle=Cbtle,Title=Ttle,YTitle=YTtle,$
 XRange=[Min(Tarr[0]),Max(Tarr[Npnts-1])],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5,ymargin=10.5,dat5=dat5
 PoyntArr=DispArr

PntRes=TRes
MnPow=double(MnRng)
MxPow=double(MxRng)
;He_cycl_freq ,state,cm_eph,cm_val,Dat5
;eph_inter_win,cm_eph,cm_val,state,Dat5
;****************************************

Loadct,17
 TVLCT,r,g,b,/get
 r(0)=0
 g(0)=0
 b(0)=0
 tvlct,r,g,b
Dat5='xx'
Fname='Poynt.ps'
;spectralps2_test,tims_32,Dat5,DispArr,Fname
;*****************************************
;DPChoice_poynt,Dat5
Print,'Finished'

;stop
end
