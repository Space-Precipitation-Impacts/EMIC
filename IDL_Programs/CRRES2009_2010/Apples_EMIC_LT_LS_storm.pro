pro Apples_EMIC_LT_LS_storm
;EMIC_LT_LS was begining too long, so this is an extension... as in it
;has the same goals as EMIC_LT_LS, but is putting out other plots,
;namely more concise plots about the occurances of EMIC waves during
;storms. - Alexa Halford

datafolder = '../Data/'

;Here we are restoring the template to read in the EMIC waves from Hu
restore, '../Templates/CRRES_EMIC_template.save'

                                ;Here we are reading in the EMIC waves
                                ;events from Hi
  jeep = read_ascii('../Data/CRRES_emic.txt', template = template)
  hMLT = make_array(365.*24.*60., value = !values.F_NAN)
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
                                ;Here we are making the arrays for doy
                                ;and year. 
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

                                ;here we create the arrays which are
                                ;used later in the program. Many of
                                ;these are the year long arrays for
                                ;the different variables. In order to
                                ;get the correct indexing (our index
                                ;starts at 0) we need to subtract 1
                                ;from the doy.
  in90 = where(year eq 90)
  in91 = where(year eq 91)

  doy90 = doy(in90) -1.
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

  syearminHu90 = make_array(365.*24.*60., value = !Values.F_NAN)
  syearminHu91 = make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt90 =  make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt91 = hmlt90
  hls90 = hmlt90
  hls91 = hmlt90
  hden90 = hmlt90
  hden91 = hmlt90

  oncrres90 = hmlt90
  oncrres91 = hmlt90
                                ;here we are putting in the variables
                                ;into the year long arrays. 
  for i = 0l, n_elements(UT90) -1 do begin
     syearminHu90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = 1
     hmlt90(Floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):Floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = $
        (hmlt190(i) + hmlt290(i))/2.
     hls90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = $
        (Hls190(i) + hls290(i))/2.
     oncrres90((doy90(i)*24.*60.) + (Ut90(i)*60.)) = 1
     hden90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) =  $
        thden90(i)
  endfor

  for i = 0l, n_elements(UT91) -1 do begin
     syearminHu91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = 1
     hmlt91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = $
        (hmlt191(i) + hmlt291(i))/2.
     hls91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = $
        (Hls191(i) + hls291(i))/2.
     oncrres91((doy91(i)*24.*60.) + (Ut91(i)*60.)) = 1
     hden91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = $
        thden91(i)
  endfor

                                ;Now we are starting to read in the
                                ;storms and their phases. 
  s1 = strpos('CRRES_storm_phases.txt','.')
  file2 = strmid('CRRES_storm_phases.txt',0,s1)
  file3 = strcompress('../Templates/'+file2+'_template.save')

  
                                ; Here we restoring and reaging in the
                                ; storms and their phases during the
                                ; CRRES mission.
  restore, file3  
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
  year = meep.year
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

  onyday = stand2yday(month, day, year, hh, mm, 0.)
  mainyday = stand2yday(mmonth, mday, myear, mhour, mmm, 0.)
  recyday = mainyday + 6. ;stand2yday(mmonth, mday, myear, mhour, mmm, 0.) + 6.
  
