;AUTHOR: Paul Manusiu
;PROGRAM: filter.pro
;DESCRIPTION: Low pass 2nd order Butterworth filter with
;cuttoff frequency of 6.5Hz, Sampling rate or 32Hz. The
;program generates 400 sine waves of frequency range of
;0 to 20Hz at 0.05Hz steps.
;
pro filter2
N = 100
y = fltarr(N)
x =fltarr(N)
z = fltarr(N)

arg = 2.0*!PI/16.0
M=600
f = fltarr(M)
;WINDOW, 1, XSIZE=700, YSIZE=500, TITLE='Square Window'
high = fltarr(M)
highx=fltarr(M)
pheta = fltarr(M)
y[0] = 0.0
y[1] = 0.0
for i=0, M-1 do begin
f[i]= 0.05*i
   for j=2, N-1 do begin
x[j] = sin(arg*f[i]*(j-2))
y[j] = 0.2116457*x[j]+0.4232914*x[j-1]+0.2116457*x[j-2]+0.3462655*y[j-1]-0.1928483*y[j-2]
;pheta[j] = atan(sqrt(abs(x[j]^2+y[j]^2)))
   endfor
high[i] = max(y)
highx[i]=max(x)
pheta[i]=atan(sqrt(abs(high[i]^2-highx[i]^2)))
endfor
!P.MULTI=[0,1,3]
set_plot,'win'
Window,0, Xsize=600,Ysize=500
plot,x,title='Testing low-pass Butterworth filter (sinewave)'
plot,f,high,title='Testing low-pass Butterworth filter (sinewave)',xtitle = 'frequency (Hz)',ytitle = 'Amplitude (Volts)'
plot,f,pheta/!PI*180,xrange=[0,8],title='Phase low-pass Butterworth filter (sinewave)',$
xtitle = 'frequency (Hz)',ytitle = 'Phase (rads)'

;SET_PLOT, 'PS'	                ;Set plotting to PostScript.
;!P.MULTI=[2,1,2]
;DEVICE, FILENAME='filter.ps'	;Set the filename.
;plot,f,high,xrange=[min(f),max(f)],title='Testing low-pass Butterworth filter (sinewave)',$
;xtitle = 'frequency (Hz)',ytitle = 'Amplitude (Volts)'
;plot,f,pheta,xrange=[min(f),max(f)],title='Phase low-pass Butterworth filter (sinewave)',$
;DEVICE,/CLOSE
end