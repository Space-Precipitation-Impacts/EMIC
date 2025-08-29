;DATE: 10/06/00
;TITLE: sample5.pro
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
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Function XTLab,Axis,Index,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Pro random_data3
!X.charsize=2.0;1.5
!Y.charsize=2.0;1.5
pi=3.14
ct=1000
index=INDGEN(8)
indx=[7,6,5,4,3,2,1,0]
data_32 = fltarr(ct)
tims_32=lonarr(ct)
;frq = fltarr(1000)
for i=0,ct-1 do $
          begin
             tims_32[i] = long(10000000) + long(64)*i
             data_32[i] = sin(2*pi*20*i)
				;frq[i] = i/1000.
endfor
count=long(0)
datafft=(abs(FFT(data_32,-1)))^2.0

freq_16=1000.0/ABS(tims_32[1]-tims_32[0])
!P.Multi = [0,1,3]
set_plot,'WIN'
Window,1, Xsize=650,Ysize=680,title='Wave fields'
    plot,tims_32,data_32,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',ymargin=[5,5],xmargin=[10,12];,$
    ;xrange=[tims_32[0],tims_32[100]]
    csd_power,data_old_16,data_32,freq_16,ct,fff1,fff2,fff12,fFF,mm,aa
    ;plot,fff,fff1,xrange=[min(fff),1.0],xtitle='Frequency (Hz)'
    plot,fff,datafft,xrange=[min(fff),0.5],xtitle ='Frequency (Hz)',ymargin=[5,5],xmargin=[10,12];,$
print,max(datafft)
print,min(datafft)
Xdat=data_32
;stop
;for ii=0, n_elements(XDat)-1 do $
;		if XDat[ii]  GT 0.999 then $
;			print,Xdat[ii],' ',tim(tims_32[ii])
print,Xdat[100],'  ',tim(tims_32[100])
;stop
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SInt=(tims_32[1]-tims_32[0])/1000.
;stop
Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
;stop
;stop
;
; Set up Analysis parameters
;
NPnts = ct
Print,'There are ',NPnts,' Points.'
Print,'The Sample Period is ',SInt,' Sec.'
Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=100
;PnTres=200
NyqF=1.0/(2.0*SInt)
Print,'The Nyquist is ',NyqF,' Hz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=0.5
;Read,MxF
DelF=1.0/(FFTN*SINT)
NFr=Fix(MxF/DelF)+1
MxFr=(NFr-1)*DelF
Print,'The Frequency Resolution is ',DelF,' Hz.'
TsArr=DblArr(FFTN)    ; Time Series Array
TrArr=DblArr(FFTN)    ; FFT Array
REPEAT Begin
 Ans1=0
 Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=5
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
 Print,'You have ',NBlocs,' FFT Blocks.'
 ;Print,'Is this O.K ? [0=No]'
Print,'Calcuting Spectrum.....'
 ;Read,Ans
Ans=1
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
T=LonArr(NBlocs)
T(0)=tims_32(0);/1000.;Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(TRes*SInt)
 ;stop
DispArr=DblArr(NBlocs,NFr)
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
  Wnd(i)=Exp(-(Float(i-2*ism)/Float(ism))^2)
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
 TrArr=FFT(TsArr,1)    ;Now implemented with forward FFT
 ;stop
 For i=0,NFr-1 do $
 Begin
 ;stop
  V1=(abs(TrArr(i)))^2
 ;V1=TrArr(i)
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end
;******************************************************************************
;
 If (WndT EQ 1) Then $   ; Time Domain Window
 Begin
  For i=0,NFr-1 do $
  Begin
   SpArr(i)=SpArr(i)*Wght(i)

 	;stop
      If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
      If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
 ;        DispArr(Bloc,i)=20*ALog10(SpArr(i))
  end    ; end of i Loop
 end      ; end of If WndT = 1
 ;
 ;*******************************************************************************
 ;
 If (WndT EQ 2) Then $   ; Frequency Domain Window
 Begin
  For i=long(0),iLFr-1 do $
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
      If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
  ;    DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
  end
  For i=NFr-1-ism,NFr-1 do $  ;top frequency end
  Begin
   DispArr(Bloc,i)=SpArr(i)*Wght(i)
  If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
   ;  DispArr(Bloc,i)=20*ALOG10(DispArr(Bloc,i))
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
    DispArr(Bloc,i)=DispArr(Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DispArr(Bloc,i)=DispArr(Bloc,i)*Wght(i)
			If (DispArr(Bloc,i) LT 1e-6) Then DispArr(Bloc,i)=1e-6
 	;  		DispArr(Bloc,i)=20*ALog10(DispArr(Bloc,i))
  end     ; end of I loop
 end      ; end of If Freq Domain Filt.
;
;*********************************************************************
 Posn=(Bloc+1)*TRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End    ; end Bloc Loop
;
MnRng=Min(DispArr)
MxRng=Max(DispArr)
;print,'hello',max(Disparr)*V1*V1
;
;**********************************************************************
;calculate dB for Power
;
;Disparr = 10*Alog10(Disparr/MxRng)
;**********************************************************************
;
MnRng=Min(DispArr)
MxRng=Max(DispArr)

 ;set_plot,'win'
Set_Plot,'WIN'
;REPEAT Begin
 PAgn=0
 Print,'Minimum Log Power is ',Min(DispArr),'dB'
 Print,'Maximum Log Power is ',Max(DispArr),'dB'
 ;print,Disparr[0:10]
 ;Window,0,XSize=500,YSize=400
 ;Erase
 Device,Decomposed=0
 LoadCT,13  ;13
 Ttle='Test Power Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1
 ;!P.multi=0
 dat5='test'
 DYNTV_crres_test,DispArr,Title=Ttle,YTitle=YTtle,xtitle='UT',$
 XRange=[Min(tims_32[0]),Max(tims_32[Npnts-1])],YRange=[YRngL,MxFr],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=4.0,ymargin=[8,0],xmargin=[10,5],dat5=dat5
;endelse
PntRes=TRes
MnPow=MnRng
MxPow=MxRng
print,'FFT max ', max(datafft)
print,'FFT min ',min(datafft)

Print,'Finished'
!X.charsize=1.0
!Y.charsize=1.0
Print,freq_16
;stop
end
