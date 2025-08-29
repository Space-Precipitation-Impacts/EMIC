;Input files:crfiles.shr
; *.0ep

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


Pro crresd


fils=findfile('*.0ep')
for n=0,n_elements(fils)-1 do $
 begin
 texts=strarr(1)
 filss=strmid(fils[n],0,8)			 ;Fiche naming convention e.g. c9000000.*
;**********************************************************************************
openr,/get_lun,u,fils[n]
status = FSTAT(u)	;Get file status.
dd = status.size / (4*60)
UT=lonarr(dd)
Jul=long(0)

eph={XSCECI:fltarr(dd),YSCECI:fltarr(dd),ZSCECI:fltarr(dd),XaSCECI:fltarr(dd),$
YaSCECI:fltarr(dd),ZaSCECI:fltarr(dd),REARTHSC:fltarr(dd),Altitude:fltarr(dd),$
Lat:fltarr(dd),Lon:fltarr(dd),Velocity:fltarr(dd),Localtime:fltarr(dd),RMAG:fltarr(dd),$
MLAT:fltarr(dd),MLON:fltarr(dd),RSM:fltarr(dd),LatSM:fltarr(dd),LocaltimeSM:fltarr(dd),$
RGSM:fltarr(dd),LatGSM:fltarr(dd),LocaltimeGSM:fltarr(dd),B:fltarr(dd),BXECI:fltarr(dd),$
BYECI:fltarr(dd),BZECI:fltarr(dd),MLT:fltarr(dd),SZenith:fltarr(dd),InvLat:fltarr(dd),$
B100NLat:fltarr(dd),B100NLon:fltarr(dd),B100SLat:fltarr(dd),B100SLon:fltarr(dd),$
Lshell:fltarr(dd), Bmin:fltarr(dd),Bminlat:fltarr(dd),Bminlon:fltarr(dd),Bminalt:fltarr(dd),$
BconjLat:fltarr(dd),BconjLon:fltarr(dd),Bconjalt:fltarr(dd),XsunECI:fltarr(dd),$
YsunECI:fltarr(dd), ZsunECI:fltarr(dd), XmoonECI:fltarr(dd),YmoonECI:fltarr(dd),$
ZmoonECI:fltarr(dd),RAGreenwich:fltarr(dd),B100NMagField:fltarr(dd),B100SMagField:fltarr(dd),$
MxDipole:fltarr(dd),MyDipole:fltarr(dd),MzDipole:fltarr(dd),DxDipole:fltarr(dd),$
DyDipole:fltarr(dd),DzDipole:fltarr(dd)}

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
  eph.XSCECI[j]=a[j,2]*1.e-4
  eph.YSCECI[j]=a[j,3]*1.e-4
  eph.ZSCECI[j]=a[j,4]*1.e-4
  eph.XaSCECI[j]=a[j,5]*1.e-7
  eph.YaSCECI[j]=a[j,6]*1.e-7
  eph.ZaSCECI[j]=a[j,7]*1.e-7
  eph.REARTHSC[j]=a[j,8]*1.e-4
  eph.Altitude[j]=a[j,9]*1.e-4
  eph.Lat[j]=a[j,10]*1.e-6
  eph.Lon[j]=a[j,11]*1.e-6
  eph.Velocity[j]=a[j,12]*1.e-7
  eph.Localtime[j]=a[j,13]*1.e-7
  eph.RMAG[j]=a[j,14]*1.e-7
  eph.MLat[j]=a[j,15]*1.e-6
  eph.MLon[j]=a[j,16]*1.e-6
  eph.RSM[j]=a[j,17]*1.e-7
  eph.LatSM[j]=a[j,18]*1.e-6
  eph.LocaltimeSM[j]=a[j,19]*1.e-7
  eph.RGSM[j]=a[j,20]*1.e-7
  eph.LatGSM[j]=a[j,21]*1.e-6
  eph.LocaltimeGSM[j]=a[j,22]*1.e-7
  eph.B[j]=a[j,23]*1.e-4
  eph.BXECI[j]=a[j,24]*1.e-4
  eph.BYECI[j]=a[j,25]*1.e-4
  eph.BZECI[j]=a[j,26]*1.e-4
  eph.mlt[j] = a[j,27]*1.e-7
  eph.SZenith[j] = a[j,28]*1.e-6
  eph.Invlat[j] = a[j,29]*1.e-6
  eph.B100NLat[j]=a[j,30]*1.e-6
  eph.B100NLon[j]=a[j,31]*1.e-6
  eph.B100SLat[j]=a[j,32]*1.e-6
  eph.B100SLon[j]=a[j,33]*1.e-6
  eph.lshell[j]=a[j,34]*1.e-7
  eph.Bmin[j]=a[j,35]*1.e-4
  eph.Bminlat[j]=a[j,36]*1.e-6
  eph.Bminlon[j]=a[j,37]*1.e-6
  eph.Bminalt[j]=a[j,38]*1.e-4
  eph.Bconjlat[j]=a[j,39]*1.e-6
  eph.Bconjlon[j]=a[j,40]*1.e-6
  eph.Bconjalt[j]=a[j,41]*1.e-4
  eph.XsunECI[j]=a[j,42]*1.
  eph.YsunECI[j]=a[j,43]*1.
  eph.ZsunECI[j]=a[j,44]*1.
  eph.XmoonECI[j]=a[j,45]*1.
  eph.YmoonECI[j]=a[j,46]*1.
  eph.ZmoonECI[j]=a[j,47]*1.
  eph.RAGreenwich[j]=a[j,48]*1.e-6
  eph.B100NMagField[j]=a[j,49]*1.e-4
  eph.B100SMagField[j]=a[j,50]*1.e-4
  eph.MxDipole[j]=a[j,51]*1.e-4
  eph.MyDipole[j]=a[j,52]*1.e-4
  eph.MzDipole[j]=a[j,53]*1.e-4
  eph.DxDipole[j]=a[j,54]*1.e-4
  eph.DyDipole[j]=a[j,55]*1.e-4
  eph.DzDipole[j]=a[j,56]*1.e-4
  endfor
  Jul = a[0,0]
  free_lun,u
  ;**********************************************************************************
  ;Input time tags from raw data files
  ;
  openr,/get_lun,us,'orb917time.val'
  num=4959
  ttt=lonarr(num)
  val={XSCECI:fltarr(num),YSCECI:fltarr(num),ZSCECI:fltarr(num),XaSCECI:fltarr(num),$
  YaSCECI:fltarr(num),ZaSCECI:fltarr(num),REARTHSC:fltarr(num),Altitude:fltarr(num),$
  Lat:fltarr(num),Lon:fltarr(num),Velocity:fltarr(num),Localtime:fltarr(num),RMAG:fltarr(num),$
  MLAT:fltarr(num),MLON:fltarr(num),RSM:fltarr(num),LatSM:fltarr(num),LocaltimeSM:fltarr(num),$
  RGSM:fltarr(num),LatGSM:fltarr(num),LocaltimeGSM:fltarr(num),B:fltarr(num),BXECI:fltarr(num),$
  BYECI:fltarr(num),BZECI:fltarr(num),MLT:fltarr(num),SZenith:fltarr(num),InvLat:fltarr(num),$
  B100NLat:fltarr(num),B100NLon:fltarr(num),B100SLat:fltarr(num),B100SLon:fltarr(num),$
  Lshell:fltarr(num), Bmin:fltarr(num),Bminlat:fltarr(num),Bminlon:fltarr(num),Bminalt:fltarr(num),$
  BconjLat:fltarr(num),BconjLon:fltarr(num),Bconjalt:fltarr(num),XsunECI:fltarr(num),$
  YsunECI:fltarr(num), ZsunECI:fltarr(num), XmoonECI:fltarr(num),YmoonECI:fltarr(num),$
  ZmoonECI:fltarr(num),RAGreenwich:fltarr(num),B100NMagField:fltarr(num),B100SMagField:fltarr(num),$
  MxDipole:fltarr(num),MyDipole:fltarr(num),MzDipole:fltarr(num),DxDipole:fltarr(num),$
  DyDipole:fltarr(num),DzDipole:fltarr(num)}

  i=long(0)
  tt=strarr(1)
  for i=long(0), 4958 do $
  begin
  readf,us,tt
  ttt[i]=long(tt)       ;Store time data in array ttt
  endfor
  ;
  ;**********************************************************************************
  i=long(0)
  for kk=0, n_elements(UT)-1 do $
   if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
      begin
       i=i+1

   endif
  ;**************************************************************************************
  ;Condition 1: Only one eph.time element within val.time[0]
  ;             && val.time[n_elements(val.time)-1]
  ;
  if i EQ 1 then $
   begin
    for kk=0, n_elements(UT)-1 do $
     if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
      begin
       lj=kk
     endif

  ;Condition 1a: ttt(0) < UT[lj] < ttt(n-1)

   if ttt[0] LT UT[lj] and UT[lj] LT ttt[n_elements(ttt)-1] then $
     begin
      val_eph_time=[UT[lj-1],ttt[0],UT[lj],ttt[n_elements(ttt)-1],UT[lj+1]]
	ephtime=[UT[lj-1],UT[lj],UT[lj+1]]
	valtime=[ttt[0],ttt[n_elements(ttt)-1]]
     for ii=0,n_tags(eph)-1 do $
      begin
       ephlshell=[eph.(ii)[lj-1],eph.(ii)[lj],eph.(ii)[lj+1]]
       eph_inter_lshell=interpol(ephlshell,ephtime,val_eph_time)
       fin_eph_inter_lshell=[eph_inter_lshell[1],eph_inter_lshell[3]]
       val.(ii)=interpol(fin_eph_inter_lshell,valtime,ttt)
       ;print,ii
     endfor
  endif

  ;Condition 1b: ttt(0) EQ UT[lj]
   if ttt[0] EQ UT[lj] then $
    begin
       val_eph_time=[UT[lj],ttt[n_elements(ttt)-1],UT[lj+1]]
	 ephtime=[UT[lj],UT[lj+1]]
       valtime=[ttt[0],ttt[n_elements(ttt)-1]]
       for ii=0,n_tags(eph)-1 do $
        begin
         ephlshell=[eph.(ii)[lj],eph.(ii)[lj+1]]
         eph_inter_lshell=interpol(ephlshell,ephtime,val_eph_time)
         fin_eph_inter_lshell=[eph_inter_lshell[0],eph_inter_lshell[1]]
         val.(ii)=interpol(fin_eph_inter_lshell,valtime,ttt)
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
     ephtime=lonarr(i)
     for kk=0, n_elements(UT)-1 do $
      if (UT[kk] GE ttt[0]) AND (UT[kk] LE ttt[n_elements(ttt)-1]) then $
        begin
        lj[ii]=kk
        ephtime[ii]=UT[kk]
        ii=ii+1
      endif

  endif
