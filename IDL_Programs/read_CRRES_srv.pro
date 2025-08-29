pro read_CRRES_srv;, tempf, dataf
;This program attempts to read in all the CRRES data and possibly
;write it to ascii files for each year, but more importantly it writes
;everything to save files. 


  tempf = '../Templates/'
  dataf = '../Data/'
                                ;here we restore and read in the cr
                                ;file which  will allow us to put
                                ;times and orbits with all of the
                                ;other CRRES data
  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crsrvfiles.shr', template = template)
  sorbit = meep.field01
  syear = meep.field02
  smonth = meep.field03
  sday = meep.field04
  filename1 = meep.field14

;stop
  for i = 0l, n_elements(filename1)-1. do begin 
                                ;now we create the file names of the
                                ;srv files which seem to have
                                ;processed data of some sort,
                                ;hopefully what we need. It appears
                                ;that the resolution size is 5 - 7 sec.
  srvfile = strcompress(dataf+'CRRES_data/srv_files/'+filename1(i)+'.srv')
  srvsavefile = strcompress(dataf+'CRRES_data/srv_files/'+filename1(i)+'.save') 
  srvsavefilemin =  strcompress(dataf+'CRRES_data/srv_files/'+filename1(i)+'_1min.save') 
  restore, tempf+'CRRES_srv_template.save'
  jeep = read_ascii(srvfile, template = template) 
  orbit = make_array(N_elements(jeep.field01), value = sorbit(i))
  year = make_array(n_elements(jeep.field01), value = syear(i))
  month = make_array(n_elements(jeep.field01), value = smonth(i))
  day = make_array(n_elements(jeep.field01), value = sday(i))
  milsrv = jeep.field01
  Bx = jeep.field13
  By = jeep.field14
  Bz = jeep.field15
  mlt = jeep.field28
  ls = jeep.field29
  mlat = jeep.field30
  if year(0) eq 1990 then   print, 'on loop ', i, ' file name ', srvfile
                                ;now we save the data into save files
                                ;for each orbit to be strung together later.
  save, orbit, year, month, day, bx, by, bz, mlt, ls, mlat, milsrv, filename = srvsavefile
                                ;now I want to rebin everything to 1 min resolution.
                                ;first lets change the millisecond to
                                ;min. and find the length to make the
                                ;array to.
     minsrv = milsrv/(10^(3.)*60.)
     yd = stand2yday(month(0), day(0), year(0), 0., 0., 0.)
     syearmin = yd*24.*60. + (minsrv(0))
     eyearmin = yd*24.*60. + (minsrv(n_elements(minsrv)-1))
     length = floor(eyearmin - syearmin)
     old_array = minsrv - minsrv(0)
     new_array = findgen(length)*old_array(n_elements(old_array)-1)/length
                                ;+ syearmin

     hr = floor(minsrv/60.)
;     hr = long(strmid(strtime, 0, 2))*60.
     mm = floor(minsrv - hr*60.) 
;     mm = long(strmid(strtime, 3, 2))
     ss = floor((milsrv/10^(3)) - mm*60.)
;     ss = long(strmid(strtime, 6, 2))/60.
                                ;Here we are creating the time arrays
;     yday = stand2yday(month(0), day(0), year(0), 0, 0, 0)
;     yearmin = (yday*24.*60.) + (hr*60.) + mm + (ss/60.)
;     length = floor(yearmin(n_elements(yearmin) -1) - yearmin(0))
;     time_srv = findgen(length)+floor(yearmin(0)) +1
                                ;Here we are interpolating this data
                                ;to a 1 min time scale. Make sure to
                                ;check this with what I already have
                                ;to make sure they agree.
     time_srv = findgen(length) + floor(syearmin)
     lshell = interpol(LS, old_array, new_array)
     maglt = interpol(mlt, old_array, new_array)
     maglat = interpol(mlat, old_array, new_array)
     orbit1 = interpol(orbit, old_array, new_array)
     year1 = interpol(year, old_array, new_array)
     month1 = interpol(month, old_array, new_array)
     day1 = interpol(day, old_array, new_array)
     Bx1 = interpol(bx, old_array, new_array)
     By1 = interpol(by, old_array, new_array)
     Bz1 = interpol(bz, old_array, new_array)


     save, time_srv, lshell, maglt, maglat, orbit1, year1, month1, day1, bx1, by1, bz1, filename =  srvsavefilemin
;     stop
  endfor

end
;**************** this needs to be figured out!********************
                                ;Now we are going to filter the
                                ;magnetic field data. I'm using
                                ;the same method as I did for the
                                ;density data in order to hopefully
                                ;reduce any aliasing and other imposed
                                ;frequencies. All we want at this
                                ;moment are the main field measurements.
