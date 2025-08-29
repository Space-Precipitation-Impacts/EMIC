; This program requires two input files which must be in the c:\xfer directory.
; The first is the transferred file of CRRES orbit of interest, e.g. aa0512 for orbit 512.
;(see dataextr.wpd for details)
; The second is the ephemerus file, e.g. l0512 for orbit 512. If this file is not available use the
;program a888.pro instead of a88.pro.
; In responding to the prompt sentence'Enter SUN filename:', you should enter e.g. aa0512

;In responding to the prompt sentence 'Entered SUN filename is OK, Y or N :'
;you should enter Y if correct; or N if not, you will be required to enter SUN file name again
; The first window containing plots will appear, minimize it to an icon at the bottom of the sreen.
;or close it to save the memory.
;In responding to the prompt sentence 'Enter waiting time,floating number:'
; you should enter 0.0; if you enter a, f, ect.
; the code of a88.pro will appear and the propram running is aborted.
; The second window containing plots will appear, minimize it similarly.
;In responding to the prompt sentence 'Enter waiting time,floating number:' ; you should enter 0.0
;In responding to the prompt sentence'Enter X,Z, or L(ellipticity) to be displayed :'
; You should enter L to obtain dynamic ellipticity display,
; when it appears, minimize similarly.
;In responding to the prompt sentence 'Enter C to continue or E to exit:',
;you should enter C to continue, then enter X to obtain Bx and By spectrogams,
; minimize the window similarly.
; Similarly, enter C and then Z to obtain Btr and Bz spectrogams.
; If you already obtain three windows for ellipticity, Bx and By, and Btr and Bz,
; you should enter E to exit the Repeat Loop.

;In responding to the prompt sentence 'Enter Initial Time for 2 min Power Plot ,FORMAT: hh:mm :'
; You should enter for example 08:18
;to obtain spectra of magnetic component from this 2 minute interval
;which must be covered by the UT duration as extracted using fiche.batch at SUN computer.
; Minimize the new window
;In responding to the prompt sentence 'Enter waiting time,floating number:'
;you should enter 0.0 to get the plot of
; ellipticity and polarization versus wave frequency, minimize the window similarly.
;In responding to the prompt sentence 'Do you want to finish Repeat Loop, Y or N',
; you should enter N to continue to get spectra for other 2 minute interval
; or enter Y to finish the program running.
 ; Occasionally, the computer can not allocate enough memory to run the program, close IDL,
 ; then open IDL again and re-run the program.

CD,'C:\XFER' & ON_ERROR,2
 REPEAT BEGIN
sxyz=' '
READ,sxyz,PROMPT='Enter SUN filename:'
filecheck=' ' & READ,filecheck,PROMPT='Entered SUN filename is OK, Y or N :'
 ENDREP UNTIL STRUPCASE(filecheck) EQ 'Y'
OPENR,unit,sxyz, /GET_LUN & str=STRARR(14);& PRINT,str(3)
READF,unit,str & PRINT,str(0) & PRINT,str(13) &str8=STRCOMPRESS(str(8),/REMOVE_ALL)
n=STRMID(str8,23,6)&n=long(n) & PRINT,'Number of elements before conversion: ',n

;;;xb=FLTARR(n)&yb=xb &zb=xb & PRINT,str(3)
;;;bx1=0. & by1=0. &bz1=0. &bx2=0. & by2=0. & bz2=0.  & i=0L & time=0L
;;;FOR i=0L,n -1 DO BEGIN
;;;    READF,unit,time,bx1,by1,bz1,bx2,by2,bz2; ,format='(I9, E10.4, E10.4 ,E10.4, E10.4, E10.4, E10.4)'

;;;       xb(i)=bx1
;;;        yb(i)=by1
;;;        zb(i)=bz1

;;;ENDFOR

;WHILE (NOT EOF(unit)) DO BEGIN
 ;  READF,unit,time,index,temp3


 ; i=i+1
; ENDWHILE
  m=150000
xb=FLTARR(m)&yb=xb &zb=xb & PRINT,str(3)
bx0=0. & by0=0. &bz0=0. & time0=0L ;& by=0. & bz2=0.  & i=0L & time=0L
bx1=0. & by1=0. &bz1=0. &bx2=0. & by2=0. & bz2=0.  & i=0L & time=0L
READF,unit,time0,bx0,by0,bz0,bx2,by2,bz2
FOR i=1L,n -2 DO BEGIN
    READF,unit,time,bx1,by1,bz1,bx2,by2,bz2; ,format='(I9, E10.4, E10.4 ,E10.4, E10.4, E10.4, E10.4)'
      a=(time-time0)/192 & xb(a)=bx1 & yb(a)=by1 & zb(a)=bz1
      ; xb(i)=bx1
       ; yb(i)=by1
       ; zb(i)=bz1

ENDFOR

 nelementx=N_ELEMENTS(xb) & nelementy=N_ELEMENTS(yb)
 nelementz=N_ELEMENTS(zb)
 PRINT,'Number of elements of x,y z components:', nelementx,nelementy,nelementz
 PRINT,'Reading SUN file finished'
 FREE_LUN,unit & str4=str(5) & str1=str(4) & PRINT,str4 , str1 ;& str=0

 orbit=STRMID(sxyz,2,4)
 str1='CRRES Orbit '+orbit+', '+ str1 +', '+ str4 & PRINT, str1
 subtitle=STRCOMPRESS('CRA0'+orbit+'OMGSEFA')



;LOADCT,5
  str2=STRCOMPRESS(str4,/REMOVE_ALL)
   starttime=STRMID(str2,STRLEN(str2)-33,5)
   endtime=STRMID(str2,STRLEN(str2)-12,5)
   strhour1=STRMID(starttime,0,2) & strmin1=STRMID(starttime,3,2)
   strhour2=STRMID(endtime,0,2) & strmin2=STRMID(endtime,3,2)
   hour1=FIX(strhour1) & min1=FIX(strmin1)
   hour2=FIX(strhour2) & min2=FIX(strmin2)

   time1=hour1*60 + min1
   time2=hour2*60 + min2
   inter=LONG((TIME2-TIME1)/8)
   xtemp=STRARR(9)
FOR I=0,8 DO xtemp(I)=STRCOMPRESS(STRING((time1+i*inter)/60)+':'+ STRING((time1+i*inter) MOD 60),/REMOVE_ALL)
   utarr=xtemp   & xtemp=0
   eradarr=STRARR(9)& mltarr=eradarr
   lsharr=eradarr & mlatarr=eradarr


; REPEAT BEGIN
ephfile='l'+orbit
;READ,ephfile,PROMPT='Enter EPHEMERUS filename,Format Lnnnn,n:integer:'
;ephfilecheck=' ' & READ,ephfilecheck,PROMPT='Entered EPHEMERUS filename is OK, Y or N :'
; ENDREP UNTIL STRUPCASE(ephfilecheck) EQ 'Y'
OPENR,unit2,ephfile, /GET_LUN & ephstr=STRARR(6)
READF,unit2,ephstr
startorbstr=ephstr(1)& PRINT,startorbstr  & ephstr=0
utime=0.& mlt=0. & mlat=0.& erad=0. & lshell=0.
arrut=FLTARR(130) & arrmlt=arrut  & arrmlat=arrut & arrerad=arrut  & arrlshell=arrut
  ; READF,UNIT2,arrut,arrmlt,arrmlat,arrerad,arrlshell
i=0
WHILE (NOT EOF(unit2)) DO BEGIN
  READF,unit2,utime,mlt,mlat,erad,lshell
