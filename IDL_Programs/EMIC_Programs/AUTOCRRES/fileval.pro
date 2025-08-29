
PRO fileval,Fname,valvv,state
text=strarr(1)
NPnts=Long(0)
Openr,us,FName,/get_lun             ;Open data file
ReadF,us,text
ct=0L
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Telemetry Information.........'
While not eof(us) do $
Begin
 ReadF,us,text
 NPnts=NPnts+Long(1)
ct=ct+long(1)
;WIDGET_CONTROL, state.file_info,SET_VALUE ='Extracting Telemetry Information.........'
if ct mod 1000 EQ 0 then $
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Telemetry Information.........'
end
WIDGET_CONTROL, state.dat_info,SET_VALUE =string(NPnts)+' Points'
Point_Lun,us,0
Print,NPnts
text=strarr(1)
valvv={ttt:lonarr(NPnts),Ex:dblarr(NPnts),Ey:dblarr(NPnts),$
Ez:dblarr(NPnts),dBx:dblarr(NPnts),dBy:dblarr(NPnts),dBz:dblarr(NPnts),Bx:dblarr(NPnts),$
By:dblarr(NPnts),Bz:dblarr(NPnts)}
i=long(0)
tt=strarr(1)
readf,us,tt
head=tt
ct=0L
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Telemetry Data..........'
for i=long(0), NPnts-1 do $
begin
ct=ct+long(1)
if ct mod 1000 EQ 0 then $
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Telemetry Data..........'
readf,us,tt
valvv.ttt[i]=long(strmid(tt(0),0,8))       ;Store time data in array ttt
valvv.Ex[i]=double(strmid(tt(0),10,10))
valvv.Ey[i]=double(strmid(tt(0),21,10))
valvv.Ez[i]=double(strmid(tt(0),32,10))
valvv.dBx[i]=double(strmid(tt(0),43,10))
valvv.dBy[i]=double(strmid(tt(0),54,10))
valvv.dBz[i]=double(strmid(tt(0),65,10))
valvv.Bx[i]=double(strmid(tt(0),77,11))
valvv.By[i]=double(strmid(tt(0),89,11))
valvv.Bz[i]=double(strmid(tt(0),100,11))

endfor
WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
END