;AUTHOR: Paul Manusiu
;
Function XTLab,Axis,Index,Value		;Function to format x axis into hours:minutes:seconds.frac
 common nam,nn,ttt					;Reference ttt array in main, call ttt index nn
 mSec=long(Value)
 milsec=long(mSec) Mod 1000
 seci=Long(mSec/1000)
 secf = long(seci) mod 60
 mni=Long(seci)/60
 mnf = long(mni) mod 60
 hr = Long(mni/60)
 ;**********************************
 ;Search for xtickformat index
 ;
 tmp1=float(msec-min(ttt))
 tmp2=float(max(ttt)-min(ttt))
 ind=fix(tmp1/tmp2*n_elements(ttt))	;if found take ind index of ttt array closes to xtickformat
 nn(index)=ind						;Pass ind to nn array for reference in main
 ;
 ;**********************************
 Return,String(hr,mnf,$
  Format="(I2.2,':',I2.2)")
end

pro timtagc								;Begin main
common nam,nn,ttt						;Call common block in XTLab function
;cd,'c:\paul\phd\orbit912_917'
;
;**********************************************************************
;Input E and B data
;

openr,/get_lun,us,'orb917ebfac.val'
ttt=lonarr(4959)
Ez=dblarr(4959)
dBz=dblarr(4959)
Bz=dblarr(4959)
i=long(0)
tt=strarr(1)
readf,us,tt
head=tt
for i=long(0), 4958 do $
 begin
  readf,us,tt
  ttt[i]=long(strmid(tt(0),0,8))       ;Store time data in array ttt
  Ez[i]=double(strmid(tt(0),34,10))
  dBz[i]=double(strmid(tt(0),65,10))
  Bz[i]=double(strmid(tt(0),100,11))
endfor
stop
;
;********************************************************************
;Routine to convert ephmerius binary numbers to real
;Data in 32 bit (4 byte) unsigned integer
;There are 60 parameters in ephmerius binary file
;Substract 2^30 from integer to obtain real integer numbers
;
openr,/get_lun,u,'c9122012.0ep'	;Open binary ephmerius file
status = FSTAT(u)				;Get file status.
dd = status.size / (4*60)		;Get size of file
 UT=lonarr(dd)
eph={MLT:fltarr(dd),$
     MLAT:fltarr(dd),$
     Lshell:fltarr(dd)}

a=lonarr(dd,60)					;Long array to store each parameter
bdat=byte(1)					;Byte array to store 8 bits
dat=bytarr(4)					;Byte array to store each byte of unsigned integer
for j=0,dd-1 do $				;Loop to input binary data
 begin
  for i=0,59 do $				;Loop to input the 60 ephmerius parameters
   begin
    fdat=double(0.0)			;Declare variable to pass unsigned integer
    sgn=1.						;
   for aa=0,3 do $         		;Input 4 bytes
    begin
     READU,u,bdat
     dat(aa)=bdat				;Pass to byte array for storage
   end
   dat(0)=dat(0)-64   			;Take off 2^30
   fdat=dat(0)*256.*256.*256+dat(1)*256.*256.+dat(2)*256.+dat(3)	;Convert to real integer
   fdat=sgn*fdat				;If fdat negative, redundant
   a[j,i]=fdat					;Pass each real integer to array
  end
 				;Convert integer to real value using conversion factors
  UT[j]=a[j,1]
  eph.lshell[j]=a[j,34]*1.e-7
  eph.mlat[j] = a[j,15]*1.e-6
  eph.mlt[j] = a[j,27]*1.e-7
endfor
Jul= a[0,0]
free_lun,u
stop
;**********************************************************************************
;Beginning of Ephermius interpolation routines
;Data in *val files >> data in *0ep files
;
;**********************************************************************************
;**********************************************************************************
;Search through *0ep and count i for which (val.time[0] <= eph.time <= val.time[max])
;
i=long(0)
for kk=0, n_elements(UT)-1 do $
  if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
     begin
      i=i+1
  endif