arrut(i)=utime & arrmlt(i)=mlt & arrmlat(i)=mlat &  arrerad(i)=erad & arrlshell(i)=lshell
   i=i+1
 ENDWHILE



 FREE_LUN,unit2
 startorbstr2=STRCOMPRESS(startorbstr,/REMOVE_ALL)
  startorbtime=STRMID(startorbstr2,STRLEN(startorbstr2)-12,5)
; PRINT,startorbtime
  orbhourstr=STRMID(startorbtime,0,2)  &  orbminstr=STRMID(startorbtime,3,2)
   orbhour=FIX(orbhourstr) & orbmin=FIX(orbminstr)
    orbstarttime=orbhour*60 + orbmin
    index1st=LONG((time1-orbstarttime)/5)  & PRINT,'First index',index1st
    indexinter=LONG(inter/5)& PRINT,'index interval',indexinter
FOR I=0,8 DO BEGIN
eradarr(i)=STRCOMPRESS(STRING(arrerad(index1st+i*indexinter)),/REMOVE_ALL)
mltarr(i)=STRCOMPRESS(STRING(arrmlt(index1st+i*indexinter)),/REMOVE_ALL)
lsharr(i)=STRCOMPRESS(STRING(arrlshell(index1st+i*indexinter)),/REMOVE_ALL)
mlatarr(i)=STRCOMPRESS(STRING(arrmlat(index1st+i*indexinter)),/REMOVE_ALL)

 eradarr(i)=STRMID(eradarr(i),0,STRLEN(eradarr(i))-2)
 mltarr(i)=STRMID(mltarr(i),0,STRLEN(mltarr(i))-2)
 lsharr(i)=STRMID(lsharr(i),0,STRLEN(lsharr(i))-2)
 mlatarr(i)=STRMID(mlatarr(i),0,STRLEN(mlatarr(i))-2)
ENDFOR

  CD,'C:\RSI\IDL40'
 strplot1='!C Magnetic field versus time Plot  MGSE Coodinate  Sampling Frequency: 16 Hz'
 xaxis1=FINDGEN(nelementx) & xvaltick1=(MAX(xaxis1)-MIN(xaxis1))/8.*FINDGEN(9)
 xtitle1='UNIVERSAL TIME (Hour)'
; !P.POSITION=[0.1,0.2,0.8,0.7]
; !P.FONT=0 ;& DEVICE,/TIMES


     ;ENDFOR
   xxx=CONGRID(xb,115201) ;& xxfit=0 ; & xaxis1=0
 yyy=CONGRID(yb,115201);& yyfit=0
 zzz=CONGRID(zb,115201); & zzfit=0
  srx=0 &sry=0 &srz=0

spike=1000.0 ;& READ,spike,PROMPT='Enter additing number for spike removal:'


    FOR i=1L,nelementx-2 DO BEGIN
   If (xb(i) GE xb(i-1)+spike) OR (xb(i) LE xb(i-1)-spike)  then xb(i)=xb(i-1)
;then xb(i)=xb(i-1);+xb(i+1))/2.
If (yb(i) GE yb(i-1)+spike) OR (yb(i) LE yb(i-1)-spike)   then yb(i)=yb(i-1)
;then xb(i)=xb(i-1)
;then yb(i)=yb(i-1);+xb(i+1))/2.
If (zb(i) GE zb(i-1)+spike) OR (zb(i) LE zb(i-1)-spike) then zb(i)=zb(i-1)
;If ((xb(i) GE (xb(i-1)+spike))AND (xb(i) GE (xb(i+1)+spike))) OR ((xb(i) LE (xb(i-1)-spike))AND (xb(i) LE (xb(i+1)-spike)))$
;then xb(i)=(xb(i-1)+xb(i+1))/2.

 ;If ((yb(i) GE (yb(i-1)+spike))AND (yb(i) GE (yb(i+1)+spike))) OR ((yb(i) LE (yb(i-1)-spike))AND (yb(i) LE (yb(i+1)-spike)))$
;then yb(i)=(yb(i-1)+yb(i+1))/2.

; If ((zb(i) GE (zb(i-1)+spike))AND (zb(i) GE (zb(i+1)+spike))) OR ((zb(i) LE (zb(i-1)-spike))AND (zb(i) LE (zb(i+1)-spike)))$
;then zb(i)=(zb(i-1)+zb(i+1))/2.


   ENDFOR

   str1=STRCOMPRESS(str1)
WINDOW,1,XSIZE=900,YSIZE=750
 PLOT,xaxis1,xb,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
  YRANGE=[MIN(xb),MAX(xb)],XTITLE=xtitle1,YTITLE='BX (nT)',XTICKS=8,$
  XMINOR=5,XTICKV=xvaltick1,XTICKNAME=utarr,TICKLEN=-0.04,POSITION=[0.2,0.1,0.8,0.3],/noerase ;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,2,XSIZE=750,YSIZE=600
 PLOT,xaxis1,yb,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
  YRANGE=[MIN(yb),MAX(yb)],XTITLE=xtitle1,YTITLE='BY (nT)',XTICKS=8,$
  XMINOR=5,XTICKV=xvaltick1,XTICKNAME=utarr,TICKLEN=-0.04,POSITION=[0.2,0.4,0.8,0.6],/noerase ;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,3,XSIZE=750,YSIZE=600
 PLOT,xaxis1,zb,TITLE=str1+strplot1,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
  YRANGE=[MIN(zb),MAX(zb)],XTITLE=xtitle1,YTITLE='BZ (nT)',XTICKS=8,$
  XMINOR=5,XTICKV=xvaltick1,XTICKNAME=utarr,TICKLEN=-0.04 ,POSITION=[0.2,0.7,0.8,0.9],/noerase;COLOR=200

 delaytime=0.
 READ,delaytime,PROMPT='Enter waiting time,floating number:'
 WAIT,delaytime

     xaxis1=FINDGEN(nelementx)
        result11=POLY_FIT(xaxis1,xb,2,xxfit) & bxsub=xb-xxfit    & RESULT11=0  & xb=0
         A=0&B=0&Z=0&YBAND=0&SIGMA=0& XX=0 &c=0
    result22=POLY_FIT(xaxis1,Yb,2,yyfit)  & bysub=yb-yyfit   & RESULT22=0   & yb=0
     A=0&B=0&Z=0&YBAND=0&SIGMA=0& XX=0 &c=0
    result33=POLY_FIT(xaxis1,Zb,2,zzfit) &  bzsub=zb-zzfit   & RESULT33=0   & zb=0
     A=0&B=0&Z=0&YBAND=0&SIGMA=0& XX=0 &c=0
  ; delaytime=0.


  coeff1=DIGITAL_FILTER(0.,0.768,50,8)
  xfilt=BLK_CON(coeff1,bxsub) & bxsub=0
  yfilt=BLK_CON(coeff1,bysub) & bysub=0
  zfilt=BLK_CON(coeff1,bzsub) & bzsub=0

  xfilt=REVERSE(BLK_CON(coeff1,REVERSE(xfilt)))
yfilt=REVERSE(BLK_CON(coeff1,REVERSE(yfilt)))
zfilt=REVERSE(BLK_CON(coeff1,REVERSE(zfilt)))
  ;;; xxa=CONGRID(xfilt+xxfit,115201) ;& xfilt=0 ; & xaxis1=0
 ;;;  yya=CONGRID(yfilt+yyfit,115201); & yfilt=0
 ;;;  zza=CONGRID(zfilt+zzfit,115201) ;& zfilt=0

   srx=0 &sry=0 &srz=0
 axx=CONGRID(xfilt,115201) & xfilt=0 ; & xaxis1=0
 ayy=CONGRID(yfilt,115201) & yfilt=0
 azz=CONGRID(zfilt,115201) & zfilt=0

    srx=0 &sry=0 &srz=0

 xfit=CONGRID(xxfit,115201) & xxfit=0 ; & xaxis1=0
 yfit=CONGRID(yyfit,115201)& yyfit=0
 zfit=CONGRID(zzfit,115201) & zzfit=0
    srx=0 &sry=0 &srz=0
 ; AXX=AXX+XFIT
  ; AYY=AYY+YFIT
  ; AZZ=AZZ+ZFIT
