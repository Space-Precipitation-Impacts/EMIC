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


Pro crresc
;cd,'c:\paul\phd\orbit912_917'
fils=findfile('*.0ep')
for n=0,n_elements(fils)-1 do $
 begin
 texts=strarr(1)
 filss=strmid(fils[n],0,8) ;Fiche naming convention e.g. c9000000.*

print,'Processing file: ',fils[n]
;**********************************************************************************

openr,/get_lun,u,fils[n]
status = FSTAT(u)	;Get file status.
dd = status.size / (4*60)
UT=lonarr(dd)
Jul=long(0)
eph={MLT:fltarr(dd),MLAT:fltarr(dd),Lshell:fltarr(dd)}

a=lonarr(dd,60)
bdat=byte(1)
dat=bytarr(4)
for j=0,dd-1 do $            ;Loop to count total data rows and
begin
 for i=0,59 do $
 begin
  fdat=double(0.0)
  sgn=1.
  for aa=0,3 do $         ;data component rows in file.
  begin
   READU,u,bdat
   dat(aa)=bdat
  end
  dat(0)=dat(0)-64   ; take off 2^30
  fdat=dat(0)*256.*256.*256+dat(1)*256.*256.+dat(2)*256.+dat(3)
  fdat=sgn*fdat
  a[j,i]=fdat
 end

UT[j]=a[j,1]
eph.lshell[j]=a[j,34]*1.e-7
eph.mlat[j] = a[j,15]*1.e-6
eph.mlt[j] = a[j,27]*1.e-7
endfor
Jul = a[0,0]

openr,/get_lun,uu,'crfiles.shr'
while (not eof(uu)) do $
 begin
  readf,uu,texts
  if strmid(texts(0),46,8) EQ filss then $
    begin
    orbit=strmid(texts(0),0,5)
    date=strmid(texts(0),6,10)
    openw,un,/get_lun,'orb'+strtrim(orbit,1)+'a.eph'
    printf,un,'Orbit'+strtrim(orbit,1)+' '+strtrim(date,1)
    print,orbit
  endif
endwhile
 mSec=long(UT)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)

printf,un,FORMAT ='(A10,2X,I0)',$
'Julian day',Jul
printf,un,FORMAT ='(6X,A5,9X,A7,4X,A6,5X,A6)',$
'TIME','MLT(hr)','MLAT','Lshell'
for i=0, dd-1 do $
  begin
    printf,un,FORMAT ="(2X,I10,2X,F10.6,2X,F12.6,2X,F6.3)",UT[i],eph.MLT[i],eph.MLAT[i],eph.Lshell[i]
   ; printf,un,FORMAT ="(I2.2,':',I2.2,':',i2.2,'.',i3.3,2X,F9.6,2X,F10.6,2X,F6.3)",$
  ;hr[i],mnf[i],secf[i],milsec[i],eph.MLT[i],eph.MLAT[i],eph.Lshell[i]
endfor
free_lun,u
Free_lun,uu
free_lun,un
endfor
;plot,FORMAT ="(I6,4X,I2.2,':',I2.2,':',i2.2,'.',i3.3,
print,'end of program'

end