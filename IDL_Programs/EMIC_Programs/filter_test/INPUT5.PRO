;TITLE: Input.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: The program inputs the extracted raw CRRES data from the Sun computer
;and computes the Poynting vector as well as PHETA_SB.
;
;MODIFICATIONS:
;
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

FUNCTION E_x,E_y,E_z,B_x,B_y,B_z,Nm
 Exx = fltarr(Nm+1)
 for i = 0,Nm do $
   Exx[i] = -((E_y[i]*B_y[i]/B_x[i]) + (E_z[i]*B_z[i]/B_x[i]))
 return,Exx
END

FUNCTION Pheta,S_x,S_y,S_z,B_z,Nm
 Pheta= fltarr(Nm+1)
 S= fltarr(Nm+1)
 modBz = fltarr(Nm+1)
 for i = 0,Nm do $
   begin
    modBz[i]=abs(B_z[i])
    S[i] = sqrt(S_x[i]^2+S_y[i]^2+S_z[i]^2)
    Pheta[i] = acos((S_z[i]*B_z[i])/(S[i]*modBz[i]))
 endfor
 return,Pheta
end

FUNCTION Poynt,E_x,E_y,E_z,B_x,B_y,B_z
 u = 4*!PI*10^(-7)
 Nm = 50
 S_x = fltarr(Nm+1)
 S_y = fltarr(Nm+1)
 S_z = fltarr(Nm+1)
 for i =0, Nm do $
   begin
    S_x[i] = (1/u)*(E_y[i]*B_z[i] - B_y[i]*E_z[i])
    S_y[i] = (1/u)*(E_z[i]*B_x[i] - B_z[i]*E_x[i])
    S_z[i] = (1/u)*(E_x[i]*B_y[i] - B_x[i]*E_y[i])
 endfor
 return,string(S_x,S_y,S_z, FORMAT ='(3(F20),Q)')
END

Pro input5                              ;Start of main body
count_rows =long(13)                   ;Declare count variable for total number of rows
countE12=long(0)                       ;Declare count variables for data
countE12=long(0)                       ;
countE34=long(0)                       ;
countBx=long(0)                        ;
countBy=long(0)                        ;
countBz=long(0)                        ;
countBxx=long(0)                       ;
countByy=long(0)                       ;
countBzz=long(0)                       ;
FName=Pickfile(Title='Select Input data file', Filter='*.*')  ;Delecting file(popup window)
Openr,units,FName,/get_lun             ;Open data file
text = strarr(1)                       ;Declare data input handling variable
For i=0,13 do readf,units,text         ;Reads header data
Indx = intarr(8)                       ;Declare data component index variable
for i=0,7 do $                         ;Start loop to define data component index
begin
Indx[i]=i                              ;Change for data component required
endfor
print,'Reading file information and number of data points'
print,'PLEASE BE PATIENT'                                 ;End loop
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

  count_rows = count_rows + long(1)    ;Counter for total No. of rows in data
EndWhile                               ;End counter loop
Free_lun,units
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
header = StrArr(14)
openr,unit,FName,/get_lun               ;Open data file for data input
For i=0,13 do $
 begin
  readf,unit,text           ;Read header data
  header[i] = text
endfor
PRINT,'Data counter complete'

print,'DATA FOR ',header[0]
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
print,'Begin reading data file'
k=long(14)                              ;Declare initalized data position index
count0=long(0)                           ;Declare count
count1=long(0)
count2=long(0)
count3=long(0)
count4=long(0)
count5=long(0)
count6=long(0)
count7=long(0)
While (k LT count_rows) do $            ;Loop to begin data input
begin
 readf,unit,text                        ;Read data
 index = fix(strmid(text(0),10,2))      ;Find data component index
 data = float(strmid(text(0),13,30))    ;Find data
 dattme = Long(strmid(text(0),0,10))    ;Find time
 if index EQ Indx[0] then $             ;If index found loop input data to data arrays
 begin
  Ey[count0] = data
  Eytime[count0] = dattme
  count0=count0+long(1)
 endif
 if index EQ Indx[1] then $
 begin
  Ez[count1] = data
  Eztime[count1] = dattme
  count1=count1+long(1)
 endif
 if index EQ Indx[2] then $
 begin
  Bx[count2] = data
  Bxtime[count2] = dattme
  count2=count2+long(1)
 endif
 if index EQ Indx[3] then $
 begin
  By[count3] = data
  Bytime[count3] = dattme
  count3=count3+long(1)
 endif
 if index EQ Indx[4] then $
 begin
  Bz[count4] = data
  Bztime[count4] = dattme
  count4=count4+long(1)
 endif
 if index EQ Indx[5] then $
 begin                                  ;
  Bxx[count5] = data
  Bxxtime[count5] = dattme
  count5=count5+long(1)
 endif
 if index EQ Indx[6] then $
 begin
  Byy[count6] = data
  Byytime[count6] = dattme
  count6=count6+long(1)
 endif
 if index EQ Indx[7] then $
 begin
  Bzz[count7] = data
  Bzztime[count7] = dattme
  count7=count7+long(1)
 endif
 k = k + long(1)
 If (k EQ 10000) then print,'Programme in progress........'
 If (k mod 20000) eq 0 then print,'running smoothly after ',k,' data rows'
endwhile                                 ;End loop
Free_Lun,unit                            ;Destroy file unit
Eyres = fltArr(6999)                     ;Declare arrays to resample at Nyquist of 8Hz
Eytimres =fltArr(6999)
Eytimres[i]=Eytime[2*i]
for i=0,6998 do $
begin
  Eyres[i]=Ey[2*i]
  Eytimres[i]=Eytime[2*i]
endfor
  count0=count0+long(1)
!P.MULTI = [0, 1, 2]                     ;
set_plot,'WIN'
window,0,xsize=700,ysize=500
plot,Eytimres,Eyres,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
ytitle='Bx(filtered/nT)';,XRange=[Min(Eytime),Max(Eytime)]
plot,Eytime,Ey,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)',$
ytitle='Bx(filtered/nT)';,XRange=[Min(Eytime),Max(Eytime)]
print,'Finished'
end