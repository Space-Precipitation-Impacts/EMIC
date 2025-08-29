Pro read_emicLex, datafolder,templatefolder   
;this program was created to read in the Dst data from Hu's
;EMIC wave list. It was created on April 4th 2008 by Alexa Halford
;Make sure that the template to read in the data has been
;created using make_template.pro and named CRRES_emic_template.save
;You will also need the file named crres_orbit.txt and it's
;template folder in order to get the yearday associated with the orbit out.

;this was updated September 6th 2010 by Alexa Halford. I was having
;problems with programs after this one getting the correct orbit
;numbers so I'm going through them all.
                                ;Here we restore the template for reading in the data
  restore, Templatefolder + 'CRRES_EMIC_2010_template.save'
                                ; Here we create the name of the save
                                ; file for the CRRES_EMIC events, the
                                ; text folder containing the CRRES
                                ; EMIC events, and the CRRES orbits
                                ; with their day of year. 
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC_2010'+'.save',$
               /remove_all)
  CRRESfile = strcompress(datafolder+'CRRES_EMIC_2010.txt',$
                          /remove_all)  
  CRRESorbitfile = strcompress(datafolder+'crres_orbit.txt',$
                               /remove_all)    
                                ;Here we are are opening the file with
                                ;the EMIC events and get their start
                                ;and stop times.
  jeep = read_ascii(CRRESfile, template = template)
  ;hMLT = make_array(365.*24.*60., value = 0);!values.F_NAN)
  ;hLS = hmlt     
  orbit = jeep.orbit            ;The orbit number of the event (orbit number)
  shour  = jeep.shour           ;the starting hour of the event (hr)
  ehour = jeep.ehour            ;the end hour of the event (hr)
  smin = jeep.smin              ;the start min of the event (min)
  emin = jeep.emin              ;the end min of the event (min)
  UT = shour*60. + (smin)       ;the start UT time of the event (min)
  endUT = ehour*60. + (emin)    ;the end UT time of the event (min) 
  duration = endUT - Ut         ;the duration of the event (min)
                                ;Here we create the arrays for the day
                                ;of year and the year.
  doy = make_array(n_elements(orbit))
  year = make_array(n_elements(orbit))
                                ;Here we restore the orbit file for
                                ;the CRRES mission.
  restore, templatefolder + 'CRRES_orbit_template.save'
  beep = read_ascii(crresorbitfile, template = template)
  CRorbit = beep.orbit          ;the orbits in the CRRES mission
  starttime = beep.start        ;the start of the orbit
  CRdoy = beep.doy              ;the doy of the orbit
  cryear = beep.year            ;the year of the orbit
                                ;Here we find the doy for each of the
                                ;events and also create the year array
                                ;as well.
  for i = 0l, n_elements(orbit)-1 do begin
                                ;Here we are finding where where the
                                ;CRRES orbit is the same as the event orbit
     index = where(CRorbit eq orbit(i))
                                ;Here we make sure that we can find
                                ;the orbit number as well as putting
                                ;in the correct DOY and if it's
                                ;not there then we print 'no match'
     if index(0) ne -1 then doy(i) = crdoy(index(0)) $
     else print, 'no match'
                                ;here we are just adding the hour and
                                ;mins so that we can figure out the
                                ;correct day and year.
     doy(i) = doy(i) + (shour(i)/24.) + (smin(i)/(24.*60.))
     print, doy(i), orbit(i)
                ;Here we are now taking that year.
     year(i) = cryear(index(0))
                                ;In this loop (which is in particulare
                                ;for orbit 415 or 389 something around
                                ;there it's such a horrible
                                ;file I have to use to get the days.) 
     if doy(i) ge 366. then begin 
        year(i) = year(i) + 1.
        doy(i) = doy(i) - 365.
        print, orbit(i)
     endif
  endfor
                                ;Here we are going to create the jul
                                ;time, then convert back into cal day
                                ;so that we can get all the years and
                                ;days right since some of the
                                ;Ut's will be over 24 hours. 
;  CRRES_jul = julday(0,doy, year, shour,smin,0) 
;  caldat, CRRES_jul, zmonth, zday, zyear, zhh, zmm
;  yday = stand2yday(zmonth, zday, zyear, zhh, zmm, 0)
                                ;here we are 
  in90 = where(year eq 90)
  in91 = where(year eq 91)
  year90 = year(in90)
  year91 = year(in91)
  doy90 = doy(in90) -1.         ; This is because the year long arrays start with year day 
                                ;of 0 instead of 1.It's an indexing problem. 
  doy91 = doy(in91) -1.         ;in frac days
  ut90 = ut(in90)               ;in mins
  ut91 = ut(in91)               ;in mins.
  endUT90 = endut(in90)         ;in mins. 
  endut91 = endut(in91)         ;in mins. 
  duration90 = duration(in90)   ;in mins.
  duration91 = duration(in91)   ;in mins.
  orbit90 = orbit(in90)         ;
  orbit91 = orbit(in91)
  
                                ;Here I've put it back to NaN's but it
                                ;was having problems before.
  syearmin90 = make_array(365.*24.*60.,value = !Values.F_NAN); value = 0);
  syearmin91 = make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt90 =  make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt91 = hmlt90
  hls90 = hmlt90
  hls91 = hmlt90
  hden90 = hmlt90
  hden91 = hmlt90

  oncrres90 = hmlt90
  oncrres91 = hmlt90

  for i = 0l, n_elements(UT90) -1 do begin
     syearmin90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i)) = 1
     oncrres90(doy90(i)*24.*60.) = 1
  endfor

  for i = 0l, n_elements(UT91) -1 do begin
     syearmin91(floor(doy91(i)*24.*60.):Floor(doy91(i)*24.*60.) + duration91(i)) = 1
     oncrres91(doy91(i)*24.*60.) = 1
  endfor

  restore, datafolder + 'CRRES_1min_1990.save'
  restore, datafolder + 'CRRES_1min_1991.save'
  hmlt90 = syearmin90 * mlt90
  hmlt91 = syearmin91 * mlt91
  hLS90 = syearmin90 * LS90
  hLS91 = syearmin90 * LS91
  hden90 = syearmin90 * den90
  hden91 = syearmin90 * den91
  

     save, orbit90, orbit91, orbit, shour, smin, ehour, emin, UT90, UT91, UT, endUT90, endUT91, endUT,  doy90, doy91, duration90,  duration91, duration, year, oncrres90, oncrres91, syearmin90, syearmin91, hmlt90, hmlt91, hls90, hls91, hden90, hden91, filename = CRRESsave
  
end
