
;

;
;
; MAIN PROCEDURE STARTS HERE
;
pro doo;, MnPow,MxPw
;common DispArrX,DispArrY,DispArrZ,T
common uvalues, ff,f2,f3,f4,f5,f6,dat5,ser5,fil_info
common orbinfo,orb,orb_binfile,orb_date
Common BLK34,Xdat,Ydat,Zdat,Dte
Common cm_crres,state,cm_eph,cm_val
Common BLK1,NPnts,SInt,FFTN,DelF,NyqF,MxF,PntRes,NBlocs,NFr
Common BLK2,SpW,SpTyp,Smo
Common BLK4,MnPow,MxPow
Common BLK5,Ttle,XTtle,YTtle,YRngL,MxFr,MnT,MxT,Scl,DispArr

FName='' & StaL='' & IFmt=1  ;Data Format [1=CLW, 2=JCS]
nname = tag_names(cm_val)
print,nname
print,dat5
;stop
if dat5 EQ 'ALL E FIELDS' or dat5 EQ 'EX' or dat5 EQ 'EY' or dat5 EQ 'EZ' then $
 begin

XDat=DblArr(NPnts)
Xdat=cm_val.(1)
Ydat=cm_val.(2)
Zdat=cm_val.(3)
endif
if dat5 EQ 'ALL DB FIELDS' or dat5 EQ 'DBX' or dat5 EQ 'DBY' or dat5 EQ 'DBZ' then $
 begin
