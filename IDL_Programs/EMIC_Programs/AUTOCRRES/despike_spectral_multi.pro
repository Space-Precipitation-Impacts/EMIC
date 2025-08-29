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
pro Despike_spectral_multi,cm_eph,cm_val,state,BB,noi
common orbinfo,orb,orb_binfile,orb_date
common datafiles, data_files,no_data,para_struct
common logs, filename1,filename2
common despike_para,des_limit,grad_limit
common Poyntpow, PoyntArr
Common BLK4,MnPow,MxPow
common pow_multi, disparr_multi
openw,lg,filename1[0],/get_lun,/append
printf,lg,' '
printf,lg,'Starting Poynting Despiking Routine....'
widget_control,state.text,set_value='Starting Despiking Routine....'
printf,lg,string(para_struct[noi].filename)
widget_control,state.text,set_value=string(para_struct[noi].filename),/append
names=tag_names(cm_val)

widget_control,state.text,set_value='Despiking Poynting Vectors...',/append,/show
;
;stop
widget_control,state.text,set_value=' ',/append,/show
widget_control,state.text,set_value='Gradient method used',/append,/show
widget_control,state.text,set_value='Mean of '+string(des_limit[0])+' points are taken',/append
widget_control,state.text,set_value='with gradient taken as difference between',/append
widget_control,state.text,set_value='point and mean.',/append
widget_control,state.text,set_value='Gradient limit set for fields: '+string(grad_limit[0]),/append
;wait,0.7
;Start loop to despike E and B fields
;
;stop
MnRng=dblarr(3)
MxRng=dblarr(3)
MnPow=dblarr(3)
MxPow=dblarr(3)
printf,lg,'Number Point per Despike: '+string(des_limit[0])
printf,lg,'Normalized Gradient Limit: '+string(grad_limit[0])
;***********************************************************************************
;Remove spikes
;
which=['SX','SY','SZ']
for q=0, 2 do $
begin
xdat=Poyntarr[*,*,q]
Len=n_elements(Xdat)
widget_control,state.text,set_value='Despiking '+string(which[q]),/append
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
Poyntarr[*,*,q]=Xdat
MnRng[q]=Min(PoyntArr[*,*,q])

MxRng[q]=Max(PoyntArr[*,*,q])

if abs(MxRng[q]) GE abs(MnRng[q]) then $
MnRng[q]=-MxRng[q] else $
MxRng[q]=abs(MnRng[q])
end
Free_lun,lg
;********************************************************************************
if MxRng[0] GE MxRng[1] and MxRng[0] GE MxRng[2] then $
begin
new_MxRng=MxRng[0]
new_MnRng=MnRng[0]

end else $

if MxRng[1] GE MxRng[0] and MxRng[1] GE MxRng[2] then $
begin
new_MxRng=MxRng[1]
new_MnRng=MnRng[1]
end else $
begin
new_MxRng=MxRng[2]
new_MnRng=MnRng[2]
endelse


;*********************************************************************************
for q=0,2 do $
begin
MxPow[q]=double(new_MxRng)
MnPow[q]=double(new_MnRng)
end
End