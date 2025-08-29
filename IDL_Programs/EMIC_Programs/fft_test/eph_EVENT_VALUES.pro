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

pro eph_EVENT_VALUES,cm_eph,cm_val,state
TTT=CM_VAL.(0)
UT=fltarr(n_elements(cm_eph.(2)))
for i=0, n_elements(UT) -1 do $
UT[i]=cm_eph.(1)[i]
i=long(0)
nname = tag_names(cm_eph)

OPENW,UU,'EPH.EPH',/GET_LUN
PRINTF,UU,'TIME',' ',EPH_TLAB(TTT[0]),' ',EPH_TLAB(TTT[n_elements(ttt)-1])
PRINTF,UU,'JULIAN',CM_EPH.(0),FORMAT='(a6,2X,I0)'
j=long(0)
index=where((UT GE ttt[0]) AND (UT LE ttt[n_elements(ttt)-1]),count)
print,UT[index]
utt=ut[index]
ww=n_elements(utt)
;STOP
PRINTF,UU,'UT'
for y=0,n_elements(index)-1 do $
begin
printf,uu,eph_tlab(utt[y])
end

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

  endfor
  FREE_LUN,UU
end
