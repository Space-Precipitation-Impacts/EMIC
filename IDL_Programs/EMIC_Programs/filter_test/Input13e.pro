;TITLE: Input13.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: The program inputs the extracted raw CRRES data from the Sun computer
;and computes the Poynting vector as well as PHETA_SB. Takes two input files:
;First data file: Contains raw B field data in MGSE coordinates. The B fields are
;Bx, By, and Bz wave fields all high pass filtered, and Bx, By, and Bz main field
;plus wave field. The files are of the form orb*a.val ( where * indicates orbit
;number).
;Second data file: Contains Ey, and Ez wave field data with time tags aligned with
;Bx wave field time tag.
;
;MODIFICATIONS:
;
Pro Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 pi=3.1415926535898
 ;Print,'In 1st Order Filter...'
 ;Wait,0.5
 a=float((wc-2)/(wc+2))
 c=float(wc/(wc+2))
 eta=1.0
 If (FiltType eq 1) then Begin
  zeta=float(-cos(2*pi*CutFreq))
  a=float(-(a-zeta)/(1-a*zeta))
  c=c*(1-zeta)/(1-a*zeta)
  eta=-1.0
 end
 YDat(0)=c*XDat(0)
 If (FiltType eq 1) Then YDat(0)=0.0
 i=Long(1)
 For i=Long(1),Long(LenX-1) do $
  YDat(i)=-a*YDat(i-1)+c*(XDat(i)+eta*XDat(i-1))
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
Pro Filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 pi=3.1415926535898
 ;Print,'In 2nd Order Filter...'
 ;Wait,0.5
 ar=float(wc*cos(tmp))  ; Pass Theta(m) as tmp
 ai=float(wc*sin(tmp))
 alp=float(-2*ar)
 bet=float(ar^2+ai^2)
 gamma=bet
; Bilinear Transform
 delt=1.0/(4.0+2.0*alp+bet)
 a=2.0*(bet-4.0)*Delt
 b=(4.0-2.0*alp+bet)*delt
 c=gamma*delt
 eta=2.0
 If (FiltType eq 1) Then Begin
  zeta=float(-cos(2.0*cutfreq*pi))
  V1=float(a-b*Zeta)
  V2=float(V1*Zeta)
  psi=float(1.0/(1.0-V2))
  c=psi*c*(1.0-zeta)^2
  bp=psi*((zeta-a)*zeta+b)
  a=psi*(2.0*zeta*(1.0+b)-a*(1.0+zeta^2))
  b=bp
  eta=-2.0
 end
 YDat(0)=c*XDat(0)
 YDat(1)=-a*YDat(0)+c*(XDat(1)+eta*XDat(0))
 For i=Long(2),Long(LenX-1) do Begin
  V1=float(-A*YDat(i-1)-B*YDat(i-2))
  V2=float(XDat(i)+Eta*XDat(i-1)+XDat(i-2))
  YDat(i)=float(V1+c*V2)
   ;print,Ydat,' ',i
 end
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
;
Pro Reverse,XDat,YDat,LenX
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=XDat(LenX-i-1)
 XDat=YDat
 For i=Long(0),Long(LenX-1) do $
  YDat(i)=0
end
;
;
Pro FiltCtrl2,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=0.0
 wc=float(2.0*Tan(CutFreq*pi))
 ;print,wc
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
end
;
Pro FiltCtrl,XDat,YDat,wc,Order,FiltType,CutFreq,LenX,theta
 pi=3.1415926535898
 wc=0.0
 ;Ydat = 0.0
 wc=float(2.0*Tan(CutFreq*pi))
 ;print,wc
 uneven=0     ; False
 uu=order mod 2
 if (uu eq 1) then uneven=1  ; True
 for i=1,order/2 do $
  theta(i-1)=(order+2*i-1)*pi/(2.0*order)
 for m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
 For m=0,order/2-1 do begin
  tmp=theta(m)
  filtr2,XDat,YDat,wc,CutFreq,tmp,FiltType,LenX
 end
 if (uneven eq 1) then $
  filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 Reverse,XDat,YDat,LenX
