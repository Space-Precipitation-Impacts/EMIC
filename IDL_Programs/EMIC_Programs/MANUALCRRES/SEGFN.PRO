; Program to get a Section of Data
;
;  C Waters Sept 1993
;
; Canadian Network for Space Research
; University of Alberta,
; Edmonton
; CANADA
;
; Last Modified
; Del File format option and remove DTrend (Oct 1996, CW)
;
;
Function Tim,Sec
 Hr=Long(Sec)/3600
 Mn=Long(Sec-3600*Hr)/60
 Sc=Sec Mod 60
Return,String(hr,mn,sc,$
   Format="(I2.2,':',I2.2,':',i2.2)")
end
;
; Main
FName=''
Print,'Obtain Section Data File'
Print,'Enter Data File Name : '
Read,FName
OpenR,u,FName,/Get_Lun
StaL=''
IFmt=1
ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
 StaL,Year,Month,Day,Hour,Min,Sec,SInt,NPnts
XDat=DBlArr(NPnts)
ReadF,u,XDat
Free_Lun,u
Hour=Long(Hour)
STm=Long(Hour*3600+Min*60+Sec)
Print,'Data Start Time is ',Tim(STm)
Print,'Sample Interval is ',SInt,' Seconds'
Print,'Number Data Points is ',NPnts
REPEAT begin
 Ans1=0
 Print,'Enter Time Series START Point [1=First]: '
 Read,Strt
 Strt=Strt-1
 Tm1=STm+Strt*SInt
 Print,'Start Time is ',Tim(Tm1)
 Print,'Is this O.K ? [0=No]'
 Read,Ans
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
Print,'Start Point is ',Strt
Print,'Total Number Data Points is ',NPnts
REPEAT begin
 Ans1=0
 Print,'Enter Time Series END Point : '
 Read,EPnt
 Tm2=Stm+EPnt*SInt
 Print,'END Time is ',Tim(Tm2)
 Print,'Is this O.K ? [0=No]'
 Read,Ans
 Ans1=(Ans NE 0)
 endrep $
UNTIL Ans1
Leng=EPnt-Strt
Print,'Number Points Chosen = ',Leng
;
Hr=Fix(Tm1/3600)
Mn=Fix((Tm1-Hr*3600)/60)
Sc=Tm1 MOD 60
FName=''
Print,'Enter OutPut File Name : '
Read,FName
OpenW,u,FName,/Get_Lun
If (IFmt EQ 1) Then $
 PrintF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
  StaL,Year,Month,Day,Hr,Mn,Sc,SInt,Leng
For i=Strt,Strt+Leng-1 do $
 PrintF,u,XDat(i)
Free_Lun,u
Print,'Finished.'
End