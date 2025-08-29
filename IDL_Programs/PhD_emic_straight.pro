Pro PhD_emic_straight
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
preon = 3. ;three hours prior to onset (preonset start time)
  dt = 5.
  minmlt = 14.
  maxmlt = 18.
  minmlttab = 14.
  maxmlttab = 18.
  minltab = 3.
  maxltab = 9.
  datafolder = '../Data/'
  templatefolder = '../Templates/'
  restore, '../Data/CRRES_1min_1990.save'
  restore, '../Data/CRRES_1min_1991.save'
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
     ;print, doy(i), orbit(i)
                ;Here we are now taking that year.
     year(i) = cryear(index(0))
                                ;In this loop (which is in particulare
                                ;for orbit 415 or 389 something around
                                ;there it's such a horrible
                                ;file I have to use to get the days.) 
     if doy(i) ge 366. then begin 
        year(i) = year(i) + 1.
        doy(i) = doy(i) - 365.
        ;print, orbit(i)
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

;;Now we start looking at the storms. First we re-create the file names and the template file names
  s1 = strpos('CRRES_storm_phases.txt', '.')
  file2 = strmid('CRRES_storm_phases.txt', 0,s1)
  file3 = strcompress('../Templates/'+ file2 + '_template.save')
;;Here we are going to read in the powerspectrum data
;  restore, '../Data/CRRES_powerspec_1min.save'
;  Hdb = [Hdb90, Hdb91]
;  hedb = [hedb90, hedb91]
;  indb = where(Hedb ge hdb)
;  db = hdb
;  db(indb) = hedb(indb)
;  Hintpower = [intpH90, intpH91]
;  Heintpower = [intpHe90, intpHe91]
;  inintpower = where(Heintpower ge Hintpower)
;  intpower = Hintpower
;  intpower(inintpower) = Heintpower(inintpower)
;;Now we read in the storm data
  restore, file3
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
  spyear = meep.year
  spmonth = meep.month
  spday = meep.day
  sphour = meep.hour
  spmin = meep.mm
  spmmonth = meep.mmonth
  spmday = meep.mday 
  spmhour = meep.mhour
  spmmin = meep.mmm
  spemonth = meep.emonth
  speday = meep.eday
  spehour = meep.ehour
  spemin = meep.emm
;;Here we are creating the arrays we will need for the different magnetospheric conditions.  
  year_array_length = 365.*24.*60.
  quiet90 = make_array(year_array_length, value = !values.F_NAN)
  storm90 = quiet90
  storm690 = quiet90
  onphase90 = quiet90
  mainphase90 = quiet90 
  recovphase90 = quiet90
  recov6phase90 = quiet90
  quiet91 =quiet90
  storm91 = quiet90
  storm691 = quiet90
  onphase91 = quiet90
  mainphase91 = quiet90 
  recovphase91 = quiet90
  recov6phase91 = quiet90
;;Now we are creating the arrays with 1's where there were those specific conditions.   
  for k = 0l, n_elements(spyear) -1. do begin 
;Here we are finding the yeardays
     onyday = stand2yday(spmonth(k), spday(k), spyear(k), sphour(k), spmin(k), 0.)
     mainyday = stand2yday(spmmonth(k), spmday(k), spyear(k), spmhour(k), spmmin(k), 0.)
     recyday = stand2yday(spemonth(k), speday(k), spyear(k), spehour(k), spemin(k), 0.)
;;now we are finding the start of the storm, the onset time, the
;;minimum sym-H value and the end of the recovery phase.
     styday = onyday - (preon/24.) - 1.
     onyday = onyday - 1.
     mainyday = mainyday -1.
     recov = recyday -1.
