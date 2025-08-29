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

pro eph_EVENT_VALUES_cal
common datastruct, dat_struct,eph_idl_path,eph_data_path,event_fname,data_fil,no_dat
common results,data_results
common ev,ev_orb

;
;***********************************************************************************
;
eph_idl_path = 'c:\paul\phd\crres\eph_test'

eph_data_path = 'e:\ephresults'

cd,eph_data_path;[0]

event_fname = 'events_orbit_time3.val'

data_fname = '*a.eph'

data_fil=findfile(data_fname)

no_dat=n_elements(data_fil)
;
;stop
;***********************************************************************************
;
dat = CREATE_STRUCT('filename',' ','Orbit',0,'start_time',0,'end_time',0)
dat_struct=REPLICATE(dat, no_dat)
;
;***********************************************************************************
;
dat_struct.filename = data_fil
dat_struct.Orbit = fix(strmid(data_fil,3,4))

for jjj=0,no_dat -1 do $
begin

dat_struct[jjj].end_time = fix(strmid(data_fil[jjj],fix(strlen(data_fil[jjj])-9),4))
dat_struct[jjj].start_time= fix(strmid(data_fil[jjj],fix(strlen(data_fil[jjj])-14),4))
end
;dat_struct.start_time = fix(strmid(data_fil,6,4))

;stop
text = ''

openr,u,event_fname,/get_lun
readf,u,text
print,text

ev_orb = 0l
ev_avtime = ' '
j=0l
;stop
jj=0
for j=0,no_dat -1 do $
begin
while (not eof(u)) do $
 begin
 readf,u,ev_orb,ev_avtime

 ev_avtime= strtrim(ev_avtime,1)
 ev_hr = strmid(ev_avtime,0,2)
 ev_hr = fix(ev_hr)
 ev_hr = strtrim(string(ev_hr),1)
ev_hr = strtrim(string(ev_hr),1)
 if strlen(ev_hr) EQ 1 then $
  begin
  ev_mn = strmid(ev_avtime,2,2)
  ev_sec = strmid(ev_avtime,4,2)
 end

 if strlen(ev_hr) EQ 2 then $
  begin
  ev_mn = strmid(ev_avtime,3,2)
  ev_sec = strmid(ev_avtime,6,2)
 end
if ev_orb EQ dat_struct[j].Orbit then $
if fix(ev_hr+ev_mn) GE dat_struct[j].start_time and fix(ev_hr+ev_mn) LE dat_struct[j].end_time then $
begin
print,dat_struct[j].filename
print,ev_orb,' ',ev_hr+ev_mn
filnme = dat_struct[j].filename
evtim = fix(strtrim(ev_hr+ev_mn,1))
eph_calculate,filnme,evtim,ev_hr,ev_mn,jj
jj=jj+1
end
endwhile
end
cd,eph_idl_path;[0]
free_lun,u
stop
end
