Function Tim,mSec
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

Function XTLab,Axis,Index,Value
 mSec=Value
 milsec=mSec Mod 1000
 seci=fix(Long(mSec)/1000)
 secf = seci mod 60
 mni=fix(Long(seci)/60)
 mnf = mni mod 60
 hr = fix(Long(mni)/60)
 Return,String(hr,mnf,secf,milsec,$
  Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3)")
end

PRO crres_eph
 NPnts=10
 A=lonarr(NPnts,60)
 B=lonARR(NPnts,60)

FName=Pickfile(Title='Select Input data file', Filter='*.*')  ;Selecting data file(popup window)
Openr,units,FName,/get_lun,/binary             ;Open data file
bdat=byte(1)
dat=bytarr(4)
for j=0,NPnts-1 do $            ;Loop to count total data rows and
begin
 for i=0,59 do $
 begin
  fdat=double(0.0)
  sgn=1.
  for aa=0,3 do $         ;data component rows in file.
  begin
   READU,units,bdat
   dat(aa)=bdat
  end
  dat(0)=dat(0)-64   ; take off 2^30
  fdat=dat(0)*256.*256.*256+dat(1)*256.*256.+dat(2)*256.+dat(3)
  fdat=sgn*fdat
  a[j,i]=fdat
;  b[j,i]=text
 end
endfor
FREE_LUN,UNITS
Openw,units,'test5.txt',/get_lun
for i=0,NPnts-1 do $
begin
 Julian = a[i,0]
 mSec=long(a[i,1])
 lshell=a[i,49]*1.e-8
 mlat = float(a[i,24]*1.e-7)
 mlt = a[i,22]*1.e-7
 latgsm = a[i,30]*1.e-6
;time UT in military
 milsec= mSec Mod 1000.
 seci=long(mSec)/1000.
 secf = seci mod 60.
 mni=long(seci)/60.
 mnf = mni mod 60.
 hr = long(mni)/60.
;Ouput to device formatted
 printf,units,a[i,*]
 printf,units,'****************************************************************'
; printf,units,string(hr,mnf,secf,milsec,mlat,mlt,lshell,latgsm,$
; Format="(I2.2,':',I2.2,':',i2.2,'.',i2.2,4x,F12.2,4x,F12.2,4x,F12.2,4x,F12.2)")
endfor
free_lun,units

;stop
 Print,'Finished'
END
