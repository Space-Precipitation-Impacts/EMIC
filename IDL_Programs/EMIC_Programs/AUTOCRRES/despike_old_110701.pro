;AUTHOR; T. Loto'aniu
;
;DATE: June 2001
;
;PURPOSE: DeSpike Time Series Data
;
;DEPENDENCY: None
;
;MODIFICATION HISTORY: June 2001 - Initially the depsike algorithm was manual with user choosing
;								   amplitude limit based on time series plot amplitude.
;					   July 2001 - To automate the routine required a more sophisticated routine
;								   Now implemented using a normalized gradient method (see method below).
;
;METHOD: Mean Normalization Gradient Method
;		 input -> array -> if array element > gradient -> array element = new array element
;						   else input another array element
;
;		array size: 40 points - This was found to be the number of points that optmized the routine
;								given the total data length, sample rate and event burst duration.
;								Event burst duration over singler packets tend to be at least 30sec
;								and with a sample rate of 16Hz than 40 points only amounts to 2.5sec
;								of data.
;
;	      Gradient: array[i]/mean(array) - array[i-1]/mean(array)
;					The mean is used in order to normalize the gradient thus giving greater degree
;					of freedom from data type.
;					Gradient limit recommended is 1.0 for CRRES, this seems to optmize the affectivness
;					of the despikng routine without comprimising the data.
;					The new value of data element is set to the "median" of the input array if
;					gradient is greater than gradient limit.
;
;
Function Tim,Value
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I0)")
end
;
; Main
pro Despike,cm_eph,cm_val,state,BB,noi
common orbinfo,orb,orb_binfile,orb_date
common datafiles, data_files,no_data,para_struct
common logs, filename1,filename2
common despike_para,des_limit,grad_limit
;stop
openw,lg,filename1[0],/get_lun,/append
printf,lg,' '
printf,lg,'Starting Despiking Routine....'
widget_control,state.text,set_value='Starting Despiking Routine....'
printf,lg,string(para_struct[noi].filename)
widget_control,state.text,set_value=string(para_struct[noi].filename),/append
names=tag_names(cm_val)

;
widget_control,state.text,set_value=' ',/append
widget_control,state.text,set_value='Gradient method used',/append
widget_control,state.text,set_value='Mean of ten points are taken',/append
widget_control,state.text,set_value='with gradient taken as difference between',/append
widget_control,state.text,set_value='point and mean.',/append
widget_control,state.text,set_value='Gradient limit set for fields: '+string(grad_limit[0]),/append
wait,0.7
;Start loop to despike E and B fields
;
;stop

printf,lg,'Number Point per Despike: '+string(des_limit[0])
printf,lg,'Normalized Gradient Limit: '+string(grad_limit[0])
num=float(des_limit[0])
;BB=[2,6]
for numcmv=bb[0],bb[1] do $
 begin
widget_control,state.text,set_value='Despiking '+string(names[numcmv]),/append
;printf,lg,'Despiking '+string(names[numcmv])
leng = n_elements(cm_val.(numcmv))
NPnts=Leng
;********************************
;Changed 08/07/01 T. Loto'aniu
;num=fix(0.00370*Npnts)
;********************************
XDat=FltArr(NPnts)

XDat=cm_val.(numcmv)
;*************************************
no_ploy=fix(npnts/num[0])
max_len=fix(no_ploy*num[0])
;*************************************
ten_ploy=fix(npnts/num[0])
sum_grad=0.0
num=long(fix(num[0]))
;***************************
;num=Long(70)
;ten_ploy=fix(npnts/num[0])
;***************************
For i=long(0),long(ten_ploy)-1 do $
begin
 one=XDat[i*num[0]:num[0]*i+num[0]-1]
 onee=one
 meann=moment(abs(one))
 mediann=median(abs(one))
grad=(abs(one)-abs(meann[0]))/abs(meann[0])
index=where(abs(grad) GT float(grad_limit[0]),count)

if count GT 0 then $
begin
	 for gg=0,count-1 do $
   if median(one) LT max(xdat) then $
   onee[index[gg]]=median(one) else $
   onee[index[gg]]=max(xdat)/2.0
   sum_grad=sum_grad+count
end

;Xdat[i*num[0]:num[0]*i+num[0]-1]=onee
cm_val.(numcmv)[i*num[0]:num[0]*i+num[0]-1]=onee
;stop

if long(i) mod 5000 EQ 0 then $
widget_control,state.text,set_value='Despike Processing....',/append,/show
;stop
end
;stop
widget_control,state.text,set_value='Number of points despiked: '+string(sum_grad),/append,/show
printf,lg,'Number of points despiked: '+string(sum_grad)
widget_control,state.text,set_value='Despike finished....',/show

;stop
!P.Multi=[0,1,2]
window,0,xsize=500,ysize=500
Plot,cm_val.(0),XDat,TiTle='Original '+string(names[numcmv]),XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
;!Y.Range=[-100,100]
Plot,cm_val.(0),cm_val.(numcmv),Title='DeSpiked '+string(names[numcmv]),XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
!P.Multi=0
Print,'Finished.'
widget_control,state.text,set_value='Done',/append

end

end

Free_lun,lg
End