;;now we are putting 1's where those conditions occurred.      
     if spyear(k) eq 1990 then begin 
        storm90(styday*24.*60.:recov*24.*60.) = 1
        storm690(styday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
        onphase90(styday*24.*60.:onyday*24.*60.-1) = 1
        mainphase90(onyday*24.*60:mainyday*24.*60.-1) = 1
        recovphase90(mainyday*24.*60.:recov*24.*60.) = 1
        recov6phase90(mainyday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
     endif
     if spyear(k) eq 1991 then begin 
        storm91(styday*24.*60.:recov*24.*60.) = 1
        storm691(styday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
        onphase91(styday*24.*60.:onyday*24.*60.-1) = 1
        mainphase91(onyday*24.*60:mainyday*24.*60.-1) = 1
        recovphase91(mainyday*24.*60.:recov*24.*60.) = 1
        recov6phase91(mainyday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
     endif
  endfor
;;now we are finding where there were not storms in 1990, and 1991
;;during the CRRES mission. 
  nsindex90 = where(storm90 ne 1) 
  nsindex91 = where(storm91 ne 1)
;;And now we can put in the quiet (and non-CRRES mission) times
  quiet90(nsindex90) = 1. 
  quiet91(nsindex91) = 1.
;;Here we are creating the two year long arrays for everything  
  quiet = [quiet90, quiet91]
  storm = [storm90, storm91]
  storm6 = [storm690, storm691]
  onset = [onphase90, onphase91]
  main = [mainphase90, mainphase91]
  recovery = [recovphase90, recovphase91]
  recov6 = [recov6phase90, recov6phase91]
;;Here we are going to be creating an array with the magnetospheric conditions
;  magcondition = make_array(7, n_elements(quiet))
;  magcondition(0,*) = quiet
;  magcondition(1,*) = storm
;  magcondition(2,*) = storm6
;  magcondition(3,*) = onset
;  magcondition(4,*) = main
;  magcondition(5,*) = recovery
;  magcondition(6,*) = recov6
;  magstring = ['quiet', 'storm', 'storm_6day', 'pre-onset', 'main', 'recovery', 'recovery_6day']

chi_square_95 = [3.84146, 5.99147, 7.81473, 9.48773, 11.0705, 12.5916, 14.0671, 15.5073, 16.9190, 18.3070, 19.6751, 21.0261, 22.3621, 23.6848, 24.9958, 26.2962, 27.5871, 28.8693, 30.1435, 31.41104, 32.6705, 33.9244, 35.1725, 36.4151, 37.6525, 38.8852, 40.1133, 41.3372, 42.7222, 43.7729, 44.985, 46.194, 47.400, 48.602, 49.802, 50.998, 52.192, 53.384, 54.572, 55.758, 56.942, 58.124, 59.304, 60.481, 61.656, 62.830, 64.001, 65.171, 66.339, 67.505, 68.669, 69.832, 70.993,72.153, 73.311, 74.468, 75.624, 76.778, 77.931, 79.082, 80.232]
Chi_square_df = findgen(n_elements(chi_square_95)) + 1. 
;for jj = 0l, n_elements(magcondition(*,0)) -1 do begin

  normemic90 = make_array(n_elements(UT90), dt*2. + 102.)
  normemic91 = make_array(n_elements(UT91), dt*2. + 102.)
  normemic = make_array(n_elements(UT90) + n_elements(UT91), dt*2. + 102, value = !values.F_nan)
  mainnormemic =  make_array(n_elements(UT90) + n_elements(UT91), dt*2. + 102, value = !values.F_nan)
  normdis =  make_array(n_elements(UT90) + n_elements(UT91), dt*2. + 102, value = !values.F_nan)
  earthnormemic = make_array(n_elements(UT90) + n_elements(UT91), dt*2. + 102, value = !values.F_nan)
  mainearthnormemic =  make_array(n_elements(UT90) + n_elements(UT91), dt*2. + 102, value = !values.F_nan)
  dis90 =  make_array(n_elements(UT90), dt*2. + 102.)
  dis91 = make_array(n_elements(UT91), dt*2. + 102.) 
  tempx2coeff90 = make_array(n_elements(UT90))
  tempx2coeff91 = make_array(n_elements(UT91))
  disx3coeff90 = make_array(n_elements(UT90))
  disx3coeff91 = make_array(n_elements(UT91))
  disx2coeff90 = make_array(n_elements(UT90))
  disx2coeff91 = make_array(n_elements(UT91))
  disxcoeff90 = make_array(n_elements(UT90))
  disxcoeff91 = make_array(n_elements(UT91))
  disacoeff90 = make_array(n_elements(UT90))
  disacoeff91 = make_array(n_elements(UT91))
  chisig90 = make_array(n_elements(UT90), value = 0)
  chisig91 = make_array(n_elements(UT91), value = 0)
  df90 = make_array(n_elements(UT90), value = 0)
  df91 = make_array(n_elements(UT91), value = 0)
  chi_square90 =  make_array(n_elements(UT90), value = 0)
  chi_square91 =  make_array(n_elements(UT91), value = 0)
  r2_90 =  make_array(n_elements(UT90), /float, value = 0)
  r2_91 =  make_array(n_elements(UT91), /float, value = 0)
  minl90 = make_array(n_elements(UT90), /float, value = 0)
  minl91 = make_array(n_elements(UT91), /float, value = 0)
  maxl90 = make_array(n_elements(UT90), /float, value = 0)
  maxl91 = make_array(n_elements(UT91), /float, value = 0)
  avemlt90 = make_array(n_elements(UT90), /float, value = 0)
  avemlt91 = make_array(n_elements(UT91), /float, value = 0)

  intemp90 = where(den90 lt 0.) 
  den90(intemp90) = !values.F_NAN

  intemp91 = where(den91 lt 0.) 
  den91(intemp91) = !values.F_NAN
  normloop = 0.
  for i = 0l, n_elements(UT90) -1 do begin
;     syearmin90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i)) = 1
     yearmin = make_array(365.*24.*60., value = !values.F_NAN)
     yearmin(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i)) = 1
;     oncrres90(doy90(i)*24.*60.) = 
;     tempemicden = den90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i))/(1390.*(3.dis)^4.83)
;     test = where(tempemicden lt 0.) 
;     if test(0) ne -1. then print, 'loop ', i,' has a non zero density'
     innerls = yearmin*ls90
     index = where(innerls eq min(innerls, /nan))
