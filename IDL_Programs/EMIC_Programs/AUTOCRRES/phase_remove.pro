
;Routine to remove phasing introduced by spacecraft preprocessing.
;The data is run backwards through a 2nd order Butterworth filter
;Filter is implemented using Bi-Linear Transformation.
;
;************************************************************************************
Pro phase_remove
common cm_crres,state,cm_eph,cm_val
common orbinfo,orb,orb_binfile,orb_date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path

SSInt=ABS(cm_val.(0)[1] - cm_val.(0)[0])
SSSInt=SSINt/1000.0
freq=1./SSSInt
count0=n_elements(cm_val.(0))
pI=3.1415926535898	 					;Declare Pi to 12 demical places.

sam1=fre_int[0]
Order = 2
FiltType = 2
Cut = float(sam1/freq)
Print,'Low pass filtering data now'
WIDGET_CONTROL, state.dat_info,$
       SET_VALUE ='Removing phasing due to spacecraft preprocessing'
WIDGET_CONTROL, state.orb_info,$
       SET_VALUE ='Please be patient..............................'
WIDGET_CONTROL, state.text,$
       SET_VALUE =' '

dumm =fltarr(count0)
Theta=fltArr(6)
Ex=cm_val.(1)
Ey=cm_val.(2)
Ez=cm_val.(3)
dBx=cm_val.(4)
dBy=cm_val.(5)
dBz=cm_val.(6)
Bx=cm_val.(7)
By=cm_val.(8)
Bz=cm_val.(9)

Print,'Removing phasing due to spacecraft preprocessing'
Print,'Please be patient....'


Reverse,dBx,dumm,count0
Reverse,dBy,dumm,count0
Reverse,dBz,dumm,count0
Reverse,Bx,dumm,count0
Reverse,By,dumm,count0
Reverse,Bz,dumm,count0
;
;stop
 dtrend2,Bx,count0,Rax,Rbx
 Bxxx=Bx[0]
;stop
 dtrend2,By,count0,Ray,Rby
 Byyy=By[0]
 dtrend2,Bz,count0,Raz,Rbz
 Bzzz=Bz[0]
 for i=long(0),long(count0)-long(1) do $
  begin
   Bx[i]=Bx[i]-Bxxx
   By[i]=By[i]-Byyy
   Bz[i]=Bz[i]-Bzzz
 endfor
 ;stop
FiltCtrl2,dBx,dumm,wc,Order,FiltType,cut,count0,theta
;stop
FiltCtrl2,dBy,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl2,dBz,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl2,Bx,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl2,By,dumm,wc,Order,FiltType,cut,count0,theta
FiltCtrl2,Bz,dumm,wc,Order,FiltType,cut,count0,theta
for  i=long(0),long(count0)-long(1) do $
  begin
   Bx[i]=Bx[i]+Bxxx
   By[i]=By[i]+Byyy
   Bz[i]=Bz[i]+Bzzz
 endfor
 for  i=long(0),long(count0)-long(1) do $
  begin
   Bx[i]=Bx[i]+Rax+Rbx*Float(i)
   By[i]=Bz[i]+Ray+Rby*Float(i)
  Bz[i]=Bz[i]+Raz+Rbz*Float(i)
 endfor
Reverse,dBx,dumm,count0
Reverse,dBy,dumm,count0
Reverse,dBz,dumm,count0
Reverse,Bx,dumm,count0
Reverse,By,dumm,count0
Reverse,Bz,dumm,count0
;*********************************************************************************
cm_val.(1)=Ex
cm_val.(2)=Ey
cm_val.(3)=Ez
cm_val.(4)=dBx
cm_val.(5)=dBy
cm_val.(6)=dBz
cm_val.(7)=Bx
cm_val.(8)=By
cm_val.(9)=Bz
;*********************************************************************************
WIDGET_CONTROL, state.dat_info,$
       SET_VALUE ='Phase due to spacecraft preprocessing has been removed'
WIDGET_CONTROL, state.orb_info,$
       SET_VALUE ='Orbit'+string(orb)+'  '+string(orb_date)
;stop
end