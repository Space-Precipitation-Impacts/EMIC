pro PhD_emic_plasma
;In this program we are looking at the background magnetic field
;observed by CRRES.
                                ;Here we are deffining the pre-onset
                                ;time, the buffer around EMIC wave
                                ;events and the folders that
                                ;everything is located in.
  preon = 3.                    ;this is in hours
  buffer = 0.                   ;this is in min.
;  minmlt = [12,13,15,17]
;  maxmlt = [13,15,17,19]
  minmlt = [14]
  maxmlt = [18]
  figurefolder = '~/figures/'
  savefolder = '~/Savefiles/'
  tempfolder = '~/Templates/'
  datafolder = '~/Data/'
  restore, '~/Data/model_plasmasphere.save'
  quietave =  model_6_lsmean

                                ;Here are the constants that we might
                                ;need
              
  me = 9.1094d*10^(-28.)             ;G this is the mass of the electron for CGS
  c = double(2.9979*10^10.)       ;cm/s for CGS
  
                                ;Here we are restoring and getting the
                                ;orbit data   
  restore, tempfolder + 'CRRES_orbit_template.save'
  beep = read_ascii(datafolder + 'crres_orbit.txt', template = template)
  CRorbit = beep.orbit
  starttime = beep.start
  CRdoy = beep.doy
  cryear = beep.year

  restore, datafolder + 'CRRES_EMIC_2010.save'
  emcrres90 = oncrres90
  emcrres91 = oncrres91
  emyearmin90 = syearmin90
  emyearmin91 = syearmin91

                                ;Here we are creating a buffer around
                                ;the EMIC wave events and printing how
                                ;many events we have before and after.  
  print, 'number of events to start with', n_elements(where(emcrres90 eq 1)) + n_elements(where(emcrres91 eq 1))
  emcrres90 = same_event_cleaner(emcrres90, buffer, 0.)
  emcrres91 = same_event_cleaner(emcrres91, buffer, 0.)
  print, 'number of events after cleaning', n_elements(where(emcrres90 eq 1)) + n_elements(where(emcrres91 eq 1))
                                ;Now we create an index showing where
                                ;we have the onset of EMIC wave events.
  indexevents90 = where(emcrres90 eq 1)
  indexevents91 = where(emcrres91 eq 1)  
                                ;Now we start looking at the
                                ;storms. First we re-create the file
                                ;names and the template file names
  s1 = strpos('CRRES_storm_phases.txt', '.')
  file2 = strmid('CRRES_storm_phases.txt', 0,s1)
  file3 = strcompress(tempfolder + file2 + '_template.save')
                                ;Now we read in the storm data
  restore, file3
  meep = read_ascii(datafolder + 'CRRES_storm_phases.txt', template = template)
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
                                ;Here we are creating the arrays we
                                ;will need for the different
                                ;magnetospheric conditions.  
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

                                ;Now we are creating the arrays
                                ;with 1's where there were
                                ;those specific conditions.   
  for k = 0l, n_elements(spyear) -1. do begin 
                                ;Here we are finding the yeardays
     onyday = stand2yday(spmonth(k), spday(k), spyear(k), sphour(k), spmin(k), 0.)
     mainyday = stand2yday(spmmonth(k), spmday(k), spyear(k), spmhour(k), spmmin(k), 0.)
     recyday = stand2yday(spemonth(k), speday(k), spyear(k), spehour(k), spemin(k), 0.)
                                ;now we are finding the start of the
                                ;storm, the onset time, the minimum
                                ;sym-H value and the end of the
                                ;recovery phase.
     styday = onyday - (preon/24.) - 1.
     onyday = onyday - 1.
     mainyday = mainyday -1.
     recov = recyday -1.
                                ;now we are putting 1's where
                                ;those conditions occurred.      
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
                                ;now we are finding where there were
                                ;not storms in 1990, and 1991 during the
                                ;CRRES mission. 
  nsindex90 = where(storm90 ne 1) 
  nsindex91 = where(storm91 ne 1)
                                ;And now we can put in the quiet (and
                                ;non-CRRES mission) times
  quiet90(nsindex90) = 1. 
  quiet91(nsindex91) = 1.
                                ;Here we are creating the two year
                                ;long arrays for everything  
  quiet = [quiet90, quiet91]
  storm = [storm90, storm91]
  storm6 = [storm690, storm691]
  onset = [onphase90, onphase91]
  main = [mainphase90, mainphase91]
  recovery = [recovphase90, recovphase91]
  recov6 = [recov6phase90, recov6phase91]

  all = make_array(n_elements(quiet), value = 1.)
                                ;Here we are finding where there are
                                ;EMIC waves during each of the
                                ;magnetospheric conditions.
  qemic90 = emyearmin90*quiet90
  semic90 = emyearmin90*storm90
  s6emic90 = emyearmin90*storm690
  oemic90 = emyearmin90*onphase90
  memic90 = emyearmin90*mainphase90
  remic90 = emyearmin90*recovphase90  
  r6emic90 = emyearmin90*recov6phase90
  qemic91 = emyearmin91*quiet91
  semic91 = emyearmin91*storm91
  s6emic91 = emyearmin91*storm691
  oemic91 = emyearmin91*onphase91
  memic91 = emyearmin91*mainphase91
  remic91 = emyearmin91*recovphase91
  r6emic91 = emyearmin91*recov6phase91
                                ;And now we fit them into a year long
                                ;array.   
  emic = [emyearmin90, emyearmin91]
  qemic = [qemic90, qemic91]
  semic = [semic90, semic91]
  s6emic = [s6emic90, s6emic91]
  oemic = [oemic90, oemic91]
  memic = [memic90, memic91]
  remic = [remic90, remic91]
  r6emic = [r6emic90, r6emic91]