;     startden = den90(floor(doy90(i)*24.*60.) - dt :
;                                                floor(doy90(i)*24.*60.))

     if n_elements(index) gt 1 then print, 'there are more than 1 min.'
     tempemicdenall =  den90(index(0) - dt :index(0) + dt)
     dis = ls90(index(0) - dt :index(0) + dt)
     tempmlt = mlt90(index(0) - dt :index(0) + dt)
     avemlt90(i) = mean(tempmlt, /nan)
     minl90(i) = min(dis, /nan)
     maxl90(i) = max(dis, /nan)
     dis90(i,0:n_elements(dis)-1) = dis
     timeaxis = findgen(n_elements(tempemicdenall))
     dispoly1 = linFit(dis, tempemicdenall/ (1390.*(3./dis)^4.83))
;     dispoly1 = poly_fit(dis, tempemicdenall, 1)
     expected_dis_values1 = dispoly1(0) + dispoly1(1)*dis
     
     if (avemlt90(i) ge minmlt) and (avemlt90(i) le maxmlt) then begin 
                                ;Here we are cutting the arrays to
                                ;their proper lengths
        startdis = ls90(floor(doy90(i)*24.*60.) - dt : floor(doy90(i)*24.*60.))
        startden = den90(floor(doy90(i)*24.*60.) - dt : floor(doy90(i)*24.*60.))/(1390.*(3./startdis)^4.83)
        enddis = ls90(floor(doy90(i)*24.*60.)+ duration90(i):floor(doy90(i)*24.*60.)+ duration90(i) + dt)
        endden = den90(floor(doy90(i)*24.*60.)+ duration90(i):floor(doy90(i)*24.*60.)+ duration90(i) + dt)/(1390.*(3./enddis)^4.83)
        tempdis = ls90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i))
        tempemicden = den90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i))/(1390.*(3./tempdis)^4.83)

                                ;Here we are normalizing the density
                                ;and distance array lengths during the
                                ;EMIC wave events then filling in the
                                ;resulting array. 
        norm1 = congrid(tempemicden, 100.)
        norm2 = congrid(tempdis, 100.)
        normemic(normloop,0:dt) = startden
        normemic(normloop, dt+1:dt+ 100) = norm1
        normemic(normloop, dt + 101: n_elements(normemic90(0,*)) -1) = endden
        normdis(normloop,0:dt) = startdis
        normdis(normloop, dt+1:dt+ 100) = norm2
        normdis(normloop, dt + 101: n_elements(normemic90(0,*)) -1) = enddis
        
                                ;Here we are sorting the array so that
                                ;instead of following as time from
                                ;start or end of EMIC wave
                                ;event, it's distance from Earth
        tempalldis = normdis(normloop, *)
        earthtempallemic = normemic(normloop, *)
        order = sort(tempalldis)
        earthnormemic(normloop, *) = earthtempallemic(order)

                                ;Here we are determining if we are in
                                ;the main phase or not
        phase = mainphase90(floor(doy90(i)*24.*60.) - dt : floor(doy90(i)*24.*60.)+ duration90(i) + dt)
        if total(phase, /nan) gt 1. then begin 
           mainnormemic(normloop, *) = tempalldis
           mainearthnormemic(normloop, *) = earthnormemic(normloop, *)
        endif else begin 
           mainnormemic(normloop, *) = !values.F_nan
           mainearthnormemic(normloop, *) =  !values.F_nan
        endelse


     endif
     normloop = normloop + 1.
     
                                ;Here we will look at the r2 value for
                                ;the fits. 
                                ;first for the straight line
     inside = (tempemicdenall - expected_dis_values1)^2.
     denaverage = mean(tempemicdenall, /nan)
     inside2 = (tempemicdenall - denaverage)^2.
     serr = total(inside, /nan)
     stot = total(inside2, /nan)
     r2_1 = 1.-(serr/stot)
                                ;now for the quadratic

           disxcoeff90(i) = dispoly1(1)
           disacoeff90(i) = dispoly1(0)
     good = where(finite(tempemicdenall))
     if good(0) eq -1 then begin
        r2_90(i) = !values.F_NAN
        disxcoeff90(i) = !values.F_NAN
        disacoeff90(i) = !values.F_NAN
     endif ;else begin
     

  endfor

  for i = 0l, n_elements(UT91) -1 do begin
     yearmin = make_array(365.*24.*60., value = !values.F_NAN)
     yearmin(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i)) = 1
     innerls = yearmin*ls91
     index = where(innerls eq min(innerls, /nan))
     if n_elements(index) gt 1 then print, 'there are more than 1 min.'
     tempemicdenall =  den91(index(0) - dt :index(0) + dt)/(1390.*(3./dis)^4.83)
     dis = ls91(index(0) - dt :index(0) + dt)
     tempmlt = mlt91(index(0) - dt :index(0) + dt)
     avemlt91(i) = mean(tempmlt, /nan)
     minl91(i) = min(dis, /nan)
     maxl91(i) = max(dis, /nan)
     dis91(i,0:n_elements(dis)-1) = dis
     timeaxis = findgen(n_elements(tempemicdenall))
