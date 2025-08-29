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

pro eph_calculate,filnme,evtim,ev_hr,ev_mn,jj
common formt,format_str,format_str1,ww
common datastruct, dat_struct,eph_idl_path,eph_data_path,event_fname,data_fil,no_dat
common results,data_results
common ev,ev_orb
;***********************************************************************************
;
data_results = dblarr(55)
resfilnme = 'eph_events_results.val'

ww = [8,8]
format_str1='(a8,2X,'+ string(ww[jj],format='(i4)') + '(A20))'
format_str='(a8,2X,'+ string(ww[jj],format='(i4)') + '(f20.6))'
;
texts = ' '
para_text = ' '
eph_dat = strarr(ww[jj])
epv_hr = strarr(ww[jj])
epv_mn = strarr(ww[jj])
epv_tim = lonarr(ww[jj])
stop
cd,eph_data_path
openr,uu,filnme,/get_lun
readf,uu,texts
print,texts
readf,uu,texts
print,texts

readf,uu,para_text;,eph_dat,format = format_str1
print,para_text;,eph_dat
nnme = strmid(para_text,0,8)
;stop
for y=0,ww[jj]-1 do $
begin
eph_dat[y] = strmid(para_text,20*y+10,20)
eph_dat[y] = strtrim(eph_dat[y],1)
epv_hr[y] = strmid(eph_dat[y],0,2)
epv_mn[y] = strmid(eph_dat[y],3,2)
epv_tim[y] = long(strtrim(epv_hr[y]+epv_mn[y],1))
end

;epv_tim[ww] = long(strtrim(evtim,1))
index_sort = sort(epv_tim)

epv_tim_old = epv_tim

epv_tim = lonarr(ww[jj]+1)
for yy=0, n_elements(epv_tim_old) - 1 do $
epv_tim[yy] = epv_tim_old[yy]
epv_tim[ww[jj]] = long(strtrim(evtim,1))

namess=strarr(55)

for datta=0, 54 do $
begin
dd = string('')
datt = dblarr(ww[jj])

readf,uu,dd,datt,format = format_str
print,epv_tim
print,datt
;stop
Result = INTERPOL(datt, epv_tim_old, epv_tim)
data_results[datta] = result[n_elements(result)-1]
namess[datta] = dd
end
free_lun,uu
if jj LT 1 then $
 begin
 openw,q,resfilnme,/get_lun
 printf,q,'Orbit','time',namess,format = '(a5,2X,a4,2X,55(a20))'
 printf,q,strtrim(ev_orb,1),strtrim(evtim,1),data_results,$
 format = '(a5,2X,a4,2X,55(f20.6))'
free_lun,q
endif else $
begin
 openw,q,resfilnme,/get_lun,/append
 printf,q,strtrim(ev_orb,1),strtrim(evtim,1),data_results,$
 format = '(a5,2X,a4,2X,55(f20.6))'
free_lun,q
endelse
cd,eph_idl_path
;[0]
free_lun,uu
;jj+1
stop
end