totpnts=N_ELEMENTS(axx)




;totpnts=N_ELEMENTS(axx)
  ;PRINT,AXX(0:5)
   ;PRINT,AYY(0:5)
   ; PRINT,AZZ(0:5)

 PRINT,'Number of elements of x,y z components after resampling:',N_ELEMENTS(axx)
 coeff=DIGITAL_FILTER(0.,0.0025,50,8)
 axxfilt=BLK_CON(coeff,axx)
 ayyfilt=BLK_CON(coeff,ayy)
 azzfilt=BLK_CON(coeff,azz)
  axxfilt=REVERSE(BLK_CON(coeff,REVERSE(axxfilt)))
  ayyfilt=REVERSE(BLK_CON(coeff,REVERSE(ayyfilt)))
  azzfilt=REVERSE(BLK_CON(coeff,REVERSE(azzfilt)))


  axxfilt=axxfilt+ xfit  & XFIT=0
   ;axxfilt= xfit  & XFIT=0
  ayyfilt=ayyfilt+ yfit  & YFIT=0
   ;aYYfilt= Yfit   & YFIT=0
 azzfilt=azzfilt+ zfit    & ZFIT=0


  ;  aZZfilt= ZFit   &ZFIT=0
; axx=CONGRID(xb,LONG(nelementx/3.90625)) & xb=0
; ayy=CONGRID(yb,LONG(nelementx/3.90625)) & yb=0
; azz=CONGRID(zb,LONG(nelementx/3.90625)) & zb=0
; PRINT,'Number of elements of x,y z components after resampling:',N_ELEMENTS(axx)
; coeff=DIGITAL_FILTER(0.,0.0025,50,8)
 ; axxfilt=BLK_CON(coeff,axx)
 ; ayyfilt=BLK_CON(coeff,ayy)
  ; azzfilt=BLK_CON(coeff,azz)       a=LONG(nelementx/4)  & b=4*a-1
    ; xb=xb(0:b)
    ; yb=yb(0:b)
    ; zb=zb(0:b)

  ; xx=REBIN(xb,a)
    ;yy=REBIN(yb,a)
    ; zz=REBIN(zb,a)


     xaxis1=FINDGEN(nelementx)



totpnts=N_ELEMENTS(axx)
 ;;; axx=xxa &ayy=yya & azz=zza &xxa=0 &yya=0 &zza=0
 coeff=0
; theta1=ATAN(axxfilt/ayyfilt)& coss=COS(theta1)& sinn=SIN(theta1)& theta1=0
 sqr=ayyfilt^2 + axxfilt^2 ;& ayyfilt=0 & axxfilt=0
  coss=ayyfilt/SQRT(sqr) & sinn=axxfilt/SQRT(sqr)
  cosphi=SQRT(sqr)/SQRT(sqr+azzfilt^2) & sinphi=azzfilt/SQRT(sqr+azzfilt^2)
  sqr=0 & ayyfilt=0 & axxfilt=0 & azzfilt=0 & axxfilt=0
; phi=ATAN(azzfilt/SQRT(sqr)) & sqr=0;azzfilt=0 & sqr=0
 h1=ayy*coss + axx*sinn
 xxout=axx*coss- ayy*sinn
 axx=0 & coss=0 & sinn=0 & ayy=0
 zzout=h1*cosphi+azz*sinphi
 yyout=-azz*COSphi+h1*SINphi
  azz=0 & h1=0 &cosphi=0 &sinphi=0

 ;coeff4=DIGITAL_FILTER(0.05,1.,50,8)
; xxout=BLK_CON(coeff4,xxout)
 ; yyout=BLK_CON(coeff4,yyout)
  ; zzout=BLK_CON(coeff4,zzout)

strplot2='!C Magnetic field versus time Plot ,after resampling and coordinate conversion'
strplot3='!C FAC Coordinate    Sampling Frequency: 4 Hz'
xaxis2=FINDGEN(N_ELEMENTS(xxout))&  xvaltick2=(MAX(xaxis2)-MIN(xaxis2))/8.*FINDGEN(9)

 ;coeff=DIGITAL_FILTER(0.025,1.,50,8)
 ; xxout=BLK_CON(coeff,xxout)
 ;  yyout=BLK_CON(coeff,yyout)
;  zzout=BLK_CON(coeff,zzout)

; xxout=REVERSE(BLK_CON(coeff,REVERSE(xxout)))
;  yyout=REVERSE(BLK_CON(coeff,REVERSE(yyout)))
; zzout=REVERSE(BLK_CON(coeff,REVERSE(zzout)))

 ;nelementxx=N_ELEMENTS(xxout)


 ;xxout=SMOOTH(xxout,3,/EDGE_TRUNCATE)
 	;	yyout=SMOOTH(yyout,3,/EDGE_TRUNCATE)
 		;	zout=SMOOTH(zzout,3,/EDGE_TRUNCATE)

WINDOW,4 ,XSIZE=900,YSIZE=750
 PLOT,xaxis2,xxout,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis2),MAX(xaxis2)],$
  YRANGE=[MIN(xxout),MAX(xxout)],XTITLE=xtitle1,YTITLE='BX (nT)',XTICKS=8,$
  XMINOR=6,XTICKV=xvaltick2,XTICKNAME=utarr,TICKLEN=-0.04,POSITION=[0.2,0.08,0.8,0.28],/noerase ;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,5 ,XSIZE=750,YSIZE=600
 PLOT,xaxis2,yyout,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis2),MAX(xaxis2)],$
  YRANGE=[MIN(yyout),MAX(yyout)],XTITLE=xtitle1,YTITLE='BY (nT)',XTICKS=8,$
  XMINOR=6,XTICKV=xvaltick2,XTICKNAME=utarr,TICKLEN=-0.04,POSITION=[0.2,0.38,0.8,0.58],/noerase;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,6 ,XSIZE=750,YSIZE=600
 PLOT,xaxis2,zzout,TITLE=str1+strplot2+strplot3,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis2),MAX(xaxis2)],$
  YRANGE=[MIN(zzout),MAX(zzout)],XTITLE=xtitle1,YTITLE='BZ (nT)',XTICKS=8,$
  XMINOR=6,XTICKV=xvaltick2,XTICKNAME=utarr,TICKLEN=-0.04,POSITION=[0.2,0.68,0.8,0.88],/noerase ;COLOR=200
 delaytime=0.
 READ,delaytime,PROMPT='Enter waiting time,floating number:'
 WAIT,delaytime

; PRINT,'Coordinate conversion finished , ready for FFTs '
  n=240; & READ,n,PROMPT='Enter FFT length,integer only, 240 or 480 recommended:'
 length=FLOAT(n) & divisor=3 & pshift=n/divisor

 ;READ,divisor,PROMPT='Enter ratio of FFT length to step length,odd integer only 3 or 5:'

  If (divisor EQ 3)then freedom='     DEG. OF FREEDOM:4.7'
 If (divisor EQ 5)then freedom='     DEG. OF FREEDOM:4.4'
; mult=8.0
  strplot='!CFFT Length:'+STRCOMPRESS(STRING(n))+'  STEP:'+STRCOMPRESS(STRING(pshift))+freedom+'  '+subtitle

 delf=1./(length*0.25) & mult=8.0;& hamm=FLTARR(n)