;   onyday = stand2yday(month(k), day(k), syear(k), hh(k), mm(k), 0.)
;     mainyday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.)
;     recyday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.) + 6.
  

                                ;these are the indices for the storm
                                ;phases. In order to get the correct
                                ;indexing we have to subtract one from
                                ;the day of year
  on90 = where(year eq 1990.)
  on91 = where(year eq 1991.)
                                ;These are the start and end of the storms
  styday90 = onyday(on90) - (24./24.) -1.
  onyday90 = onyday(on90) -1.
  mainyday90 = mainyday(on90) -1.
  recov90 = recyday(on90) -1.
  styday91 = onyday(on91) - (24./24.) -1.
  onyday91 = onyday(on91) -1.
  mainyday91 = mainyday(on91) -1.
  recov91 = recyday(on91) -1.

                                ;Here we make the year array for the storms
  storm90 = make_array(365.*24.*60., value = !values.F_NAN)
  storm91 = make_array(365.*24.*60., value = !values.F_NAN)
  onphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  onphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  mainphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  mainphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  recovphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  recovphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  
                                ;Here we put a 1 during the times when
                                ;there is a storm.
  for ii = 0,n_elements(onyday90) -1 do begin
     storm90(styday90(ii)*24.*60.:recov90(ii)*24.*60.) = 1
     onphase90(styday90(ii)*24.*60.:onyday90(ii)*24.*60.) = 1
     mainphase90(onyday90(ii)*24.*60.:mainyday90(ii)*24.*60.) = 1
     recovphase90(mainyday90(ii)*24.*60.:recov90(ii)*24.*60.) = 1
  endfor
  restore, datafolder+'kyoto_Sym_1990.save'
  sym90 = sym
  for jj = 0,n_elements(onyday91) -1 do begin
     storm91(styday91(jj)*24.*60.:recov91(JJ)*24.*60.) = 1
     onphase91(styday91(jj)*24.*60.:onyday91(jj)*24.*60.) = 1
     mainphase91(onyday91(jj)*24.*60.:mainyday91(jj)*24.*60.) = 1
     recovphase91(mainyday91(jj)*24.*60.:recov91(jj)*24.*60.) = 1
  endfor
  restore, datafolder+'kyoto_Sym_1991.save'
  sym91 = sym
  

  allarray = [oncrres90, oncrres91]

  mlt90 = hmlt90 * storm90
  mlt91 = hmlt91 * storm91
  ls90 = hls90 * storm90
  ls91 = hls91 * storm91
  symstorm90 = sym90*storm90
  symstorm91 = sym91*storm91
  numarray = [oncrres90 * storm90,oncrres91 * storm91]
  den90 = hden90*storm90
  den91 = hden91*storm91


  num90index = where(finite(ls90)) 
  num90index = where(finite(ls91))
  numberevents = n_elements(num90index) + n_elements(num91index)
  print, numberevents
  


  omlt90 = hmlt90 * onphase90
  omlt91 = hmlt91 * onphase91
  ols90 = hls90 * onphase90
  ols91 = hls91 * onphase91
  numonarray = [oncrres90 * onphase90,oncrres91 * onphase91]
  oden90 = hden90*onphase90
  oden91 = hden91*onphase91
  osym90 = sym90*onphase90
  osym91 = sym91*onphase91


  mmlt90 = hmlt90 * mainphase90
  mmlt91 = hmlt91 * mainphase91
  mls90 = hls90 * mainphase90
  mls91 = hls91 * mainphase91
  nummainarray = [oncrres90 * mainphase90,oncrres91 * mainphase91]
  mden90 = hden90*mainphase90
  mden91 = hden91*mainphase91
  msym90 = sym90*mainphase90
  msym91 = sym91*mainphase91


  rmlt90 = hmlt90 * recovphase90
  rmlt91 = hmlt91 * recovphase91
  rls90 = hls90 * recovphase90
  rls91 = hls91 * recovphase91
  numrecovarray = [oncrres90 * recovphase90,oncrres91 * recovphase91]
  rden90 = hden90*recovphase90
  rden91 = hden91*recovphase91
  rsym90 = sym90*recovphase90
  rsym91 = sym91*recovphase91


  maxden90 =  max(hden90(where(finite(hden90))))
  maxden91 =  max(hden91(where(finite(hden91))))
  maxdensity = max([maxden90, maxden91])*.57
;********************************************************************************************************************
;********************************************************************************************************************

         loadct, 6
         sym = 4
         line = 0
        !P.multi=[0,2,2]
        set_plot, 'PS'
        device, filename = '../figures/Apples_CRRES_Hu_polar_LS_LT.ps', /landscape, /color
                                 ;Here we plot the Dst        
        tch = 1.2
        yout = 9.
        xout = -12.
        miny = -10
        maxy = 10
        minx = -11
        maxx = 11
        offset = 1.
        syms = .25
        noonx = -12
        noony = 0.2
        duskx = -4 
        dusky = -9.8
        ytit = ''
        xtit = ''
        ych = .05
        xch = .05
        xych = 1.

        plot, /polar,  hls90,  hmLT90*(!pi/12.), psym = sym, yrange = [miny, maxy], xrange = [minx,maxx],$
              xtitle = xtit, ytitle = ytit, symsize = syms, charsize = tch, pos = [0.,.5,.5,1.], $
              title = 'CRRES EMIC Events', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
        oplot, /polar, ls91, mlt91*(!pi/12.), color = 150, psym = sym, symsize = syms
        oplot, /polar, ls90, mlt90*(!pi/12.), color = 150, linestyle = line, psym = sym, symsize = syms
        in = where(numarray eq 1, allcount)
        xyouts, xout, yout, strcompress(string(allcount) + ' storm EMIC events'), charsize = xych, $
                color = 150
        in2 = where(allarray eq 1, every)
        xyouts, xout, yout -1, strcompress(string(every) + ' EMIC events'), charsize =  xych
        xyouts, duskx, dusky, 'Dusk', charsize =  xych
        xyouts, noonx, noony, 'Noon', charsize =  xych       
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360.;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize =  xych
        xyouts, 0.15, 3.1, '3 RE', charsize =  xych
        xyouts, 0.15, 9.1, '9 RE', charsize =  xych
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
       ; xyouts, -7.7, 0.19, '6.6 RE', charsize = .5
       ; xyouts, -4.1, 0.19, '3 RE', charsize = .5
       ; xyouts, -10.1, 0.19, '9 RE', charsize = .5

       
        plot, /polar, ols91, omLT91*(!pi/12.)*offset, psym = sym, yrange = [miny, maxy], xrange = [minx, maxx],$
              xtitle = xtit, ytitle = ytit, title = 'Pre-Onset Phase', charsize = tch, pos = [.5,.5,1.,1.],$
              /isotropic, symsize = syms, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        oplot, /polar, ols90, omlt90*(!pi/12.)*offset, psym = sym, symsize = syms
        in = where(numonarray eq 1, oncount)
        xyouts, xout, yout, strcompress(string(oncount) + ' EMIC events'), charsize =  xych
        ;xyouts, duskx, dusky, 'Dusk', charsize = .75
        ;xyouts, noonx, noony, 'Noon', charsize = .75        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360.;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize =  xych
        xyouts, 0.15, 3.1, '3 RE', charsize =  xych
        xyouts, 0.15, 9.1, '9 RE', charsize =  xych
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)*offset
        ;xyouts, -7.7, 0.19, '6.6 RE', charsize = .5
        ;xyouts, -4.1, 0.19, '3 RE', charsize = .5
        ;xyouts, -10.1, 0.19, '9 RE', charsize = .5



        plot, /polar, mls91, mmLT91*(!pi/12.)*offset, psym = sym,  yrange = [miny, maxy], xrange = [minx,maxx],$
              xtitle = xtit, ytitle = ytit, title = 'Main Phase', charsize = tch, pos = [0.,.0,.5,.5], $
              /isotropic, symsize = syms, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        oplot, /polar, mls90, mmlt90*(!pi/12.)*offset, psym = sym, symsize = syms
        in = where(nummainarray eq 1, maincount)
        xyouts, xout, yout, strcompress(string(maincount) + ' EMIC events'), charsize = xych
        xyouts, duskx, dusky, 'Dusk', charsize =  xych
        xyouts, noonx, noony, 'Noon', charsize = xych       
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360.;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize =  xych
        xyouts, 0.15, 3.1, '3 RE', charsize =  xych
        xyouts, 0.15, 9.1, '9 RE', charsize =  xych
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)*offset
        ;xyouts, -7.7, 0.19, '6.6 RE', charsize = .5
        ;xyouts, -4.1, 0.19, '3 RE', charsize = .5
        ;xyouts, -10.1, 0.19, '9 RE', charsize = .5


        plot, /polar, rls91, rmLT91*(!pi/12.)*offset, psym = sym, yrange = [miny, maxy], xrange = [minx,maxx], $
              xtitle = xtit, ytitle =ytit, title = 'Recovery Phase', charsize = tch, pos = [0.5,.0,1.,.5], $
              /isotropic, symsize = syms, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        oplot,  /polar,rls90, rmlt90*(!pi/12.)*offset, linestyle = line , psym = sym, symsize = syms
        in = where(numrecovarray eq 1, recovcount)
        xyouts, xout, yout, strcompress(string(recovcount) + ' EMIC events'), charsize = xych
        ;xyouts, duskx, dusky, 'Dusk', charsize = .75
        ;xyouts, noonx, noony, 'Noon', charsize = .75        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360.;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = xych
        xyouts, 0.15, 3.1, '3 RE', charsize = xych
        xyouts, 0.15, 9.1, '9 RE', charsize = xych
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)*offset
        ;xyouts, -7.7, 0.19, '6.6 RE', charsize = .5
        ;xyouts, -4.1, 0.19, '3 RE', charsize = .5
        ;xyouts, -10.1, 0.19, '9 RE', charsize = .5
        
        device, /close_file
        close, /all
        
        
        
        
        
        