;stop

  magcondition = [[all], [quiet], [storm], [onset], [main], [recovery], [recov6], [qemic], [semic], [oemic], [memic], [remic], [r6emic]]
  filecondition = ['all', 'quiet', 'storm', 'pre', 'main', 'recovery', 'extended_recovery', 'quiet_EMIC',$
                   'storm_EMIC','pre_EMIC', 'main_EMIC', 'recov_EMIC', 'recov6_emic']
  titlecondition = ['all', 'quiet', 'storm', 'pre-onset', 'main', 'recovery', 'extended recovery', 'quiet EMICs', $
                    'storm EMICs','pre-onset EMICs','main EMICs', 'recovery EMICs', 'extended recovery EMICs']
 
                                ;Here we are restoring the magnetic
                                ;field data
  restore, datafolder + 'CRRES_srv1min_1990.save'
  restore, datafolder + 'CRRES_srv1min_1991.save'  
                                ;Now we are creating the total magnetic
                                ;field data.
  mag90 = sqrt(bx90^2. + by90^2. + bz90^2.)
  mag91 = sqrt(bx91^2. + by91^2. + bz91^2.)
  mag = [mag90, mag91]
  restore, datafolder + 'CRRES_1min_1990.save'
  restore, datafolder + 'CRRES_1min_1991.save'  
  den = [den90, den91]
  ls = [ls90, ls91]
  mlt = [mlt90, mlt91]
  mlat = [mlat90, mlat91]
  good = where(finite(mlat))

;  xehist = [0., .5, .5, 1., 1., 1.5, 1.5, 2., 2., 2.5, 2.5, 3., 3., 3.5, 3.5, 4., 4., 4.5, 4.5, 5., 5., 5.5, 5.5, 6., 6., 6.5, 6.5, 7., 7., 7.5, 7.5, 8.]
  tempx = findgen(41.) /5.
  xehist = make_array(n_elements(tempx)*2)
  xehist(0) = 0
  for i = 1l, n_elements(xehist) -2, 2 do begin 
     xehist(i:i+1) = tempx((i+1)/2)
  endfor
  xehist(n_elements(xehist) -1) = 8.1
;print, xehist 
;stop
  countemic = make_array(n_elements(xehist)/2)
  counts6 =  make_array(n_elements(xehist)/2)
  counto = make_array(n_elements(xehist)/2)
  countm = make_array(n_elements(xehist)/2)
  countr = make_array(n_elements(xehist)/2)
  countr6 = make_array(n_elements(xehist)/2)

  ;print,'number of good elements',  n_elements(good)