stop
;
;**************************************************************************************
;Condition 1: Only one eph.time element within val.time[0]
;             && val.time[n_elements(val.time)-1]
;
if i EQ 1 then $
 begin
 val_inter_lshell=fltarr(3,n_elements(ttt))
   for kk=0, n_elements(UT)-1 do $
    if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
     begin
      lj=kk
   endif

   ;Condition 1a: ttt(0) < UT[lj] < ttt(n-1)
   if ttt[0] LT UT[lj] and UT[lj] LT ttt[n_elements(ttt)-1] then $
    begin
    for i=long(0),2 do $
    	begin
     val_eph_time=[UT[lj-1],ttt[0],UT[lj],ttt[n_elements(ttt)-1],UT[lj+1]]
     ephlshell=[eph.(i)[lj-1 ],eph.(i)[lj],eph.(i)[lj+1]]
     ephtime=[UT[lj-1],UT[lj],UT[lj+1]]
     eph_inter_lshell=interpol(ephlshell,ephtime,val_eph_time)
     fin_eph_inter_lshell=[eph_inter_lshell[1],eph_inter_lshell[3]]
     valtime=[ttt[0],ttt[n_elements(ttt)-1]]
     val_inter_lshell[i,*]=interpol(fin_eph_inter_lshell,valtime,ttt)
endfor
   endif
stop
;Condition 1b: ttt(0) EQ UT[lj]
   if ttt[0] EQ UT[lj] then $
    begin
     for i=long(0),2 do $
    	begin
     val_eph_time=[UT[lj],ttt[n_elements(ttt)-1],UT[lj+1]]
     ephlshell=[eph.(i)[lj-1 ],eph.(i)[lj],eph.(i)[lj+1]]
     ephtime=[UT[lj],UT[lj+1]]
     eph_inter_lshell=interpol(ephlshell,ephtime,val_eph_time)
     fin_eph_inter_lshell=[eph_inter_lshell[0],eph_inter_lshell[1]]
     valtime=[ttt[0],ttt[n_elements(ttt)-1]]
     val_inter_lshell[i,*]=interpol(fin_eph_inter_lshell,valtime,ttt)
     endfor
   endif

endif

;
;**********************************************************************************
;Condition 2: More than one eph.time element within val.time[0]
;             && val.time[n_elements(val.time)-1]
if i GT 1 then $
 begin
   ii=long(0)
   lj=lonarr(i)
   ephtime=fltarr(i)
   for kk=0, n_elements(UT)-1 do $
    if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
     begin
      lj[ii]=kk
      ephtime[ii]=UT[kk]
      ii=ii+1
   endif
endif
;
;
;**********************************************************************************

set_plot,'ps'
device,filename='Orb917efbac.ps',yoffset=3, ysize=23
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.04
!P.MULTI = [0,1,3]                     ;                     ;
nn=intarr(4)
plot,ttt,Ez,ytitle='Ey(mV/m)',XStyle=5,Xticks =3,XTickFormat='XTLab',xcharsize=2.0,ycharsize=2.0
print,nn
plot,ttt,dBz,ytitle='dBz(nT)',XStyle=5,Xticks =3,XTickFormat='XTLab',xcharsize=2.0,ycharsize=2.0
plot,ttt,Bz,ytitle='Bz(nT)',XStyle=9,Xticks =3,XTickFormat='XTLab',xcharsize=2.0,ycharsize=2.0
xyouts,[-750,-750,-750,-750],[180,-600,-1300,-2000],['UT','L','MLAT','MLT'],/device
xyouts,0,-600,String(val_inter_lshell[2,0],val_inter_lshell[2,nn[1]],$
val_inter_lshell[2,nn[2]],val_inter_lshell[2,n_elements(val_inter_lshell[2,*])-1],$
Format="(2X,F6.2,23X,F6.2,23X,F6.2,23X,F6.2)"),/device
xyouts,0,-1300,String(val_inter_lshell[1,0],val_inter_lshell[1,nn[1]],$
val_inter_lshell[1,nn[2]],val_inter_lshell[1,n_elements(val_inter_lshell[1,*])-1],$
Format="(2X,F6.2,23X,F6.2,23X,F6.2,23X,F6.2)"),/device
xyouts,0,-2000,String(val_inter_lshell[0,0],val_inter_lshell[0,nn[1]],$
val_inter_lshell[0,nn[2]],val_inter_lshell[0,n_elements(val_inter_lshell[0,*])-1],$
Format="(2X,F6.2,23X,F6.2,23X,F6.2,23X,F6.2)"),/device
device,/close
set_plot,'win'
!P.MULTI = 0
end