;     dispoly1 = poly_fit(dis, tempemicdenall, 1)
     dispoly1 = linFit(dis, tempemicdenall)
     expected_dis_values1 = dispoly1(0) + dispoly1(1)*dis
     sum_array1 = (tempemicdenall - expected_dis_values1)^2./expected_dis_values1
     if (avemlt91(i) ge minmlt) and (avemlt91(i) le maxmlt) then begin 
        ;tempemicden = den91(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i))/(1390.*(3./dis)^4.83)
        ;startden = den91(floor(doy91(i)*24.*60.) - dt : floor(doy91(i)*24.*60.))/(1390.*(3./dis)^4.83)
        ;endden = den91(floor(doy91(i)*24.*60.)+ duration91(i):floor(doy91(i)*24.*60.)+ duration91(i) + dt)/(1390.*(3./dis)^4.83)
        ;norm1 = congrid(tempemicden, 100.)
        ;normemic(normloop,0:dt) = startden
        ;normemic(normloop, dt+1:dt+ 100) = norm1
        ;normemic(normloop, dt + 101: n_elements(normemic91(0,*)) -1) = endden
                                ;Here we are cutting the arrays to
                                ;their proper lengths
        startdis = ls91(floor(doy91(i)*24.*60.) - dt : floor(doy91(i)*24.*60.))
        startden = den91(floor(doy91(i)*24.*60.) - dt : floor(doy91(i)*24.*60.))/(1390.*(3./startdis)^4.83)
        enddis = ls91(floor(doy91(i)*24.*60.)+ duration91(i):floor(doy91(i)*24.*60.)+ duration91(i) + dt)
        endden = den91(floor(doy91(i)*24.*60.)+ duration91(i):floor(doy91(i)*24.*60.)+ duration91(i) + dt)/(1390.*(3./enddis)^4.83)
        tempdis = ls91(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i))
        tempemicden = den91(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i))/(1390.*(3./tempdis)^4.83)
        
                                ;Here we are normalizing the density
                                ;and distance array lengths during the
                                ;EMIC wave events then filling in the
                                ;resulting array. 
        norm1 = congrid(tempemicden, 100.)
        norm2 = congrid(tempdis, 100.)
        normemic(normloop,0:dt) = startden
        normemic(normloop, dt+1:dt+ 100) = norm1
        normemic(normloop, dt + 101: n_elements(normemic90(0,*)) -1) = endden
        normdis(normloop,0:dt) = startdis
        normdis(normloop, dt+1:dt+ 100) = norm2
        normdis(normloop, dt + 101: n_elements(normemic90(0,*)) -1) = enddis
        
                                ;Here we are sorting the array so that
                                ;instead of following as time from
                                ;start or end of EMIC wave
                                ;event, it's distance from Earth
        tempalldis = normdis(normloop, *)
        earthtempallemic = normemic(normloop, *)
        order = sort(tempalldis)
        earthnormemic(normloop, *) = earthtempallemic(order)

                                ;Here we are determining if we are in
                                ;the main phase or not
        phase = mainphase91(floor(doy91(i)*24.*60.) - dt : floor(doy91(i)*24.*60.)+ duration91(i) + dt)
        if total(phase, /nan) gt 1. then begin 
           mainnormemic(normloop, *) = tempalldis
           mainearthnormemic(normloop, *) = earthnormemic(normloop, *)
        endif else begin 
           mainnormemic(normloop, *) = !values.F_nan
           mainearthnormemic(normloop, *) =  !values.F_nan
        endelse

     endif
     normloop = normloop + 1. 

     inside = (tempemicdenall - expected_dis_values1)^2.
     denaverage = mean(tempemicdenall, /nan)
     inside2 = (tempemicdenall - denaverage)^2.
     serr = total(inside, /nan)
     stot = total(inside2, /nan)
     r2_1 = 1.-(serr/stot)

           r2_91(i) = r2_1
           disxcoeff91(i) = dispoly1(1)
           disacoeff91(i) = dispoly1(0)
     good = where(finite(tempemicdenall))
     if good(0) eq -1 then begin
        r2_91(i) = !values.F_NAN
        disxcoeff91(i) = !values.F_NAN
        disacoeff91(i) = !values.F_NAN
     endif ;else begin
     