;***************************************
                                ;here we want to create a plot that
                                ;includes all the different ways of
                                ;looking for a model of the
                                ;plasmasphere. We'll start with
                                ;just the average over the entire
                                ;mission. 
for loop = 0l, n_elements(minmlt)-1 do begin 
  mltindex = where((mlt ge minmlt(loop)) and (mlt le maxmlt(loop)))
  tempindex = make_array(N_elements(ls), value = !values.F_NAN)
  tempindex(mltindex) = 1
  ls = ls*tempindex
  den = den*tempindex
  nummin = n_elements(where(finite(emic*tempindex)))
  print, 'normalizing EMIC number', nummin
  semic = emic*tempindex * storm
  s6emic = emic*tempindex * storm6
  oemic = emic*tempindex * onset
  memic = emic*tempindex * main
  remic = emic*tempindex * recovery
  r6emic = emic*tempindex * recov6
  ;print, n_elements(where(finite(semic)))
;stop

                                ;Here we start by finding the average
                                ;density observed by CRRES across
                                ;L-shells. 
  step = tempx(1) - tempx(0)
  for i = 0l, n_elements(tempx)-1. do begin 
     temp = where((ls ge tempx(i)) and (ls lt (tempx(i)+ step)))
     if temp(0) ne -1 then begin 
        tempemic =  n_elements(where(finite(semic(temp)))) 
        temps6 =  n_elements(where(finite(s6emic(temp))))
        tempo =  n_elements(where(finite(oemic(temp))))
        tempm =  n_elements(where(finite(memic(temp))))
        tempr =  n_elements(where(finite(remic(temp))))
        tempr6 =  n_elements(where(finite(r6emic(temp))))
        
        if tempemic(0) ne -1 then countemic(i) = tempemic else countemic(i) = 0
        if temps6(0) ne -1 then counts6(i) = temps6 else counts6(i) = 0
        if tempo(0) ne -1 then counto(i) = tempo else counto(i) = 0
        if tempm(0) ne -1 then countm(i) = tempm else countm(i) = 0
        if tempr(0) ne -1 then countr(i) =  tempr else countr(i) = 0
        if tempr6(0) ne -1 then countr6(i) = tempr6 else countr6(i) = 0
     endif else begin 
        countemic(i) = 0
        counts6(i) = 0
        counto(i) = 0
        countm(i) = 0
        countr(i) = 0
        countr6(i) = 0
     endelse
    ; print, temp(0)
  endfor


  ehist = make_array(n_elements(xehist))
  s6hist  = ehist               ;make_array(n_elements(countemic)*2)
  ohist = ehist                 ;make_array(n_elements(countemic)*2) 
  mhist = ehist                 ;make_array(n_elements(countemic)*2)
  rhist = ehist                 ;make_array(n_elements(countemic)*2)
  r6hist = ehist                ;make_array(n_elements(countemic)*2)

  ;print, 'ehist is '
  ;print, total(emic, /nan)
  ;print, countemic

  for i = 0l, n_elements(ehist) -1, 2 do begin 
     ehist(i:i+1) = countemic(i/2)
     s6hist(i:i+1) = counts6(i/2)
     ohist(i:i+1) = counto(i/2)
     mhist(i:i+1) = countm(i/2)
     rhist(i:i+1) = countr(i/2)
     r6hist(i:i+1) = countr6(i/2)
 endfor

  numls = 80

  model_all_ls = ls
  model_all_den = den
  model_1_lsmean = make_array(numls, value = !values.F_NAN)
  m1_e =  make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_all_ls ge i/10.) and (model_all_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_all_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_1_lsmean(i) = quart(2)
        m1_e(i) = n_elements(where(finite(emic(index))))
     endif
  endfor

  hist1 = make_array(2.*N_elements(m1_e), value = !values.F_NAN)
  for i = 0l, n_elements(m1_e)-1 do hist1(i*2:i*2+1) = m1_e(i)

                                ;endif
  
                                ;Now we will use the quiet time (from
                                ;80% recovery) to find an average.
  model_s_ls = ls*storm
  model_s_den = den*storm
  model_2_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_s_ls ge i/10.) and (model_s_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_s_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_2_lsmean(i) = quart(2)
     endif
  endfor

                                ;endif
  
                                ;Now we will use the quiet time (from
                                ;+6 day recovery) to find an average.
  model_s6_ls = ls*storm6
  model_s6_den = den*storm6
  model_3_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_s6_ls ge i/10.) and (model_s6_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_s6_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_3_lsmean(i) = quart(2)
     endif
  endfor

  model_on_ls = ls*onset
  model_on_den = den*onset
  model_4_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_on_ls ge i/10.) and (model_on_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_on_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_4_lsmean(i) = quart(2)
     endif
  endfor

  model_main_ls = ls*main
  model_main_den = den*main
  model_5_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_main_ls ge i/10.) and (model_main_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_main_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_5_lsmean(i) = quart(2)
     endif
  endfor

  model_rec_ls = ls*recovery
  model_rec_den = den*recovery
  model_6_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_rec_ls ge i/10.) and (model_rec_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_rec_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_6_lsmean(i) = quart(2)
     endif
  endfor


  model_rec6_ls = ls*recov6
  model_rec6_den = den*recov6
  model_7_lsmean = make_array(numls, value = !values.F_NAN)
  ls75 = make_array(numls, value = !values.F_NAN)
  ls25 = make_array(numls, value = !values.F_NAN)
  for i = 0l, numls-1 do begin
     index = where((model_rec6_ls ge i/10.) and (model_rec6_ls lt(i+1.)/10.))
     if index(0) ne -1 then begin 
        dentemp = model_rec6_Den(index)
        quart = quartiles(dentemp)
        ls75(i) = quart(0)
        ls25(i) = quart(1)
        model_7_lsmean(i) = quart(2)
     endif
  endfor


  xls = findgen(numls)/10.
  model_8 =  1390.*(3./xls)^4.83
  model_8a = 1390.*(3./xls)^4.83 + 440.*(3/xls)^3.6
  model_8b = 1390.*(3./xls)^4.83 - 440.*(3/xls)^3.6
  model_9 = make_array(n_elements(xls), value = 10.)
  cut_off = make_array(n_elements(xls), value = 1984.)
  
                                ;Here we are going to plot all of this 
  xhist = make_array(n_elements(xls) *2.)
  for i = 0l, n_elements(xls)-1 do xhist(i*2:i*2+1) = xls(i)
  denmin = 1
  denmax = 100000
  loadct, 6

  !P.multi = [0,1,2]
  set_plot, 'PS'
  plotname = strcompress( figurefolder + 'model_storm_plasmasphere_'+string(minmlt(loop))+'_'+string(maxmlt(loop))+'.ps', /remove_all)
  device, filename = plotname, /landscape, /color
  plot, xls, model_2_lsmean, ytitle = 'log number density',$ xtitle = 'L-Shell', $
        title ='Average plasmasphere density from Mlt '+strcompress('= '+string(minmlt(loop)), /remove_all)+' to Mlt '+ strcompress('= '+string(maxmlt(loop)), /remove_all),yrange = [denmin,denmax],$
        /ylog, thick = 4, xrange = [3,8], xstyle = 1, ystyle = 1, pos = [0., .33, 1., 1.]
  xyouts, 6,200, 'R80 Storm', charsize =  xych
;  xyouts, 5.,450, 'Average density observed by CRRES', charsize =  xych
  loadct, 5, ncolors = 256
;  oplot, xls, model_2_lsmean, color = 20, thick = 4

  oplot, xls, model_3_lsmean, color = 100, thick = 4
  xyouts, 6,275, 'R6D Storm', charsize =  xych, color = 100
;  oplot, xls, model_8, color = 150, thick = 4
;  xyouts, 6,130, 'Sheeley et al 2001', charsize =  xych, color = 150
;  oplot, xls, model_8a, color = 150, thick = 4
;  xyouts, 6,130, 'Sheeley et al 2001 (+)', charsize =  xych, color = 150
;  oplot, xls, model_8b, color = 175, thick = 4
;  xyouts, 6,100, 'Sheeley et al 2001 (-)', charsize =  xych, color = 175
  oplot, xls, model_9, color = 0., thick = 4
  xyouts, 3.1,11, '10 cm^-3', charsize =  xych, color = 0
  oplot, xls, cut_off, color = 40., thick = 4
  xyouts, 3.1,2100, 'Upper limit on CRRES', charsize =  xych, color = 40
  oplot, xls, quietave, color = 20, thick = 4, linestyle = 2 ;, psym = 4
  xyouts, 6, 530, 'quiet baseline', charsize =  xych, color = 20  
;  plot, xhist, hist1
  
  plot, xehist, ehist/nummin*100., xtitle = 'L-value', ytitle = '% of EMIC', pos = [0., 0., 1., .27],$
        xrange = [3,8], xstyle = 1, yrange = [0, max([ehist/nummin*100., s6hist/nummin*100.], /nan)]
  oplot, xehist, ehist/nummin*100., color = 20
  oplot, xehist, s6hist/nummin*100., color = 100;pos = [0., 0., 1., .27]
  device, /close_file  

  !P.multi = [0,1,2]
  set_plot, 'PS'
  plotname = strcompress( figurefolder + 'model_preonset_plasmasphere_'+string(minmlt(loop))+'_'+string(maxmlt(loop))+'.ps', /remove_all)
  device, filename = plotname, /landscape, /color
  plot, xls, model_4_lsmean, ytitle = 'log number density',$ xtitle = 'L-Shell', $
        title ='Average plasmasphere density from Mlt '+strcompress('= '+string(minmlt(loop)), /remove_all)+' to Mlt '+ strcompress('= '+string(maxmlt(loop)), /remove_all),yrange = [denmin,denmax],$
        /ylog, thick = 4, xrange = [3,8], xstyle = 1, ystyle = 1, pos = [0.,.33,1., 1.]
  xyouts, 6,140, 'Pre-onset phase', charsize =  xych
;  oplot, xls, model_8, color = 150, thick = 4
;  xyouts, 6,130, 'Sheeley et al 2001', charsize =  xych, color = 150
;  oplot, xls, model_8a, color = 150, thick = 4
;  xyouts, 6,275, 'Sheeley et al 2001 (+)', charsize =  xych, color = 150
;  oplot, xls, model_8b, color = 175, thick = 4
;  xyouts, 6,200, 'Sheeley et al 2001 (-)', charsize =  xych, color = 175
  oplot, xls, model_9, color = 0., thick = 4
  xyouts, 3.1,11, '10 cm^-3', charsize =  xych, color = 0
  oplot, xls, cut_off, color = 40., thick = 4
  xyouts, 3.1,2100, 'Upper limit on CRRES', charsize =  xych, color = 40
 oplot, xls, quietave, color = 20, thick = 4, linestyle = 2;, psym = 4
  xyouts, 6,400, 'quiet baseline', charsize =  xych, color = 20  
  plot, xehist, ohist/nummin*100., xtitle = 'L-value', ytitle = '% of EMIC', pos = [0., 0., 1., .27],$
        xrange = [3,8], xstyle = 1
  device, /close_file
  print, 'pre-onset hist', ohist
 

  !P.multi = [0,1,2]
  set_plot, 'PS'
  plotname = strcompress( figurefolder + 'model_main_plasmasphere_'+string(minmlt(loop))+'_'+string(maxmlt(loop))+'.ps', /remove_all)
  device, filename = plotname, /landscape, /color
  plot, xls, model_5_lsmean, ytitle = 'log number density', $xtitle = 'L-Shell', $
        title ='Average plasmasphere density from Mlt '+ strcompress('= '+string(minmlt(loop)), /remove_all)+' to Mlt '+strcompress('= '+string(maxmlt(loop)), /remove_all),yrange = [denmin,denmax],$
        /ylog, thick = 4, xrange = [3,8], xstyle = 1, ystyle = 1, pos = [0., .33, 1., 1.]
  xyouts, 6,140, 'Main phase', charsize =  xych 
;  oplot, xls, model_8, color = 150, thick = 4
;  xyouts, 6,275, 'Sheeley et al 2001', charsize =  xych, color = 150
;  oplot, xls, model_8a, color = 150, thick = 4
;  xyouts, 6,275, 'Sheeley et al 2001 (+)', charsize =  xych, color = 150
;  oplot, xls, model_8b, color = 175, thick = 4
;  xyouts, 6,200, 'Sheeley et al 2001 (-)', charsize =  xych, color = 175
  oplot, xls, model_9, color = 0., thick = 4
  xyouts, 3.1,11, '10 cm^-3', charsize =  xych, color = 0
  oplot, xls, cut_off, color = 40., thick = 4
  xyouts, 3.1,2100, 'Upper limit on CRRES', charsize =  xych, color = 40
 oplot, xls, quietave, color = 20, thick = 4, linestyle = 2;, psym = 4
  xyouts, 6,400, 'quiet baseline', charsize =  xych, color = 20  
  plot, xehist, mhist/nummin*100., xtitle = 'L-value', ytitle = '% of EMIC', pos = [0., 0., 1., .27],$
        xrange = [3,8], xstyle = 1
  device, /close_file

  !P.multi = [0,1,2]
  set_plot, 'PS'
  plotname = strcompress( figurefolder + 'model_recovery_plasmasphere_'+string(minmlt(loop))+'_'+string(maxmlt(loop))+'.ps', /remove_all)
  device, filename = plotname, /landscape, /color
  plot, xls, model_6_lsmean, thick = 4, ytitle = 'log number density', $
        title ='Average plasmasphere density from Mlt '+ strcompress('= '+string(minmlt(loop)), /remove_all)+' to Mlt '+strcompress('= '+string(maxmlt(loop)), /remove_all),yrange = [denmin,denmax],$
        /ylog, xrange = [3,8] , xstyle = 1, ystyle = 1, pos = [0., .33, 1., 1.]
  xyouts, 6,400, 'R80 phase', charsize =  xych
  oplot, xls, model_7_lsmean, color = 100, thick = 4
  xyouts, 6,560, 'R6D phase', charsize =  xych, color = 100
;  oplot, xls, model_8, color = 150, thick = 4
;  xyouts, 6,275, 'Sheeley et al 2001', charsize =  xych, color = 150
;  oplot, xls, model_8a, color = 150, thick = 4
;  xyouts, 6,275, 'Sheeley et al 2001 (+)', charsize =  xych, color = 150
;  oplot, xls, model_8b, color = 175, thick = 4
;  xyouts, 6,200, 'Sheeley et al 2001 (-)', charsize =  xych, color = 175
  oplot, xls, model_9, color = 0., thick = 4
  xyouts, 3.1, 11, '10 cm^-3', charsize =  xych, color = 0
  oplot, xls, cut_off, color = 40., thick = 4
  xyouts, 3.1,2100, 'Upper limit on CRRES', charsize =  xych, color = 40
  oplot, xls, quietave, color = 20, thick = 4, linestyle = 2 ;, psym = 4
  xyouts, 6, 780, 'quiet baseline', charsize =  xych, color = 20  
  plot, xehist, rhist/nummin*100., xtitle = 'L-value', ytitle = '% of EMIC', pos = [0., 0., 1., .27],$
        xrange = [3,8], xstyle = 1, yrange = [0, max([ehist/nummin*100., s6hist/nummin*100.], /nan)]
  oplot, xehist, r6hist/nummin*100., color = 100
  device, /close_file

  notes = 'model 1 is the average density, model 2 is the average storm as defined by the 80% recovery, model 3 is the average storm as defined by the  + 6 day recovery, model 4 is the average pre-onset phase, model 5 is the main phase, model 6 is the average 80% recovery , model_7_lsmean is the + 6 day recovery phase, model 8a is the Sheeley et al 2001 with the +, 8b is the Sheeley et al 2001 with the -, model_9 is the 10 particles per a cubic centimeter, and the cut_off is the highest density CRRES could record. xls is the xvalues to go with those arrays. This save file was created by the program model_plasmapshere.pro'
  save, model_1_lsmean, model_2_lsmean, model_3_lsmean, model_4_lsmean, model_5_Lsmean, $
        model_6_lsmean, model_7_lsmean, model_8a, model_8b, model_9, cut_off, notes, xls,  filename = '../Data/model_storm_plasmasphere'+string(minmlt(loop))+'_'+string(maxmlt(loop))+'.save'

endfor

end