;*************************************************************************************************************************************************
        
;This is for storm time events
        mlt = [mlt90, mlt91]
        den = [den90, den91]
        omlt = [omlt90, omlt91]
        oden = [oden90, oden91]
        mmlt = [mmlt90, mmlt91]
        mden = [mden90, mden91]
        rmlt = [rmlt90, rmlt91]
        rden = [rden90, rden91]
        ls = [ls90, ls91]
        ols = [ols90, ols91]
        mls = [mls90, mls91]
        rls = [rls90, rls91]


;        ormlt = sort(mlt)
;        truemlt = mlt(ormlt)
;        trueden = den(ormlt)
  
        denmean =make_array(24)
        denprec24 = fltarr(24)
        denprec50 = fltarr(24)
        denprec75 = fltarr(24)
        denmed =  fltarr(24)
        den75 = denmean
        den25 = denmean
        allcount = denmean

  
        odenmean =make_array(24)
        odenprec24 = fltarr(24)
        odenprec50 = fltarr(24)
        odenprec75 = fltarr(24)
        odenmed =  fltarr(24)
        oden75 = denmean
        oden25 = denmean
        oallcount = denmean


  
        mdenmean =make_array(24)
        mdenprec24 = fltarr(24)
        mdenprec50 = fltarr(24)
        mdenprec75 = fltarr(24)
        mdenmed =  fltarr(24)
        mden75 = denmean
        mden25 = denmean
        mallcount = denmean


  
        rdenmean =make_array(24)
        rdenprec24 = fltarr(24)
        rdenprec50 = fltarr(24)
        rdenprec75 = fltarr(24)
        rdenmed =  fltarr(24)
        rden75 = denmean
        rden25 = denmean
        rallcount = denmean

        
        for nn = 0l, 23 do begin
           ind = where((mlt ge nn) and (mlt lt (nn+1.)), counti)
           oind = where((omlt ge nn) and (omlt lt (nn+1.)), ocounti)
           mind = where((mmlt ge nn) and (mmlt lt (nn+1.)), mcounti)
           rind = where((rmlt ge nn) and (rmlt lt (nn+1.)), rcounti)
           allcount(nn) = counti 
           if ind(0) ne -1 then begin
              den75 = long(75.*counti/100.)
              den25 = long(25.*counti/100.)   
              denarray = den(ind)
              denmean(nn) = mean(denarray)
              denmed(nn) = median(denarray, /even)
              denii = sort(denarray)
              denprec75(nn) = denarray(denii(den75))
              denprec24(nn) = denarray(denii(den25))
           endif
           if oind(0) ne -1 then begin
              oden75 = long(75.*ocounti/100.)
              oden25 = long(25.*ocounti/100.)   
              odenarray = oden(oind)
              odenmean(nn) = mean(odenarray)
              odenmed(nn) = median(odenarray, /even)
              odenii = sort(odenarray)
              odenprec75(nn) = odenarray(odenii(oden75))
              odenprec24(nn) = odenarray(odenii(oden25))
           endif
           if mind(0) ne -1 then begin
              mden75 = long(75.*mcounti/100.)
              mden25 = long(25.*mcounti/100.)   
              mdenarray = mden(mind)
              mdenmean(nn) = mean(mdenarray)
              mdenmed(nn) = median(mdenarray, /even)
              mdenii = sort(mdenarray)
              mdenprec75(nn) = mdenarray(mdenii(mden75))
              mdenprec24(nn) = mdenarray(mdenii(mden25))
           endif
           if rind(0) ne -1 then begin
              rden75 = long(75.*rcounti/100.)
              rden25 = long(25.*rcounti/100.)   
              rdenarray = rden(rind)
              rdenmean(nn) = mean(rdenarray)
              rdenmed(nn) = median(rdenarray, /even)
              rdenii = sort(rdenarray)
              rdenprec75(nn) = rdenarray(rdenii(rden75))
              rdenprec24(nn) = rdenarray(rdenii(rden25))
           endif
      endfor




        xmlt = findgen(24)
        pxmlt = make_array(24.*2)
        pdenmean = pxmlt
        pdenprec75 = pxmlt
        pdenprec24 = pxmlt
        pdenmed = pxmlt

        opdenmean = pxmlt
        opdenprec75 = pxmlt
        opdenprec24 = pxmlt
        opdenmed = pxmlt

        mpdenmean = pxmlt
        mpdenprec75 = pxmlt
        mpdenprec24 = pxmlt
        mpdenmed = pxmlt

        rpdenmean = pxmlt
        rpdenprec75 = pxmlt
        rpdenprec24 = pxmlt
        rpdenmed = pxmlt


        pxmlt = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24]
        for i = 0,24.*2-1 ,2 do begin
           pdenmean(i:i+1) = denmean(i/2.)
           pdenprec75(i:i+1) = denprec75(i/2.)
           pdenprec24(i:i+1) = denprec24(i/2.)
           pdenmed(i:i+1) = denmed(i/2.)

           opdenmean(i:i+1) = odenmean(i/2.)
           opdenprec75(i:i+1) = odenprec75(i/2.)
           opdenprec24(i:i+1) = odenprec24(i/2.)
           opdenmed(i:i+1) = odenmed(i/2.)

           mpdenmean(i:i+1) = mdenmean(i/2.)
           mpdenprec75(i:i+1) = mdenprec75(i/2.)
           mpdenprec24(i:i+1) = mdenprec24(i/2.)
           mpdenmed(i:i+1) = mdenmed(i/2.)

           rpdenmean(i:i+1) = rdenmean(i/2.)
           rpdenprec75(i:i+1) = rdenprec75(i/2.)
           rpdenprec24(i:i+1) = rdenprec24(i/2.)
           rpdenmed(i:i+1) = rdenmed(i/2.)
        endfor        


        loadct, 6
        !P.multi=[0,2,2]
        set_plot, 'PS'
        device, filename = '../figures/Apples_CRRES_Hu_den_mLT.ps', /landscape, /color
                                ;Here we plot the Dst        
        plot, pxmlt, pdenmean, xrange = [0,24], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75] )+5], xstyle = 1, ystyle = 1, $
              xtitle = 'Magnetic Local time', ytitle ='electron density', title = 'Storm time density for EMIC events from CRRES' 
        oplot, pxmlt, pdenprec75, color = 200;, linestyle = 2
        oplot, pxmlt, pdenprec24, color = 50;, linestyle = 2
        ;oplot, pxmlt, pdenmed, color = 50;, linestyle = 4
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pxmlt, opdenmean, xrange = [0,24], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'Magnetic Local time', ytitle ='electron density', title = '3hr before onset' 
        oplot, pxmlt, opdenprec75, color = 200;, linestyle = 2
        oplot, pxmlt, opdenprec24, color = 50;, linestyle = 2
        xyouts, 5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 5, 275, ' mean ', charsize = .75
        xyouts, 5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pxmlt, mpdenmean, xrange = [0,24], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'Magnetic Local time', ytitle ='electron density', title = 'Main phase' 
        oplot, pxmlt, mpdenprec75, color = 200;, linestyle = 2
        oplot, pxmlt, mpdenprec24, color = 50;, linestyle = 2
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pxmlt, rpdenmean, xrange = [0,24], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'Magnetic Local time', ytitle ='electron density ', title = 'Recovery phase' 
        oplot, pxmlt, rpdenprec75, color = 200;, linestyle = 2
        oplot, pxmlt, rpdenprec24, color = 50;, linestyle = 2
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        device, /close_file
        close, /all

