; Program to DeSpike Time Series Data
;
;  C Waters Sept 1995
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
common Poyntpow, PoyntArr
Common BLK4,MnPow,MxPow
common pow_multi, disparr_multi

widget_control,state.text,set_value='Starting Despiking Routine....'
widget_control,state.text,set_value=string(para_struct[noi].filename),/append
names=tag_names(cm_val)
;STOP
openw,lg,filename1[0],/get_lun,/append
printf,lg,' '
printf,lg,'Starting Despiking Routine....'
widget_control,state.text,set_value='Starting Despiking Routine....'
printf,lg,string(para_struct[noi].filename)
widget_control,state.text,set_value=string(para_struct[noi].filename),/append
names=tag_names(cm_val)
;
;stop
widget_control,state.text,set_value=' ',/append
widget_control,state.text,set_value='Gradient method used',/append
widget_control,state.text,set_value='Mean of '+string(des_limit[0])+' points are taken',/append
widget_control,state.text,set_value='with gradient taken as difference between',/append
widget_control,state.text,set_value='point and mean.',/append
widget_control,state.text,set_value='Gradient limit set for fields: '+string(grad_limit[0]),/append
;***********************************************************************************
num=float(des_limit[0])
;BB=[12,13]
for numcmv=bb[0],bb[1] do $
 begin
widget_control,state.text,set_value='Despiking '+string(names[numcmv]),/append
;printf,lg,'Despiking '+string(names[numcmv])
leng = n_elements(cm_val.(numcmv))
old_xdat=cm_val.(numcmv)
NPnts=Leng
;********************************
;Changed 11/07/01 T. Loto'aniu
num=long(fix(0.0020*Npnts))
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

for yy=0,5 do $
begin
index_max=where(max(abs(onee)) EQ abs(onee) ,count_max)
if count_max GT 0 then $
	 for gg=0,count_max-1 do $
   		onee[index_max[gg]]=median(one)

end

Xdat[i*num[0]:num[0]*i+num[0]-1]=onee

;cm_val.(numcmv)[i*num[0]:num[0]*i+num[0]-1]=onee
end

;*******************************************************************************
;stop
disparr=0.0
cm_val.(numcmv)=xdat
!P.Multi=[0,1,2]
window,0,xsize=500,ysize=500
Plot,cm_val.(0),old_XDat,TiTle='Original '+string(names[numcmv]),XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
;!Y.Range=[-100,100]
Plot,cm_val.(0),cm_val.(numcmv),Title='DeSpiked '+string(names[numcmv]),XTitle='Time (UT)',$
 YTitle='Amplitude',XStyle=1,ystyle=1,XTickFormat='XTLab'
!P.Multi=0
Print,'Finished.'
widget_control,state.text,set_value='Done',/append
;stop
end
End