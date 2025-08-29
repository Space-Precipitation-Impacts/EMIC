pro norm_den_JGR2010
  
; This program is specific to the CRRES mission and cuts the data and
; normalizes it properly... I think although still checking
; everything. As of July 14th 2009 there were a few questions with the
; emic event times. Alexa Halford
  
;Here are a bunch of things needed for bits and pieces in the
;program. 
                                ;This is the number of minuets in the
                                ;normalized onset length, main phase
                                ;length and the recovery for the storms.
  onsetlength = 60.*3.          ;180.
  mainlength = 6000.            ;3000.
  recovlength = 12000.          ;8000.
  length = onsetlength + mainlength + recovlength
  
                                ;These are the precent size bins that
                                ;we want the EMIC events divided int
                                ;to. 
  opcr = .25
  mpcr = .1
  rpcr = .1
  
                                ;This is the event file for the storm
                                ;phases, and followed by the folder
                                ;paths for the figures, save files,
                                ;templates, and the data folders
  figurefolder = '../figures/'
  savefolder = '../Savefiles/'
  tempfolder = '../Templates/'
  datafolder = '../Data/'
  
  
; Here we get the storm phase data open 
  
  s1 = strpos('CRRES_storm_phases.txt','.')
  file2 = strmid('CRRES_storm_phases.txt',0,s1)
  file3 = strcompress('../Templates/'+file2+'_template.save')
  
  
                                ; Here we restoring and reaging in the
                                ; storms and their phases during the
                                ; CRRES mission.
  restore, file3  
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
  syear = meep.year
  month = meep.month
  day = meep.day
  hh = meep.hour
  mm = meep.mm
  mmonth = meep.mmonth
  mday = meep.mday
  mhour = meep.mhour
  mmm = meep.mmm
  emonth = meep.emonth
  eday = meep.eday
  ehour = meep.ehour     
  emm = meep.emm


  minSymarray = make_array(N_elements(syear))
  recovSymarray = make_array(N_elements(syear))
  all_oemic = make_array(1./opcr, value = 0)
  all_memic = make_array(1./mpcr, value = 0)
  all_remic = make_array(1./rpcr, value = 0)

  all_oemic_indi = make_array(n_elements(syear), onsetlength)
  all_memic_indi = make_array(n_elements(syear), mainlength)
  all_remic_indi = make_array(n_elements(syear), recovlength)


  all_normsym = make_array(N_elements(syear), length)
  all_normemic = make_array(n_elements(syear), length)
  all_normkp = make_array(N_elements(syear), length)
  all_normden =  make_array(N_elements(syear), length)
  scalelength = make_array(3,n_elements(syear))

