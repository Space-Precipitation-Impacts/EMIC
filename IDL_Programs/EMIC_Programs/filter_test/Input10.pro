;TITLE: Input9.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: The program inputs the extracted raw CRRES data from the Sun computer
;and computes the Poynting vector as well as PHETA_SB.
;
;MODIFICATIONS:
;
Pro Filtr1,XDat,YDat,wc,CutFreq,FiltType,LenX
 pi=3.1415926535898
 Print,'In 1st Order Filter...'
 Wait,0.5
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
 Print,'In 2nd Order Filter...'
 Wait,0.5
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
 print,wc
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
 wc=float(2.0*Tan(CutFreq*pi))
 print,wc
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
;
FUNCTION Alpha,B_x,B_y,B_z
    alph = Atan(sqrt(B_y*B_y+B_z*B_z)/abs(B_x))
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
 piI = 3.1415926
 u = 4*PiI*1E-7
    S_z = (1.0/u)*(E_x*B_y - B_x*E_y)
 return,S_z
END

FUNCTION Poyntx,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926
 u = 4*PiI*1E-7
    S_x = (1.0/u)*(E_y*B_z - B_y*E_z)
 return,S_x
END

FUNCTION Poynty,E_x,E_y,E_z,B_x,B_y,B_z
 piI = 3.1415926
 u = 4*PiI*1E-7
     S_y = (1.0/u)*(E_z*B_x - B_z*E_x)
 return,S_y
END

Pro input10                             ;Start of main body
pI=3.1415926535898
count_rows =long(13)                   ;Declare count variable for total number of rows
;countE12=long(0)                       ;Declare count variables for data
countE12=long(0)                       ;
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
print,'DATA FOR ',header[0]
print,'Reading number of data points'  ;End loop
print,'PLEASE BE PATIENT.............'
While (NOT EOF(units)) DO $            ;Loop to count total data rows and
 BEGIN                                 ;data component rows in file.
  readf,units,text                     ;Reads data
  index = fix(strmid(text(0),10,2))    ;Search for data component index
                                       ;If index found then add to data counter
  If index eq Indx[0] then countE12=countE12+long(1) ;Ey(V/m) counter
  If index eq Indx[1] then countE34=countE34+long(1) ;Ez(V/m) counter
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
print,'Number of rows in File:',count_rows
print,'Number of Data Points Ey:',countE12
print,'Number of Data Points Ez:',countE34
print,'Number of Data Points Bx(filtered):',countBx
print,'Number of Data Points By(filtered):',countBy
print,'Number of Data Points Bz(filtered):',countBz
print,'Number of Data Points Bx(unfiltered):',countBxx
print,'Number of Data Points By(unfiltered):',countByy
print,'Number of Data Points Bz(unfiltered):',countBzz
;
;                                       ;Declaring data handling arrays
Ey = fltarr(countE12)                   ;
Ez = fltarr(countE34)                   ;
Bx = fltarr(countBx)                    ;
By = fltarr(countBy)                    ;
Bz = fltarr(countBz)                    ;
Bxx = fltarr(countBxx)                  ;
Byy = fltarr(countByy)                  ;
Bzz = fltarr(countBzz)                  ;
                                        ;Declare data time handling arrays
Eytime = LonArr(countE12)               ;
Eztime = LonArr(countE34)               ;
Bxtime = LonArr(countBx)                ;
Bytime = LonArr(countBy)                ;
Bztime = LonArr(countBz)                ;
Bxxtime = LonArr(countBxx)              ;
Byytime = LonArr(countByy)              ;
Bzztime = LonArr(countBzz)              ;
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
 if index EQ Indx[0] then $             ;If index found loop input data to data arrays
 begin

  Ey[count0] = data*1E-3
  Eytime[count0] = dattme
  count0=count0+long(1)
 endif
 if index EQ Indx[1] then $
 begin
  Ez[count1] = data*1E-3
  Eztime[count1] = dattme
  count1=count1+long(1)
 endif
 if index EQ Indx[2] then $
 begin
  Bx[count2] = data*1E-9
  Bxtime[count2] = dattme
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
  Bztime[count4] = dattme
  count4=count4+long(1)
 endif
 if index EQ Indx[5] then $
 begin                                  ;
  Bxx[count5] = data*1E-9
  Bxxtime[count5] = dattme
  count5=count5+long(1)
 endif
 if index EQ Indx[6] then $
 begin
  Byy[count6] = data*1E-9
  Byytime[count6] = dattme
  count6=count6+long(1)
 endif
 if index EQ Indx[7] then $
 begin
  Bzz[count7] = data*1E-9
  Bzztime[count7] = dattme
  count7=count7+long(1)
 endif
 k = k + long(1)
 If(k EQ 1000) then print,'PLEASE BE PATIENT THIS MAY TAKE A WHILE'
 If (k EQ 5000) then print,'Programme in progress........'
 If (k EQ 10000) then print,'Checking progress...........'
 If (k mod 30000) eq 0 then print,'running smoothly after:',k,' data points'
