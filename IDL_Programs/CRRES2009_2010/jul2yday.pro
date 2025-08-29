function jul2yday, julianday
;This function was created to take a julian time and put it to yday. 
caldat, julianday, month, day, year, hh, mm, sec


for j = 0l, n_elements(year)-1. do begin

;the case section turns the month into yearday -1. of the first day of
;the month, the sday is then added to it in order to created the
;correct yearday.

case month(j) of 

    1 :month(j) = 0.
    2 :month(j) = 31.
    3 :month(j) = 59.
    4 :month(j) = 90.
    5 :month(j) = 120.
    6 :month(j) = 151.
    7 :month(j) = 181.
    8 :month(j) = 212.
    9 :month(j) = 243.
    10:month(j) = 273.
    11:month(j) = 304.
    12:month(j) = 334.

endcase
endfor

;yday = year*1000. + month + day + (hh/24.) + (mm/(24.*60.))
yday =  month + day + (hh/24.) + (mm/(24.*60.))


return, yday

end