;Now we do the same for l-shell

        denmean =make_array(10)
        denprec24 = fltarr(10)
        denprec50 = fltarr(10)
        denprec75 = fltarr(10)
        denmed =  fltarr(10)
        den75 = denmean
        den25 = denmean
        allcount = denmean

  
        odenmean =make_array(10)
        odenprec24 = fltarr(10)
        odenprec50 = fltarr(10)
        odenprec75 = fltarr(10)
        odenmed =  fltarr(10)
        oden75 = denmean
        oden25 = denmean
        oallcount = denmean


  
        mdenmean =make_array(10)
        mdenprec24 = fltarr(10)
        mdenprec50 = fltarr(10)
        mdenprec75 = fltarr(10)
        mdenmed =  fltarr(10)
        mden75 = denmean
        mden25 = denmean
        mallcount = denmean


  
        rdenmean =make_array(10)
        rdenprec24 = fltarr(10)
        rdenprec50 = fltarr(10)
        rdenprec75 = fltarr(10)
        rdenmed =  fltarr(10)
        rden75 = denmean
        rden25 = denmean
        rallcount = denmean

        
        for nn = 0l, 9 do begin
           ind = where((ls ge nn) and (ls lt (nn+1.)), counti)
           oind = where((ols ge nn) and (ols lt (nn+1.)), ocounti)
           mind = where((mls ge nn) and (mls lt (nn+1.)), mcounti)
           rind = where((rls ge nn) and (rls lt (nn+1.)), rcounti)
           allcount(nn) = counti 
           if ind(0) ne -1 then begin
              den75 = long(75.*counti/100.)
              den25 = long(25.*counti/100.)   
              denarray = den(ind)
              denmean(nn) = mean(denarray)
              denmed(nn) = median(denarray, /even)
              denii = sort(denarray)
              denprec75(nn) = denarray(denii(den75))
              denprec24(nn) = denarray(denii(den25))
           endif
           if oind(0) ne -1 then begin
              oden75 = long(75.*ocounti/100.)
              oden25 = long(25.*ocounti/100.)   
              odenarray = oden(oind)
              odenmean(nn) = mean(odenarray)
              odenmed(nn) = median(odenarray, /even)
              odenii = sort(odenarray)
              odenprec75(nn) = odenarray(odenii(oden75))
              odenprec24(nn) = odenarray(odenii(oden25))
           endif
           if mind(0) ne -1 then begin
              mden75 = long(75.*mcounti/100.)
              mden25 = long(25.*mcounti/100.)   
              mdenarray = mden(mind)
              mdenmean(nn) = mean(mdenarray)
              mdenmed(nn) = median(mdenarray, /even)
              mdenii = sort(mdenarray)
              mdenprec75(nn) = mdenarray(mdenii(mden75))
              mdenprec24(nn) = mdenarray(mdenii(mden25))
           endif
           if rind(0) ne -1 then begin
              rden75 = long(75.*rcounti/100.)
              rden25 = long(25.*rcounti/100.)   
              rdenarray = rden(rind)
              rdenmean(nn) = mean(rdenarray)
              rdenmed(nn) = median(rdenarray, /even)
              rdenii = sort(rdenarray)
              rdenprec75(nn) = rdenarray(rdenii(rden75))
              rdenprec24(nn) = rdenarray(rdenii(rden25))
           endif
      endfor




        xmlt = findgen(10)
        pxmlt = make_array(10.*2)
        pdenmean = pxmlt
        pdenprec75 = pxmlt
        pdenprec24 = pxmlt
        pdenmed = pxmlt

        opdenmean = pxmlt
        opdenprec75 = pxmlt
        opdenprec24 = pxmlt
        opdenmed = pxmlt

        mpdenmean = pxmlt
        mpdenprec75 = pxmlt
        mpdenprec24 = pxmlt
        mpdenmed = pxmlt

        rpdenmean = pxmlt
        rpdenprec75 = pxmlt
        rpdenprec24 = pxmlt
        rpdenmed = pxmlt


        pls = [0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10]
        for i = 0,10.*2-1 ,2 do begin
           pdenmean(i:i+1) = denmean(i/2.)
           pdenprec75(i:i+1) = denprec75(i/2.)
           pdenprec24(i:i+1) = denprec24(i/2.)
           pdenmed(i:i+1) = denmed(i/2.)

           opdenmean(i:i+1) = odenmean(i/2.)
           opdenprec75(i:i+1) = odenprec75(i/2.)
           opdenprec24(i:i+1) = odenprec24(i/2.)
           opdenmed(i:i+1) = odenmed(i/2.)

           mpdenmean(i:i+1) = mdenmean(i/2.)
           mpdenprec75(i:i+1) = mdenprec75(i/2.)
           mpdenprec24(i:i+1) = mdenprec24(i/2.)
           mpdenmed(i:i+1) = mdenmed(i/2.)

           rpdenmean(i:i+1) = rdenmean(i/2.)
           rpdenprec75(i:i+1) = rdenprec75(i/2.)
           rpdenprec24(i:i+1) = rdenprec24(i/2.)
           rpdenmed(i:i+1) = rdenmed(i/2.)
        endfor        


        loadct, 6
        !P.multi=[0,2,2]
        set_plot, 'PS'
        device, filename = '../figures/Apples_CRRES_Hu_den_LS.ps', /landscape, /color
                                ;Here we plot the Dst        
        plot, pls, pdenmean, xrange = [0,10], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75] )+5], xstyle = 1, ystyle = 1, $
              xtitle = ' L - Shell', ytitle ='electron density', title = 'Storm time density for EMIC events from CRRES' 
        oplot, pls, pdenprec75, color = 200;, linestyle = 2
        oplot, pls, pdenprec24, color = 50;, linestyle = 2
        ;oplot, pls, pdenmed, color = 50;, linestyle = 4
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pls, opdenmean, xrange = [0,10], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'L - Shell', ytitle ='electron density', title = '3hr before onset' 
        oplot, pls, opdenprec75, color = 200;, linestyle = 2
        oplot, pls, opdenprec24, color = 50;, linestyle = 2
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pls, mpdenmean, xrange = [0,10], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'L - Shell', ytitle ='electron density', title = 'Main phase' 
        oplot, pls, mpdenprec75, color = 200;, linestyle = 2
        oplot, pls, mpdenprec24, color = 50;, linestyle = 2
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50


        plot, pls, rpdenmean, xrange = [0,10], yrange = [0.,max([denprec75, odenprec75, mdenprec75, rdenprec75])+5], xstyle = 1, ystyle = 1, $
              xtitle = 'L - Shell', ytitle ='electron density ', title = 'Recovery phase' 
        oplot, pls, rpdenprec75, color = 200 ;, linestyle = 2
        oplot, pls, rpdenprec24, color = 50  ;, linestyle = 2
        xyouts, 0.5, 300, '75 percent quartile', charsize = .75, color = 200
        xyouts, 0.5, 275, ' mean ', charsize = .75
        xyouts, 0.5, 250, '25 percent quartile', charsize = .75, color = 50
        
        device, /close_file
        close, /all
        