;Here we are creating the year long arrays for the CRRES data.

  restore, '../Templates/CRRES_emic_template.save'

  jeep = read_ascii('../Data/CRRES_emic.txt', template = template)
  hMLT = make_array(365.*24.*60., value = 0);!values.F_NAN)
  hLS = hmlt
  
  UT = jeep.field13
  orbit = jeep.field01
  duration = jeep.field26
  endUT = jeep.field18
  Humlt1 = jeep.field15
  HUmlt2 = jeep.field20
  HULS1 = jeep.field16
  HULS2 = jeep.field21
  hden = jeep.field03

  print, 'average duration', mean(duration)
  doy = make_array(n_elements(orbit))
  year = make_array(n_elements(orbit))
                                ;Here we restore the orbit file for
                                ;the CRRES mission.
  restore,'../Templates/CRRES_orbit_template.save'
  beep = read_ascii('../Data/crres_orbit.txt', template = template)
  CRorbit = beep.orbit
  starttime = beep.start
  CRdoy = beep.doy
  cryear = beep.year



                                ;Here we find the doy for each of the
                                ;events and also create the year array
                                ;as well.
  for i = 0l, n_elements(orbit)-1 do begin
     index = where(CRorbit eq orbit(i))
     if index(0) ne -1 then doy(i) = crdoy(index(0)) $
     else print, 'no match'
                                ; I don't think that this is
                                ; needed. The UT time (hour) when put
                                ; into Julday should work out right.
                                ; if Starttime(index) gt UT(i) then doy(i) = doy(i)+1.
     year(i) = cryear(index(0))
  endfor

  in90 = where(year eq 90)
  in91 = where(year eq 91)

  doy90 = doy(in90) -1. ; This is because the year long arrays start with year 
                                ;day of 0 instead of 1.It's an indexing problem. 
  doy91 = doy(in91) -1.
  ut90 = ut(in90)
  ut91 = ut(in91)
  endUT90 = endut(in90)
  endut91 = endut(in91)
  hmlt190 = humlt1(in90)
  hmlt191 = humlt1(in91)
  hmlt290 = humlt2(in90)
  hmlt291 = humlt2(in91)
  hls190 = huls1(in90)
  hls191 = huls1(in91)
  hls290 = huls2(in90)
  hls291 = huls2(in91)
  thden90 = hden(in90)
  thden91 = hden(in91)

  syearminHu90 = make_array(365.*24.*60., value = 0);!Values.F_NAN)
  syearminHu91 = make_array(365.*24.*60., value = 0) ;!Values.F_NAN)
  hmlt90 =  make_array(365.*24.*60., value = 0);!Values.F_NAN)
  hmlt91 = hmlt90
  hls90 = hmlt90
  hls91 = hmlt90
  hden90 = hmlt90
  hden91 = hmlt90

  oncrres90 = hmlt90
  oncrres91 = hmlt90

  for i = 0l, n_elements(UT90) -1 do begin
     syearminHu90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = 1
     hmlt90(Floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):Floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = (hmlt190(i) + hmlt290(i))/2.
     hls90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = (Hls190(i) + hls290(i))/2.
     oncrres90((doy90(i)*24.*60.) + (Ut90(i)*60.)) = 1
     hden90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = thden90(i)
  endfor

  for i = 0l, n_elements(UT91) -1 do begin
     syearminHu91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = 1
     hmlt91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = (hmlt191(i) + hmlt291(i))/2.
     hls91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = (Hls191(i) + hls291(i))/2.
     oncrres91((doy91(i)*24.*60.) + (Ut91(i)*60.)) = 1
     hden91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = thden91(i)
  endfor

  s1 = strpos('CRRES_storm_phases.txt','.')
  file2 = strmid('CRRES_storm_phases.txt',0,s1)
  file3 = strcompress('../Templates/'+file2+'_template.save')

  
  
                                ; Here we restoring and reaging in the
                                ; storms and their phases during the
                                ; CRRES mission.
  restore, file3  
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
  syear = meep.year
  month = meep.month
  day = meep.day
  hh = meep.hour
  mm = meep.mm
  mmonth = meep.mmonth
  mday = meep.mday
  mhour = meep.mhour
  mmm = meep.mmm
  emonth = meep.emonth
  eday = meep.eday
  ehour = meep.ehour     
  emm = meep.emm

  numberstorms = n_elements(syear)
  odndt = make_array(4, n_elements(syear))
  mdndt = make_array(10, n_elements(syear))
  rdndt = make_array(10, n_elements(syear))

                                ;here are the dummy variables to find
                                ;the total amount of time in the
                                ;onset, main phase, recovery phase,
                                ;and the storm as well as the standard
                                ;devations and averages.
  ttonset = make_array(n_elements(syear))
  ttmain = make_array(n_elements(syear))
  ttrecovery = make_array(n_elements(syear))
  ttstorm = make_array(n_elements(syear))


;Here we start the main part of the program. 
  for k = 0l, n_elements(syear) - 1. do begin
    
     
     coemic = make_array(1./opcr, value = 0) ; c = count, next character = phase, then emic
     cmemic = make_array(1./mpcr, value = 0)
     cremic = make_array(1./rpcr, value = 0)
     
;Now we will first get all of the sym data cut into the proper pieces
;for each of the storm events. 
     
     
     onyday = stand2yday(month(k), day(k), syear(k), hh(k), mm(k), 0.)
     mainyday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.)
     recyday = stand2yday(emonth(k), eday(k), syear(k), ehour(k), emm(k), 0.)
     
     
                                ;These are the start and end of the
                                ;storms in fracdays. Again the
                                ;-1's are there to find the
                                ;correct index in the arrays. 
     styday = onyday - (3./24.) -1.
     onyday = onyday -1.
     mainyday = mainyday -1.
     recov = recyday -1.

