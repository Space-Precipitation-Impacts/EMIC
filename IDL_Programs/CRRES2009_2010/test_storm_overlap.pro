pro test_storm_overlap


  figurefolder = '../figures/'
  savefolder = '../Savefiles/'
  tempfolder = '../Templates/'
  datafolder = '../Data/'
  
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

     
print, 'this many storms', n_elements(syear)

  !P.multi = [0,1,1]
  loadct, 6
  set_plot, 'PS'
  plotname = 'Apples_overlap'
  filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
  device, filename=filename1, /landscape , /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches


  plot, findgen(365.*24.*60.*2.), make_array(100, value = 0), yrange = [0,2.*n_elements(syear)+5], $
        xrange = [0,(365.*24.*60.*2.)], ystyle = 1, xstyle = 1

  for k = 0l, n_elements(syear) - 1. do begin     
     onyday = stand2yday(month(k), day(k), syear(k), hh(k), mm(k), 0.)
     mainyday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.)
     recyday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.) + 6.
     
     oyday = stand2yday(month(k), day(k), syear(k), hh(k), mm(k), 0.)
     myday = stand2yday(mmonth(k), mday(k), syear(k), mhour(k), mmm(k), 0.)
     ryday = stand2yday(emonth(k), eday(k), syear(k), ehour(k), emm(k), 0.)

                                ;These are the start and end of the
                                ;storms in fracdays. Again the
                                ;-1's are there to find the
                                ;correct index in the arrays. 
     styday = onyday - (24./24.) -1.
     onyday = onyday -1.
     mainyday = mainyday -1.
     recov = recyday -1.
     ;regular def.
     rstyday = onyday - (3./24.) -1.
     oryday = onyday -1.
     mryday = mainyday -1.
     rryday = recyday -1.

     
     storm = make_array(365.*24.*60., value = !values.F_NAN)
     onphase = make_array(365.*24.*60., value = !values.F_NAN)
     mainphase = make_array(365.*24.*60., value = !values.F_NAN)
     recovphase = make_array(365.*24.*60., value = !values.F_NAN)

     rstorm = make_array(365.*24.*60., value = !values.F_NAN)
     orphase = make_array(365.*24.*60., value = !values.F_NAN)
     mrphase = make_array(365.*24.*60., value = !values.F_NAN)
     rrphase = make_array(365.*24.*60., value = !values.F_NAN)


                                ;Here we put a 1 during the times when
                                ;there is a storm.
     storm(styday*24.*60.:recov*24.*60.) = 1
     onphase(styday*24.*60.:onyday*24.*60.-1) = 1
     mainphase(onyday*24.*60.:mainyday*24.*60.-1) = 1
     recovphase(mainyday*24.*60.:recov*24.*60.) = 1
     
     rstorm(rstyday*24.*60.:rryday*24.*60.) = 1
     orphase(rstyday*24.*60.:oryday*24.*60.-1) = 1
     mrphase(oryday*24.*60.:mryday*24.*60.-1) = 1
     rrphase(mryday*24.*60.:rryday*24.*60.) = 1
     

     dummy = make_array((365.*24.*60.), value = !values.F_NAN)
     if syear(k) eq 1990 then stormp = [storm, dummy]
     if syear(k) eq 1991 then stormp = [dummy, storm]

     if syear(k) eq 1990 then rstormp = [rstorm, dummy]
     if syear(k) eq 1991 then rstormp = [dummy, rstorm]

     oplot,  findgen(365.*24.*60.*2.), stormp*k, thick = 4, color = 200
     oplot,  findgen(365.*24.*60.*2.), rstormp*k, psym = 4, color = 50
  endfor

end





