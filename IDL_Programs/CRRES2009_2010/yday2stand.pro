function yday2stand, yday
;This function was created to take a julian time and put it to yday. 
;caldat, julianday, month, day, year, hh, mm, sec


stand = make_array(5,n_elements(yday))
for j = 0l, n_elements(yday)-1. do begin
;print, 'on loop ', j, ' of ', n_elements(month)
;the case section turns the month into yearday -1. of the first day of
;the month, the sday is then added to it in order to created the
;correct yearday.


fracday = yday(j) - floor(yday(j))
frachour = fracday*24. - (floor(fracday*24.))
hour = fracday*24. - frachour
fracmin = frachour*60. - (floor(frachour*60.))
mm = frachour*60.  - fracmin
fracsec = fracmin*60. - (floor(fracmin*60.))
ss = fracmin*60. - fracsec

doy = yday(j) - fracday

if ((doy lt 32) and (doy ge 1)) then begin 
   month = 1
   day = doy
endif

if ((doy lt 60) and (doy ge 32)) then begin
   month = 2
   day = doy - 31
endif

if ((doy lt 91) and (doy ge 60)) then begin 
   month = 3
   day = doy - 59
endif

if ((doy lt 121) and (doy ge 91)) then begin 
   month = 4
   day = doy - 90
endif

if ((doy lt 152) and (doy ge 121)) then begin 
   month = 5
   day = doy - 120
endif 

if ((doy lt 182) and (doy ge 152)) then begin 
   month = 6
   day = doy - 151
endif

if ((doy lt 213) and (doy ge 182)) then begin 
   month = 7
   day = doy - 181 
endif 

if ((doy lt 244) and (doy ge 213)) then begin 
   month = 8
   day = doy - 212 
endif 

if ((doy lt 274) and (doy ge 244)) then begin 
   month = 9
   day = doy - 243 
endif

if ((doy lt 305) and (doy ge 274)) then begin 
   month = 10
   day = doy - 273
endif 

if ((doy lt 335) and (doy ge 305)) then begin 
   month = 11
   day = doy - 304
endif 

if ((doy lt 366) and (doy ge 335)) then begin 
   month = 12
   day = doy - 334
endif

array = [month, day, hour, mm, ss]
stand(*,j) = array

endfor
return, stand

end