;     print, 'Start ', styday*24.*60.
;     print, ' onset', onyday*24.*60.
;     print, 'Main ',  mainyday*24.*60.
;     print, 'recov', recov*24.*60.
                                ;Here we make the year array for the storms
     storm = make_array(365.*24.*60., value = !values.F_NAN)
     onphase = make_array(365.*24.*60., value = !values.F_NAN)
     mainphase = make_array(365.*24.*60., value = !values.F_NAN)
     recovphase = make_array(365.*24.*60., value = !values.F_NAN)
     
     
                                ;Here we put a 1 during the times when
                                ;there is a storm.
     storm(styday*24.*60.:recov*24.*60.) = 1
     onphase(styday*24.*60.:onyday*24.*60.-1) = 1
     mainphase(onyday*24.*60.:mainyday*24.*60.-1) = 1
     recovphase(mainyday*24.*60.:recov*24.*60.) = 1
     
     ttonset(k) = total(onphase, /NAN)
     ttmain(k) = total(mainphase, /NAN)
     ttrecovery(k) = total(recovphase, /NAN)
     ttstorm(k) = total(storm, /NAN)

                                ;Here we are finding our EMIC wave
                                ;events for each phase     
     if syear(k) eq 1990 then begin 
        oemicy = oncrres90*onphase
        memicy = oncrres90*mainphase
        remicy = oncrres90*recovphase
     endif

                                ;events for each phase     
     if syear(k) eq 1991 then begin 
        oemicy = oncrres91*onphase
        memicy = oncrres91*mainphase
        remicy = oncrres91*recovphase
     endif
                                ;Here we want to find the region for
                                ;our entire phase to cut out the
                                ;correct area of the EMIC array
     ino = where(finite(onphase))
     inm = where(finite(mainphase))
     inr = where(finite(recovphase))
     
     oemic = oemicy(ino)
     memic = memicy(inm)
     remic = remicy(inr)

     messino = where(finite(oemic), complement = nano)
     messinm = where(finite(memic), complement = nanm)
     messinr = where(finite(remic), complement = nanr)

     newoemic = oemic
     newmemic = memic
     newremic = remic
     
     if nano(0) ne -1 then newoemic(nano) = 0
     if nanm(0) ne -1 then newmemic(nanm) = 0
     if nanr(0) ne -1 then newremic(nanr) = 0


     all_oemic_indi(k,*) = congrid(newoemic, onsetlength)
     all_memic_indi(k,*) = congrid(newmemic, mainlength)
     all_remic_indi(k,*) = congrid(newremic, recovlength)

                                ; now we want to find our length for
                                ; the EMIC bins. 25% for the pre-onset
                                ; phase, 10% for rest.
     
                                ;Here we find the bin lengths for each
                                ;phase. 
     obin = floor(opcr*n_elements(ino))
     mbin = floor(mpcr*n_elements(inm))
     rbin = floor(rpcr*n_elements(inr))
     
                                ;Here we are finding the number of
                                ;events for each phase
     for i = 0,n_elements(coemic)-2 do begin
        coemic(i) = total(oemic((i*obin) : ((i+1)*obin)-1), /nan)
     endfor
     coemic(N_elements(coemic)-1) = total(oemic((i)*obin : N_elements(oemic)-1), /nan)
     
     for j = 0,n_elements(cmemic)-2 do begin
        cmemic(j) = total(memic(j*mbin : (j+1)*mbin-1), /nan)
     endfor
     cmemic(N_elements(cmemic)-1) = total(memic((j)*mbin : N_elements(memic)-1), /nan)
     
     for l = 0,n_elements(cremic)-2 do begin
        cremic(l) = total(remic(l*rbin : (l+1)*rbin-1), /nan)
     endfor
     cremic(N_elements(cremic)-1) = total(remic((l)*rbin : N_elements(remic)-1), /nan)
     
     
                                ;to add these EMIC events to the
                                ;running total we have 
     all_oemic = all_oemic + coemic
     all_memic = all_memic + cmemic
     all_remic = all_remic + cremic

                                ;Here we determine the rate of events
                                ;occuring in number of events per a
                                ;min.

;     for loop = 0l, n_elements(odndt(*,k)) -1 do odndt(loop,k) = coemic(loop)/obin 
     
