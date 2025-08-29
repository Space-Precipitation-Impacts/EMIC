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



pro inBxyz

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