; FOR i=0,n-1 DO hamm(i)=0.08+0.46*(1. - COS(2.*!PI*I/length))
 hamm=HANNING(n,ALPHA=0.54)

 ;READ,mult,PROMPT='Enter power scale factor,floating number:'
 totpnts=N_ELEMENTS(xxout)
 ;PRINT,'Total points :',totpnts
 numbloc=LONG((totpnts - n )/pshift) + 1
 PRINT,'Nunber of blocks of FFT :',numbloc
 frearr=delf*1000.*FINDGEN(n/2+1)& oxifre=FLTARR(numbloc)

 tvarrx=FLTARR(numbloc,n/2+1)& tvarry=tvarrx
 tvarrz=tvarrx & tvtrans=tvarrx & tvarrxy=COMPLEXARR(numbloc,n/2+1)& xaxis=FINDGEN(numbloc+1)

FOR bloc=0L,numbloc-1 DO BEGIN
	  m1=bloc*pshift & m2=m1+n-1 & mm=m1+pshift-1
   x=xxx(m1:mm)  & meanx= TOTAL(x)/pshift  & x=0
   y=yyy(m1:mm)  & meany= TOTAL(y)/pshift   & y=0
   z=zzz(m1:mm)   & meanz= TOTAL(z)/pshift  & z=0




    ; bfield=SQRT(x(0)^2 +y(0)^2 + z(0)^2)  &x=0 &y=0 &z=0
   bfield=SQRT(meanx^2 +meany^2 + meanz^2)

   xa=xxout(m1:m2)  & meanxx= TOTAL(xa)/length
   ya=yyout(m1:m2)  & meanyy= TOTAL(ya)/length
   za=zzout(m1:m2)   & meanzz= TOTAL(za)/length
     ;bfield=SQRT((TOTAL(xa)/length)^2 +(TOTAL(ya)/length)^2 + (TOTAL(za)/length)^2)
  ; bfield=SQRT(meanx^2 +meany^2 + meanz^2)
   oxifre(bloc)=3.8*bfield
   fftx=FFT(mult*hamm*(xa-meanxx),-1) & xa=0
   ffty=FFT(mult*hamm*(ya-meanyy),-1) & ya=0
   fftz=FFT(mult*hamm*(za-meanzz),-1) & za=0
   fftxnew=fftx(0:n/2) & fftx=0
   fftynew=ffty(0:n/2) & ffty=0
   fftznew=fftz(0:n/2) & fftz=0
   powx=ABS(CONJ(fftxnew)*fftxnew)
   powy=ABS(CONJ(fftynew)*fftynew)
   powz=ABS(CONJ(fftznew)*fftznew) & fftznew=0
  ; powtrans=(powx+powy)
   powxy=fftxnew*CONJ(fftynew) & fftxnew=0 & fftynew=0
   ;beta=0.5*ASIN(2*IMAGINARY(powxy)/powtrans) ;& powxy=0
  ; ellip=TAN(beta) & beta=0
    ; coh=ABS(powxy)/SQRT(powx*powy)
    ; coharr(bloc,*)=coh & coh=0
  ; tvarrelip(bloc,*)= ellip*100.+120. & ellip=0
   ;powx=powx < 1.E10  & powx=1. > powx
  ; powy=powy < 1.E10  & powy=1. > powy
  ; powz=powz < 1.E10  & powz=1. > powz
   ;powtrans=powtrans < 1.E10  & powtrans=1. > powtrans
  ; powx=20.1*ALOG10(powx)
   ;powy=20.1*ALOG10(powy)

  ; powz=20.1*ALOG10(powz)
   ;powtrans=20.1*ALOG10(powtrans)


   tvarry(bloc,*)=powy & tvarrx(bloc,*)=powx ;& powx=0;& powy=0
     tvtrans(bloc,*)=powx+powy & powx=0  & powy=0
   tvarrz(bloc,*)=powz & powz=0 &tvarrxy(bloc,*)=powxy & powxy=0

    ;  bzsub=zb-zzfit   & RESULT33=0   & zb=0
  ; tvtrans(bloc,*)=powtrans & powtrans=0

  ENDFOR
  zzout=0 ; xxout=0 & yyout=0 & zzout=0 & hamm=0
   xxx=0 & yyy=0 & zzz=0

varrx= tvarrx & varry= tvarry & varrz= tvarrz  & varrxy= tvarrxy & varrt= tvtrans
FOR i=0,n/2 DO BEGIN
	tvarrx(*,i)=SMOOTH(tvarrx(*,i),divisor+2,/EDGE_TRUNCATE)
	tvarry(*,i)=SMOOTH(tvarry(*,i),divisor+2,/EDGE_TRUNCATE)
	tvtrans(*,i)=SMOOTH(tvtrans(*,i),divisor+2,/EDGE_TRUNCATE)
	tvarrz(*,i)=SMOOTH(tvarrz(*,i),divisor+2,/EDGE_TRUNCATE)
	tvarrxy(*,i)=SMOOTH(tvarrxy(*,i),divisor+2,/EDGE_TRUNCATE)
ENDFOR
;	tvtrans=tvarrx+tvarry
	beta=0.5*ASIN(2*IMAGINARY(tvarrxy)/SQRT((tvarrx-tvarry)^2+4*ABS(tvarrxy)^2)) ;& powxy=0
	; beta=0.5*ASIN(2*IMAGINARY(tvarrxy)/tvtrans) ;& powxy=0
   ellip=TAN(beta) & beta=0 & tvarrellip= ellip*100.+120. & ellip=0
    ; coh=ABS(powxy)/SQRT(powx*powy)
    ; coharr(bloc,*)=coh & coh=0

pol=SQRT((tvarrx-tvarry)^2+4*ABS(tvarrxy)^2)/tvtrans &	sub1=WHERE(pol LE 0.7 ) & pol=0

  ; tvarrpol=pol*200. +20. ;& pol=0
	;sub=WHERE(tvtrans GE 0.60*MAX(tvtrans))
	;tvarrellip(sub)=255. & sub=0
    ; tvarrx(*,0:3)=1. & tvarry(*,0:3)=1.  & tvarrz(*,0:3)=1.  & tvtrans(*,0:3)=1.
  ; tvarrx=tvarrx < 1.E10  & tvarrx=1. > tvarrx
 ;  tvarry=tvarry < 1.E10  & tvarry=1. > tvarry
 ;  tvarrz=tvarrz < 1.E10  & tvarrz=1. > tvarrz
;   tvtrans=tvtrans < 1.E10  & tvtrans=1. > tvtrans

   tvarrx=20.1*ALOG10(tvarrx*564.06) & tvarry=20.1*ALOG10(tvarry*564.06)

	tvarrz=20.1*ALOG10(tvarrz*564.06) &  tvtrans=20.1*ALOG10(tvtrans*564.06)

 ;  PRINT,'FFT loop terminated '
   PRINT,str1 & PRINT,oxifre(0:9) & PRINT,oxifre(numbloc-9 :numbloc-1)

  ; PRINT,'Ready for display '
   yvaltick=(MAX(frearr)-MIN(frearr))/4.*FINDGEN(5) & yname=['0.0','0.5','1.0','1.5','2.0']

   strbar=REPLICATE('........  ',12)
barnum=['-3.0','-2.5','-2.2','-2.0','-1.7','-1.5','-1.2','-1.0','-0.8','-0.5','-0.3',' 0.0']
;barstr=strbar+barnum
; barpow1=['(0.0033)','(0.0070)','(0.0147)','(0.0310)','(0.0652)','(0.1371)']
;barpow2=['(0.2884)','(0.6067)','(1.2769)','(2.6866)','(5.6528)','(11.894)']
;barpow=[barpow1,barpow2]&barpow1=0 &barpow2=0
; strbar2=REPLICATE('  ',12)
   barstr=strbar+barnum;+strbar2+ barpow

