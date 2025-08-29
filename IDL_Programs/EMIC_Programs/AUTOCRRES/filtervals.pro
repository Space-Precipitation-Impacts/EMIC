
pro filtervals, lowgroup
common cm_crres,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common lowchoice ,filtords,fieldch,filttype,cut
print,filtords,fieldch,cut
;************************************************************************************
;The data is run through a Butterworth filter
;Filter is implemented using Bi-Linear Transformation.
;
SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
SSSInt=SSINt/1000.0
freq=1./SSSInt
count0=n_elements(cm_val.(0))
pI=3.1415926535898						;Declare Pi to 12 demical places.
sam1=cut[0]                              ;lowpass dB to remove phase due to spacecraft
Order = filtords+1
FiltType = filttype+1
Cut = float(sam1/freq)
Print,'Low pass filtering data now'
dumm =fltarr(count0)
Theta=fltArr(6)
;
Ex=cm_val.(1)
Ey=cm_val.(2)
Ez=cm_val.(3)
dBx=cm_val.(4)
dBy=cm_val.(5)
dBz=cm_val.(6)
Bx=cm_val.(7)
By=cm_val.(8)
Bz=cm_val.(9)
if fieldch[0] EQ 1 and fieldch[1] EQ 1 and fieldch[2] EQ 0 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Lowpass filtering B & dB fields with cuttoff'+string(cut)+'Hz'
FiltCtrl,dBx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBy,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBz,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Bx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,By,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Bz,dumm,wc,Order,FiltType,cut,count0,theta
endif

;*********************************************************************************

if fieldch[0] EQ 1 and fieldch[1] EQ 1 and fieldch[2] EQ 1 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering all fields with cuttoff'$
+string(cut)+'Hz'

for i=0,100 do $
 if Ex[i] NE 0.0 then $
FiltCtrl,Ex,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ey,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ez,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBy,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBz,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Bx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,By,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Bz,dumm,wc,Order,FiltType,cut,count0,theta
endif
;*************************************************************************************

;*********************************************************************************

if fieldch[0] EQ 1 and fieldch[1] EQ 0 and fieldch[2] EQ 0 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering B fields with cuttoff'$
+string(cut)+'Hz'
if FiltType EQ 2 then $
 begin
 FiltType=1
 Bxx=Bx
 Byy=By
 Bzz=Bz
 ;sam1=(freq/2.)-sam1
 sam1=0.0310
 cut=sam1/freq
 ;stop
 FiltCtrl,Bxx,dumm,wc,Order,FiltType,cut,count0,theta
 FiltCtrl,Byy,dumm,wc,Order,FiltType,cut,count0,theta
 FiltCtrl,Bzz,dumm,wc,Order,FiltType,cut,count0,theta
 for  i=long(0),long(count0)-long(1) do $
  begin
  Bx[i]=Bx[i]-Bxx[i]
  By[i]=By[i]-Byy[i]
  Bz[i]=Bz[i]-Bzz[i]
  endfor
 endif
endif
;*************************************************************************************

;*********************************************************************************

if fieldch[0] EQ 0 and fieldch[1] EQ 1 and fieldch[2] EQ 0 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering dB fields with cuttoff'$
+string(cut)+'Hz'
FiltCtrl,dBx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBy,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBz,dumm,wc,Order,FiltType,cut,count0,theta
endif
;*************************************************************************************
if fieldch[0] EQ 0 and fieldch[1] EQ 0 and fieldch[2] EQ 1 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering E fields with cuttoff'$
+string(cut)+'Hz'

for i=0,100 do $
 if Ex[i] NE 0.0 then $
FiltCtrl,Ex,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ey,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ez,dumm,wc,Order,FiltType,cut,count0,theta
endif
;**************************************************************************************
;*********************************************************************************

if fieldch[0] EQ 0 and fieldch[1] EQ 1 and fieldch[2] EQ 1 then $
	begin
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering dB & E fields with cuttoff'$
+string(cut)+'Hz'

for i=0,100 do $
 if Ex[i] NE 0.0 then $
FiltCtrl,Ex,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBy,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,dBz,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ey,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl,Ez,dumm,wc,Order,FiltType,cut,count0,theta
endif
;**************************************************************************************
WIDGET_CONTROL, state.dat_info,SET_VALUE = 'Lowpass filtering done'

;Pass values to data structure
cm_val.(1)=Ex
cm_val.(2)=Ey
cm_val.(3)=Ez
cm_val.(4)=dBx
cm_val.(5)=dBy
cm_val.(6)=dBz
cm_val.(7)=Bx
cm_val.(8)=By
cm_val.(9)=Bz
;**************************************************************************************
;return memory to heap
Ex=0.
Ey=0.
Ez=0.
dBx=0.
dBy=0.
dBz=0.
Bx=0.
By=0.
Bz=0.
;********************************************************************************
;*********************************************************************************
end