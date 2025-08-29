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

pro eph_calculate_auto,filnme,evtim,ev_hr,ev_mn,noi
;common formt,format_str,format_str1,ww
common datastruct, dat_struct,eph_idl_path,eph_data_path,event_fname,data_fil,no_dat
common results,data_results
common ev,ev_orb
common eph_data_struct, eph_names, eph_data_array,data_len
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
common eph_name_tim_day,nname,julian_day,u_time_formated,u_time_milsec
;***********************************************************************************
;
common count_data, countd

data_results = dblarr(55)
resfilnme = 'eph_events_results_new.val'

ww = data_len
format_str1='(a8,2X,'+ string(ww,format='(i4)') + '(A20))'
format_str='(a8,2X,'+ string(ww,format='(i4)') + '(f20.6))'
;
texts = ' '
para_text = ' '
;eph_dat = strarr(ww)
epv_hr = lonarr(ww)
epv_mn = lonarr(ww)
epv_tim = lonarr(ww)
;stop
for y=0,ww-1 do $
begin
 mSec=long(u_time_milsec[y])
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
epv_hr[y] = hr
epv_mn[y] = mnf
epv_tim[y] = long(epv_hr[y]*100+epv_mn[y])
;stop
end

;epv_tim[ww] = long(strtrim(evtim,1))
index_sort = sort(epv_tim)

epv_tim_old = epv_tim

epv_tim = lonarr(ww+1)
for yy=0, n_elements(epv_tim_old) - 1 do $
epv_tim[yy] = epv_tim_old[yy]
epv_tim[ww] = long(strtrim(evtim,1))
;stop
namess=strarr(55)
;stop
for datta=0, n_elements(eph_names)-1 do $
begin
dd = string('')
datt = dblarr(ww)
datt = eph_data_array[datta,*]
;print,epv_tim
;print,datt
;stop
Result = INTERPOL(datt, epv_tim_old, epv_tim)
data_results[datta] = result[n_elements(result)-1]
namess[datta] = eph_names[datta]
;stop
end
;stop
if countd EQ 0 then $
 begin
 openw,q,resfilnme,/get_lun
 printf,q,'Orbit','time',namess,format = '(a5,2X,a4,2X,55(a20))'
 printf,q,strtrim(string(ev_orb),1),strtrim(string(evtim),1),data_results,$
 format = '(a5,2X,a4,2X,55(f20.6))'
free_lun,q
endif else $
begin
 openw,q,resfilnme,/get_lun,/append
 printf,q,strtrim(string(ev_orb),1),strtrim(string(evtim),1),data_results,$
 format = '(a5,2X,a4,2X,55(f20.6))'
free_lun,q
endelse
countd=countd+1
cd,idl_path[0]
;[0]
;free_lun,uu
;jj+1
;stop
end