;colbar1=REPLICATE(200,7) & colbar2=REPLICATE(120,5)
;colbar=[colbar1,colbar2]
;!P.POSITION=0
 ; str1=STRCOMPRESS(str1)
  xval=(MAX(xaxis)-MIN(xaxis))/8.*FINDGEN(9)
 REPEAT BEGIN
   option=' '
    READ,option,PROMPT='Enter X,Z,or L(ellipticity) to be displayed :'

     CASE STRUPCASE(option) OF
        'X':BEGIN
      WINDOW,7,XSIZE=900,YSIZE=750
        strx='!CX Component and He and H Cyclotron Frequency Plot'+'  '+subtitle
        mult2=3.5; & READ,mult2,PROMPT='Enter second scale factor,floating number:'
        tvarrxx=mult2*tvarrx
        tvcongridx=CONGRID(tvarrxx,600,200) & sz=SIZE(tvcongridx)
  xvaltick=sz(1)/8.*FINDGEN(9)  & tvcongridx=tvcongridx < 250. & tvcongridx=0. > tvcongridx
   tvcongridx(*,0:5)=0.       ;xvaltick=(MAX(xaxis)-MIN(xaxis))/8.*FINDGEN(9)
       ; ERASE & TV,BYTE(tvcongridx),100,150
PLOT,xaxis,frearr,/NODATA,/DEVICE,YTITLE='BX (Hz)',XSTYLE=1,$
 YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.04,$
 XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.1,XTICKNAME=utarr,XTICKV=xval,$
POSITION=[100,150,100+sz(1)-1,150+sz(2)-1],YTICKV=yvaltick,YTICKNAME=yname
  TV,BYTE(tvcongridx),100,150 & tvcongridx=0 & strx=0 ;COLOR=200
       arrbar=BYTARR(20,251)
       FOR i=0,19 DO arrbar(i,*)=BINDGEN(251)
       con=CONGRID(arrbar,20,418) & arrbar=0
      TV,con,100+sz(1)+25,150 & con=0
XYOUTS,100+sz(1)+20,585,'LOG POWER (dB)',/DEVICE ,SIZE=1.1;COLOR=200

FOR i=0,11 DO XYOUTS,100+sz(1)+25,149+i*38,barstr(i),/DEVICE,SIZE=1.0;,COLOR=colbar(i)

       XYOUTS,30,115,'UT',/DEVICE,SIZE=1.2;,COLOR=200
       XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
      FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
       XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
      FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       xcrange=!X.CRANGE & xrange=xcrange(1)-xcrange(0)
       xaxisrange=xrange/numbloc*xaxis
      OPLOT,xaxisrange,oxifre,THICK=2;,COLOR=150
      OPLOT,xaxisrange,oxifre*4.,THICK=2;,COLOR=150
       sz=0
    ; END
               ; 'Y':BEGIN
      ; WINDOW,8,XSIZE=850,YSIZE=680
        stry='!CBX and BY Spectrograms, He and H Cyclotron Frequency Plot';+'  '+subtitle
        mult2=3.5; & READ,mult2,PROMPT='Enter second scale factor,floating number:'
        tvarryy=mult2*tvarry
        tvcongridy=CONGRID(tvarryy,600,200) & sz=SIZE(tvcongridy)
xvaltick=sz(1)/8.*FINDGEN(9)   & tvcongridy=tvcongridy < 250. & tvcongridy=0. > tvcongridy
   tvcongridy(*,0:5)=0.       ;xvaltick=(MAX(xaxis)-MIN(xaxis))/8.*FINDGEN(9)

       ; ERASE & TV,BYTE(tvcongridy),100,150
    PLOT,xaxis,frearr,/NODATA,/DEVICE,TITLE=str1+stry+strplot,YTITLE='BY (Hz)',XSTYLE=1,$
  YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.04,$
        XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.1,XTICKNAME=utarr,XTICKV=xval,$
        POSITION=[100,400,100+sz(1)-1,400+sz(2)-1],YTICKV=yvaltick,YTICKNAME=yname ,/NOERASE
       TV,BYTE(tvcongridy),100,400 & tvcongridy=0 & stry=0 ;COLOR=200
       ;arrbar=BYTARR(20,251)
       ;FOR i=0,19 DO arrbar(i,*)=BINDGEN(251)
     ;  con=CONGRID(arrbar,20,418) & arrbar=0
     ;  TV,con,100+sz(1)+20,150 & con=0
;  XYOUTS,100+SZ(1)+20,115,'LOG POWER:dB(nTxnT/Hz)',/DEVICE ;COLOR=200
;FOR i=0,11 DO XYOUTS,100+sz(1)+20,149+i*38,barstr(i),/DEVICE,SIZE=1.0;,COLOR=colbar(i)
       XYOUTS,30,365,'UT',/DEVICE,SIZE=1.2;,COLOR=200
      ; XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
      ; XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
     ;  XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
     ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
     ;  XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
       ;FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
       xcrange=!X.CRANGE & xrange=xcrange(1)-xcrange(0)
       xaxisrange=xrange/numbloc*xaxis
      OPLOT,xaxisrange,oxifre,THICK=2;,COLOR=150
      OPLOT,xaxisrange,oxifre*4.,THICK=2;,COLOR=150
       sz=0
     END
               'Z':BEGIN
      WINDOW,9 ,XSIZE=900,YSIZE=750
        strz='!CZ Component and He and H Cyclotron Frequency Plot'; +'  '+subtitle
        mult2=3.5; & READ,mult2,PROMPT='Enter second scale factor,floating number:'
        tvarrzz=mult2*tvarrz
        tvcongridz=CONGRID(tvarrzz,600,200) & sz=SIZE(tvcongridz)
xvaltick=sz(1)/8.*FINDGEN(9)   & tvcongridz=tvcongridz < 250.  & tvcongridz=0. > tvcongridz
   tvcongridz(*,0:5)=0.       ;xvaltick=(MAX(xaxis)-MIN(xaxis))/8.*FINDGEN(9)

       ;ERASE & TV,BYTE(tvcongridz),100,150
      PLOT,xaxis,frearr,/NODATA,/DEVICE,YTITLE='BZ (Hz)',XSTYLE=1,$
   YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.04,$
        XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.1,XTICKNAME=utarr,XTICKV=xval,$
        POSITION=[100,150,100+sz(1)-1,150+sz(2)-1],YTICKV=yvaltick,YTICKNAME=yname ;COLOR=200
       TV,BYTE(tvcongridz),100,150 & tvcongridz=0 & strz=0
       arrbar=BYTARR(20,251)
       FOR i=0,19 DO arrbar(i,*)=BINDGEN(251)
       con=CONGRID(arrbar,20,418) & arrbar=0
       TV,con,100+sz(1)+25,150 & con=0
XYOUTS,100+SZ(1)+20,585,'LOG POWER: (dB)',/DEVICE ,SIZE=1.1;COLOR=200
FOR i=0,11 DO XYOUTS,100+sz(1)+25,149+i*38,barstr(i),/DEVICE,SIZE=1.0;,COLOR=colbar(i)
       XYOUTS,30,115,'UT',/DEVICE,SIZE=1.2;,COLOR=200
       XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
       XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
       xcrange=!X.CRANGE & xrange=xcrange(1)-xcrange(0)
       xaxisrange=xrange/numbloc*xaxis
      OPLOT,xaxisrange,oxifre,THICK=2;,COLOR=150
      OPLOT,xaxisrange,oxifre*4.,THICK=2;,COLOR=150
        sz=0
   ;  END
             ; 'T':BEGIN
    ;  WINDOW,10,XSIZE=850,YSIZE=680
        strt='!CBZ and BT(Transverse), He and H Cyclotron Frequency Plot'; +'  '+subtitle
        mult2=3.5; & READ,mult2,PROMPT='Enter second scale factor,floating number:'
        tvtransnew=mult2*tvtrans
        tvcongridt=CONGRID(tvtransnew,600,200) & sz=SIZE(tvcongridt)