endwhile                                 ;End loop
Free_Lun,unit                            ;Destroy file unit

;
;Data resampling
;                                         ;Determine initial sampling frequency
Esample = abs(Eytime[1] - Eytime[0])     ;E field sampling time
Esfreq = round(1000.0/Esample)           ;E field sampling frequency
Bsample = abs(Bxtime[1] - Bxtime[0])     ;B field sampling time
Bsfreq = round(1000.0/Bsample)           ;B field sampling frequency
ENyfreq = Round(Esfreq/2.0)
BNyfreq = Round(Bsfreq/2.0)

print,' '
print,'The B field data has an unwanted phase shift at frequencies above 0.5Hz'
print,'and must be removed prior to Poynting vector processing. Reverse 2nd'
print,'order Butterworth digital filter with cutoff frequency of 6.0Hz will'
print,'remove phase shift.'
Set_plot,'WIN'
!P.MULTI = [0, 1, 2]
Window,0, Xsize=600,Ysize=400,title='B wave field before and after reverse low pass filtering'
Print,'Plotting B wave field  data.......'
wait,0.5
plot,Byytime,Bxx,title='Bx (wave field) before reverse filtering',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
FiltType=2
Order=2
Cut=float(6.0/Bsfreq)
dum=fltarr(countBy)
dumm = fltarr(countBxx)
dummy = fltarr(countE12)
Theta=fltArr(6)
Print,'Reversing data before lowpass filtering.........'
wait,1.0
Reverse,Bx,dum,countBx
Reverse,By,dum,countBy
Reverse,Bz,dum,countBz
Reverse,Bxx,dumm,countBxx
Reverse,Byy,dumm,countByy
Reverse,Bzz,dumm,countBzz
Print,'Lowpass filtering B field data...........'
wait,1.0
FiltCtrl2,Bx,dum,wc,Order,FiltType,Cut,countBx,theta
FiltCtrl2,By,dum,wc,Order,FiltType,Cut,countBy,theta
FiltCtrl2,Bz,dum,wc,Order,FiltType,Cut,countBz,theta
FiltCtrl2,Bxx,dumm,wc,Order,FiltType,Cut,countBxx,theta
FiltCtrl2,Byy,dumm,wc,Order,FiltType,Cut,countByy,theta
FiltCtrl2,Bzz,dumm,wc,Order,FiltType,Cut,countBzz,theta
Print,'Reversing data after lowpass filtering.........'
wait,1.0
Reverse,Bx,dum,countBx
Reverse,By,dum,countBy
Reverse,Bz,dum,countBz
Reverse,Bxx,dumm,countBxx
Reverse,Byy,dumm,countByy
Reverse,Bzz,dumm,countBzz
Print,'Plotting filtered B field  data.......'
wait,0.5
plot,Byytime,Bxx,title='Bx (wave field) after reverse filtering',XStyle=1,Xticks =4,XTickFormat='XTLab',xtitle ='Time (UT)'
stop
print,''
wait,1.5
print,'E field sampling frequency is',Esfreq,'Hz and Nyquist is',ENyfreq,'Hz.'
print,'B field sampling frequency is',Bsfreq,'Hz and Nyquist is',BNyfreq,'Hz.'
Print,'The data Sampling Interval is : ',double(1.0/Bsfreq)
Print,'If you intend to resample the input data to the Nyquist',Bnyfreq,'Hz then it is'
Print,'advisable to first low pass filter the data below',fix(Bnyfreq/2.0),'Hz.'

