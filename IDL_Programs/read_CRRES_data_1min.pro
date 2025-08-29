pro read_CRRES_data_1min;, tempf, dataf
;This program attempts to read in all the CRRES data and possibly
;write it to ascii files for each year, but more importantly it writes
;everything to save files. 
  
;here we restore and read in the cr file which will allow us to put
;times and orbits with all of the other CRRES data

  tempf = '../Templates/'
  dataf = '../Data/'
  resamplerate = 60.            ;this needs to be in seconds. 
  nyfr = 1./(2.*resamplerate)   ;the nyquist frequency 
  
  
  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crfiles.shr', template = template)
  ssorbit = meep.field01
  ssyear = meep.field02
  ssmonth = meep.field03
  ssday = meep.field04
  filename1 = meep.field14
  ephfilenames = strarr(N_elements(filename1))
  ephorb = make_array(N_elements(filename1))
  for i = 0l, n_elements(filename1)-1. do begin 
     

     ephfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(i)+'.eph')

     restore, tempf+'CRRES_eph_template.save'
     jeep = read_ascii(ephfile, template = template)
 
     orbit = make_array(N_elements(jeep.field1), value = ssorbit(i))
     year = make_array(n_elements(jeep.field1), value = ssyear(i))
     month = make_array(n_elements(jeep.field1), value = ssmonth(i))
     day = make_array(n_elements(jeep.field1), value = ssday(i))
     

     mileph = jeep.field1
     LS =  jeep.field2
     rad = jeep.field3
     loct = jeep.field4
     mlt = jeep.field5
     mlat = jeep.field6
;     help, jeep.field1
;     print, 'year month day', year(0), month(0), day(0)
;     print, 'mileph(0)', mileph(0)
;     print, 'mileph(last)', mileph(n_elements(mileph)-1)
     
                                ;now I want to rebin everything to 1 min resolution.
                                ;first lets change the millisecond to
                                ;min. and find the length to make the
                                ;array to.
     mineph = mileph/(10^(3.)*60.)
     yd = stand2yday(month(0), day(0), year(0), 0., 0., 0.)
     syearmin = yd*24.*60. + (mineph(0))
     eyearmin = yd*24.*60. + (mineph(n_elements(mineph)-1))
     length = floor(eyearmin - syearmin)
     old_array = mineph - mineph(0)
     new_array = findgen( floor(eyearmin - syearmin))*old_array(n_elements(old_array)-1)/(floor(eyearmin-syearmin)) ;+ syearmin
;     help, length
                                ;For the ephemeris data I am not doing
                                ;a digital filter. since its already
                                ;in a min time series.

     time_eph = findgen(length) + floor(syearmin)
     lshell = interpol(LS, old_array, new_array)
     radius = interpol(rad, old_array, new_array)
     localtime = interpol(loct, old_array, new_array)
     magLT = interpol(mlt, old_array, new_array)
     maglat = interpol(mlat, old_array, new_array)
     sorbit = interpol(orbit, old_array, new_array)
     syear = interpol(year, old_array, new_array)
     smonth = interpol(month, old_array, new_array)
     sday = interpol(day, old_array, new_array)


     if orbit(0) eq 387 then help, lshell
     if orbit(0) eq 387 then help, sday
;*********************************************************************************     

     
     savefilename = strcompress('../Data/Min_CRRES_data/crres_pos_1min_'+string(sorbit(0))+'_data.save', /remove_all)

     save, sorbit, syear, smonth, sday, time_eph, lshell, radius, localtime, magLT, maglat,$
           filename = savefilename
     ephfilenames(i) = savefilename
     ephorb(i) = sorbit(0)

  endfor

;spliting up so that I can get rid of the bad data files. 

  
  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crfilesxyz.shr', template = template)
  sorbit = meep.field01
  syear = meep.field02
  smonth = meep.field03
  sday = meep.field04
  filename1 = meep.field14
  psnfilenames = strarr(n_elements(filename1))
  psnorb = make_array(n_elements(filename1))

 for i = 0l, n_elements(filename1)-1. do begin 



     psnfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(i)+'.psn')

     restore, tempf + 'CRRES_psn_template.save'
     beep = read_ascii(psnfile, template = template)

     milpsn = beep.field1
     x_eci = beep.field2
     y_eci = beep.field3
     z_eci = beep.field4

     savefilexyzraw = strcompress('../Data/CRRES_data/crres_pos_'+string(sorbit(i))+'_data.save' , /remove_all)
     save, milpsn, x_eci, y_eci, z_eci, $
           filename = savefilexyzraw
     

     minpsn = milpsn/(10^(3.)*60.)
     yd = stand2yday(smonth(i), sday(i), syear(i), 0., 0., 0.)
     syearminps = yd*24.*60. + (minpsn(0))
     eyearminps = yd*24.*60. + (minpsn(n_elements(minpsn)-1))
     psnlength = floor(eyearminps - syearminps)
     old_array = minpsn - minpsn(0)
     new_array = findgen(floor(eyearminps - syearminps))*old_array(n_elements(old_array)-1)/(floor(eyearminps-syearminps))

     time_psn = findgen(psnlength) + floor(syearminps)
     sx_eci = interpol(x_eci, old_array, new_array)
     sy_eci = interpol(y_eci, old_array, new_array)
     sz_eci = interpol(z_eci, old_array, new_array)