xvaltick=sz(1)/8.*FINDGEN(9)  & tvcongridt=tvcongridt < 250. & tvcongridt=0. > tvcongridt
   tvcongridt(*,0:5)=0.       ;xvaltick=(MAX(xaxis)-MIN(xaxis))/8.*FINDGEN(9)

        ;ERASE & TV,BYTE(tvcongridt),100,150
      PLOT,xaxis,frearr,/NODATA,/DEVICE,TITLE=str1+strt+strplot,YTITLE='BT (Hz)',XSTYLE=1,$
  YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.04,$
        XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.1,XTICKNAME=utarr,XTICKV=xval,$
        POSITION=[100,400,100+sz(1)-1,400+sz(2)-1],YTICKV=yvaltick,YTICKNAME=yname,/NOERASE;COLOR=200
       TV,BYTE(tvcongridt),100,400 & tvcongridt=0 & strt=0
      ; arrbar=BYTARR(20,251)
      ; FOR i=0,19 DO arrbar(i,*)=BINDGEN(251)
      ; con=CONGRID(arrbar,20,418) & arrbar=0
      ;TV,con,100+sz(1)+20,150 & con=0
;XYOUTS,100+SZ(1)+20,115,'LOG POWER:dB(nTxnT/Hz)',/DEVICE;COLOR=200
;FOR i=0,11 DO XYOUTS,100+sz(1)+20,149+i*38,barstr(i),/DEVICE,SIZE=1.0;,COLOR=colbar(i)
       XYOUTS,30,365,'UT',/DEVICE,SIZE=1.2;,COLOR=200
    ;   XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
     ;  FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
      ; XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
      ; XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5;COLOR=200
      ; XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ;COLOR=200
       xcrange=!X.CRANGE & xrange=xcrange(1)-xcrange(0)
       xaxisrange=xrange/numbloc*xaxis
      OPLOT,xaxisrange,oxifre,THICK=2;,COLOR=150
      OPLOT,xaxisrange,oxifre*4.,THICK=2;,COLOR=150
       sz=0
     END
          'L':BEGIN
        WINDOW,11,XSIZE=850,YSIZE=680
            threspow=33.3
          ;  READ,threspow,PROMPT='Enter power threshold scale ,floatiing, (>140. and < 160.):'
            	sub=WHERE(tvtrans LT threspow)
        	;sub1=WHERE(pol LE 0.7 )
 threspowstr=STRCOMPRESS(STRING(EXP(threspow*2.302585/20.1)*0.001662),/REMOVE_ALL)
 strpowthres='Transverse Power Threshold:'+threspowstr +'(nT**2/Hz)'
 elipstr='!C'+'POLARIZATION Percentage > or = 70%' +'  '+ strpowthres
        	arrellip=tvarrellip
  	    	arrellip(sub)=0. & sub=0
  	    	arrellip(sub1)=0.; & sub1=0
        stre='!C Ellipticity Display and He and H Cyclotron Frequency Plot'; & PRINT,tvarrelip(0,0:9)
        tvcongridellip=CONGRID(arrellip,600,420) & arrellip=0
       tvcongridellip(*,0:10)=0.
        sz=SIZE(tvcongridellip)
        xvaltick=sz(1)/8.*FINDGEN(9)
       ; ERASE & TV,BYTE(tvcongridellip),100,150
PLOT,xaxis,frearr,/NODATA,/DEVICE,TITLE=str1+stre+strplot+elipstr,YTITLE='FREQUENCY (Hz)',XSTYLE=1,$
    YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.03,$
        XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.1,XTICKNAME=utarr,XTICKV=xval,$
       POSITION=[100,150,100+sz(1)-1,150+sz(2)-1] ,YTICKV=yvaltick,YTICKNAME=yname; COLOR=200,
       TV,BYTE(tvcongridellip),100,150 & tvcongridellip=0 & stre=0
       arrbar=BYTARR(20,201)
       FOR i=0,19 DO arrbar(i,*)=BINDGEN(201)+20
       con=CONGRID(arrbar,20,401) & arrbar=0
       TV,con,100+sz(1)+30,150 & con=0
       XYOUTS,100+sz(1)+30,150,'........ e=-1',/DEVICE ; COLOR=200,
       XYOUTS,100+sz(1)+30,401+150,'........ e=+1',/DEVICE ; COLOR=200,
       XYOUTS,100+sz(1)+30,200+150,'........ e=0',/DEVICE ; COLOR=200,
       XYOUTS,100+sz(1)+30,220+150,'........ e=+0.2',/DEVICE ; COLOR=200,
       XYOUTS,100+sz(1)+30,180+150,'........ e=-0.2',/DEVICE ; COLOR=200,
       XYOUTS,100+sz(1)+30,568,'ELLIPTICITY',/DEVICE ,SIZE=1.1; COLOR=200,

       XYOUTS,30,110,'UT',/DEVICE,SIZE=1.2;,COLOR=200
       XYOUTS,30,90,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,90,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
       XYOUTS,30,70,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,70,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5; COLOR=200,
       XYOUTS,30,50,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,50,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
       XYOUTS,30,30,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
       FOR i=0,8 DO XYOUTS,xvaltick(i)+100,30,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
        xcrange=!X.CRANGE & xrange=xcrange(1)-xcrange(0)
       xaxisrange=xrange/numbloc*xaxis
      OPLOT,xaxisrange,oxifre,THICK=2;,COLOR=150
      OPLOT,xaxisrange,oxifre*4.,THICK=2;,COLOR=150
       sz=0
     END

 ; 'M':BEGIN
      ;  WINDOW,13,XSIZE=850,YSIZE=680
            ;threspow=0.0
           ; READ,threspow,PROMPT='Enter power threshold scale ,floatiing, (>0.5 and < 0.95):'
            ;	sub=WHERE(tvtrans LT threspow* MAX(tvarry))
        	;sub1=WHERE(pol LE 0.7 )
        ;	arrellip=tvarrellip
  	    	;arrellip(sub)=0. & sub=0
  	    ;	arrellip(sub1)=0.; & sub1=0
     ;   stre='!C Ellipticity Display'; & PRINT,tvarrelip(0,0:9)
      ;  tvcongridellip=CONGRID(arrellip,600,420) & arrellip=0

      ;  sz=SIZE(tvcongridellip)
      ;  xvaltick=sz(1)/8.*FINDGEN(9)
       ; ERASE & TV,BYTE(tvcongridellip),100,150
