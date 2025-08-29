Function XTLab,Axis,Index,Value			;Function to format x axis into hours:minutes:seconds.frac
 common nam;,nn,ttt
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 tmp1=float(msec-min(ttt))
 tmp2=float(max(ttt)-min(ttt))
 ind=(tmp1/tmp2*(n_elements(ttt)-1))
 nn(index)=ind
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end

Pro teststruct
common nam,nn,ttt
nn=intarr(4)
k=long(0)
text=' '
openr,/get_lun,u,'c9122012.0ep'
status = FSTAT(u)	;Get file status.
dd = status.size / (4*60)
val={time:lonarr(dd),$
     mlt:dblarr(dd),$
     mlat:dblarr(dd),$
     lshell:dblarr(dd)}
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

val.(0)[j] = a[j,1]
val.(1)[j] = a[j,27]*1.e-7
val.(2)[j] = a[j,15]*1.e-6
val.(3)[j] = a[j,34]*1.e-7
endfor

;openr,u,/get_lun,'orb92.eph'
;readf,u,text
;readf,u,text
;while NOT eof(u) do $
; begin
; readf,u,text
; k=k+1
;endwhile
;val={time:lonarr(k),$
;     mlt:dblarr(k),$
;     mlat:dblarr(k),$
;     lshell:dblarr(k)}
name=tag_names(val)
E=sin(findgen(dd))
;openr,u,/get_lun,'orb92.eph'
;readf,u,text
;readf,u,text
;for i=0, k-1 do $
;   begin
;   readf,u,text
;   val.(0)[i]=long(strmid(text(0),12,10))
;   val.(1)[i]=double(strmid(text(0),22,14))
;   val.(2)[i]=double(strmid(text(0),36,10))
;   val.(3)[i]=double(strmid(text(0),50,10))
;endfor
ttt=val.(0)
;point_lun,u,0
;readf,u,text
;readf,u,text
;endfor
;Free_lun,u
;for i=0,n_tags(val)-1 do $
; begin
;   ;val.(i) = 20*val.(i)
;    print,val.(i);,format="(1x,8I)")
;endfor
;val = 20
window,0,xsize=700,ysize=500
plot,val.time,E,xticks=n_elements(nn)-1,xtickformat='XTLab',ymargin=[5,0],xstyle=1
xyouts,[5,5,5],[20,40,55],['MLAT','MLT','UT'],/device
xyouts,[10,210,410,610],[40,40,40,40],[string(val.(1)[nn[0]]),string(val.(1)[nn[1]]),$
string(val.(1)[nn[2]]),string(val.(1)[nn[3]])],/device
xyouts,[10,210,410,610],[20,20,20,20],[string(val.(2)[nn[0]]),string(val.(2)[nn[1]]),$
string(val.(2)[nn[2]]),string(val.(2)[nn[3]])],/device

stop
end