;     print, 'onset count', coemic
;     print, 'onset dndt', odndt(*,k)
;     for loop2 = 0l, n_elements(mdndt(*,k))-1 do mdndt(loop2,k) = cmemic(loop2)/mbin 
;     print, 'main count', cmemic
;     print, 'main dndt', mdndt(*,k)
;     for loop3 = 0l, n_elements(rdndt(*,k)) -1 do rdndt(loop3,k) = cremic(loop3)/rbin 
;     print, 'recovery count', cremic
;     print, 'recovery dndt', rdndt(*,k)
     
     odndt(*,k) = coemic/(opcr*n_elements(ino))*60.*100.
     mdndt(*,k) = cmemic/(mpcr*n_elements(inm))*60.*100.
     rdndt(*,k) = cremic/(rpcr*n_elements(inr))*60.*100.

                                ;Here we want just the finite bit of
                                ;the previous arrays
                                ;Here we make the year array for the
                                ;storms. We're making the
                                ;arrays again so that we can use the
    
     if syear(k) eq 1990 then restore, '../Data/kyoto_Sym_1990.save'
     if syear(k) eq 1991 then restore, '../Data/kyoto_Sym_1991.save'
     if syear(k) eq 1990 then restore, '../Data/kp_CDAWeb1990.save'
     if syear(k) eq 1991 then restore, '../Data/kp_CDAWeb1991.save'
     if syear(k) eq 1990 then begin 
        ;restore, '../Data/CRRES_data/MIN_CRRES_data/CRRES1990.save'
        restore, '../Data/CRRES_1min_1990.save'
        den = den90
     endif
     if syear(k) eq 1991 then begin 
        ;restore, '../Data/CRRES_data/MIN_CRRES_data/CRRES1991.save'
        restore, '../Data/CRRES_1min_1991.save'
        den = den91
     endif

    
     stormsym = storm *sym
     osym  = onphase*sym 
     msym = mainphase*sym
     rsym = recovphase*Sym


     inos = where(finite(osym))
     inms = where(finite(msym))
     inrs = where(finite(rsym))

     osyms = osym(inos)
     mainsyms =  msym(inms)
     recovsyms = rsym(inrs)
     
     
                                ;This should be creating an array that
                                ;has NaN's and then the Kp
                                ;index where the storm or phase is occuring.
     stormkp = storm *kp
     okp  = onphase*kp
     mkp = mainphase*kp
     rkp = recovphase*kp
     
                                ;This should be finding/indexing where
                                ;the storm or phase is occuring
     inok = where(finite(okp))
     inmk = where(finite(mkp))
     inrk = where(finite(rkp))
                                ;This should be cutting out the
                                ;section of the total array where the
                                ;storm or phase is occuring. 
     okps = okp(inok)
     mainkps =  mkp(inmk)
     recovkps = rkp(inrk)
     

                                ;same thing but for density now
     stormden = storm*den
     oden  = onphase*den
     mden = mainphase*den
     rden = recovphase*den


     inod = where(finite(oden))
     inmd = where(finite(mden))
     inrd = where(finite(rden))

     if inod(0) ne -1 then odens = oden(inod) else odens = make_array(n_elements(okps), value = !values.F_NAN)
     if inmd(0) ne -1 then maindens = mden(inmd) else maindens = make_array(n_elements(mainkps), value = !values.F_NAN)
     if inrd(0) ne -1 then recovdens = rden(inrd) else recovdens = make_array(n_elements(recovkps), value = !values.F_NAN)
;     maindens =  mden(inmd)
;     recovdens = rden(inrd)


                                ;This is the total length of the storm
                                ;in minutes.
;     length = onsetlength + mainlength + recovlength
     
     
                                ;normalizing the times and data to the
                                ;predefined lengths
                                ;Congrid just resamples the arrays to
                                ;the new length that is defined. 
     foSyms = congrid(oSyms, onsetlength)
     fmainSyms = congrid(mainsyms, mainlength)
     frecovSyms = congrid(recovsyms,recovlength)

     fokps = congrid(okps, onsetlength)
     fmainkps = congrid(mainkps, mainlength)
     frecovkps = congrid(recovkps,recovlength)

     fodens = congrid(odens, onsetlength)
     fmaindens = congrid(maindens, mainlength)
     frecovdens = congrid(recovdens,recovlength)

                                ;resample the data to the normalized
                                ;lengths. 
     scalelength(0,k) = onsetlength/n_elements(osyms)
     scalelength(1,k) = mainlength/n_elements(mainsyms)
     scalelength(2,k) = recovlength/n_elements(recovsyms)


                                ;Here we take the normalize data and
                                ;refit it together. This is done
                                ;because then we just need to find the
                                ;quartiles and all of that once
                                ;instead of for four variables.
     normSyms = make_array(length)
     normSyms(0:onsetlength -1 ) = foSyms 
     normSyms(onsetlength : onsetlength+mainlength -1) = fmainSyms
     normSyms(onsetlength+mainlength :length -1) = frecovSyms
     all_normsym(k,*) = normSyms     

     normkps = make_array(length)
     normkps(0:onsetlength -1 ) = fokps 
     normkps(onsetlength : onsetlength+mainlength -1) = fmainkps
     normkps(onsetlength+mainlength :length -1) = frecovkps
     all_normkp(k,*) = normkps     

     normdens = make_array(length)
     normdens(0:onsetlength -1 ) = fodens 
     normdens(onsetlength : onsetlength+mainlength -1) = fmaindens
     normdens(onsetlength+mainlength :length -1) = frecovdens
     all_normden(k,*) = normdens     
 

     set_plot, 'x'
     xxx = findgen(n_elements( [okps,mainkps,recovkps]))
     x1 = findgen(n_elements(okps))
     x2 = findgen(n_elements(mainkps))+n_Elements(x1)+1
     x3 = findgen(n_elements(recovkps))+N_elements(x2)+2
     ;plot, all_normkp(K,*)
     ;oplot, okps, color = 729834072
     ;oplot, mainkps, color = 729834072
     ;oplot, recovkps, color = 729834072
     

 endfor

