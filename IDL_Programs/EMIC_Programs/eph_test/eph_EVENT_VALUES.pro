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

pro eph_EVENT_VALUES,cm_eph,cm_val,state,noi

common formt,format_str,format_str1,ww

common init_struct,state2
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
;***********************************************************************************
common orbinfo,orb,orb_binfile,orb_date
;Declared global variables:
;	orb->orbit No.
;	orb_binfile->ephmerius file name.
;	orb_date->orbit date.
;**************************************************************************
;common cm_crres,state,cm_eph,cm_val
;Declared global varibles:
;	state->structure holding child widgets and submenus.
;	cm_eph->structure holding ephmerius variables
;	cm_val->sturcture holding telemetry data
;**************************************************************************
common eph_ff, ffeph
;Declared global variable:
;	ffeph->hold ephmerius data
;**************************************************************************
common val_ff, ffval
;Declared global variable:
;	ffval->holds telemetry data
;**************************************************************************
;
common val_header, header
;**************************************************************************
common datafiles, data_files,no_data,para_struct

;**************************************************************************
;Log files
common logs, filename1,filename2
fname=strmid(para_struct[noi].filename,0,strlen(para_struct[noi].filename)-4)+'.eph'
;stop
UT=fltarr(n_elements(cm_eph.(2)))
for i=0, n_elements(UT) -1 do $
UT[i]=cm_eph.(1)[i]
i=long(0)
nname = tag_names(cm_eph)
j=long(0)

;********************************************************************
stime=double(strmid(para_struct(noi).start_time,0,2))*60.*60.*1000.+ double(strmid(para_struct(noi).start_time,2,2))*60.*1000.

etime=double(strmid(para_struct(noi).end_time,0,2))*60.*60.*1000.+ double(strmid(para_struct(noi).end_time,2,2))*60.*1000.
;********************************************************************
;
;stop
index=where((UT GE long(stime)) AND (UT LE long(etime)),count)
print,UT[index]
utt=ut[index]
ww=n_elements(utt)
utarr = strarr(ww)

for y=0,ww-1 do $
utarr[y] = eph_tlab(utt[y])

format_str1='(a8,2X,'+ string(ww,format='(i4)') + '(A20))'
format_str='(a8,2X,'+ string(ww,format='(i4)') + '(f20.6))'
cd,res_path[0]
OPENW,UU,fname,/GET_LUN
PRINTF,UU,'TIME',EPH_TLAB(stime),EPH_TLAB(etime),FORMAT='(a8,2X,2A20)'
PRINTF,UU,'JULIAN',CM_EPH.(0),FORMAT='(a8,2X,I20)'
printf,uu,'UT',utarr,FORMAT = format_str1
for j=0,n_elements(nname)-3 do $
printf,uu,nname[j+2],cm_eph.(j+2)[index],FORMAT=format_str
FREE_LUN,UU
cd,idl_path[0]
;stop
end