;     tempx2coeff91(i) = temppoly(2)
  endfor

r = [r2_90, r2_91]
coeff = [disxcoeff90, disxcoeff91]
minl = [minl90, minl91]
maxl = [maxl90, maxl91]
mlt = [avemlt90, avemlt91]

indexl = where((minl ge minltab) and (maxl le maxltab))
rl = r(indexl)
coeffl = coeff(indexl)
mltl = mlt(indexl)

indexmlt = where((mltl ge minmlttab) and (mlt le maxmlttab))

rbin = rl(indexmlt)
xbin = coeffl(indexmlt)

index9 = where(rbin ge .9)
index8 = where(rbin ge .8)
index7 = where(rbin ge .7)
index6 = where(rbin ge .6)
index5 = where(rbin ge .5)
index4 = where(rbin ge .4)
index3 = where(rbin ge .3)
index2 = where(rbin ge .2)
index1 = where(rbin ge .1)
index0 = where(rbin ge .0)

print, 'there are ', n_elements(index9), ' events with r >= .9'
print, 'there are ', n_elements(index8), ' events with r >= .8'
print, 'there are ', n_elements(index7), ' events with r >= .7'
print, 'there are ', n_elements(index6), ' events with r >= .6'
print, 'there are ', n_elements(index5), ' events with r >= .5'
print, 'there are ', n_elements(index4), ' events with r >= .4'
print, 'there are ', n_elements(index3), ' events with r >= .3'
print, 'there are ', n_elements(index2), ' events with r >= .2'
print, 'there are ', n_elements(index1), ' events with r >= .1'
print, 'there are ', n_elements(index0), ' events with r >= .0'