;  momon = moment(ttonset)
;  stdevon = sqrt(momon(1))
  stdevon = quartiles(ttonset)

;  momma = moment(ttmain)
;  stdevma = sqrt(momma(1))
  stdevma = quartiles(ttmain)

;  momrec = moment(ttrecovery)
;  stdevrec = sqrt(momrec(1))
  stdevrec = quartiles(ttrecovery)

;  momstorm = moment(ttstorm)
;  stdevst = sqrt(momstorm(1))
  stdevst = quartiles(ttstorm)



  print, 'quartiles of storm times in hrs', stdevst/60.
  print, 'quartiles of  onset times in hrs', stdevon/60.
  print, 'quartiles of main times in hrs', stdevma/60.
  print, 'quartiles of recovery times in hrs', stdevrec/60.
;stop
                                ;The main look is all done now. 
                                ;Now we are starting the superposed
                                ;epoch analysis and finding the mean,
                                ;the median and the 25 and 75th
                                ;percentiles. 
  
  mean_n_u = make_array(n_elements(all_normsym(0,*))) 
  prec24 = fltarr(n_elements(all_normsym(0,*)))
  prec50 = fltarr(n_elements(all_normsym(0,*)))
  prec75 = fltarr(n_elements(all_normsym(0,*)))

  kpmean_n_u = make_array(n_elements(all_normsym(0,*))) 
  kpprec24 = fltarr(n_elements(all_normsym(0,*)))
  kpprec50 = fltarr(n_elements(all_normsym(0,*)))
  kpprec75 = fltarr(n_elements(all_normsym(0,*)))

  denmean_n_u = make_array(n_elements(all_normsym(0,*))) 
  denprec24 = fltarr(n_elements(all_normsym(0,*)))
  denprec50 = fltarr(n_elements(all_normsym(0,*)))
  denprec75 = fltarr(n_elements(all_normsym(0,*)))
  
                                ;Sym75 this is going to be an array of
                                ;the number for the storms in the top
                                ;25%  and Sym25 the bottom 25%
  
  for nn = 0, n_elements(all_normsym(0,*))-1 do begin 
     good = where(finite(all_normsym(*,nn)), count)
     n_set = count
     p75 = long(75.*n_set/100.)
     p25 = long(25.*N_set/100.)
     
     array = all_normsym[*,nn]
     array = array(good)
     mean_n_u(nn) = mean(array)
     prec50(nn) = median(array)
     ii = sort(array)
     