end

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
;
FUNCTION Alpha,B_x,B_y,B_z
    if(B_x EQ 0.0) then alph = 0.0 else $
      begin
        alph = Atan(sqrt(B_y*B_y+B_z*B_z)/abs(B_x))
    endelse
    return,alph
END

FUNCTION thetaSB,S_x,S_y,S_z
pI = 3.1415926
if(S_z EQ 0.0) then ThSB = pI/2.0 else $
if(S_z EQ 0.0) AND (S_x EQ 0.0) AND (S_y EQ 0.0) then ThSB = 0.0 else $
begin
 thSB = Atan(sqrt(S_x*S_x+S_y*S_y)/abs(S_z))
endelse
 ;if(ThSB LT 0.0) then THSB =-ThSB + pI/2.0
    return,thSB
END

FUNCTION E_x,E_y,E_z,B_x,B_y,B_z
 if (B_x NE 0.0) then $
   begin
    Exx = -(E_y*B_y + E_z*B_z)/B_x
 endif else $
 begin
    Exx =0.0
 endelse
  return,Exx
END

FUNCTION Poyntz,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
    S_z = (1.0/u)*(E_x*B_y - B_x*E_y)
 return,S_z
END

FUNCTION Poyntx,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
    S_x = (1.0/u)*(E_y*B_z - B_y*E_z)
 return,S_x
END

FUNCTION Poynty,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926535898
 u = 4*PiI*1E-7
     S_y = (1.0/u)*(E_z*B_x - B_z*E_x)
 return,S_y
END

Pro input13e                             ;Start of main body
pI=3.1415926535898
count_rows =long(13)                   ;Declare count variable for total number of rows
countE34=long(0)                       ;
countBx=long(0)                        ;
countBy=long(0)                        ;
countBz=long(0)                        ;
countBxx=long(0)                       ;
countByy=long(0)                       ;
countBzz=long(0)                       ;
Indx = intarr(8)                       ;Declare data component index variable
header = StrArr(14)
for i=0,7 do $                         ;Start loop to define data component index
begin
Indx[i]=i                              ;Change for data component required
endfor
FName=Pickfile(Title='Select Input data file', Filter='*.*')  ;Selecting data file(popup window)
Openr,units,FName,/get_lun             ;Open data file
text = strarr(1)                       ;Declare data input handling variable
print,'Reading header file information........'
For i=0,13 do $                        ;Loop to read header information
begin
readf,units,text                       ;Reads header data as 256 string
header[i] = text                       ;Input Header string data into string array
endfor
WAIT,1.51

print,'B FIELD DATA FOR ',header[0]
WAIT,1.5
print,'Reading number of data points'  ;End loop
WAIT,1.0
print,'PLEASE BE PATIENT.............'
While (NOT EOF(units)) DO $            ;Loop to count total data rows and
 BEGIN                                 ;data component rows in file.
  readf,units,text                     ;Reads data
  index = fix(strmid(text(0),10,2))    ;Search for data component index

  If index eq Indx[2] then countBx=countBx+long(1)   ;Bx(nT) filtered counter
  If index eq Indx[3] then countBy=countBy+long(1)   ;By(nT) filtered counter
  If index eq Indx[4] then countBz=countBz+long(1)   ;Bz(nT) filtered counter
  If index eq Indx[5] then countBxx=countBxx+long(1) ;Bx(nT) unfiltered counter
  If index eq Indx[6] then countByy=countByy+long(1) ;By(nT) unfiltered counter
  If index eq Indx[7] then countBzz=countBzz+long(1) ;Bz(nT) unfiltered counter

  count_rows = count_rows + long(1)      ;Counter for total No. of rows in data