;PLOT,xaxis,frearr,/NODATA,/DEVICE,TITLE=str1+stre+strplot,YTITLE='FREQUENCY in Hz',XSTYLE=1,$
      ;  YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.02,$
      ;  XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.2,XTICKNAME=utarr,XTICKV=xval,$
      ; POSITION=[100,150,100+sz(1)-1,150+sz(2)-1] ,YTICKV=yvaltick,YTICKNAME=yname; COLOR=200,
      ; TV,BYTE(tvcongridellip),100,150 & tvcongridellip=0 & stre=0
     ;  arrbar=BYTARR(20,201)
     ;  FOR i=0,19 DO arrbar(i,*)=BINDGEN(201)+20
     ; con=CONGRID(arrbar,20,401) & arrbar=0
     ;  TV,con,100+sz(1)+30,150 & con=0
     ;  XYOUTS,100+sz(1)+10,150,'e=-1',/DEVICE ; COLOR=200,
     ;  XYOUTS,100+sz(1)+10,401+150,'e=+1',/DEVICE ; COLOR=200,
     ;  XYOUTS,100+sz(1)+10,200+150,'e=0',/DEVICE ; COLOR=200,
     ; XYOUTS,100+sz(1)+10,220+150,'e=+0.2',/DEVICE ; COLOR=200,
      ; XYOUTS,100+sz(1)+10,180+150,'e=-0.2',/DEVICE ; COLOR=200,
     ;  XYOUTS,100+sz(1)+20,115,'ELLIPTICITY',/DEVICE ; COLOR=200,

     ; XYOUTS,30,115,'UT',/DEVICE,SIZE=1.2;,COLOR=200
     ; XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
     ;  XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
     ;  FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5; COLOR=200,
      ;XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
      ; XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
    ;   FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,

    ;END
  ;  'P':BEGIN
      ;  WINDOW,12,XSIZE=850,YSIZE=680
          ;  threspow=0.0
          ;  READ,threspow,PROMPT='Enter power threshold scale ,floatiing, (>140. and < 160.):'
        ;sub=WHERE(tvtrans LT threspow)
        ;arrpol=tvarrpol
  	    ;	arrpol(sub)=0. & sub=0
       ; strp='!C % Polarization Display'; & PRINT,tvarrelip(0,0:9)
       ; tvcongridpol=CONGRID(arrpol,600,420) & arrpol=0

       ; sz=SIZE(tvcongridpol)
       ; xvaltick=sz(1)/8.*FINDGEN(9)
       ; ERASE & TV,BYTE(tvcongridellip),100,150
;PLOT,xaxis,frearr,/NODATA,/DEVICE,TITLE=str1+strp+strplot,YTITLE='FREQUENCY in Hz',XSTYLE=1,$
      ;  YSTYLE=1,XRANGE=[MIN(xaxis),MAX(xaxis)],YRANGE=[MIN(frearr),MAX(frearr)],TICKLEN=-0.02,$
      ;  XTICKS=8,YTICKS=4,XMINOR=6,YMINOR=5,CHARSIZE=1.2,XTICKNAME=utarr,XTICKV=xvaltick,$
      ; POSITION=[100,150,100+sz(1)-1,150+sz(2)-1] ,YTICKV=yvaltick,YTICKNAME=yname; COLOR=200,
     ; TV,BYTE(tvcongridpol),100,150 & tvcongridpol=0 & strp=0
      ; arrbar=BYTARR(20,201)
      ; FOR i=0,19 DO arrbar(i,*)=BINDGEN(201)+20
      ;con=CONGRID(arrbar,20,401) & arrbar=0
      ; TV,con,100+sz(1)+30,150 & con=0
      ; XYOUTS,100+sz(1)+10,150,'p=0.0',/DEVICE ; COLOR=200,
     ;  XYOUTS,100+sz(1)+10,401+150,'p=1.0',/DEVICE ; COLOR=200,
     ;  XYOUTS,100+sz(1)+10,200+150,'p=0.5',/DEVICE ; COLOR=200,
       ;XYOUTS,100+sz(1)+10,220+150,'e=+0.2',/DEVICE ; COLOR=200,
      ; XYOUTS,100+sz(1)+10,180+150,'e=-0.2',/DEVICE ; COLOR=200,
      ; XYOUTS,100+sz(1)+20,115,'% POLARIZATION',/DEVICE ; COLOR=200,

     ;  XYOUTS,30,115,'UT',/DEVICE,SIZE=1.2;,COLOR=200
      ; XYOUTS,30,95,'ERAD',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,95,eradarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
      ; XYOUTS,30,75,'MLT',/DEVICE,SIZE=1.2;,COLOR=200
      ; FOR i=0,8 DO XYOUTS,xvaltick(i)+100,75,mltarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5; COLOR=200,
      ; XYOUTS,30,55,'LSH',/DEVICE,SIZE=1.2;,COLOR=200
     ;  FOR i=0,8 DO XYOUTS,xvaltick(i)+100,55,lsharr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,
     ;  XYOUTS,30,35,'MLAT',/DEVICE,SIZE=1.2;,COLOR=200
     ;  FOR i=0,8 DO XYOUTS,xvaltick(i)+100,35,mlatarr(i),/DEVICE,SIZE=1.2,ALIGN=0.5 ; COLOR=200,

  ;   END
      ELSE:PRINT,'Nothing to be displayed'

     ENDCASE
       test=' '& READ,test,PROMPT='Enter C to continue or E to exit:'
       ENDREP UNTIL STRUPCASE(test) EQ 'E'
        tvarrx=0 &  tvarry=0 & tvarrz=0 & tvarrxy=0 & tvarrellip=0
                   REPEAT BEGIN
t1=' '
READ,t1,PROMPT='Enter Initial Time for 2 min Power Plot ,FORMAT: hh:mm :'
 t1=STRCOMPRESS(t1,/REMOVE_ALL)
t1hour1=STRMID(t1,0,2) & t1min1=STRMID(t1,3,2)
 hourt1=FIX(t1hour1) & mint1=FIX(t1min1)
  Itime1=hourt1*60 + mint1

;  m11=I1*240 -1  & m12=m11+480
;  mint2= mint1+2
;strt2=STRCOMPRESS(STRING(mint2/60)+':'+ STRING(mint2 MOD 60),/REMOVE_ALL)
;IF STRLEN(strt2) LT 5 then  strt2=STRMID(strt2,0,3)+'0'+STRMID(strt2,3,1)
stra='CRRES Orbit '+orbit+ str(4) +', '+ '  from '+t1
  i=( Itime1 -time1)*3-1 &print,itime1,time1,i
 xxpow=REFORM((varrx(i,*)+varrx(i+1,*)+varrx(i+2,*)+varrx(i+3,*)+varrx(i+4,*)+varrx(i+5,*))/6)
yypow=REFORM((varry(i,*)+varry(i+1,*)+varry(i+2,*)+varry(i+3,*)+varry(i+4,*)+varry(i+5,*))/6)
zzpow=REFORM((varrz(i,*)+varrz(i+1,*)+varrz(i+2,*)+varrz(i+3,*)+varrz(i+4,*)+varrz(i+5,*))/6)
ttpow=REFORM((varrt(i,*)+varrt(i+1,*)+varrt(i+2,*)+varrt(i+3,*)+varrt(i+4,*)+varrt(i+5,*))/6)
xypow=REFORM((varrxy(i,*)+varrxy(i+1,*)+varrxy(i+2,*)+varrxy(i+3,*)+varrxy(i+4,*)+varrxy(i+5,*))/6)
	beta=0.5*ASIN(2*IMAGINARY(xypow)/SQRT((xxpow-yypow)^2+4*ABS(xypow)^2)) ;& powxy=0
	; beta=0.5*ASIN(2*IMAGINARY(tvarrxy)/tvtrans) ;& powxy=0
   ellip=TAN(beta) & beta=0
;n=120 &length=FLOAT(n)
;totpnts=N_ELEMENTS(cx)
     pol=SQRT((xxpow-yypow)^2+4*ABS(xypow)^2)/ttpow
      ;pol=SQRT((tvarrx-tvarry)^2+4*ABS(tvarrxy)^2)/tvtrans
;n=LONG(totpnts/2)*2/4 & length=FLOAT(n)
;PRINT,'FFT length:',n

