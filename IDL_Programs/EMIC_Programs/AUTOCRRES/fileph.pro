pro fileph, fnm,ep,state
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path
pathtemp=idl_path[0]
WIDGET_CONTROL, state.orb_info,SET_VALUE =string(' ')
WIDGET_CONTROL, state.dat_info,SET_VALUE =string(' ')
ct=0L
WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Ephmerius Data...'
cd,eph_path[0]
openr,/get_lun,u,fnm,error=error
if (error NE 0) then $
begin
Result = DIALOG_MESSAGE('No ephmerius file found in default directory!')
end
filss=fnm
status = FSTAT(u)	;Get file status.
dd = status.size / (4*60)
ephs={Julian:long(0),UT:lonarr(dd),XSCECI:fltarr(dd),YSCECI:fltarr(dd),ZSCECI:fltarr(dd),XaSCECI:fltarr(dd),$
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
  ephs.UT[j]=a[j,1]
  ephs.XSCECI[j]=a[j,2]*1.e-4
  ephs.YSCECI[j]=a[j,3]*1.e-4
  ephs.ZSCECI[j]=a[j,4]*1.e-4
  ephs.XaSCECI[j]=a[j,5]*1.e-7
  ephs.YaSCECI[j]=a[j,6]*1.e-7
  ephs.ZaSCECI[j]=a[j,7]*1.e-7
  ephs.REARTHSC[j]=a[j,8]*1.e-4
  ephs.Altitude[j]=a[j,9]*1.e-4
  ephs.Lat[j]=a[j,10]*1.e-6
  ephs.Lon[j]=a[j,11]*1.e-6
  ephs.Velocity[j]=a[j,12]*1.e-7
  ephs.Localtime[j]=a[j,13]*1.e-7
  ephs.RMAG[j]=a[j,14]*1.e-7
  ephs.MLat[j]=a[j,15]*1.e-6
  ephs.MLon[j]=a[j,16]*1.e-6
  ephs.RSM[j]=a[j,17]*1.e-7
  ephs.LatSM[j]=a[j,18]*1.e-6
  ephs.LocaltimeSM[j]=a[j,19]*1.e-7
  ephs.RGSM[j]=a[j,20]*1.e-7
  ephs.LatGSM[j]=a[j,21]*1.e-6
  ephs.LocaltimeGSM[j]=a[j,22]*1.e-7
  ephs.B[j]=a[j,23]*1.e-4
  ephs.BXECI[j]=a[j,24]*1.e-4
  ephs.BYECI[j]=a[j,25]*1.e-4
  ephs.BZECI[j]=a[j,26]*1.e-4
  ephs.mlt[j] = a[j,27]*1.e-7
  ephs.SZenith[j] = a[j,28]*1.e-6
  ephs.Invlat[j] = a[j,29]*1.e-6
  ephs.B100NLat[j]=a[j,30]*1.e-6
  ephs.B100NLon[j]=a[j,31]*1.e-6
  ephs.B100SLat[j]=a[j,32]*1.e-6
  ephs.B100SLon[j]=a[j,33]*1.e-6
  ephs.lshell[j]=a[j,34]*1.e-7
  ephs.Bmin[j]=a[j,35]*1.e-4
  ephs.Bminlat[j]=a[j,36]*1.e-6
  ephs.Bminlon[j]=a[j,37]*1.e-6
  ephs.Bminalt[j]=a[j,38]*1.e-4
  ephs.Bconjlat[j]=a[j,39]*1.e-6
  ephs.Bconjlon[j]=a[j,40]*1.e-6
  ephs.Bconjalt[j]=a[j,41]*1.e-4
  ephs.XsunECI[j]=a[j,42]*1.
  ephs.YsunECI[j]=a[j,43]*1.
  ephs.ZsunECI[j]=a[j,44]*1.
  ephs.XmoonECI[j]=a[j,45]*1.
  ephs.YmoonECI[j]=a[j,46]*1.
  ephs.ZmoonECI[j]=a[j,47]*1.
  ephs.RAGreenwich[j]=a[j,48]*1.e-6
  ephs.B100NMagField[j]=a[j,49]*1.e-4
  ephs.B100SMagField[j]=a[j,50]*1.e-4
  ephs.MxDipole[j]=a[j,51]*1.e-4
  ephs.MyDipole[j]=a[j,52]*1.e-4
  ephs.MzDipole[j]=a[j,53]*1.e-4
  ephs.DxDipole[j]=a[j,54]*1.e-4
  ephs.DyDipole[j]=a[j,55]*1.e-4
  ephs.DzDipole[j]=a[j,56]*1.e-4

  ;WIDGET_CONTROL, state.file_info,SET_VALUE ='Extracting Ephmerius Data...'
  ct=ct+long(1)
  if ct mod 50 EQ 0 then $
  WIDGET_CONTROL, state.dat_info,SET_VALUE ='Extracting Ephmerius Data...'
  endfor
  ephs.Julian = a[0,0]
  free_lun,u
 ep=ephs
 ;stop
 cd,idl_path[0]
 end