If (count_rows mod 30000) eq 0 then $
begin
   print,count_rows,' data rows counted'
endif
EndWhile                                 ;End counter loop
Free_lun,units
PRINT,'Data points counter complete'
                                         ;Ouput to screen counter info
print,'Total number of points in File:',count_rows
print,'Number of Data Points Bx(High pass filtered):',countBx
print,'Number of Data Points By(High pass filtered):',countBy
print,'Number of Data Points Bz(High pass filtered):',countBz
print,'Number of Data Points Bx(unfiltered):',countBxx
print,'Number of Data Points By(unfiltered):',countByy
print,'Number of Data Points Bz(unfiltered):',countBzz
;                                       ;Declaring data handling arrays
Bx = fltarr(countBx)                    ;
By = fltarr(countBy)                    ;
Bz = fltarr(countBz)                    ;
Bxx = fltarr(countBxx)                  ;
Byy = fltarr(countByy)                  ;
Bzz = fltarr(countBzz)                  ;
                                        ;Declare data time handling arrays
;Bxtime = LonArr(countBx)                ;
Bytime = LonArr(countBy)                ;
;Bztime = LonArr(countBz)                ;
;Bxxtime = LonArr(countBxx)              ;
;Byytime = LonArr(countByy)              ;
;Bzztime = LonArr(countBzz)              ;
k=long(14)                              ;Declare initalized data position index
count0=long(0)                          ;Declare initialized data counters
count1=long(0)
count2=long(0)
count3=long(0)
count4=long(0)
count5=long(0)
count6=long(0)
count7=long(0)
openr,unit,FName,/get_lun               ;Open data file for data input
For i=0,13 do $                         ;Loop to bypass header information
 begin
  readf,unit,text                       ;Read header data and bypass
endfor
print,'Begining to read in data file.........'
 While (k LT count_rows) do $            ;Loop to begin data input
 begin
 readf,unit,text                        ;Read data
 index = fix(strmid(text(0),10,2))      ;Find data component index
 data = float(strmid(text(0),13,30))    ;Find data
 dattme = Long(strmid(text(0),0,10))    ;Find time
  if(data GE 1000) then $
    begin
      print,'data ',data,' at time ',datime,' greater then 1000nT.'
      stop
  endif

 if index EQ Indx[2] then $
 begin
  Bx[count2] = data*1E-9
 ; Bxtime[count2] = dattme
  count2=count2+long(1)
 endif
 if index EQ Indx[3] then $
 begin
  By[count3] = data*1E-9
  Bytime[count3] = dattme
  count3=count3+long(1)
 endif
 if index EQ Indx[4] then $
 begin
  Bz[count4] = data*1E-9
 ; Bztime[count4] = dattme
  count4=count4+long(1)
 endif
 if index EQ Indx[5] then $
 begin                                  ;
  Bxx[count5] = data*1E-9
  ;Bxxtime[count5] = dattme
  count5=count5+long(1)
 endif
 if index EQ Indx[6] then $
 begin
  Byy[count6] = data*1E-9
  ;Byytime[count6] = dattme
  count6=count6+long(1)
 endif
 if index EQ Indx[7] then $
 begin
  Bzz[count7] = data*1E-9
  ;Bzztime[count7] = dattme
  count7=count7+long(1)
 endif
 k = k + long(1)
 If(k EQ 1000) then print,'PLEASE BE PATIENT THIS MAY TAKE A WHILE'
 If (k EQ 5000) then print,'Programme in progress........'
 If (k EQ 10000) then print,'Checking progress...........'
 If (k mod 30000) eq 0 then print,'running smoothly after:',k,' data points'
endwhile                                 ;End loop
Free_Lun,unit
                                         ;Destroy file unit
