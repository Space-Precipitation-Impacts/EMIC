; This program is used as an example in the "Widgets"
; chapter of the _Using IDL_ manual.
;
;WIDGET_CONTROL, ev.top, GET_UVALUE=drawID
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


PRO widget2_event, ev
WIDGET_CONTROL, ev.top, get_uvalue=state
if(ev.id eq state.file_bttn2) then $
  begin
        FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.0ep')
openr,u,FName,/get_lun
filss='c9122012'
status = FSTAT(u)	;Get file status.
dd = status.size / (4*60)
UT=lonarr(dd)
Jul=long(0)
ephs={XSCECI:fltarr(dd),YSCECI:fltarr(dd),ZSCECI:fltarr(dd),XaSCECI:fltarr(dd),$
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
  endfor
  Jul = a[0,0]
        WIDGET_CONTROL,state.text,set_value='Data for file: '+string(FName),/HOURGLASS
        free_lun,u
        base2 =WIDGET_BASE(title="Select Parameters Required",XSIZE=300)

        field2 = CW_FIELD(base2, TITLE = "Name", /FRAME,/RETURN_EVENTS)
        WIDGET_CONTROL, field2, GET_VALUE = X
        WIDGET_CONTROL, base2, /REALIZE
        print,X

 endif
   WIDGET_CONTROL, ev.top, get_uvalue=state
if(ev.id eq state.file_bttn1) then $
  begin
  WIDGET_CONTROL,state.text,set_value=' '
  WIDGET_CONTROL, state.Plot_bttn1, sensitive=0
endif
  WIDGET_CONTROL, ev.top, get_uvalue=state
if(ev.id eq state.Plot_bttn1) then $
  begin

endif

  WIDGET_CONTROL, ev.top, get_uvalue=state;,/NO_COPY
;ENDcase
end


PRO widget2
base = WIDGET_BASE(title='SPG UNiNew CRRES Poynting Flux', /row,mbar=bar)

;**************************************************

file_menu = WIDGET_BUTTON(bar, VALUE='File', /MENU)
edit_menu = WIDGET_BUTTON(bar, VALUE='Edit', /MENU)
Plot_menu=  WIDGET_BUTTON(bar, VALUE='Plot',uval='plt', /MENU)
help_menu = WIDGET_BUTTON(bar, VALUE='Help', /MENU)

;**************************************************

file_bttn1=WIDGET_BUTTON(file_menu, VALUE='New',$
                        UVAL='file1')
file_bttn2=WIDGET_BUTTON(file_menu, VALUE='Open',$
                        UVAL='file2')
Plot_bttn1=WIDGET_BUTTON(Plot_menu, VALUE='Ex',$
                        UVAL='Plot1')
Plot_bttn2=WIDGET_BUTTON(Plot_menu, VALUE='Ey',$
                        UVAL='Plot2')
Plot_bttn3=WIDGET_BUTTON(Plot_menu, VALUE='Ez',$
                        UVAL='Plot3')
Plot_bttn4=WIDGET_BUTTON(Plot_menu, VALUE='Bx',$
                        UVAL='Plot4')
Plot_bttn5=WIDGET_BUTTON(Plot_menu, VALUE='By',$
                        UVAL='Plot5')
Plot_bttn6=WIDGET_BUTTON(Plot_menu, VALUE='Bz',$
                        uVAL='Plot6')

;**************************************************
text = WIDGET_TEXT(base, value='Start', XSIZE=30,ysize=20,uval='tex',/editable,/scroll,/wrap)
draw1 = WIDGET_DRAW(base,uval='drawID',xsize=400,ysize=400)

;**************************************************
state={file_bttn1:file_bttn1,$
       file_bttn2:file_bttn2,$
       draw1:draw1,$
        text:text,$
        Plot_bttn1:Plot_bttn1,$
        Plot_bttn2:Plot_bttn2,$
        Plot_bttn3:Plot_bttn3,$
        Plot_bttn4:Plot_bttn4,$
        Plot_bttn5:Plot_bttn5,$
        Plot_bttn6:Plot_bttn6}
WIDGET_CONTROL, state.Plot_bttn1, sensitive=0
WIDGET_CONTROL, state.Plot_bttn2, sensitive=0
WIDGET_CONTROL, state.Plot_bttn3, sensitive=0
WIDGET_CONTROL, state.Plot_bttn4, sensitive=0
WIDGET_CONTROL, state.Plot_bttn5, sensitive=0
WIDGET_CONTROL, state.Plot_bttn6, sensitive=0
WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, base,set_uvalue=state

XMANAGER, 'Widget2', base,/no_block

END