;stop
     ephfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(i)+'.eph')

     restore, tempf+'CRRES_eph_template.save'
     jeep = read_ascii(ephfile, template = template)


     orbit = make_array((psnlength), value = sorbit(i))
     year = make_array((psnlength), value = syear(i))
     month = make_array((psnlength), value = smonth(i))
     day = make_array((psnlength), value = sday(i))


     
     savefilename = strcompress('../Data/Min_CRRES_data/crres_xyz_1min_'+string(sorbit(i))+'_data.save', /remove_all)

     save, orbit, year, month, day,$
           time_psn, sx_eci, sy_eci, sz_eci, $
           filename = savefilename
     psnfilenames(i) = savefilename
     psnorb(i) = orbit(0)
     
  endfor



  restore, tempf+ 'CRRES_den_filenames_template.save'
  denf = strcompress(dataf + 'CRRES_data/CRRES_particle_filenames.txt')
  deep = read_ascii(denf, template = template)
  denfile = deep.field1

  denfilenames  = strarr(N_elements(denfile))
  denorb = make_array(N_elements(denfile))

  for k = 0l, n_elements(denfile) -1 do begin 
     restore, tempf+'CRRES_den_template.save'
     feep = read_ascii(dataf+'CRRES_data/'+denfile(k), template = template)
     
     storb = strmid(denfile(k),21,4)
     yrday =  feep.field2
     strtime =  feep.field3
     fce = feep.field4
     fuhr = feep.field5
     fpe = feep.field6
     den = feep.field7
     if min(feep.field2) lt 90000 then print, 'bad data in file ', denfile(k)

     year = floor(yrday/1000.)
     yday = yrday - (year*1000.)

     hr = long(strmid(strtime, 0, 2))*60.
     mm = long(strmid(strtime, 3, 2))
     ss = long(strmid(strtime, 6, 2))/60.
     
     yearmin = yday*24.*60. + hr + mm + ss
     length = floor(yearmin(n_elements(yearmin) -1) - yearmin(0)))
     time_den = findgen(length)+floor(yearmin(0)) +1
                                ;Now we are going to filter out any
                                ;induced digital signal we might get
                                ;by resampling. 
stop
     fftden = fft(den)
     filterden = make_array(n_elements(den), value = 1)

                                ;Here we make the array of the time steps between each index
     deltaden = (yearmin(1:n_elements(yearmin)-1) - yearmin(0:n_elements(yearmin)-2))*60. ; this is in seconds
                                ;here we are  determining the
                                ;frequency represented in each of the
                                ;indexes.  
     freqden = findgen(N_elements(fftden))/(n_elements(den)*deltaden)
                                ;Since we are wanting to move to a 1
                                ;sample per a min. we have a nyquist
                                ;frequency of (1./120.) so here we are
                                ;trying to find at which index that
                                ;corresponds to. 
     find = abs((1./120.) - freqden)
     findmin = min(find) 
     index = where(findmin eq abs(find))
     if index(0) ne -1. then hif = index(0) else stop

                                ;Here we are creating the filter.     
     filterden(hif:n_elements(den)- hif) = 0
     filterden([ hif-1,n_elements(den) - hif+1]) = .3
     filterden([ hif-2,n_elements(den) - hif+2]) = .6
                                ;Here we apply that filter
     filtfftden = filterden*fftden
                                ;Now we take the inverse fft
     Dfft = fft(filtfftden, /inverse)

     den1 = congrid(dfft, length, /interp)

     savefilename2 = strcompress( '../Data/Min_CRRES_data/crres_den_data_'+storb+'.save' , /remove_all)

                                ;Because I'm not sure what to
                                ;do at the moment for the
                                ;filter since we are putting this on a
                                ;min. grid we'll just do the den.

     save, yday, hr, mm, ss, time_den, den1, $
           filename = savefilename2

     denfilenames(k) = savefilename2
     denorb(k) = long(storb)
;stop
  endfor
                      
  savefilenames = strcompress( '../Data/Min_CRRES_data/min_psn_eph_den_files.save' , /remove_all)
  save, psnfilenames, ephfilenames, denfilenames, denorb, ephorb, psnorb, filename = savefilenames

end