headers = StrArr(15)
ct = long(0)
k = long(0)
Print,'Selecting E field data file......'
wait,2.0
Print,'Data file not found prompting for data file now:'
wait,1.0
FName=Pickfile(Title='Select E field Input data file', Filter='*.*')  ;Selecting data file(popup window)
Openr,units,FName,/get_lun             ;Open data file
text = strarr(1)                       ;Declare data input handling variable
print,'Reading E field header file information........'
wait,1.0
For i=0,14 do $                        ;Loop to read header information
begin
readf,units,text                       ;Reads header data as 256 string
headers[i] = text                       ;Input Header string data into string array
endfor
print,'E FIELD DATA FOR ',header[0]
wait,1.0
print,'Reading number of data points'  ;End loop
wait,1.0
print,'PLEASE BE PATIENT.............'
While (NOT EOF(units)) DO $            ;Loop to count total data rows and
 BEGIN                                 ;data component rows in file.
  readf,units,text                     ;Reads data
  ct = ct +long(1)
  k= k+ long(1)
  If (k mod 3000) eq 0 then print,'running smoothly after:',k,' data points'
endwhile
Print,'E field data has ',ct,' data points
free_lun,units
openr,unit,FName,/get_lun               ;Open data file for data input
For i=0,14 do $                         ;Loop to bypass header information
 begin
  readf,unit,text                       ;Read header data and bypass
endfor
print,'Begining to read in data file.........'
Ey = fltarr(ct)                   ;
Ez = fltarr(ct)
Et = fltarr(ct)                   ;
c = long(0)
k = long(0)
Print,'E field data has ',ct,' data points
While (NOT EOF(unit)) DO $            ;Loop to count total data rows and
;While (c LE ct) do $
 BEGIN                                 ;data component rows in file.
  readf,unit,text
  dattmes = Long(strmid(text(0),0,10))    ;Find time                     ;Reads data
   data1 = float(strmid(text(0),16,25))
    data2 = float(strmid(text(0),26,35))
     Ey[c] = data1*1E-3
     Ez[c] = data2*1E-3
     Et[c] = dattmes
     c = c + long(1)
     k = k+long(1)
     If (k mod 3000) eq 0 then print,'running smoothly after:',k,' data points'
endwhile
free_lun,unit
!P.Multi = [0,1,2]
set_plot,'WIN'
Window,5, Xsize=400,Ysize=400,title='Comparision of wave fields'
plot,Et,Ey,title='Ey (wave field) data from post_dump',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,Bytime,By,title='By (wave field) data from raw file',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;stop
;
;
;Data resampling
;
;
array = long(0)
;tt = long(countBx)

if(ct LT countBy) then $
  begin
   Bx = Congrid(Bx,ct)
   By = Congrid(By,ct)
   Bz = Congrid(Bz,ct)
   Bxx = Congrid(Bxx,ct)
   Byy = Congrid(Byy,ct)
   Bzz = Congrid(Bzz,ct)
   Print,'B wave field data resampled to E wave field array size',ct
   array = ct
   tt = Et
endif
if(ct GT countBy) then $
  begin
   Bxx = Congrid(Bxx,countBy)
   Byy = Congrid(Byy,countBy)
   Bzz = Congrid(Bzz,countBy)
   tt = Congrid(Et,countBy)
   Ey = Congrid(Ey,countBy)
   Ez = Congrid(Ez,countBy)

   Print,'E wave field data resampled to B wave field array size',countBy
   array = countBy
endif else $
  begin
   Print,'B and E wave field data array size are equal.'
   array = ct
   tt    = Et
endelse

Window,4, Xsize=400,Ysize=400,title='Comparision of wave fields'
plot,tt,Ey,title='Ey (wave field) after congrid',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,tt,Byy,title='By (wave field) after congrid',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'


;

;                                         ;Determine initial sampling frequency
sample = abs(tt[1] - tt[0])                   ;E field sampling time
freq = round(1000.0/sample)                 ;E field sampling frequency
Nyf = Round(freq/2.0)


