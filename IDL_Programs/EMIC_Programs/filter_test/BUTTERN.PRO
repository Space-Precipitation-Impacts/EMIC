; Butterworth Filter Program
;
; C. Waters  14 June 1995
; Physics Department
; University of Newcastle
; New South Wales, Australia
;
; Modification list :
; Altered input data for Newcastle STD2IDL program {Oct, 1995, CW}
;
Pro Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 pi=3.1415926535898
 Print,'In 1st Order Filter...'
 Wait,0.5
 a=Double((wc-2)/(wc+2))
 c=Double(wc/(wc+2))
 eta=1.0
 If (FiltType eq 1) then Begin
  zeta=Double(-cos(2*pi*CutFreq))
  a=Double(-(a-zeta)/(1-a*zeta))
  c=c*(1-zeta)/(1-a*zeta)
  eta=-1.0
 end
 YDat(0)=c*XDat(0)
 If (FiltType eq 1) Then YDat(0)=0.0
 i=Long(1)
 For i=Long(1),Long(LenX-1) do $
  YDat(i)=-a*YDat(i-1)+c*(XDat(i)+eta*XDat(i-1))
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
;
Pro Filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 pi=3.1415926535898
 Print,'In 2nd Order Filter...'
 Wait,0.5
 ar=Double(wc*cos(tmp))  ; Pass Theta(m) as tmp
 ai=Double(wc*sin(tmp))
 alp=Double(-2*ar)
 bet=Double(ar^2+ai^2)
 gamma=bet
; Bilinear Transform
 delt=1.0/(4.0+2.0*alp+bet)
 a=2.0*(bet-4.0)*Delt
 b=(4.0-2.0*alp+bet)*delt
 c=gamma*delt
 eta=2.0
 If (FiltType eq 1) Then Begin
  zeta=Double(-cos(2.0*cutfreq*pi))
  V1=Double(a-b*Zeta)
  V2=Double(V1*Zeta)
  psi=Double(1.0/(1.0-V2))
  c=psi*c*(1.0-zeta)^2
  bp=psi*((zeta-a)*zeta+b)
  a=psi*(2.0*zeta*(1.0+b)-a*(1.0+zeta^2))
  b=bp
  eta=-2.0
 end
 YDat(0)=c*XDat(0)
 YDat(1)=-a*YDat(0)+c*(XDat(1)+eta*XDat(0))
 For i=Long(2),Long(LenX-1) do Begin
  V1=Double(-A*YDat(i-1)-B*YDat(i-2))
  V2=Double(XDat(i)+Eta*XDat(i-1)+XDat(i-2))
  YDat(i)=V1+c*V2
 end
;Print,'a=',a
;Print,'b=',b
;Print,'c=',c
;Print,'c*eta=',c*eta
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
;
Pro Reverse,XDat,YDat,LenX
 Print,'Reversing Data...'
 Wait,0.5
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=XDat(LenX-i-1)
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
;
Pro FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=Double(2.0*Tan(CutFreq*pi))
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
 For m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
end
;
;  Main Program
;
pro buttern
pi=3.14159
FName=''
StaL=''
Print,'Butterworth Digital Filter'
Print,'Enter Input File Name : '
Read,FName
OpenR,u,FName,/Get_Lun
StaL=''
ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
 StaL,Year,Month,Day,Hour,Min,Sec,SInt,NPnts
LenX=Long(NPnts)
XDat=DblArr(LenX)
ReadF,u,XDat
Free_Lun,u
YDat=DblArr(LenX)
Theta=DblArr(6)
Set_Plot,'WIN'
Window,0,XSize=400,YSize=300
!Y.Range=[min(XDat),max(XDat)]
Plot,XDat,Title=StaL+'Unfiltered Data'
Print,'The Input Data has been Plotted'
Print,'Sample Interval is : ',SInt
Print,'Enter the Filter Type :'
Print,'1=High, 2=Low, 3=Band Pass'
Read,FiltType
FiltFlag=FiltType
Print,'Enter the Filter Order :'
Read,Order
SampF=Double(1.0/SInt)
Print,'SampF=',SampF
If (FiltType eq 1) or (FiltType eq 3) then begin
 Print,'Enter the LOW Frequency cut off (mHz) : '
 Read,cutfreq
 CutFreq=CutFreq/1000.0
 CutFreq=CutFreq/SampF
 FiltType=1
 Print,'HIGH Pass Filtering Data...'
 Wait,0.5
 FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 FiltType=FiltFlag   ; Used for BandPass
end
if (FiltType eq 2) or (FiltType eq 3) then begin
 print,'Enter the HIGH Frequency cut off (mHz) :'
 Read,CutFreq
 CutFreq=CutFreq/1000
 CutFreq=CutFreq/SampF
 FiltType=2
 Print,'LOW Pass Filtering Data...'
 Wait,0.5
 FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
end
Window,1,XSize=400,YSize=300
!Y.Range=[min(XDat),max(XDat)]
Plot,XDat,Title=StaL+'Filtered Data'
Print,'The Filtered Data has been Plotted'
Print,'Enter the OutPut File Name : '
Read,FName
OpenW,u,FName,/Get_Lun
PrintF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
 StaL,Year,Month,Day,Hour,Min,Sec,SInt,LenX
For i=Long(0),Long(LenX-1) do $
 PrintF,u,XDat(i)
Free_Lun,u
Print,'Finished.'
end
