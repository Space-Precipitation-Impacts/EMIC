;AUTHOR: Paul Manusiu
;
Function EPH_TLab, Value ;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,$
  Format="(I2.2,':',I2.2,':',I2.2)")

end

pro eph_EVENT_VALUES,cm_eph,cm_val,state,jj
common orbinfo,orb,orb_binfile,orb_date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common val_header, header
common datafiles, data_files,no_data,para_struct

;stop
;for jj=0, n_elements(para_struct)-1 do $
;begin
fname='Orb'+orb+'_'+para_struct(jj).start_time+'_'+para_struct(jj).end_time+'a.eph'
print,orb
UT=fltarr(n_elements(cm_eph.(2)))
for i=0, n_elements(UT) -1 do $
UT[i]=cm_eph.(1)[i]

i=long(0)

nname = tag_names(cm_eph)
utime=strarr(2)
;for y=0,1 do $
;begin
stime=strmid(para_struct(0).start_time,0,2)*60.*60.*1000. + strmid(para_struct(0).start_time,2,2)*60.*1000.
etime=strmid(para_struct(0).END_time,0,2)*60.*60.*1000. + strmid(para_struct(0).END_time,2,2)*60.*1000.


;end
;stop
UTIME[0]=eph_tlab(stime)
UTIME[1]=eph_tlab(etime)
;stop
;OPENW,UU,FName,/GET_LUN


;PRINTF,UU,'TIME',utime,FORMAT='(a8,2X,2a20)'
;PRINTF,UU,'JULIAN',CM_EPH.(0),FORMAT='(a8,2X,I20)'
j=long(0)
index=where((UT GE stime) AND (UT LE etime),count)
print,UT[index]
utt=ut[index]
ww=n_elements(utt)
ut=strarr(n_elements(utt))
;STOP
cd,res_path[0]
OPENW,UU,FName,/GET_LUN
PRINTF,UU,'TIME',utime,FORMAT='(a8,2X,2a20)'
PRINTF,UU,'JULIAN',CM_EPH.(0),FORMAT='(a8,2X,I20)'

for y=0,n_elements(index)-1 do $
begin
ut[y]=eph_tlab(utt[y])
end

 if ww EQ 1 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,1a20)'

 if ww EQ 2 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,2a20)'

 if ww EQ 3 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,3a20)'

 if ww EQ 4 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,4a20)'

 if ww EQ 5 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,5a20)'

 if ww EQ 6 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,6a20)'

 if ww EQ 7 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,7a20)'

 if ww EQ 8 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,8a20)'

 if ww EQ 9 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,9a20)'

 if ww EQ 10 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,10a20)'

 if ww EQ 11 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,11a20)'

 if ww EQ 12 then $
PRINTF,UU,'UT',ut,FORMAT='(a8,2X,12a20)'


for j=0,n_elements(nname)-3 do $
  begin
 if ww EQ 1 then $

printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,1F20.6)'

 if ww EQ 2 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,2F20.6)'

 if ww EQ 3 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,3F20.6)'

  if ww EQ 4 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,4F20.6)'

if ww EQ 5 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,5F20.6)'

if ww EQ 6 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,6F20.6)'

if ww EQ 7 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,7F20.6)'

if ww EQ 8 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,8F20.6)'

if ww EQ 9 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,9F20.6)'

if ww EQ 10 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,10F20.6)'

if ww EQ 11 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,11F20.6)'

if ww EQ 12 then $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT='(a8,2X,12F20.6)'

  endfor
  FREE_LUN,UU
;stop
cd,idl_path[0]
;end

end
