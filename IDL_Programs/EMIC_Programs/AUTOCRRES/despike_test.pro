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
pro Despike_test,cm_eph,cm_val,state,BB,noi
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
BB=[11,13]
for numcmv=bb[0],bb[1] do $
 begin
widget_control,state.text,set_value='Despiking '+string(names[numcmv]),/append
;printf,lg,'Despiking '+string(names[numcmv])
leng = n_elements(cm_val.(numcmv))
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

Xdat[i*num[0]:num[0]*i+num[0]-1]=onee
;cm_val.(numcmv)[i*num[0]:num[0]*i+num[0]-1]=onee
;stop

if long(i) mod 5000 EQ 0 then $
widget_control,state.text,set_value='Despike Processing....',/append,/show
;stop
end
;Remove spikes
;
;stop
;xxdat=xdat
disparr=Xdat

Len=n_elements(Disparr)

div=10.

ploy=long(fix(Len/div))
print,ploy
;
for jj=0,19 do $
begin
for tt=long(0),long(div)-1 do $
begin
disparr = Xdat[tt*ploy:tt*ploy + ploy-1]
index_max=where(max(disparr) EQ disparr,count_max)
if count_max LE 5 then $
begin
 if (index_max[0] LT n_elements(disparr)-5) and  (index_max[0] GT 5) then $
 begin
 temp1=disparr[index_max[0]+1:index_max[0]+5]
 temp2=disparr[index_max[0]-5:index_max[0]-1]
 ;stop
 disparr[index_max]=(total(temp1)+total(temp2))/10.
 end else $
 begin
 temp1=disparr[0:9]
 ;stop
 disparr[index_max]=(total(temp1))/10.
 endelse
 ;stop
 Xdat[tt*ploy:tt*ploy + ploy-1]=disparr
end



index_min=where(min(disparr) EQ disparr,count_min)
if count_min LE 5 then $
begin
if (index_min[0] LT n_elements(disparr)-5) and  (index_min[0] GT 5) then $
 begin
 temp1=disparr[index_min[0]+1:index_min[0]+5]
temp2=disparr[index_min[0]-5:index_min[0]-1]
;stop
disparr[index_min]=(total(temp1)+total(temp2))/10.
end else $
 begin
 temp1=disparr[0:9]
;stop
 disparr[index_min]=(total(temp1))/10.
 endelse
 Xdat[tt*ploy:tt*ploy + ploy-1]=disparr
end
end
end
;*******************************************************************************
;stop
disparr=0.0
cm_val.(numcmv)=xdat
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
End