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

Pro random_data
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
ct=50
index=INDGEN(8)
indx=[7,6,5,4,3,2,1,0]
data_32 = fltarr(ct)
data_16 = fltarr(2*ct)
tims_32=lonarr(ct)
tims_16=lonarr(2*ct)
;
for i=0,ct-1 do $
          begin
             tims_32[i] = long(10000010) + long(64)*i
             data_32[i] = sin(2*pi*60*i)
endfor
for i=0,2*ct-1 do $
          begin
             tims_16[i] = long(10000000) + long(32)*i
             data_16[i] = sin(2*pi*60*i/2)
endfor
count=long(0)
Openw,unit,'sample5.dat',/get_lun             ;Open data file
For i=0,13 do $                        ;Loop to read header information
begin
printf,unit,header[i]                        ;Input Header string data into string array
endfor
for j=0,1 do $
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_16[0],index[j],data_16[0]
   for j=2,7 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_32[0],index[j],data_32[0]
   endfor
for i=0,ct/2-2 do $
 begin
   for j=6,7 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_16[4*i+1],indx[j],data_16[4*i+1]
   endfor
   for j=0,1 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_16[4*i+2],index[j],data_16[4*i+2]
   endfor
   for j=0,5 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_32[2*i+1],indx[j],data_32[2*i+1]
   endfor
   for j=6,7 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_16[4*i+3],indx[j],data_16[4*i+3]
   endfor
   for j=0,1 do $
     begin
      printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
      tims_16[4*i+4],index[j],data_16[4*i+4]
   endfor
   for j=2,7 do $
     begin
    printf,unit,FORMAT ='(I0,2X,I0,2X,E14.6)',$
    tims_32[2*i+2],index[j],data_32[2*i+2]
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