Print,'Would you like to lowpass filter the data to the Nyquist( yes=1, no=2)?:'
;Read,ans
ans = 1
if (ans EQ 1) then $
 begin
 Theta=fltArr(6)
  Print,'Enter the LOW Frequency cut off (Hz). It should be below',fix(Bnyfreq/2.0),'Hz: '
  Read,cutfreq
  Cut=float(CutFreq/Bsfreq)
  FiltType = 2
  Print,'About to lowpass filter all data at',cutfreq,'Hz'
  wait,1.0
  Print,'LOW Pass Filtering Ey and Ez wave field Data...'
  Wait,0.5
  Order = 2
  FiltCtrl,Ey,dummy,wc,Order,FiltType,Cut,countE12,theta
  FiltCtrl,Ez,dummy,wc,Order,FiltType,Cut,countE34,theta
  !P.Multi = [0,1,2]
  window,1,xsize=800,ysize=500, title ='E wave fields low pass filtered'
  plot,Eytime,By,title='Ey (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  plot,Eztime,Bz,title='Ez (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT
  Print,'LOW Pass Filtering Bx, By and Bz wave field Data...'
  Wait,0.5
  Order = 2
  FiltCtrl,Bx,dum,wc,Order,FiltType,Cut,countBx,theta
  FiltCtrl,By,dum,wc,Order,FiltType,Cut,countBy,theta
  FiltCtrl,Bz,dum,wc,Order,FiltType,Cut,countBz,theta
  !P.MULTI = [0,1,3]
  ;window,2,xsize=800,ysize=500, title='B wave field after low pass filtering'
  ;plot,Bxtime,Bx,title='Bx (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  ;plot,Bytime,By,title='By (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  ;plot,Bztime,Bz,title='Bz (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT
  Print,'LOW Pass Filtering Bx, By and Bz wave plus background field Data...'
  Wait,0.5
  Order = 2
  FiltCtrl,Bxx,dumm,wc,Order,FiltType,CutFreq,countBxx,theta
  FiltCtrl,Byy,dumm,wc,Order,FiltType,CutFreq,countByy,theta
  FiltCtrl,Bzz,dumm,wc,Order,FiltType,CutFreq,countBzz,theta
  ;window,0,xsize=800,ysize=500, title='B background plus perturbed after lowpass filtering'
  ;plot,Bxxtime,Bxx,title='Bx (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  ;plot,Byytime,Byy,title='By (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  ;plot,Bzztime,Bzz,title='Bz (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  ;
  ;
  Print,'Resampling data to reduce array size by half. This should reduce demand that Poynting
  Print,'vector calculations puts on CPU time.'
  wait,1.0
  array = long(0)
  If(countE12 LE countBx) then $
    begin
     If(countE12 LE countBxx) then $
       begin
         array = fix(countE12/2.0)
     endif else $
       begin
         array = fix(countBxx/2.0)
     endelse
  endif else $
    begin
     If countBx LE countBxx then $
       begin
          array = fix(countBx/2.0)
     endif else $
       begin
          array = fix(countBxx/2.0)
     endelse
  endelse

  Ey = Congrid(Ey,array)
  Ez = Congrid(Ez,array)
  Etime = Congrid(Eytime,array)
  Bx = Congrid(Bx,array)
  By = Congrid(By,array)
  Bz = Congrid(Bz,array)
  dBtime = Congrid(Bxtime,array)
  Bxx = Congrid(Bxx,array)
  Btime = Congrid(Byytime,array)
  Byy = Congrid(Byy,array)
  Bzz = Congrid(Bzz,array)
  window,0,xsize=800,ysize=600, title='B wave field after low pass filtering and resampling'
  plot,dBtime,By,title='Bx (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  plot,Btime,Byy,title='By (main field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
  plot,Etime,Ez,title='Ez (wave field)',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT
  endif
  stop
  if( ans EQ 2) then $
    begin
      Print,'Recommend no resampling due to possible aliasing above Nyquist'
      wait,0.5
      array = countE34
  endif
  print,array

print,''
print,'Now determining the alpha angle between B field and spin axis.'
print,'This angle is used to determine whether Ex calculation is valid.'
print,'If alpha is greater then 70degrees Ex calculation is invalid and defaulted to zero.'
alpha_angle = fltarr(array)            ;Initialize alpha angle handling array.


n=long(0)
for m=0,array -1 do $                  ;Note: all perturb B fields have same array size so
 begin                                   ;using any of the data point counters will do.
   If(Bx[m] EQ 0.0) then $               ;Default to in case a division by zero ocurrs.
     begin
      alpha_angle[m] = 0.0               ;Default angle is zero.
      print,'The dBx component is',Bx[m],'nT',$
      'thus angle between B field and spin axis defaults to',alpha_angle[m],'degrees'
   endif else $                          ;Calling procedure for alpha function.
     begin
      alpha_angle[m] = alpha(Bx[m],By[m],Bz[m])  ;Calling alpha function.
      If alpha_angle[m] LE 70.0/180.0*pI then $
        begin
                 n = n + long(1)
       endif
   endelse
endfor
m = long(0)
nn = long(n)
;long(9504)
Ex = fltarr(nn)
Eys = fltArr(nn)
Eyt = fltArr(nn)
Ezs = fltArr(nn)
;Ezt = fltArr(nn)
Bxs =fltarr(nn)
Bxt = fltarr(nn)
Bys =fltarr(nn)
;Byt = fltarr(nn)
Bzs =fltarr(nn)
;Bzt = fltarr(nn)
Bxxs =fltarr(nn)
Bxxt = fltarr(nn)
Byys =fltarr(nn)
;Byyt = fltarr(nn)
Bzzs =fltarr(nn)
;Bzzt = fltarr(nn)
Sz = fltarr(nn)
Sx = fltarr(nn)
Sy = fltarr(nn)
S = fltarr(nn)
B = fltarr(nn)
nnn = Long(0)
for mm=0,array -1 do $  ;Begin loop to determine alpha angle.
 begin
  If(Bx[mm] EQ 0.0) then $               ;Default to in case a division by zero ocurrs.
    begin
     alpha_angle[mm] = 0.0               ;Default angle is zero.
     print,'The dBx component is',Bx[mm],'nT',$
     'thus angle between B field and spin axis defaults to',alpha_angle[m],'degrees'
     endif else $                          ;Calling procedure for alpha function.
     begin
      alpha_angle[mm] = alpha(Bx[mm],By[mm],Bz[mm])  ;Calling alpha function.

      If alpha_angle[mm] LE 70.0/180.0*pI then $
        begin
         Eys[nnn] = Ey[mm]
         Et[nnn] = Etime[mm]
         Ezs[nnn] = Ez[mm]
         ;Ezt[nnn] = Eztime[mm]
         Bxs[nnn] = Bx[mm]
         dBt[nnn] = dBtime[mm]
         Bys[nnn] = By[mm]
         ;Byt[nnn] = Bytime[mm]
         Bzs[nnn] = Bz[mm]
         ;Bzt[nnn] = Bztime[mm]
        Bxxs[nnn] = Bxx[mm]
        Bt[nnn] = Btime[mm]
        Byys[nnn] = Byy[mm]
        ;Byyt[nnn] = Byytime[mm]
        Bzzs[nnn] = Bzz[mm]
        ;Bzzt[nnn] = Bzztime[mm]
        Ex[nnn] = E_x(Eys[nnn],Ezs[nnn],Bxs[nnn],Bys[nnn],Bzs[nnn])
        Sz[nnn] = Poyntz(Ex[nnn],Eys[nnn],Ezs[nnn],Bxs[nnn],Bys[nnn],Bzs[nnn])
        Sx[nnn] = Poyntx(Ex[nnn],Eys[nnn],Ezs[nnn],Bxs[nnn],Bys[nnn],Bzs[nnn])
        Sy[nnn] = Poynty(Ex[nnn],Eys[nnn],Ezs[nnn],Bxs[nnn],Bys[nnn],Bzs[nnn])
        ;S[n] = sqrt(Sx[n]^2.0+Sy[n]^2.0+Sz[n]^2.0)
        ;B[n] =sqrt(Bxs[n]^2.0+Bys[n]^2.0+Bzs[n]^2.0)
         nnn = nnn + long(1)
       endif
    endelse
endfor
COEFFx = POLY_FIT(Bt,Bxxs,1)
COEFFy = POLY_FIT(Bt,Byys,1)
COEFFz = POLY_FIT(Bt,Bzzs,1)
BXMAIN = POLY(Bt,COEFFx)
BYMAIN = POLY(Bt,COEFFy)
BZMAIN = POLY(Bt,COEFFz)
dBx = Bxxs - Bxmain
dBy = Byys - Bymain
dBz = Bzzs - Bzmain
stop
;
;Rotation routine
;
theta = fltarr(nn)
phi = fltarr(nn)
theta = atan(sqrt(BXmain*Bxmain+Bymain*Bymain)/abs(Bzmain))
for q=0,nn-1 do $
; begin
;  if (BXMAIN[q] LT 0.0) then theta[q] = -theta[q]
  phi[q] = atan(abs(BYMAIN[q]/BXMAIN[q]))
;  if(BYMAIN[q] LT 0.0) AND (BXMAIN[q] LT 0.0) then phi[q] = phi[q] + pI
;  if(BYMAIN[q] LT 0.0) AND (BXMAIN[q] GE 0.0) then phi[q] = -phi[q]
;   if(BYMAIN[q] GE 0.0) AND (BXMAIN[q] LT 0.0) then phi[q] = pI - phi[q]
;endfor
;
;Rotation about z through phi to x1y1z1
;
BZmain1 = BZmain
SZ1 = SZ
Ez1 = Ezs
Bz1 = Bzs
BYmain1 = BYmain*cos(phi)-BXmain*sin(phi)
BXmain1 = BXmain*cos(phi)+BYmain*sin(phi)
By1 = Bys*cos(phi)-Bxs*sin(phi)
Bx1 = Bxs*cos(phi)+Bys*sin(phi)
Ey1 = Eys*cos(phi) - Ex*sin(phi)
Ex1 = Ex*cos(phi)+Eys*sin(phi)
Sx1 = Sx*cos(phi)+Sy*sin(phi)
Sy1 = Sy*cos(phi)-Sx*sin(phi)


;
;Rotation about Y1 through theta to X2Y2Z2
;
BYmain2 = BYmain1
Ey2 = Ey1
Sy2 = Sy1
By2 = By1
BZmain2 = BZmain1*cos(theta)-BXmain1*sin(theta)
BXmain2 = BXmain1*cos(theta)+BZmain1*sin(theta)
Bz2 = Bz1*cos(theta)-Bx1*sin(theta)
Bx2 = Bx1*cos(theta)+Bz1*sin(theta)
Ez2 = Ez1*cos(theta)-Ex1*sin(theta)
Ex2 = Ex1*cos(theta)+Ez1*sin(theta)
Sx2 = Sx1*cos(theta)+Sz1*sin(theta)
Sz2 = Sz1*cos(theta)-Sx1*sin(theta)
arr = fltarr(nn)
;arr =0.0
theta = fltarr(6)
Order = 2
FiltType = 2
Cut = 0.5
;FiltCtrl,Sx2,arr,wc,Order,FiltType,cut,n,theta
;FiltCtrl,Sy2,arr,wc,Order,FiltType,cut,n,theta
;FiltCtrl,Sz2,arr,wc,Order,FiltType,cut,n,theta
S = sqrt(Sx2^2.0+Sy2^2.0+Sz2^2.0)
;FiltCtrl,S,arr,wc,Order,FiltType,cut,n,theta
angleSSz = acos(Sz2/S)
;
;Rotation about z2 through -phi to X3Y3Z3
;
;BZMAIN3 = BZmain2
;Sz3 =Sz2
;Ez3 = Ez2
;Bz3 =Bz2
;BYmain3 = BYmain2*cos(-phi)-BXmain2*sin(-phi)
;BXmain3 = BXmain2*cos(-phi)+BYmain2*sin(-phi)
;By3 = By2*cos(-phi)-Bx2*sin(-phi)
;Bx3 = Bx2*cos(-phi)+By2*sin(-phi)
;Ey3 = Ey2*cos(phi) - Ex2*sin(-phi)
;Ex3 = Ex2*cos(phi)+Ey2*sin(-phi)
;Sx3 = Sx2*cos(phi)+Sy2*sin(-phi)
;Sy3 = Sy2*cos(phi)-Sx2*sin(-phi)
;
;Calculating angle between S and Sz
;
angleSB =fltarr(nn)
for t=0,nn-1 do $
 begin
 angleSB[t] = ThetaSB(Sx2[t],Sy2[t],Sz2[t])
endfor

!P.MULTI = [0, 1, 3]                     ;
;set_plot,'WIN'
window,0,xsize=700,ysize=500
plot,Bxxt,Sz2,title='Sz',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,Bxxt,angleSsz/Pi*180,title='angleSB',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
plot,Bxxt,S,title='S',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
stop
;plot,Byyt[2000:8000],Byys[2000:8000],title='Byy',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,Byyt[2000:8000],Bymain[2000:8000],title='Bymain',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'

;plot,Byyt[2000:8000],phi[2000:8000],title='phi',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,Eyt[2000:8000],Ex[2000:8000],title='Ex',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;plot,Byyt[2000:8000],Sz[2000:8000],title='Sz',XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)'
;print,n
stop
;!P.MULTI = [0, 1, 3]                     ;
;set_plot,'WIN'
window,0,xsize=700,ysize=500
plot,Eyt,Eys,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
ytitle='Ey(filtered/mV/m)';,XRange=[Min(Eytime),Max(Eytime)]
plot,Eyt,Ex,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
ytitle='Ex(filtered/mV/m)',YRange=[-10,10]
plot,Bxtime,Bx,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
ytitle='Bx(unfiltered/nT)';,XRange=[Min(Eytime),Max(Eytime)]
print,'Finished'
end