print,' '
print,'The B field data has an unwanted phase shift at frequencies above 0.5Hz'
print,'and must be removed prior to Poynting vector processing. Reverse 2nd'
print,'order Butterworth digital filter with cutoff frequency of 6.0Hz will'
print,'remove phase shift.'
;Set_plot,'WIN'
;!P.MULTI = [0, 1, 2]
Window,0, Xsize=400,Ysize=400,title='B wave field before and after reverse low pass filtering'
Print,'Plotting B wave field  data.......'
wait,0.5
plot,tt,Bx,title='Bx (wave field) before reverse filtering',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
FiltType=2              ;Low pass option
Order=2                 ;2nd order Butterworth
Cut=float(6.0/freq)      ;Cutoff freq 6.0Hz
dum=fltarr(array)       ;For B wave and E wave data
Theta=fltArr(6)         ;dummy variable
Print,'Reversing data before lowpass filtering.........'
wait,1.0
Reverse,Bx,dum,array
Reverse,By,dum,array
Reverse,Bz,dum,array
Reverse,Bxx,dum,array
Reverse,Byy,dum,array
Reverse,Bzz,dum,array
;Reverse,Ey,dum,array
;Reverse,Ez,dum,array
Print,'Lowpass filtering B field data...........'
wait,1.0
FiltCtrl2,Bx,dum,wc,Order,FiltType,Cut,array,theta
FiltCtrl2,By,dum,wc,Order,FiltType,Cut,array,theta
FiltCtrl2,Bz,dum,wc,Order,FiltType,Cut,array,theta
FiltCtrl2,Bxx,dum,wc,Order,FiltType,Cut,array,theta
FiltCtrl2,Byy,dum,wc,Order,FiltType,Cut,array,theta
FiltCtrl2,Bzz,dum,wc,Order,FiltType,Cut,array,theta
;FiltCtrl2,Ey,dum,wc,Order,FiltType,Cut,array,theta
;FiltCtrl2,Ez,dum,wc,Order,FiltType,Cut,array,theta

Print,'Reversing data after lowpass filtering.........'
wait,1.0
Reverse,Bx,dum,array
Reverse,By,dum,array
Reverse,Bz,dum,array
Reverse,Bxx,dum,array
Reverse,Byy,dum,array
Reverse,Bzz,dum,array
;Reverse,Ey,dum,array
;Reverse,Ez,dum,array
Print,'Plotting filtered B field  data.......'
wait,0.5
plot,tt,Bx,title='Bx (wave field) after reverse filtering',XStyle=1,Xticks =4,XTickFormat='XTLab',xtitle ='Time (UT)'

print,''
wait,1.5

print,'E and B field sampling frequency is',freq,'Hz and Nyquist is',Nyf,'Hz.'
Print,'The data Sampling Interval is : ',sample,'seconds'
print,''
print,'Now determining the alpha angle between B field and spin axis.'
print,'This angle is used to determine whether Ex calculation is valid.'
print,'If alpha is greater then 70degrees Ex calculation is invalid and defaulted to zero.'

alpha_angle = fltarr(array)            ;Initialize alpha angle handling array.
n=long(0)
for m=long(0),array -1 do $                  ;Note: all perturb B fields have same array size so
 begin                                   ;using any of the data point counters will do
      alpha_angle[m] = alpha(Bx[m],By[m],Bz[m])  ;Calling alpha function.
     If (alpha_angle[m] EQ 0.0) then $
       print,'The dBx component is zero thus angle between B field and spin axis defaults to zero degrees.'
      If alpha_angle[m] LE 70.0/180.0*pI then $
       n = n + long(1)
