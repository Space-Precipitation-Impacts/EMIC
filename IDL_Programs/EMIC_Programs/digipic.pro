; Procedure to Digitise Dynamic SV Plots to obtain
; FLR with time file under mouse control
; C. Waters  June, 1995
; Edmonton, Alberta
;
;
Pro digipic,XRngL,XRngH,Nx,YRngL,YRngH,Ny,OX,OY,$
 T15,Fr15,Pnts
TArr=DblArr(1000)
FrArr=DblArr(1000)
Fr15Arr=DblArr(128) ; 15 min array up to 32 hrs
T15Arr=DblArr(128)
For kk=0,127 do T15Arr(kk)=Long(kk)*900.
!x=OX & !y=OY
Print,'Press LEFT Button to Get Values'
Print,'Press RIGHT Button & MOVE when Finished'
;Print,!P.Color
PAx=DblArr(Ny)
FInc=(YRngH-YRngL)/(Ny-1)
For i=0,Ny-1 do PAx(i)=YRngL+i*FInc
Dm1=Float(XRngH-XRngL)
Lb=' '
ArrPL=' '
ii=0
REPEAT Begin
 Cursor,x,y,/Data,/Change
; Print,!err
 GOut=(!err EQ 4)  ; R button+move to exit
 If (!err EQ 1) Then $  ; L down + move
 Begin
  Dm=Float(x-XRngL)/Dm1
  ArrP=Fix(Dm*(Nx-1))
  If ArrP LT 0 Then ArrP=0
  If ArrP GT Nx-1 Then ArrP=Nx-1
  XYOuts,10,10,color=[0],Lb,/device    ; Black
  TLab=Tim(x)
  TArr(ii)=x
  FRArr(ii)=y
  ii=ii+1
  Lb=TLab+' '+StrTrim(String(y),2)+' mHz'
  color=!d.n_colors-1
  XYOuts,10,10,color=[235],Lb,/device
 End
end UNTIL GOut
Pnts=ii-1
Tme=TArr(0)
jj=-1
TooBig=0 & Timehit=0
REPEAT Begin
 jj=jj+1
 If (Tme LE T15Arr(jj)) Then Timehit=1
 If jj GE 127 Then TooBig=1
end UNTIL Timehit or TooBig
If Tme EQ T15Arr(jj) Then $
Begin
 Fr15Arr(jj)=FRArr(0)
 jj=jj+1
end
Tme=T15Arr(jj)
For ii=1,Pnts-1 do $
Begin
 If TArr(ii) GE Tme Then $
 Begin
  Fr15Arr(jj)=(FRArr(ii)-FRArr(ii-1))/(TArr(ii)-TArr(ii-1))$
              *(T15Arr(jj)-TArr(ii-1))+FRArr(ii-1)
;  print,TArr(ii),FrArr(ii),T15Arr(jj),Fr15Arr(jj)
  jj=jj+1
  If jj LE 127 then Tme=T15Arr(jj)
 end
end
Cnt=0
For ii=0,127 do $
 If Fr15Arr(ii) NE 0 Then Cnt=Cnt+1
T15=DblArr(Cnt) & Fr15=DblArr(Cnt)
Cnt=0
For ii=0,127 do $
Begin
 If Fr15Arr(ii) NE 0 Then $
 Begin
  T15(Cnt)=T15Arr(ii)
  Fr15(Cnt)=Fr15Arr(ii)
  Cnt=Cnt+1
 end
end
end