print, 'there are ', n_elements(where(xbin(index9) gt .9)), ' events with positive slope for r >= .9'
print, 'there are ', n_elements(where(xbin(index8) gt .8)), ' events with positive slope for r >= .8'
print, 'there are ', n_elements(where(xbin(index7) gt .7)), ' events with positive slope for r >= .7'
print, 'there are ', n_elements(where(xbin(index6) gt .6)), ' events with positive slope for r >= .6'
print, 'there are ', n_elements(where(xbin(index5) gt .5)), ' events with positive slope for r >= .5'
print, 'there are ', n_elements(where(xbin(index4) gt .4)), ' events with positive slope for r >= .4'
print, 'there are ', n_elements(where(xbin(index3) gt .3)), ' events with positive slope for r >= .3'
print, 'there are ', n_elements(where(xbin(index2) gt .2)), ' events with positive slope for r >= .2'
print, 'there are ', n_elements(where(xbin(index1) gt .1)), ' events with positive slope for r >= .1'
print, 'there are ', n_elements(where(xbin(index0) gt .0)), ' events with positive slope for r >= .0'


print, 'there are ', n_elements(where(xbin(index9) lt .9)), ' events with negative slope for r >= .9'
print, 'there are ', n_elements(where(xbin(index8) lt .8)), ' events with negative slope for r >= .8'
print, 'there are ', n_elements(where(xbin(index7) lt .7)), ' events with negative slope for r >= .7'
print, 'there are ', n_elements(where(xbin(index6) lt .6)), ' events with negative slope for r >= .6'
print, 'there are ', n_elements(where(xbin(index5) lt .5)), ' events with negative slope for r >= .5'
print, 'there are ', n_elements(where(xbin(index4) lt .4)), ' events with negative slope for r >= .4'
print, 'there are ', n_elements(where(xbin(index3) lt .3)), ' events with negative slope for r >= .3'
print, 'there are ', n_elements(where(xbin(index2) lt .2)), ' events with negative slope for r >= .2'
print, 'there are ', n_elements(where(xbin(index1) lt .1)), ' events with negative slope for r >= .1'
print, 'there are ', n_elements(where(xbin(index0) lt .0)), ' events with negative slope for r >= .0'

                                ;Here we find the superposed epoch and
                                ;the quartiles for the normalized
                                ;density using the start and end of
                                ;the EMIC wave as epochs
  plotden = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  plot75 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  plot25 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)

  for j = 0l, n_elements(plotden) -1 do begin 
     tempquart = quartiles(normemic(*,j))