endfor
Exn = fltarr(n)
Eyn = fltArr(n)
Ezn = fltArr(n)
Bxn =fltarr(n)
Byn =fltarr(n)
Bzn =fltarr(n)
Bxxn =fltarr(n)
Byyn =fltarr(n)
Bzzn =fltarr(n)
ttn = fltarr(n)
Sx = fltarr(n)
Sy = fltarr(n)
Sz = fltarr(n)
nn = long(0)
for mm=long(0),array -1 do $  ;Begin loop to determine alpha angle.
 begin
    If alpha_angle[mm] LE 70.0/180.0*pI then $
        begin
         Eyn[nn] = Ey[mm]
         Ezn[nn] = Ez[mm]
         Bxn[nn] = Bx[mm]
         Byn[nn] = By[mm]
         Bzn[nn] = Bz[mm]
        Bxxn[nn] = Bxx[mm]
        Byyn[nn] = Byy[mm]
        Bzzn[nn] = Bzz[mm]
        Exn[nn] = E_x(Eyn[nn],Ezn[nn],Bxn[nn],Byn[nn],Bzn[nn])
        Sz[nn] = Poyntz(Exn[nn],Eyn[nn],Ezn[nn],Bxn[nn],Byn[nn],Bzn[nn])
        Sx[nn] = Poyntx(Exn[nn],Eyn[nn],Ezn[nn],Bxn[nn],Byn[nn],Bzn[nn])
        Sy[nn] = Poynty(Exn[nn],Eyn[nn],Ezn[nn],Bxn[nn],Byn[nn],Bzn[nn])
        ttn[nn] = tt[mm]
         nn = nn + long(1)
       endif

endfor
sam=32.0;freq_32
;sam=32.0
print,'Running smoothing function over B+dB to remove dB'
opt=32.0
cuts=opt/(sam/1000.)
print,format='(A32,f9.6,A3)','The cuttoff you have entered is ',1./opt,'Hz'
BXMAINn = smooth(Bxxn,cuts,/EDGE_TRUNCATE)
BYMAINn = smooth(Byyn,cuts,/EDGE_TRUNCATE)
BZMAINn = smooth(Bzzn,cuts,/EDGE_TRUNCATE)

;Removing edge effects
;
ww = nn mod cuts
BXMAIN = BXMAINn[fix(ww/2.):nn-fix(ww/2.)-1]
BYMAIN = BYMAINn[fix(ww/2.):nn-fix(ww/2.)-1]
BZMAIN = BZMAINn[fix(ww/2.):nn-fix(ww/2.)-1]
Bxn = Bxn[fix(ww/2.):nn-fix(ww/2.)-1]
Byn = Byn[fix(ww/2.):nn-fix(ww/2.)-1]
Bzn = Bzn[fix(ww/2.):nn-fix(ww/2.)-1]
Exn = Exn[fix(ww/2.):nn-fix(ww/2.)-1]
Eyn = Eyn[fix(ww/2.):nn-fix(ww/2.)-1]
Ezn = Ezn[fix(ww/2.):nn-fix(ww/2.)-1]
Sx = Sx[fix(ww/2.):nn-fix(ww/2.)-1]
Sy = Sy[fix(ww/2.):nn-fix(ww/2.)-1]
Sz = Sz[fix(ww/2.):nn-fix(ww/2.)-1]

ttn = ttn[fix(ww/2.):nn-fix(ww/2.)-1]
nn = n_elements(BXMAIN)
STOP
;***************************************************************************
;
RotateCrres,Exn,Eyn,Ezn,dBxn,dByn,dBzn,BXMAIN,BYMAIN,BZMAIN,Sx,Sy,Sz
PRINT,'WHAT HAPPENED!!'
STOP
;
;***************************************************************************
;
;
;
angleSB =fltarr(nn)
S = sqrt(Sx^2.0+Sy^2.0+Sz^2.0)
B = sqrt(Bxn^2.0+Byn^2.0+Bzn^2.0)
for i=long(0), nn-1 do $
	begin
	angleSB[i] = atan(sqrt(Sx[i]^2+Sy[i]^2)/abs(Sz[i]))
	if Sz[i] LT float(0.0) then angleSB[i] = Pi - angleSB[i]
endfor
;****************************************************************************


