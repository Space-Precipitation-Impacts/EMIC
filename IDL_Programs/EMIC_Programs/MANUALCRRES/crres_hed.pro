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

PRO crres_hed
A=lonarr(200,13)
B=lonARR(200,13)
bit=bytarr(4,10)
;D=BYTE(5)
;E=BYTE(5)
;ee=byte(5)
;dd=byte(5)
;OpenW,units,'C:\PAUL\TEST3.TXT',/get_lun             ;Open data file
;
;WRITEU,UNITS,D,E,ee,dd
;FREE_LUN,UNITS
;STOP

FName=Pickfile(Title='Select Input data file', Filter='*.*')  ;Selecting data file(popup window)
Openr,units,FName,/get_lun,/BINARY             ;Open data file
bit=bytarr(1)
for j=0,10 do $
begin
for i=0,3 do $
 begin

readu,units,bits
byteorder,bits,/LSWAP
bit[i,j]=bits
endfor
t=[long(bit[0,j])+long(bit[1,j])+long(bit[2,j])+long(bit[3,j])]-2.^30
print,t*1.e-4/(1000.*3600.)
j=j+1
endfor
;jj=0
;G=long(A[jj])
;H=long(A[jj+1])
;J=long(A[jj+2])
;Y=long(A[jj+3])
;G=ISHFT(G,24)
;H=ISHFT(H,16)
;J=ISHFT(J,8)
;F=G+H+J+Y
;z = (F - 2.^30)*1
;print,z
;ENDFOR

; Julian = a[i,0]
; mSec=float(a[i,1])
; lshell=a[i,49]*1.e-4
;
; mlat = float(a[i,24]*0.0001)
; mlt = a[i,22]*1.e-7
; latgsm = a[i,30]*1.e-6
;
 ;time UT in military
; milsec= mSec Mod 1000.
; seci=long(mSec)/1000.
; secf = seci mod 60.
; mni=long(seci)/60.
; mnf = mni mod 60.
; hr = long(mni)/60.

 ;Ouput to device formatted
 ;printf,units,string(hr,mnf,secf,milsec,mlat,mlt,lshell,latgsm,$
 ;Format="(I2.2,':',I2.2,':',i2.2,'.',i3.3,4x,F12.2,4x,F12.2,4x,F12.2,4x,F12.2)")
stop
END