;     if nn eq (onsetlength+mainlength -1) then begin
;        Sym75 = ii(findgen(long(25.*N_set/100.))+p75)
;        Sym25 = ii(findgen(long(25.*N_set/100.)))
;     endif
     prec75(nn) = array(ii(p75))
     prec24(nn) = array(ii(p25))
  endfor
  
  for nn = 0, n_elements(all_normkp(0,*))-1 do begin 
     good = where(finite(all_normkp(*,nn)), count)
     n_set = count
     p75 = long(75.*n_set/100.)
     p25 = long(25.*N_set/100.)
     
     kparray = all_normkp[*,nn]
     kparray = kparray(good)
     kpmean_n_u(nn) = mean(kparray)
     kpprec50(nn) = median(kparray)
     jj = sort(kparray)
     kpprec75(nn) = kparray(jj(p75))
     kpprec24(nn) = kparray(jj(p25))
  endfor

  
  for nn = 0, n_elements(all_normden(0,*))-1 do begin 
     good = where(finite(all_normden(*,nn)), count)
     n_set = count
     p75 = long(75.*n_set/100.)
     p25 = long(25.*N_set/100.)
     
     denarray = all_normden[*,nn]
     denarray = denarray(good)
     denmean_n_u(nn) = mean(denarray)
     denprec50(nn) = median(denarray)
     jj = sort(denarray)
     denprec75(nn) = denarray(jj(p75))
     denprec24(nn) = denarray(jj(p25))
  endfor
  
                                ;Here we create the superposed epoch
                                ;for each of the phases of the storms.
  
  onsetmean = mean_n_u(0:onsetlength-1)
  mainmean = mean_n_u(onsetlength : onsetlength + mainlength -1)
  recovmean = mean_n_u(onsetlength+mainlength : length -1)
  
  onset50 = prec50(0:onsetlength-1)
  main50 = prec50(onsetlength : onsetlength + mainlength -1)
  recov50 = prec50(onsetlength+mainlength : length -1)
  
  onset75 = prec75(0:onsetlength-1)
  main75 = prec75(onsetlength : onsetlength + mainlength -1)
  recov75 = prec75(onsetlength+mainlength : length -1)
  
  onset25 = prec24(0:onsetlength-1)
  main25 = prec24(onsetlength : onsetlength + mainlength -1)
  recov25 = prec24(onsetlength+mainlength : length -1)



  kponsetmean = kpmean_n_u(0:onsetlength-1)
  kpmainmean = kpmean_n_u(onsetlength : onsetlength + mainlength -1)
  kprecovmean = kpmean_n_u(onsetlength+mainlength : length -1)

  kponset50 = kpprec50(0:onsetlength-1)
  kpmain50 = kpprec50(onsetlength : onsetlength + mainlength -1)
  kprecov50 = kpprec50(onsetlength+mainlength : length -1)
  
  kponset75 = kpprec75(0:onsetlength-1)
  kpmain75 = kpprec75(onsetlength : onsetlength + mainlength -1)
  kprecov75 = kpprec75(onsetlength+mainlength : length -1)
  
  kponset25 = kpprec24(0:onsetlength-1)
  kpmain25 = kpprec24(onsetlength : onsetlength + mainlength -1)
  kprecov25 = kpprec24(onsetlength+mainlength : length -1)


  denonsetmean = denmean_n_u(0:onsetlength-1)
  denmainmean = denmean_n_u(onsetlength : onsetlength + mainlength -1)
  denrecovmean = denmean_n_u(onsetlength+mainlength : length -1)

  denonset50 = denprec50(0:onsetlength-1)
  denmain50 = denprec50(onsetlength : onsetlength + mainlength -1)
  denrecov50 = denprec50(onsetlength+mainlength : length -1)
  
  denonset75 = denprec75(0:onsetlength-1)
  denmain75 = denprec75(onsetlength : onsetlength + mainlength -1)
  denrecov75 = denprec75(onsetlength+mainlength : length -1)
  
  denonset25 = denprec24(0:onsetlength-1)
  denmain25 = denprec24(onsetlength : onsetlength + mainlength -1)
  denrecov25 = denprec24(onsetlength+mainlength : length -1)
  
;stop  
  
                                ;running total we have
  histoemic = make_array(2.*N_elements(all_oemic))
  histmemic = make_array(2.*N_elements(all_memic))
  histremic = make_array(2.*N_elements(all_remic))


  histodndt = make_array(2.*N_elements(odndt(*,0)))
  histmdndt = make_array(2.*N_elements(mdndt(*,0)))
  histrdndt = make_array(2.*N_elements(rdndt(*,0)))



  for h  = 0, n_elements(all_oemic) -1 do histoemic(2.*h:(2.*h)+1) = all_oemic(h)
  for hh  = 0, n_elements(all_memic) -1 do histmemic(2.*hh:(2.*hh)+1) = all_memic(hh)
  for hhh  = 0, n_elements(all_remic) -1 do histremic(2.*hhh:(2.*hhh)+1) = all_remic(hhh)

  nstorms = n_elements(syear)

  for g  = 0, n_elements(odndt(*,0)) -1 do histodndt(2.*g:(2.*g)+1) = total(odndt(g,*))/nstorms
  for gg  = 0, n_elements(mdndt(*,0)) -1 do histmdndt(2.*gg:(2.*gg)+1) =  total(mdndt(gg,*))/nstorms
  for ggg  = 0, n_elements(rdndt(*,0)) -1 do histrdndt(2.*ggg:(2.*ggg)+1) =  total(rdndt(ggg,*))/nstorms

  olen = (findgen(n_elements(all_oemic))/n_elements(all_oemic))*100.
  mlen = (findgen(n_elements(all_memic))/n_elements(all_memic))*100. 
  rlen = (findgen(n_elements(all_remic))/n_elements(all_remic))*100.
  xhisto = [olen, olen+(olen(1) - olen(0))]
  xhistm = [mlen, mlen+(mlen(1) - mlen(0))]
  xhistr = [rlen, rlen+(rlen(1) - rlen(0))]



  bo = sort(xhisto)
  bm = sort(xhistm)
  br = sort(xhistr)

  xhisto = xhisto(bo)
  xhistm = xhistm(bm)
  xhistr = xhistr(br)




         totalo = make_array(n_elements(syear))
         totalm = make_array(n_elements(syear))
         totalr = make_array(n_elements(syear))
         
      for ta = 0l, n_elements(syear)-1. do begin
         totalo(ta) = total(all_oemic_indi(ta,*), /nan)
         totalm(ta) = total(all_memic_indi(ta,*), /nan)
         totalr(ta) = total(all_remic_indi(ta,*), /nan)
      endfor
