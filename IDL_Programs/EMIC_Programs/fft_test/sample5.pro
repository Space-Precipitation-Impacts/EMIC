;DATE: 10/06/00
;TITLE: sample5.pro
;AUTHOR: Paul Manusiu
;DESRIPTION: Generates pre-post_dump test data.
;Inputs: Header from any pre-post_dump data file (e.g. orb115b.val).
;Outputs: Header, generated data including time tags and index to file ( eg sample5.dat).
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

Pro sample5
header = StrArr(29)                   ;Declaration of file header info variable
;FName=Pickfile(Title='Select Input data file', Filter='*.*')
;Selecting data file(popup window)
;Openr,unit,FName,/get_lun             ;Open data file
Openr,unit,'sample.dat',/get_lun             ;Open data file
text = strarr(1)                       ;Declare data input handling variable
print,'Reading header file information........'
For i=0,13 do $                        ;Loop to read header information
begin
readf,unit,text                       ;Reads header data as 256 string
header[i] = text                       ;Input Header string data into string array
endfor
For i=0,13 do $                        ;Loop to read header information
begin
print,header[i]                        ;Input Header string data into string array
endfor

;print,header
free_lun,unit                         ;Input file closed.
pi=3.14
ct=1000
index=INDGEN(8)
indx=[7,6,5,4,3,2,1,0]
data_32 = fltarr(ct)
data_16 = fltarr(2*ct)
tims_32=lonarr(2*ct)
tims_16=lonarr(ct)
;
for i=0,ct-1 do $
          begin
             tims_16[i] = long(10000010) + long(64)*i
             endfor
for i=0,2*ct-1 do $
          begin
             tims_32[i] = long(10000000) + long(32)*i
             endfor
data_32 = randomn(seed,2*ct)
data_16 = randomn(seed,ct)
freq_16=1000.0/ABS(tims_16[1]-tims_16[0])
freq_32=1000.0/ABS(tims_32[1]-tims_32[0])
print,freq_16
print,freq_32
data_old_16=data_16
Order = 2
FiltType = 2
Cut = float(6.0/freq_16)
Print,'Low pass filtering data now'
dumm =fltarr(2*ct)
Theta=fltArr(6)
FiltCtrl2,data_16,dumm,wc,Order,FiltType,cut,ct,theta
csd_power,data_old_16,data_16,freq_16,ct,fff1,fff2,fff12,fFF,mm,aa
!P.Multi = [0,1,2]
set_plot,'WIN'
Window,0, Xsize=500,Ysize=500,title='Wave fields'
plot,tims_16,data_old_16,XStyle=1,Xticks =3,XTickFormat='XTLab',$
xtitle ='Time (UT)',yrange=[-2,2],title='Original Signal Before Satellite Process',ytitle='Amplitude';,xrange=[min(tims_16),10063882]
plot,tims_16,data_16,XStyle=1,Xticks =3,XTickFormat='XTLab',$
xtitle ='Time (UT)',yrange=[-2,2],title='Post Satellite Signal',ytitle='Amplitude';';,xrange=[min(tims_16),10063882],/ystyle
!P.Multi = [0,1,3]
set_plot,'WIN'
Window,1, Xsize=500,Ysize=500,title='Power Spectra for original and filtered'
plot,fff,fff1,xrange=[min(fff),8.0],xtitle='Frequency (Hz)',ytitle='Power (W)',title='Original Signal'
plot,fff,fff2,xrange=[min(fff),8.0],xtitle='Frequency (Hz)',ytitle='Power (W)',title='Lowpass Filtered Signal'
plot,fff,aa,xrange=[min(fff),8.0],xtitle='Frequency (Hz)',ytitle='Cross Phase ( !Uo!n )',title='Cross Phase Signal'

Openw,unit,'c:\paul\crres\idl_programs\sample_precrresB.val',/get_lun
printf,unit,FORMAT ='(A6,8X,A3,8X,A3,8X,A3,7X,A3,8X,A3,8X,A3,8X,A8)',$
'TIME','dBx','dBy','dBz','Bx','By','Bz','DATA NEW'
for i=0,ct-1 do $
  begin
    printf,unit,FORMAT ='(I0,2X,F9.6,2X,F9.6,2X,F9.6,2X,F9.6,2X,F9.6,2X,F9.6,2X,F9.6)',$
    tims_16[i],data_old_16[i],data_old_16[i],data_old_16[i],data_old_16[i],data_old_16[i],data_old_16[i],data_16[i]
endfor
Free_lun,unit                                         ;Destroy file unit
Openw,unit,'c:\paul\crres\idl_programs\sample_precrresE.val',/get_lun
printf,unit,FORMAT ='(A6,8X,A3,8X,A3)',$
'TIME','Ez','Ez'
for i=0,2*ct-1 do $
  begin
    printf,unit,FORMAT ='(I0,2X,F9.6,2X,F9.6)',$
    tims_32[i],data_32[i],data_32[i]
endfor
Free_lun,unit
;print,'End ofprogram'


count=long(0)
Openw,unit,'sample5.val',/get_lun             ;Open data file
print,'Writing to file....'
For i=0,13 do $                        ;Loop to read header information
begin
printf,unit,header[i]                        ;Input Header string data into string array
endfor
for j=0,1 do $
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_32[0],index[j],data_32[0]
   for j=2,7 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_16[0],index[j],data_16[0]
   endfor
for i=0,ct/2-2 do $
 begin
   for j=6,7 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_32[4*i+1],indx[j],data_32[4*i+1]
   endfor
   for j=0,1 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_32[4*i+2],index[j],data_32[4*i+2]
   endfor
   for j=0,5 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_16[2*i+1],indx[j],data_16[2*i+1]
   endfor
   for j=6,7 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_32[4*i+3],indx[j],data_32[4*i+3]
   endfor
   for j=0,1 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_32[4*i+4],index[j],data_32[4*i+4]
   endfor
   for j=2,7 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_16[2*i+2],index[j],data_16[2*i+2]
   endfor
count=long(1)+count
endfor
free_lun,unit
print,''
print,count
print,tims_16[0]
print,tims_16[1]

!P.Multi = [0,1,2]
set_plot,'WIN'
Window,0, Xsize=500,Ysize=500,title='Wave fields'
    plot,tims_32,data_32,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)';,xrange=[min(tims),10002112]
    plot,tims_16,data_16,XStyle=1,Xticks =3,XTickFormat='XTLab',xtitle ='Time (UT)';,xrange=[min(tims),10002112]

end