;     print, 'on loop j = ', j, ' tempquart = ', tempquart
     plotden(j) = mean(normemic(*, j), /nan)
     plot75(j) = tempquart(0)
     if tempquart(0) lt 0. then stop
     plot25(j) = tempquart(1)
  endfor

                                ;Here we find the superposed epoch and
                                ;the quartiles for the normalized
                                ;density using the start and end of
                                ;the EMIC wave as epochs for during
                                ;the main phase
  mainplotden = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  mainplot75 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  mainplot25 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)

  for j = 0l, n_elements(mainplotden) -1 do begin 
     tempquart = quartiles(mainnormemic(*,j))
     mainplotden(j) = mean(mainnormemic(*, j), /nan)
     mainplot75(j) = tempquart(0)
     if tempquart(0) lt 0. then stop
     mainplot25(j) = tempquart(1)
  endfor

                                ;Here we are finding the superposed
                                ;epoch and the quartiles for the
                                ;normalized density but ordered as
                                ;their distance from the Earth
  earthplotden = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  earthplot75 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  earthplot25 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)

  for j = 0l, n_elements(earthplotden) -1 do begin 
     tempquart = quartiles(earthnormemic(*,j))
     earthplotden(j) = mean(earthnormemic(*, j), /nan)
     earthplot75(j) = tempquart(0)
     if tempquart(0) lt 0. then stop
     earthplot25(j) = tempquart(1)
  endfor


                                ;Here we are finding the superposed
                                ;epoch and the quartiles for the
                                ;normalized density but ordered as
                                ;their distance from the Earth for the
                                ;main phase
  mainearthplotden = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  mainearthplot75 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)
  mainearthplot25 = make_array(N_elements(normemic(0,*)), value = !values.F_NAN)

  for j = 0l, n_elements(mainearthplotden) -1 do begin 
     tempquart = quartiles(mainearthnormemic(*,j))
     mainearthplotden(j) = mean(mainearthnormemic(*, j), /nan)
     mainearthplot75(j) = tempquart(0)
     if tempquart(0) lt 0. then stop
     mainearthplot25(j) = tempquart(1)
  endfor


  
  !P.multi = [0,3,0]
  loadct, 13
  set_plot, 'PS'
  plotname = strcompress('../Desktop/EMIC_norm_den_'+string(floor(minmlt))+'_'+string(floor(maxmlt)), /remove_all) 
  filename1 = strcompress(plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
  ymax = max([plot25, plot75, plotden], /nan)+.1
  ymin = min([plot25, plot75, plotden], /nan)-.1
  plotlen = n_elements(plotden)
  chr = 2
  plot, findgen(dt), plotden(0:dt-1.), xtitle = 'mins', ytitle = 'normalized density', xrange = [0, dt-1.], xstyle = 1, $
        pos = [0.,0.,.3, 1.], yrange = [ymin, ymax], ystyle = 1, charsize = chr
  xperc = findgen(n_elements(plotden(dt:plotlen - dt -2)))/$
          (n_elements(plotden(dt:plotlen - dt -2)))*100.
  oplot, findgen(dt), plot75(0:dt-1.), color = 150
  oplot, findgen(dt), plot25(0:dt-1.), color = 150

  plot, xperc, plotden(dt:plotlen - dt - 1.), title = 'superposed epoch of density during EMIC mlt = '$
        +strcompress(string(floor(minmlt))+'-'+string(floor(maxmlt)), /remove_all) , xrange = [0,100],$
        xstyle = 1, xtitle = 'percent of EMIC wave event ', pos = [0.3,0.0,0.66, 1.0], $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, xperc, plot75(dt: plotlen - dt -1.), color = 150
  oplot, xperc, plot25(dt: plotlen - dt -1.), color = 150

  plot, findgen(dt), plotden(plotlen - dt:plotlen -1.), xtitle = 'mins', pos = [0.66,0.0,1.0, 1.], $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, findgen(dt), plot75(plotlen - dt:plotlen -1.), color = 150
  oplot, findgen(dt), plot25(plotlen - dt:plotlen -1.), color = 150

  device, /close_file
  close, /all

  
  !P.multi = [0,3,0]
  loadct, 13
  set_plot, 'PS'
  plotname = strcompress('../Desktop/EMIC_norm_den_main'+string(floor(minmlt))+'_'+string(floor(maxmlt)), /remove_all) 
  filename1 = strcompress(plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
  ymax = max([mainplot25, mainplot75, mainplotden], /nan)+.1
  ymin = min([mainplot25, mainplot75, mainplotden], /nan)-.1
  plotlen = n_elements(mainplotden)
  chr = 2
  plot, findgen(dt), mainplotden(0:dt-1.), xtitle = 'mins', ytitle = 'normalized density', xrange = [0, dt-1.], xstyle = 1, $
        pos = [0.,0.,.3, 1.], yrange = [ymin, ymax], ystyle = 1, charsize = chr
  xperc = findgen(n_elements(mainplotden(dt:plotlen - dt -2)))/$
          (n_elements(mainplotden(dt:plotlen - dt -2)))*100.
  oplot, findgen(dt), mainplot75(0:dt-1.), color = 150
  oplot, findgen(dt), mainplot25(0:dt-1.), color = 150

  plot, xperc, mainplotden(dt:plotlen - dt - 1.), title = 'superposed epoch of density during main phase EMICs mlt = '$
        +strcompress(string(floor(minmlt))+'-'+string(floor(maxmlt)), /remove_all) , xrange = [0,100],$
        xstyle = 1, xtitle = 'percent of EMIC wave event ', pos = [0.3,0.0,0.66, 1.0], $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, xperc, mainplot75(dt: plotlen - dt -1.), color = 150
  oplot, xperc, mainplot25(dt: plotlen - dt -1.), color = 150

  plot, findgen(dt), mainplotden(plotlen - dt:plotlen -1.), xtitle = 'mins', pos = [0.66,0.0,1.0, 1.], $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, findgen(dt), mainplot75(plotlen - dt:plotlen -1.), color = 150
  oplot, findgen(dt), mainplot25(plotlen - dt:plotlen -1.), color = 150

  device, /close_file
  close, /all

  
  !P.multi = [0,1,0]
  loadct, 13
  set_plot, 'PS'
  plotname = strcompress('../Desktop/EMIC_norm_den_earth'+string(floor(minmlt))+'_'+string(floor(maxmlt)), /remove_all) 
  filename1 = strcompress(plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
  ymax = max([earthplot25, earthplot75, earthplotden], /nan)+.1
  ymin = min([earthplot25, earthplot75, earthplotden], /nan)-.1
  plotlen = n_elements(earthplotden)
  chr = 2

  xarray =  findgen(n_elements(earthplotden))/N_elements(earthplotden) * 100.
  plot, xarray, earthplotden, title = 'superposed epoch of density ordered from Earth during EMIC mlt = '$
        +strcompress(string(floor(minmlt))+'-'+string(floor(maxmlt)), /remove_all) , xrange = [0,100],$
        xstyle = 1, xtitle = 'percent of superposed epoch ', $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, xperc, earthplot75, color = 150
  oplot, xperc, earthplot25, color = 150

  device, /close_file
  close, /all


  !P.multi = [0,1,0]
  loadct, 13
  set_plot, 'PS'
  plotname = strcompress('../Desktop/EMIC_norm_den_earth_main'+string(floor(minmlt))+'_'+string(floor(maxmlt)), /remove_all) 
  filename1 = strcompress(plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
  ymax = max([mainearthplot25, mainearthplot75, mainearthplotden], /nan)+.1
  ymin = min([mainearthplot25, mainearthplot75, mainearthplotden], /nan)-.1
  plotlen = n_elements(mainearthplotden)
  chr = 2

  xarray =  findgen(n_elements(mainearthplotden))/N_elements(earthplotden) * 100.
  plot, xarray, mainearthplotden, title = 'superposed epoch of density ordered from Earth during main phase EMICs mlt = '$
        +strcompress(string(floor(minmlt))+'-'+string(floor(maxmlt)), /remove_all) , xrange = [0,100],$
        xstyle = 1, xtitle = 'percent of superposed epoch', $
        yrange = [ymin, ymax], ystyle = 1, charsize = chr
  oplot, xperc, mainearthplot75, color = 150
  oplot, xperc, mainearthplot25, color = 150

  device, /close_file
  close, /all



stop
 
end