;      print, 'number of preonset phases with EMIC events', n_elements(where(totalo gt 0))
;      print, 'number of main phases with EMIC events', n_elements(where(totalm gt 0))
;      print, 'number of recovery phases with EMIC events', n_elements(where(totalr gt 0))

      stormtotal = make_array(n_elements(syear), value = 0)
      for jj = 0l, n_elements(syear) -1 do begin 
         stormtotal(jj) = totalo(jj) + totalm(jj) + totalr(jj)
      endfor
      print, 'this many storms had EMIC events', n_elements(where(stormtotal gt 0))


      ptotalo = make_array(2.*N_elements(totalo), value = 0)
      ptotalm = make_array(2.*N_elements(totalm), value = 0)
      ptotalr = make_array(2.*N_elements(totalr), value = 0)
      for h  = 0, n_elements(totalo) -1 do ptotalo(2.*h:(2.*h)+1) = totalo(h)
      for h  = 0, n_elements(totalm) -1 do ptotalm(2.*h:(2.*h)+1) = totalm(h)
      for h  = 0, n_elements(totalr) -1 do ptotalr(2.*h:(2.*h)+1) = totalr(h)

      print, 'max for totals in order', max(ptotalo), max(ptotalm), max(ptotalr)


  ymax = max([prec75, prec50]) + 2
  ymin =  min([prec75, prec50, min(all_oemic), min(all_memic), min(all_remic)]) - 50
  kpmin = 0. ;min([kponset75, kponset25, kpmain75, kpmain25, kprecov25, kprecov75])
  kpmax = max([kponset75, kponset25, kpmain75, kpmain25, kprecov25, kprecov75])+2.
  denmin = 0. ;min([denonset75, denonset25, denmain75, denmain25, denrecov25, denrecov75])
  denmax = max([denonset75, denonset25, denmain75, denmain25, denrecov25, denrecov75])+2.
  Emin = 0. 
  emax = max([histoemic, histmemic,  histremic]) +2
  ch = 1.75

print, 'number of storms ', numberstorms
;here we determine the lengths of each of the bins to get the new rates
  onlen = (3.*numberstorms)*opcr
  malen = (8.*numberstorms)*mpcr
  relen = (17.5*numberstorms)*rpcr