;*****************************************************************
;this is now the polar plot for storm time
;events. *********************************************************
        
        
        theta = findgen(25)*!pi/12.
        lsr = findgen(11)
        
        polarx = lsr * cos(theta)
        polary = lsr * sin(theta)
        
        polarden = fltarr(24., 10.)
        tpolarden =  fltarr(24., 10.)
        
        
;Here we are creating the average electron density for EMIC
;wave events.
        
        tden  = [hden90, hden91] ;t for total
        tmlt = [hmlt90, hmlt91]
        tls = [hls90, hls91]

        for j = 0, n_elements(tpolarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(tden), value = 0)
           inls = where((tls ge j) and (tls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(tpolarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(tden), value = 0)
              inmlt = where((tmlt ge i) and (tmlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 tpolarden(i,j) = mean(tden(use))
              endif else begin
                 tpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor


        
;Here we are creating the average electron density for storm time EMIC
;wave events.
        for j = 0, n_elements(polarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(den), value = 0)
           inls = where((ls ge j) and (ls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(polarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(den), value = 0)
              inmlt = where((mlt ge i) and (mlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 polarden(i,j) = mean(den(use))
              endif else begin
                 polarden(i,j) = 0.
              endelse
           endfor                      
        endfor


;Here we are creating the average electron density for the EMIC wave
;events occurring during the onset phase        
        opolarden = fltarr(24., 10.)

        for j = 0, n_elements(opolarden(0,*))-1 do begin
           olsmeep = make_array(n_elements(oden), value = 0)
           oinls = where((ols ge j) and (ols lt j+1))
           if oinls(0) ne -1 then olsmeep(oinls) = 1
           for i = 0, n_elements(opolarden(*,0))-1 do begin
              omltmeep = make_array(n_elements(oden), value = 0)
              oinmlt = where((omlt ge i) and (omlt lt i+1))
              if oinmlt(0) ne -1 then omltmeep(oinmlt) = 1
              omeep = omltmeep*olsmeep
              ouse = where(omeep eq 1)
;              print, 'use ', ouse(0)
              if ouse(0) ne -1 then begin
;                 print, mean(oden(ouse))
                 opolarden(i,j) = mean(oden(ouse))
              endif else begin
                 opolarden(i,j) = 0.
              endelse
           endfor                      
        endfor

;here we are creating the average electron density for the EMIC wave
;events occurring during the main phase        
        mpolarden = fltarr(24., 10.)

        for j = 0, n_elements(mpolarden(0,*))-1 do begin
           mlsmeep = make_array(n_elements(mden), value = 0)
           minls = where((mls ge j) and (mls lt j+1))
           if minls(0) ne -1 then mlsmeep(minls) = 1
           for i = 0, n_elements(mpolarden(*,0))-1 do begin
              mmltmeep = make_array(n_elements(mden), value = 0)
              minmlt = where((mmlt ge i) and (mmlt lt i+1))
              if minmlt(0) ne -1 then mmltmeep(minmlt) = 1
              mmeep = mmltmeep*mlsmeep
              muse = where(mmeep eq 1)
;              print, 'use ', muse(0)
              if muse(0) ne -1 then begin
;                 print, mean(mden(muse))
                 mpolarden(i,j) = mean(mden(muse))
              endif else begin
                 mpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor
        
;Here we are creatting the average electron density for the EMIC wave
;events occuring during the storm phase.
        rpolarden = fltarr(24., 10.)

        for j = 0, n_elements(rpolarden(0,*))-1 do begin
           rlsmeep = make_array(n_elements(rden), value = 0)
           rinls = where((rls ge j) and (rls lt j+1))
           if rinls(0) ne -1 then rlsmeep(rinls) = 1
           for i = 0, n_elements(rpolarden(*,0))-1 do begin
              rmltmeep = make_array(n_elements(rden), value = 0)
              rinmlt = where((rmlt ge i) and (rmlt lt i+1))
              if rinmlt(0) ne -1 then rmltmeep(rinmlt) = 1
              rmeep = rmltmeep*rlsmeep
              ruse = where(rmeep eq 1)
;              print, 'use ', ruse(0)
              if ruse(0) ne -1 then begin
;                 print, mean(rden(ruse))
                 rpolarden(i,j) = mean(rden(ruse))
              endif else begin
                 rpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor
        denrange = maxdensity ; max([polarden, opolarden, mpolarden, rpolarden, tpolarden]) + 1.
        print, 'max range ', denrange
        noonx = -12. 
        noony = 0
        ymin = -10
        ymax = 10
        xmin = -10
        xmax = 10
        xtit = ''
        ytit = ''
        ych = .05
        xch = .05
        sysms = .5
        ch = .76
        sym = 4
        cl = 8
        

        !P.multi=[0,2,3]
        set_plot, 'PS'
        device, filename = '../figures/Apples_CRRES_Hu_den_polar.ps', /landscape


;Here we are plotting the storm events         
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.,0.5,.45,1.],  $
              title = 'CRRES EMIC storm events', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
;        print, polarden
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(polarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(polarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((polarden(kk,k)/denrange)*255.) ;color = 256.-((polarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



;Here we are plotting the onset events
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.45,0.5,.9,1.],  $
              title = 'pre-onset', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(opolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(opolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((opolarden(kk,k)/denrange)*255.) ;color = 256.-((opolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch


;Here we are plotting the EMIC events during the main phase
        loadct, 0        
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.,0.,.45,.5],  $
              title = 'Main Phase', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
;        print, polarden
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(mpolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(mpolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((mpolarden(kk,k)/denrange)*255.) ;color = 256.-((mpolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



;Here we are plotting the EMIC events during the recovery phase
        loadct, 0        
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.45,0.,.9,.5],  $
              title = 'recovery phase', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(rpolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(rpolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((rpolarden(kk,k)/denrange)*255.) ;color = 256.-((rpolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch

    

                                ;Here we create the color bar for the
                                ;scaling length
        loadct, 0
        denrange = maxdensity
                                ;max([hden90, hden91]) ; max([polarden, opolarden, mpolarden, rpolarden, tpolarden]) + 1.; max(polarden) 
        print, 'max average density ', denrange
        plot,findgen(10), findgen(denrange), pos = [.95,0.,1.,1.], yrange = [0,denrange], ystyle = 1, $
             ytitle = 'electron density per a cubic centimeter', xcharsize = 0.01
       
        loadct, cl, ncolors = max(255)
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 255
        for kk = 1l, floor(256.) -1. do begin
           polyfill, [0,10,10,0], [(denrange/255)*kk,(denrange/255)*kk,(denrange/255)*(kk+1), (denrange/255)*(kk+1)], color = 254 - kk
        endfor


        device, /close_file
        close, /all

       
;****************************** now we will do the same thing, but
;with the median instead of the mean.*****************************
        
        theta = findgen(25)*!pi/12.
        lsr = findgen(11)
        
        polarx = lsr * cos(theta)
        polary = lsr * sin(theta)
        
        polarden = fltarr(24., 10.)
        tpolarden =  fltarr(24., 10.)
        
        
;Here we are creating the average electron density for EMIC
;wave events.
        
        tden  = [hden90, hden91] ;t for total
        tmlt = [hmlt90, hmlt91]
        tls = [hls90, hls91]

        for j = 0, n_elements(tpolarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(tden), value = 0)
           inls = where((tls ge j) and (tls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(tpolarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(tden), value = 0)
              inmlt = where((tmlt ge i) and (tmlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 tpolarden(i,j) = mean(tden(use))
              endif else begin
                 tpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor



;Here we are creating the average electron density for storm time EMIC
;wave events.
        for j = 0, n_elements(polarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(den), value = 0)
           inls = where((ls ge j) and (ls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(polarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(den), value = 0)
              inmlt = where((mlt ge i) and (mlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 polarden(i,j) = median(den(use))
              endif else begin
                 polarden(i,j) = 0.
              endelse
           endfor                      
        endfor


;Here we are creating the average electron density for the EMIC wave
;events occurring during the onset phase        
        opolarden = fltarr(24., 10.)

        for j = 0, n_elements(opolarden(0,*))-1 do begin
           olsmeep = make_array(n_elements(oden), value = 0)
           oinls = where((ols ge j) and (ols lt j+1))
           if oinls(0) ne -1 then olsmeep(oinls) = 1
           for i = 0, n_elements(opolarden(*,0))-1 do begin
              omltmeep = make_array(n_elements(oden), value = 0)
              oinmlt = where((omlt ge i) and (omlt lt i+1))
              if oinmlt(0) ne -1 then omltmeep(oinmlt) = 1
              omeep = omltmeep*olsmeep
              ouse = where(omeep eq 1)
;              print, 'use ', ouse(0)
              if ouse(0) ne -1 then begin
;                 print, median(oden(ouse))
                 opolarden(i,j) = median(oden(ouse))
              endif else begin
                 opolarden(i,j) = 0.
              endelse
           endfor                      
        endfor

;here we are creating the average electron density for the EMIC wave
;events occurring during the main phase        
        mpolarden = fltarr(24., 10.)

        for j = 0, n_elements(mpolarden(0,*))-1 do begin
           mlsmeep = make_array(n_elements(mden), value = 0)
           minls = where((mls ge j) and (mls lt j+1))
           if minls(0) ne -1 then mlsmeep(minls) = 1
           for i = 0, n_elements(mpolarden(*,0))-1 do begin
              mmltmeep = make_array(n_elements(mden), value = 0)
              minmlt = where((mmlt ge i) and (mmlt lt i+1))
              if minmlt(0) ne -1 then mmltmeep(minmlt) = 1
              mmeep = mmltmeep*mlsmeep
              muse = where(mmeep eq 1)
;              print, 'use ', muse(0)
              if muse(0) ne -1 then begin
;                 print, median(mden(muse))
                 mpolarden(i,j) = median(mden(muse))
              endif else begin
                 mpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor
        
;Here we are creatting the average electron density for the EMIC wave
;events occuring during the storm phase.
        rpolarden = fltarr(24., 10.)

        for j = 0, n_elements(rpolarden(0,*))-1 do begin
           rlsmeep = make_array(n_elements(rden), value = 0)
           rinls = where((rls ge j) and (rls lt j+1))
           if rinls(0) ne -1 then rlsmeep(rinls) = 1
           for i = 0, n_elements(rpolarden(*,0))-1 do begin
              rmltmeep = make_array(n_elements(rden), value = 0)
              rinmlt = where((rmlt ge i) and (rmlt lt i+1))
              if rinmlt(0) ne -1 then rmltmeep(rinmlt) = 1
              rmeep = rmltmeep*rlsmeep
              ruse = where(rmeep eq 1)
;              print, 'use ', ruse(0)
              if ruse(0) ne -1 then begin
;                 print, median(rden(ruse))
                 rpolarden(i,j) = median(rden(ruse))
              endif else begin
                 rpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor
        denrange = maxdensity;max([hden90, hden91])
                    ; [polarden, opolarden, mpolarden, rpolarden, tpolarden]) + 1. ;that last number 
                                ;is to get the max density observed by CRRES.
        print, 'max range ', denrange
        noonx = -12. 
        noony = 0
        ymin = -10
        ymax = 10
        xmin = -10
        xmax = 10
        xtit = ''
        ytit = ''
        ych = .05
        xch = .05
        sysms = .5
        ch = .76
        sym = 4
        cl = 8
        

        !P.multi=[0,2,3]
        set_plot, 'PS'
        device, filename = '../figures/Apples_CRRES_Hu_den_polar_med.ps', /landscape


;Here we are plotting the storm events         
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.,0.5,.45,1.],  $
              title = 'Median CRRES EMIC storm events', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
;        print, polarden
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(polarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(polarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((polarden(kk,k)/denrange)*255.) ;color = 256.-((polarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



;Here we are plotting the onset events
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.45,0.5,.9,1.],  $
              title = 'pre-onset', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(opolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(opolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((opolarden(kk,k)/denrange)*255.) ;color = 256.-((opolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch


;Here we are plotting the EMIC events during the main phase
        loadct, 0        
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.,0.,.45,.5],  $
              title = 'Main Phase', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
;        print, polarden
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(mpolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(mpolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((mpolarden(kk,k)/denrange)*255.) ;color = 256.-((mpolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



;Here we are plotting the EMIC events during the recovery phase
        loadct, 0        
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. , yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.45,0.,.9,.5],  $
              title = 'recovery phase', /isotropic, xsty = 4, ysty = 4, ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
;        oplot, /polar,  hls91, hmlt91*(!pi/12.), psym = sym, symsize = syms
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(rpolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(rpolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),(K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),(K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((rpolarden(kk,k)/denrange)*255.) ;color = 256.-((rpolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch

    

                                ;Here we create the color bar for the
                                ;scaling length
        loadct, 0
        denrange = maxdensity ;max([hden90, hden91])
               ; max([polarden, opolarden, mpolarden, rpolarden, tpolarden]) + 1.;max([polarden, tpolarden]) 
        print, 'max average density ', denrange
        plot,findgen(10), findgen(denrange), pos = [.95,0.,1.,1.], yrange = [0,denrange], ystyle = 1, $
             ytitle = 'electron density per a cubic centimeter', xcharsize = 0.01
       
        loadct, cl, ncolors = max(255)
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 255
        for kk = 1l, floor(256.) -1. do begin
           polyfill, [0,10,10,0], [(denrange/255)*kk,(denrange/255)*kk,(denrange/255)*(kk+1), (denrange/255)*(kk+1)], color = 254 - kk
        endfor


        device, /close_file
        close, /all






;stop

end