;     fftbx = fft(bx)
;     filterBx = make_array(n_elements(Bx), value = 1)
;                                ;Here we make the array of the time steps between each index
;     deltabx = (yearmin(1:n_elements(yearmin)-1) - yearmin(0:n_elements(yearmin)-2))*60. ; this is in seconds
;                                ;here we are  determining the
;                                ;frequency represented in each of the
;                                ;indexes.  
;     freqbx = findgen(N_elements(fftbx))/(n_elements(bx)*deltabx)
;                                ;Since we are wanting to move to a 1
;                                ;sample per a min. we have a nyquist
;                                ;frequency of (1./120.) so here we are
;                                ;trying to find at which index that
;                                ;corresponds to. 
;     find = abs((1./120.) - freqbx)
;     findmin = min(find) 
;     index = where(findmin eq abs(find))
;     if index(0) ne -1. then hif = index(0) else stop
;                                ;Here we are creating the filter.     
;     filterbx(hif:n_elements(bx)- hif) = 0
;     filterbx([ hif-1,n_elements(bx) - hif+1]) = .3
;;     filterbx([ hif-2,n_elements(bx) - hif+2]) = .6
;                                ;Here we apply that filter
;     filtfftbx = filterbx*fftbx
;                                ;Now we take the inverse fft
;     Dfft = fft(filtfftbx, /inverse)
;                                ;Now we are putting the magnetic field
;                                ;back onto the 1 min resolution grid.
;     bx1 = congrid(dfft, length, /interp)
;                                ;now we'll do the same for By
;     fftby = fft(by)
;     filterBy = make_array(n_elements(By), value = 1)
;                                ;Here we make the array of the time steps between each index
;     deltaby = (yearmin(1:n_elements(yearmin)-1) - yearmin(0:n_elements(yearmin)-2))*60. ; this is in seconds
;                                ;here we are  determining the
;                                ;frequency represented in each of the
;                                ;indexes.  
;     freqby = findgen(N_elements(fftby))/(n_elements(by)*deltaby)
;                                ;Since we are wanting to move to a 1
;                                ;sample per a min. we have a nyquist
;                                ;frequency of (1./120.) so here we are
;                                ;trying to find at which index that
;                                ;corresponds to. 
;     find = abs((1./120.) - freqby)
;     findmin = min(find) 
;     index = where(findmin eq abs(find))
;     if index(0) ne -1. then hif = index(0) else stop
;                                ;Here we are creating the filter.     
;     filterby(hif:n_elements(by)- hif) = 0
;     filterby([ hif-1,n_elements(by) - hif+1]) = .3
;     filterby([ hif-2,n_elements(by) - hif+2]) = .6
;                                ;Here we apply that filter
;     filtfftby = filterby*fftby
;                                ;Now we take the inverse fft
;     Dfft = fft(filtfftby, /inverse)
;                                ;Now we are putting the magnetic field
;                                ;back onto the 1 min resolution grid.
;     by1 = congrid(dfft, length, /interp)
;                                ;Now we'll do the same for Bz
;     fftbz = fft(bz)
;     filterBz = make_array(n_elements(Bz), value = 1)
;                                ;Here we make the array of the time steps between each index
;     deltabz = (yearmin(1:n_elements(yearmin)-1) - yearmin(0:n_elements(yearmin)-2))*60. ; this is in seconds
;                                ;here we are  determining the
;                                ;frequency represented in each of the
;                                ;indexes.  
;     freqbz = findgen(N_elements(fftbz))/(n_elements(bz)*deltabz)
;                                ;Since we are wanting to move to a 1
;                                ;sample per a min. we have a nyquist
;                                ;frequency of (1./120.) so here we are
;                                ;trying to find at which index that
;                                ;corresponds to. 
;     find = abs((1./120.) - freqbz)
;     findmin = min(find) 
;     index = where(findmin eq abs(find))
;     if index(0) ne -1. then hif = index(0) else stop
;                                ;Here we are creating the filter.     
;     filterbz(hif:n_elements(bz)- hif) = 0
;     filterbz([ hif-1,n_elements(bz) - hif+1]) = .3
;     filterbz([ hif-2,n_elements(bz) - hif+2]) = .6
;                                ;Here we apply that filter
;     filtfftbz = filterbz*fftbx
;                                ;Now we take the inverse fft
;     Dfft = fft(filtfftbz, /inverse)
;                                ;Now we are putting the magnetic field
;                                ;back onto the 1 min resolution grid.
;     bz1 = congrid(dfft, length, /interp)