set_plot,'ps'
device, filename="orb115Szb3.ps", yoffset=3, ysize=25
!P.MULTI = [0, 1, 2]                     ;
;window,0,xsize=700,ysize=500
plot,ttn,Sz2*1e+6,title='Sz'+header[0],XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,angleSsz/Pi*180,title='angleSB',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,ttn,Ex2*1e+3,title='Ex',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,ttn,Ey2*1e+3,title='Ey',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,ttn,By2*1e+9,title='By',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,ttn,Bx2*1e+9,title='Bx',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
device,/close
print,'Program stopped......'

stop
Cut =0.0
theta = fltarr(6)
Print,'S vector results would include unwanted signs, would you like to filter out these signals (yes=1, no=2):'
Read,ann
While ( ann EQ 1) do $
 begin
Print,'Would you like to highpass filter the S component vectors ( yes =1, no =2): '
Read, an
If ( an EQ 1) then $
  begin
Print,'Please enter Low frequency for high pass filter :'
Read,Cut
Order = 2
FiltType = 1
Cut = float(Cut/freq)
Print,'High pass filtering data now'
dumm =fltarr(n)
FiltCtrl,Sx2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Sy2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Sz2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ex2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ey2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ez2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Bx2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,By2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Bz2,dumm,wc,Order,FiltType,cut,n,theta
endif
Print,'Would you like to Low pass filter the data(yes=1, no=2): '
Read,anw

 If ( anw EQ 1) then $
   begin
Cut = 0.0
Print,'Please enter High frequency for Low pass filter :'
Read,Cut
Order = 2
FiltType = 2
Cut = float(Cut/freq)
Print,'Low pass filtering data now'
dumm =fltarr(n)
;dum = 0.0
FiltCtrl,Sx2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Sy2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Sz2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ex2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ey2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Ez2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Bx2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,By2,dumm,wc,Order,FiltType,cut,n,theta
FiltCtrl,Bz2,dumm,wc,Order,FiltType,cut,n,theta
endif
wait,1.0
Print,'Calculating S - vector and angle bewteen S and B'
wait,1.0
S = sqrt(Sx2^2.0+Sy2^2.0+Sz2^2.0)
angleSSz = acos(Sz2/S)
anss=0
numss=0
Print,'Would you like to resample phetaSB (y or n ): '
Read,anss
If anss EQ 1 then $
begin
Print,'Please enter dividing factor: '
Read,numss
angleSSz = congrid(angleSSz,fix(n/numss))
ttnn = congrid(ttn,fix(n/numss))
endif

!P.MULTI = [0, 1, 3]                     ;
set_plot,'WIN'
window,0,xsize=700,ysize=500
plot,ttn,Sz2,title='Sz',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttnn,angleSsz/Pi*180,title='angleSB',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,S,title='S',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
Print,'Would you like to re-filter data ( yes=1, no=2):'
Read,ann
endwhile
!P.charsize=1.0
!Y.style=1
set_plot,'ps'
device, filename="c:\Paul\phd\crres\orb115b3a.ps", yoffset=3;, ysize=25
!P.MULTI = [0,1,4]                     ;
plot,ttn,Sz2*1e+6,title=header[0],ytitle='Sz(uW/m!u2!n)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttnn,angleSsz/Pi*180,ytitle='SB(!Uo!n)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,Ex2*1e+3,ytitle='Ex(mV/m)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,Ey2*1e+3,ytitle='Ey(mV/m)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
device,/close
set_plot,'ps'
!P.MULTI = [0,1,3]
device, filename="c:\Paul\phd\crres\orb115b3b.ps", yoffset=3;, ysize=25
plot,ttn,Bx2*1e+9,ytitle='Bx(nT)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,By2*1e+9,ytitle='By(nT)',XStyle=4,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,ttn,Bz2*1e+9,ytitle='Bz(nT)',Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',XStyle=8
device,/close

set_plot,'win'
end