;norfact=0.125*length
;totpntstr=STRCOMPRESS(STRING(totpnts))+'   FFT:'+STRCOMPRESS(STRING(n))
;strplot22='!CPOWER SPECTRA  ____ BZ and ..... HTOTAL    Duration : 2 Min ';+'NO. OF PNT. :';+totpntstr
 strplot22='!CPOWER SPECTRA  ____ B(TRANS) and ..... BZ   '
strplot2='!CPOWER SPECTRA  ____ BX and ..... BY     Duration : 2 Min ';+'NO. OF PNT. :'+totpntstr
strplot23='!CELLIPTICITY    Duration : 2 Min ';+'NO. OF PNT. :'+totpntstr
;strplot24='!CAZIMUTH ANGLE   ';'NO. OF PNT. :'+totpntstr
strplot25='!C% POLARIZATION    Duration : 2 Min ';+'NO. OF PNT. :'+totpntstr
;strplot26='!CCOHERENCY   '+'NO. OF PNT. :'+totpntstr
 freedom='  DEG. OF FREEDOM:8  '
strplot3='!C FAC Coordinate    Sampling Frequency: 4 Hz  ';+freedom +subtitle


 ;   PRINT,POWTRANS(0:5)

 ;  PRINT,'Azimuth Values', theta(0:9)



xtitle='FREQUENCY (HZ)'
ytitle='LOG POWER'
ytitle1='ELLIPTICITY'
;strplot4= '!CEllipticity versus Frequency PLOT'
;strplot6= '!C% POLARISATION versus Frequency PLOT'
 axisx=FINDGEN(N_ELEMENTS(xxpow)+1)*2.0/N_ELEMENTS(xxpow)

  yyarr=['-4','-3','-2','-1','0','1','2']
 nn=N_ELEMENTS(xxpow)
xxpow(0:nn/30)=0.003&yypow(0:nn/30)=0.003 &zzpow(0:nn/30)=0.003
ttpow(0:nn/30)=0.003 & ellip(0:nn/30)=0.00 & pol(0:nn/30)=0.5


        WINDOW,15,XSIZE=900,YSIZE=750

 PLOT, axisx,xxpow,TITLE=stra+strplot2+strplot3,/YLOG,yTICKNAME=yyarr,$
  YTITLE=ytitle,XTICKS=10,YRANGE=[0.0001,100.0],YTICKS=6,$
  XMINOR=2,TICKLEN=-0.03,LINE=0,POSITION=[0.2,0.6,0.8,0.85],/noerase ;COLOR=200 ;,THICK=2; ,COLOR=200
  OPLOT, axisx,yypow,LINE=1;;,/noerase ;COLOR=200;,THICK=2;,COLOR=130

; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime
;Zfile=' '& READ,xyfile,PROMPT='Enter filename for Z,HTOTAL component Plot,.PS extension:'
   ; DEVICE,FILENAME=xyfile

      ;WINDOW,2,XSIZE=750,YSIZE=600
 PLOT, axisx,zzpow,TITLE=stra+strplot22+strplot3,/YLOG,yTICKNAME=yyarr,$
  XTITLE=xtitle,YTITLE=ytitle,XTICKS=10,YRANGE=[0.0001,100.0],YTICKS=6,$
  XMINOR=2,TICKLEN=-0.03,LINE=1 ,THICK=1,POSITION=[0.2,0.15,0.8,0.40],/noerase ;COLOR=200; ,COLOR=200
   OPLOT, axisx,ttpow,LINE=0
        delaytime=0.
 READ,delaytime,PROMPT='Enter waiting time,floating number:'
 WAIT,delaytime
  ;DEVICE,/CLOSE
  ;SET_PLOT,mydevice
     WINDOW,16,  XSIZE=900,YSIZE=750

 PLOT, axisx,ellip, TITLE=stra+strplot23+strplot3, YSTYLE=1,YTICKS=10,$
  YTITLE=ytitle1,XTICKS=10,YRANGE=[-1.0,1.0],$
  XMINOR=2,TICKLEN=-0.03,LINE=0 ,THICK=1,POSITION=[0.2,0.6,0.8,0.85],/noerase; ,COLOR=200
    ; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime
  ;DEVICE,/CLOSE
  ;SET_PLOT,mydevice

  ;  WINDOW,5,XSIZE=750,YSIZE=600
 PLOT, axisx,pol, TITLE=stra+strplot25+strplot3, YSTYLE=1,YTICKS=10,$
  XTITLE=xtitle,YTITLE='%POLARIZATION',XTICKS=10,YRANGE=[0.0,1.0],$
  XMINOR=2,TICKLEN=-0.03,LINE=0 ,THICK=1,POSITION=[0.2,0.15,0.8,0.40],/noerase; ,POSITION=[0.2,0.2,0.8,0.45],/noerase ; ,COLOR=200
        ;      delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime
; HELP,XXOUT
; ii=( Itime1 -time1)*240L-1
;    xbX=xxout(ii:ii+480) &  ybY=yyout(ii:ii+480) & transb=SQRT(xbX^2+ybY^2)
 ;   xaxis1=FINDGEN(481)
; strplotb='!C Magnetic field versus time Plot '+'!CDuration : 2 Min  FAC Coordinate  Sampling Frequency=4Hz

  ;  WINDOW,17,XSIZE=900,YSIZE=750
; PLOT,xaxis1,xbX,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
;  YRANGE=[MIN(xbX),MAX(xbX)],YTITLE='BX in nT',XTICKS=8,$
;  XMINOR=5,TICKLEN=-0.04,POSITION=[0.2,0.1,0.8,0.3],/noerase ;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,2,XSIZE=750,YSIZE=600
; PLOT,xaxis1,ybY,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
;  YRANGE=[MIN(ybY),MAX(ybY)],YTITLE='BY in nT',XTICKS=8,$
;  XMINOR=5,TICKLEN=-0.04,POSITION=[0.2,0.4,0.8,0.6],/noerase ;COLOR=200
; delaytime=0.
; READ,delaytime,PROMPT='Enter waiting time,floating number:'
; WAIT,delaytime

;WINDOW,3,XSIZE=750,YSIZE=600
; PLOT,xaxis1,transb,TITLE=stra+strplotb,XSTYLE=1,YSTYLE=1,XRANGE=[MIN(xaxis1),MAX(xaxis1)],$
;  YRANGE=[MIN(TRANSb),MAX(TRANSb)],YTITLE='Btrans in nT',XTICKS=8,$
;  XMINOR=5,TICKLEN=-0.04 ,POSITION=[0.2,0.7,0.8,0.9],/noerase;COLOR=200

   check=' ' & READ,check,PROMPT='Do you want to finish Repeat Loop, Y or N:'
 ENDREP UNTIL STRUPCASE(check) EQ 'Y'
 varrx=0 & varry=0& varrz=0  & varrxy=0 & varrt=0
       ;  oxiarr=FLTARR(1,numbloc)
 ;   oxiarr=oxifre
   ;    oxifilename=' '
;READ,oxifilename,PROMPT='Enter OXIGEN CYCLOTRON FREQUENCY filename:'

;OPENW,outunit,oxifilename, /GET_LUN
;PRINTF,outunit,oxiarr
;FREE_LUN,outunit
          utarr=0 &  eradarr=0 &  mltarr=0 & lsharr=0 & mlatarr=0 & frearr=0
       xaxis1=0&  xaxis2=0 & oxifre=0 &xaxis=0&yvaltick=0 & xvaltick=0
       yname=0&barnum=0 &barstr=0 & strbar=0 & arrbar=0 &sz=0
       tvarrx=0 &  tvarry=0 & tvarrz=0 & tvarrxy=0 & tvarrellip=0
       PRINT,'Programme terminated, goodbye'
     END
