;Input files:crfiles.shr
;            *.0ep

Function Tim,mSec						;Function to determine hours,minutes,seconds from time tag
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end


Pro crreseph

;cd,'c:\paul\crres\alee\crres\crres\emp'
;fils=findfile('*.0ep')
;for n=0,n_elements(fils)-1 do $
; begin
 texts=strarr(1)
; filss=strmid(fils[n],0,8) ;Fiche naming convention e.g. c9000000.*
;openr,/get_lun,uu,'crfiles.shr'
;while (not eof(uu)) do $
; begin
;  readf,uu,texts
;  if strmid(texts(0),46,8) EQ filss then $
;    begin
;    orbit=strmid(texts(0),0,5)
;    date=strmid(texts(0),6,10)
;    openw,un,/get_lun,'orb'+strtrim(orbit,1)+'.eph'
;    printf,un,'Orbit'+strtrim(orbit,1)+' '+strtrim(date,1)
;  endif
;endwhile
;print,'Processing file: ',fils[n]
;openr,/get_lun,u,fils[n]
openr,/get_lun,u,'crreseph.old'
;status = FSTAT(u)	;Get file status.
;dd = status.size / (4*60)
;UT=fltarr(dd)
;MLT=fltarr(dd)
;MLAT=fltarr(dd)
;Lshell=fltarr(dd)
;texts=double(0)
text=long(0)
;for j=0,dd-1 do $
;readu,u,texts
;UT=texts
for j=0,200 do $
begin
for i=0,13 do $
begin
readu,u,text;[i]
;print,text
;if i EQ 0 then UT=(text-2.^30)/(1000.*3600.);[i]

if i EQ 0 then $
UT=long(text*1e-1)/(1000.*3600.);[i]
if i EQ 2 then $
orb=fix(text*1.e-2);[i]
if i EQ 3 then $
MLT=float(text)*1.e-7;[i]
if i EQ 4 then $
MLAT=text;*1.e-8;[i]
;byteorder,text;,/LSWAP

endfor
print,UT,'  ',orb,'  ',MLT,'  ',MLAT
endfor
;if i EQ 1 then $
;UT[j]=(text-2.^30);/(1000.*3600.);[i]
;if i EQ 22 then $
;MLT[j]=(text-2.^30)*1.e-7;[i]
;if i EQ 24 then $
;MLAT[j]=(text-2.^30)*1.e-7;[i]
;if i EQ 49 then $
;lshell[j]=(text-2.^30)*1.e-8;[i]
;endfor

; mSec=long(UT)
; milsec=long(mSec) Mod 1000
; seci=Long(mSec/1000)
; secf = long(seci) mod 60
; mni=Long(seci)/60
; mnf = long(mni) mod 60
; hr = Long(mni/60)
;openw,un,/get_lun,'orb'+strtrim(orbit,1)+'.eph'
;printf,un,'Orbit'+strtrim(orbit,1)+' '+strtrim(date,1)
;openw,un
;printf,un,FORMAT ='(A6,6X,A6,6X,A6,6X,A6)',$
;'TIME','MLT','MLAT','Lshell'
;for i=0, dd-1 do $
;  begin
;    printf,un,FORMAT ="(I10,2X,F9.6,2X,F10.6,2X,F6.3)",msec[i],MLT[i],MLAT[i],Lshell[i]

;    printf,un,FORMAT ="(I2.2,':',I2.2,':',i2.2,'.',i3.3,2X,F9.6,2X,F10.6,2X,F6.3)",$
 ;   hr[i],mnf[i],secf[i],milsec[i],MLT[i],MLAT[i],Lshell[i]
;endfor
free_lun,u
;Free_lun,uu
;free_lun,un
;endfor
print,'end of program'
end