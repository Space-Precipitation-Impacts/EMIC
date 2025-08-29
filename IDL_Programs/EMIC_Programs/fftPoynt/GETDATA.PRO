; Procedure to Get Data
; IFmt=1 is CLW
; IFmt=2 is JCS
;
; C. Waters : June, 1995
; 
Pro GetData,FName,IFmt,StL,Yr,Mth,Day,Hr,Min,$
  Sec,SInt,NPnts,DmArr,Dte
OpenR,u,FName,/Get_Lun
;
; CLW Format
;
Dte=''
If (IFmt EQ 1) Then $
Begin
 ReadF,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
 StL,Yr,Mth,Day,Hr,Min,Sec,SInt,NPnts
 Dte=String(Day,Mth,Yr,$
 Format="(I2.2,'/',I2.2,'/',I4.2)")
end
;
; Samson Format
;
If (IFmt EQ 2) Then $
Begin
 ReadF,u,Format='(1x,A4,4I5,1x,2F5.1,I5)',$
 StL,Yr,Day,Hr,Min,Sec,SInt,NPnts
 Dte=String(Day,Yr,$
  Format="(I3.2,'/',I4.2)")
end
DmArr=DblArr(NPnts)
ReadF,u,DmArr
Free_Lun,u
end