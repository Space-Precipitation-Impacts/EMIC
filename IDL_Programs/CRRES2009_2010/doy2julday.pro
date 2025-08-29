function doy2julday, doy, year, hr, mn, sc
;This procedure is adapted from John spencers procedure doy2moday and
;has been modified to then change month day year to julday. doy is the
;day of year, year is the year, hr is the hour, mn is the min, and sc
;is the sec which will be used in julday and the function returns the
;julian day. These vaules can be arrays.  
;by Alexa Halford

;this is from John Spencers program pro doy2moday,year,doy,month,day
; Converts day of year into numerical month and day.
; Year is also required for input, to account for leap years
; All parameters integer.
; doy can be an array                                       

;This makes arrays which will be used later in the program
month = make_array(n_elements(doy))
day = month
jul = month


           
    refjd=julday(1,1,year,0,0,0)
    caldat,refjd+doy-1,month,day, year, hr, mn, sc

           
    returnjul = julday(month, day, year, hr, mn, sc)

return, returnjul
                                                                    


end