print, 'total onset bin length ', onlen
print, 'total main bin length ', malen
print, 'total recovery  bin length ', relen




  !P.multi = [0,4,3]
  loadct, 6
  set_plot, 'PS'
  plotname = 'JGR_CRRES_norm_den'
  filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
  
  
  ox = findgen(onsetlength)/onsetlength * 100.
  plot, ox, onsetmean, ytitle = 'Sym (nT) ',  charsize = ch,$
        yrange = [ymin, ymax], ystyle = 1, xstyle = 1, xrange = [0,100],$ 
        xtitle = '% of Pre-Onset', ymargin = [0.1,.01],pos = [0.,0.,.25,.25] 
  oplot,ox, onset75, color = 200, thick = 4 
  oplot,ox, onset25, color = 200, thick = 4
  oplot, ox, onset50, color = 50 ;, linestyle = 2

  plot, ox, kponsetmean, ytitle = 'Kp ', xcharsize = .01, charsize = ch, pos = [0., .26, .25, .50],$
        yrange = [0, kpmax], ystyle = 1, xstyle = 1, xrange = [0,100],  ymargin = [.1,.01]
  oplot,ox, kponset75, color = 200, thick = 4 ;, linestyle = 2
  oplot,ox, kponset25, color = 200, thick = 4
  oplot, ox, kponset50, color = 50 ;, linestyle = 2  


  plot, ox, denonsetmean, ytitle = 'density ', xcharsize = .01, charsize = ch, pos = [0., .51, .25, .75],$
        yrange = [0, denmax], ystyle = 1, xstyle = 1, xrange = [0,100],  ymargin = [.1,.01]
  oplot,ox, denonset75, color = 200, thick = 4 ;, linestyle = 2
  oplot,ox, denonset25, color = 200, thick = 4
  oplot, ox, denonset50, color = 50 ;, linestyle = 2  

  plot, xhisto, histoemic, ytitle = 'EMIC wave occurance ', charsize = ch, yrange = [0, emax],$
        pos = [0.,0.76,.25,1.],  xstyle = 1, xrange = [0,100], ymargin = [.1,.01], xcharsize = 0.01
  oplot, xhisto, histodndt, color = 50, thick = 4  


  ;***************************************************************
  mx = findgen(mainlength)/mainlength *100.
  plot, mx, mainmean, $
        yrange = [ymin,ymax], ystyle = 1, charsize = ch, ycharsize = .01,$
        xtitle = '% of Main Phase', ymargin = [.01,.01],pos = [.25,0.,.5,0.25]       ;, psym = 5  
  oplot,mx, main75, color = 200, thick = 4 ;, linestyle = 2
  oplot,mx, main25, color = 200, thick = 4
  oplot, mx, main50, color = 50 ;, linestyle = 2

  plot, mx, kpmainmean, $
        yrange = [0,kpmax], ystyle = 1, charsize = ch, xcharsize = 0.01, ycharsize = .01,$
        ymargin = [.01,.01],pos = [.25,0.26,.5,0.50]       ;, psym = 5  
  oplot,mx, kpmain75, color = 200, thick = 4 ;, linestyle = 2
  oplot,mx, kpmain25, color = 200, thick = 4
  oplot, mx, kpmain50, color = 50 ;, linestyle = 2
  
  plot, mx, denmainmean, $
        yrange = [0,denmax], ystyle = 1, charsize = ch, xcharsize = 0.01, ycharsize = .01,$
        ymargin = [.01,.01],pos = [.25,0.51,.5,0.75]       ;, psym = 5  
  oplot,mx, denmain75, color = 200, thick = 4 ;, linestyle = 2
  oplot,mx, denmain25, color = 200, thick = 4
  oplot, mx, denmain50, color = 50 ;, linestyle = 2

  plot, xhistm, histmemic, pos=[.25,0.76,.5,1.], yrange = [0, emax], xcharsize = 0.01, charsize = ch, $
         ycharsize = .01, title = 'Normalized Storms for the CRRES mission and EMIC wave occurance'
  oplot, xhistm, histmdndt, color = 50, thick = 4



 ;*********************************************************************  
  rx = findgen(recovlength)/recovlength *100.
  plot, rx, recovmean, $
        yrange = [ymin,ymax], ystyle = 1, charsize = ch, ycharsize = 0.01,$      
        xtitle = '% of Recovery Phase', ymargin = [.01,.01],pos = [.5,0.,1.,.25]       ;, psym = 5  
  oplot,rx, recov75, color = 200, thick = 4 ;, linestyle = 2
  oplot,rx, recov25, color = 200, thick = 4
  oplot, rx, recov50, color = 50 ;, linestyle = 2
  
  plot, rx, kprecovmean, $
        yrange = [0.,kpmax], ystyle = 1, charsize = ch, ycharsize = 0.01, xcharsize = 0.01,$ 
        ymargin = [.01,.01],pos = [.5,0.26,1.,.51]       
  oplot,rx, kprecov75, color = 200, thick = 4 ;, linestyle = 2
  oplot,rx, kprecov25, color = 200, thick = 4
  oplot, rx, kprecov50, color = 50 ;, linestyle = 2

  plot, rx, denrecovmean, $
        yrange = [0.,denmax], ystyle = 1, charsize = ch, ycharsize = 0.01, xcharsize = 0.01,$ 
        ymargin = [.01,.01],pos = [.5,0.51,1.,.75]       
  oplot,rx, denrecov75, color = 200, thick = 4 ;, linestyle = 2
  oplot,rx, denrecov25, color = 200, thick = 4
  oplot, rx, denrecov50, color = 50 ;, linestyle = 2

  plot, xhistr, histremic, ymargin = [.01,.01],pos = [.5,0.76,1.,1.], yrange = [0., emax], $
        ycharsize = 0.01, xcharsize = 0.01
  oplot, xhistr, histrdndt, color = 50, thick = 4
  Axis, yaxis = 1, yrange = (!Y.CRANGE/100.), Ystyle = 1, ytitle = 'EMIC occurance per hour', charsize = ch, color = 50
  device, /close_file
  close, /all
  

end