XDat=DblArr(NPnts)
Xdat=cm_val.(4)
Ydat=cm_val.(5)
Zdat=cm_val.(6)
endif
stop
;begin
sstate=state
StaL='CRRES ORBIT'
Year=2001
Month=10
Day=10
Hour=10
Min=10
Sec=10
SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
SSSInt=SSINt/1000.0
SInt=SSSINt
;NPnts=NPntss
Dte=String(Day,Month,Year,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")

NFr=Fix(MxF/DelF)+1
MxF=(NFr-1)*DelF
TsArr=DblArr(3,FFTN)    ; Time Series Array
TrArr=DblArr(3,FFTN)    ; FFT Array
T=LonArr(NBlocs)
T(0)=Long(Hour)*3600+Long(Min)*60+Long(Sec)
For i=1,NBlocs-1 do $
 T(i)=T(i-1)+Long(PntRes*SInt)
DispArr=DblArr(3,NBlocs,NFr)
;
Wght=DblArr(NFr)
For i=0,NFr-1 do Wght(i)=Float(i)^SpW
Sum1=0.0
For i=0,FFTN-1 do TsArr(0,i)=XDat(i)
For i=0,FFTN-1 do TsArr(1,i)=YDat(i)
For i=0,FFTN-1 do TsArr(2,i)=ZDat(i)
If (SpTyp EQ 1) Then $
Begin
 Wnd=DblArr(5*Smo)
 For i=0,4*Smo do $
 Begin
  Wnd(i)=Exp(-(Float(i-2*Smo)/Float(Smo))^2)
  Sum1=Sum1+Wnd(i)
 End
 For i=0,4*Smo do Wnd(i)=Wnd(i)/Sum1
 iLFr=2*Smo
 LFr=iLFr*DelF
end
If (SpTyp EQ 0) Then Wnd=Hanning(FFTN)
PTyp=2
;Print,'Power Type [1=Linear, 2=Log10] : '
;
; Major Loop Starts Here
;
Print,'CALCULATING SPECTRUM.... PLEASE WAIT'
SpArr=DblArr(NFr)   ; Double Prec. Spectral Array
For Bloc=0,NBlocs-1 do $
Begin
 DTrend,TsArr(0,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(1,*),FFTN     ; Call Linear Detrend
 DTrend,TsArr(2,*),FFTN     ; Call Linear Detrend

 If (SpTyp EQ 0) Then $
  For i=0,FFTN-1 do TsArr(*,i)=TsArr(*,i)*Wnd(i)  ; Hanning
 TrArr(0,*)=FFT(TsArr(0,*),1)    ; FFT - BACKWARD so NO 1/N
 TrArr(1,*)=FFT(TsArr(1,*),1)
  TrArr(2,*)=FFT(TsArr(2,*),1)
 For i=0,NFr-1 do $
 Begin
  V1=(ABS(TrArr(i)))^2
  V2=Float(FFTN)
  SpArr(i)=V1/(V2*V2)
 end;
 If (SpTyp EQ 0) Then $   ; Time Domain Window
 Begin
  If (PTyp EQ 1) Then $
   For i=0,NFr-1 do DispArr(*,Bloc,i)=SpArr(i)*Wght(i)
  If (PTyp EQ 2) Then $
  Begin
   For i=0,NFr-1 do $
   Begin
    SpArr(i)=SpArr(i)*Wght(i)
    If (SpArr(i) GE 1e10) Then SpArr(i)=1e10
    If (SpArr(i) LT 1e-6) Then SpArr(i)=1e-6
    DispArr(*,Bloc,i)=20*ALog10(SpArr(i))
   end    ; end of i Loop
  end     ; end of If PTyp = 2
 end      ; end of If WndT = 1
 If (SpTyp EQ 1) Then $   ; Frequency Domain Window
 Begin
  For i=0,iLFr-1 do $
  Begin
   DispArr(*,Bloc,i)=SpArr(i)*Wght(i)
   If (PTyp EQ 2) Then $
   Begin
     If (DispArr(0,Bloc,i) LT 1e-6) Then DispArr(0,Bloc,i)=1e-6
     If (DispArr(1,Bloc,i) LT 1e-6) Then DispArr(1,Bloc,i)=1e-6
      If (DispArr(2,Bloc,i) LT 1e-6) Then DispArr(2,Bloc,i)=1e-6
    DispArr(*,Bloc,i)=20.*ALOG10(DispArr(*,Bloc,i))
   end
  end
  ct=0L
  For i=iLFr,NFr-1-2*Smo do $
  Begin
   DispArr(0,Bloc,i)=0.0
   DispArr(1,Bloc,i)=0.0
   DispArr(2,Bloc,i)=0.0

   Js=i-2*Smo
   Je=i+2*Smo
   iWn=-1
   ;ct=ct+1
   ;print,ct
   For j=Js,Je do $
   Begin
    iWn=iWn+1
    DispArr(*,Bloc,i)=DispArr(*,Bloc,i)+Wnd(iWn)*SpArr(j)
   end    ; end of J loop
   DispArr(*,Bloc,i)=DispArr(*,Bloc,i)*Wght(i)
   If (PTyp EQ 2) Then $
   Begin
    If (DispArr(0,Bloc,i) LT 1e-6) Then DispArr(0,Bloc,i)=1e-6
     If (DispArr(1,Bloc,i) LT 1e-6) Then DispArr(1,Bloc,i)=1e-6
      If (DispArr(2,Bloc,i) LT 1e-6) Then DispArr(2,Bloc,i)=1e-6
    DispArr(*,Bloc,i)=20*ALog10(DispArr(*,Bloc,i))
   end    ; end of If PTyp = 2
  end     ; end of I loop
  For i=NFr-2*Smo,NFr-1 do DispArr(*,Bloc,i)=-120.
 end      ; end of If Freq Domain Filt.
 Posn=(Bloc+1)*PntRes
 For j=0,FFTN-1 do TsArr(j)=XDat(Posn+j) ; New Data
End    ; end Bloc Loop
;

;
DispArrX=DblArr(NBlocs,NFr)
DispArrY=DblArr(NBlocs,NFr)
DispArrZ=DblArr(NBlocs,NFr)

 For ii=0,NBlocs-1 do $
 Begin
  For jj=0,NFr-1 do DisparrX(ii,jj)=DispArr(0,ii,jj)
    For jj=0,NFr-1 do DisparrY(ii,jj)=DispArr(1,ii,jj)
      For jj=0,NFr-1 do DisparrX(ii,jj)=DispArr(2,ii,jj)
 end
DOO_PLOT,DispArrX,DispArrY,DispArrZ,T

END


