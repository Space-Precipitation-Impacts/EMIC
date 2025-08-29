;Michael barnes
;18-12-01
;filter program

;incorporates program 'csd_power' written to perform
;meaningful fourier transforms by Dr Pasha Ponomarenko

;program relies upon program 'buttern' written by Dr Colin Waters
;to perform the filtering.

;This program writes the random data to file, which is read by buttern,
;filtered and written to a new file, which this program then reads and displays the output.

pro filter

;device,decomposed=0
loadct,0
!Y.RANGE = 0
npoints=500								;number of points to be sampled
samint=1.								;sample integer
freq=1/samint
tax=fltarr(npoints)
random=(randomu(5,npoints))				;creating random data
Set_plot,'ps'
device, /color

csd_power,random,random,freq,0,ff1,ff2,ff12,FAx,m,a

for i=0,npoints-1 do begin				;creating a time axis

TAx(i)=i*samint

end


Stal='crre'											;defining variables
year=2001
month=12
day=14
hour=10
min=30
sec=0
;set_plot, 'win'
;device, retain=2, decomposed=0


openw,u,'c:\rsi\idl51\michaelb\filterdata.dat',/get_lun		;write data to file filterdata.dat
printf,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$
 StaL,Year,Month,Day,Hour,Min,Sec,SamInt,NPoints

for i=0,n_elements(random)-1 do begin

printf,u,random, format='(6x,f10.8)'

endfor

free_lun,u


openr,u,'c:\rsi\idl51\michaelb\finis.dat',/get_lun			;read data that has been filtered by buttern
readf,u,Format='(1x,A4,5I5,1x,2F5.1,I5)',$					;from file finis.dat
 StaL,Year,Month,Day,Hour,Min,Sec,SamInt,NPoints
data=fltarr(npoints)
readf,u,data
free_lun,u

!p.multi=[0,1,4]
;window,1,xsize=900,ysize=600

plot,tax, random-mean(random), title='Time Domains of Random Data and of filtered data', xtitle='Time sec', ytitle='Magnitude'
loadct,33
oplot,Tax, data, color=200, thick=4		;plot of random data with time domain and filtered data with time domain
loadct,0



plot,fax,ff1, title='Frequency Domain of Random Data', xtitle= 'Frequency Hz', ytitle='Magnitude'
;plot of random data with frequency domain


csd_power,data,data,freq,0,fff,ff2,ff12,FAx,m,a

plot,FAx,fff, title='Highpass filtered data in frequency domain', xtitle='frequency', ytitle='magnitude'
!Y.RANGE = 0
;filtered data in frequency domain

field=fff/ff1

plot,fax,field,title='ratio', xtitle='frequency', ytitle='magnitude'
;plot of ratio in frequency domain (filtered / non filtered)

device, /close_file

set_plot,'win'

!p.multi=0

end

