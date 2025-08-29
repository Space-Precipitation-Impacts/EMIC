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
Pro DPpoynt,cm_eph,cm_val,state,Dat5,noi
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl;,DispArr
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
;Common BLK3,FrRes,TRes,FBlks
Common BLK4,MnPow,MxPow
common Data,XDat
common poynt_data,data0,data1,data2,data3
common orbinfo,orb,orb_binfile,orb_date
common Poyntpow, PoyntArr
;common CPow, MxCPow, MnCPow,CPthres,CPArr
;common CPow,CPArr
;
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common datafiles, data_files,no_data,para_struct
common logs, filename1,filename2
common fre_timres, fft_limit, timres_limit
;
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
;********************************************************************************
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
TArr=DblArr(NPnts)
TArr=ttt
;********************************************************************************
Widget_control,state.dat_info,$
set_value=string('Calculcating power spectra with default values......')
Widget_control,state.text,$
set_value=string('Calculcating Poynting spectra with default values......'),/append,/show

Widget_control,state.text,$
set_value=string('default values: FFTN = 800points, Time Res = 80points'),/append,/show
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
;
Widget_control,state.text,$
set_value='There are '+string(NPnts)+' Points.',/append,/show
Print,'There are ',NPnts,' Points.'
Widget_control,state.text,$
set_value='The Sample Period is '+string(SInt)+'sec.',/append,/show

Print,'The Sample Period is ',SInt,' Sec.'
;Print,'Enter the FFT Analysis Length : '
;Read,FFTN
FFTN=fft_limit
;FFTN=800
;PnTres=200
;NyqF=1000.0/(2.0*SInt)
NyqF=1.0/(2.0*SInt)
Widget_control,state.text,$
set_value='The Nyquist is '+string(NyqF)+'mHz',/append,/show
Print,'The Nyquist is ',NyqF,' mHz'
;Print,'Enter the Maximum Frequency Required (mHz):'
MxF=float(para_struct[noi].max_freq)
;Read,MxF
;DelF=1000.0/(FFTN*SINT)
DelF=1.0/(FFTN*SINT)

NFr=Fix(MxF/DelF)+1
;MxFr=(NFr-1)*DelF
;stop
Widget_control,state.text,$
set_value='The Frequency Resolution is '+string(DelF)+'mHz',/append,/show
Print,'The Frequency Resolution is ',DelF,' mHz.'
TsArr=DblArr(4,FFTN)    ; Time Series Array
TrArr=DblArr(4,FFTN)    ; FFT Array
;REPEAT Begin
 Ans1=0
 ;Print,'Enter the Time Resolution (Points) :'
 ;Read,TRes
TRes=timres_limit
 NBlocs=Fix((NPnts-FFTN)/TRes)
 Widget_control,state.text,$
set_value='The Time Resolution is '+string(TRes*SInt)+' Secs',/append,/show
 Print,'The Time Resolution is ',TRes*SInt,' Secs'
   Widget_control,state.text,$
set_value='You have '+string(NBlocs)+' FFT Blocks.',/append,/show

 Print,'You have ',NBlocs,' FFT Blocks.'
;stop
 ;Print,'Is this O.K ? [0=No]'
 Widget_control,state.text,$
set_value='Calculating Spectrum.....',/append,/show
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
		;Removed 0.125 factor 14/09/01 Tapu'osi Loto'aniu
  		;V1=0.125*double(Poynt(i))

  		V1=double(Poynt(i))
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
 For i=long(0),FFTN-long(1) do TsArr(0,i)=data0(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(1,i)=data1(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(2,i)=data2(Posn+i)
 For i=long(0),FFTN-long(1) do TsArr(3,i)=data3(Posn+i)
End    ; end Bloc Loop
print,TRes
;

;********************************************************************************
;Poynting Flux threshold set to 0.1uW/Hz^2 , Tapu'osi Loto'aniu 14/09/01
;
index=where(abs(disparr) LT 0.1, count)
disparr[index]=0.0
;
;*********************************************************************************
;Poynting Flux Spectral Plot
;
Set_Plot,'WIN'
PAgn=0
Widget_control,state.text,$
set_value='Maximum Poynting Flux is '+string(Max(Disparr)),/append,/show
Widget_control,state.text,$
set_value='Minimum Poynting Flux  is '+string(Min(Disparr)),/append,/show
 Print,'Minimum Poynting Flux is ',Min(DispArr)
 Print,'Maximum Poynting Flux is ',Max(DispArr)
 Erase
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

 Ttle='Orbit'+orb+' '+orb_date+' '+Dat5+' Poynting Spectrum'
 XTtle='Time (UT)'
 YTtle='Frequency (Hz)'
 YRngL=0
 Scl=1
 !P.multi=0
 window,2,xsize=500,ysize=400

;stop
;***********************************************************************************
;Remove spikes
;temp_disparr=disparr
;
;index_max=where(max(disparr) EQ disparr,count_max)
;if count_max LE 5 then $
;begin
; if (index_max[0] LT n_elements(disparr)-5) and  (index_max[0] GT 5) then $
; begin
; temp1=disparr[index_max[0]+1:index_max[0]+5]
; temp2=disparr[index_max[0]-5:index_max[0]-1]
; disparr[index_max]=(total(temp1)+total(temp2))/10.
; end else $
; begin
; temp1=disparr[0:9]
; disparr[index_max]=(total(temp1))/10.
; endelse
;end


;index_min=where(min(disparr) EQ disparr,count_min)
;if count_min LE 5 then $
;begin
;if (index_min[0] LT n_elements(disparr)-5) and  (index_min[0] GT 5) then $
; begin
; temp1=disparr[index_min[0]+1:index_min[0]+5]
;temp2=disparr[index_min[0]-5:index_min[0]-1]
;disparr[index_min]=(total(temp1)+total(temp2))/10.
;end else $
; begin
; temp1=disparr[0:9]
; disparr[index_min]=(total(temp1))/10.
; endelse
;end
;*******************************************************************************
;stop
MnRng=Min(DispArr)

MxRng=Max(DispArr)

if abs(MxRng) GE abs(MnRng) then $
MnRng=-MxRng else $
MxRng=abs(MnRng)

 DYNTV_crres,DispArr,Title=Ttle,YTitle=YTtle,$
 XRange=[Min(ttt[0]),Max(ttt[Npnts-1])],YRange=[YRngL,MxF],$
 Scale=Scl,Range=[MnRng,MxRng],Aspect=1.5,ymargin=10.5,dat5=dat5
 PoyntArr=DispArr

PntRes=TRes
MnPow=double(MnRng)
MxPow=double(MxRng)

He_cycl_freq ,state,cm_eph,cm_val,Dat5
Loadct,0
eph_inter_win,cm_eph,cm_val,state,Dat5

;DPChoice_poynt,Dat5
Print,'Finished'

;stop
end