print,'i=',i
  ;
  ;**********************************************************************************

  ;**********************************************************************************
  mSec=long(ttt)
  milsec=long(mSec) Mod 1000
  seci=Long(mSec/1000)
  secf = long(seci) mod 60
  mni=Long(seci)/60
  mnf = long(mni) mod 60
  hr = Long(mni/60)

  ;**********************************************************************************
  ;
  openr,/get_lun,uu,'crfiles.shr'
  while (not eof(uu)) do $
   begin
    readf,uu,texts
    if strmid(texts(0),46,8) EQ filss then $
      begin
       orbit=strmid(texts(0),0,5)
       date=strmid(texts(0),6,10)
       openw,un,/get_lun,'orb'+strtrim(orbit,1)+'.eph'
       printf,un,'Orbit'+strtrim(orbit,1)+' '+strtrim(date,1)
    endif
  endwhile
  print,'Processing file: ',fils[n]
  ;
  ;**********************************************************************************
  ;
  printf,un,FORMAT ='(A10,2X,I0)',$
  'Julian day',Jul
  printf,un,FORMAT ='(6X,A5,6X,A7,4X,A6,5X,A6,5X,A9)',$
  'TIME','MLT(hr)','MLAT','Lshell','B100NLat'
  ll=long(0)
  for i=0, num-1 do $
    begin
     printf,un,FORMAT ="(2X,I10,2X,F10.6,2X,F12.6,2X,F6.3,2X,F6.3)",$
     msec[i],val.MLT[i],val.MLAT[i],val.Lshell[i],val.B100NLat[i]
     ;printf,un,FORMAT ="(I6,4X,I2.2,':',I2.2,':',i2.2,'.',i3.3,2X,F9.6,2X,F10.6,2X,F6.3)",$
     ;Jul[i],hr[i],mnf[i],secf[i],milsec[i],MLT[i],MLAT[i],Lshell[i]
  ll=ll+1;
  endfor
  print,ll
  free_lun,u
  Free_lun,uu
  free_lun,un
 endfor
 print,'end of program'
 stop
end