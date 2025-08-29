pro read_CRRES_mag_1min;, tempf, dataf
;This program attempts to read in all the CRRES data and possibly
;write it to ascii files for each year, but more importantly it writes
;everything to save files. 
  
;here we restore and read in the cr file which will allow us to put
;times and orbits with all of the other CRRES data

  tempf = '../Templates/'
  dataf = '../Data/'
  magdataf = '../../../Volumes/Time\ Machine\ Backups/crres/'
  resamplerate = 60.            ;this needs to be in seconds. 
  nyfr = 1./(2.*resamplerate)   ;the nyquist frequency 
  
  
  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crmagfiles.shr', template = template)
  ssorbit = meep.field01
  ssyear = meep.field02
  ssmonth = meep.field03
  ssday = meep.field04
  filename1 = meep.field14

  indexloop = where(ssorbit ge 80)
  for k = indexloop(0), n_elements(ssorbit) -1 do begin 

     restore, magdataf + strcompress('crres_asc/crres_raw_mag'+string(ssorbit(k))+'.save', /remove_all)
     mm = make_array(N_elements(milasc), value = !values.F_NAN)
     hrasc = mm
     minasc = mm
     dayasc = mm
     secasc = mm
     yday = mm
     for j = 0l, n_elements(milasc)-1 do begin
        minasc(j) = milasc(j)/(10^(3.)*60.)
        hrasc(j) = minasc(j)/(60.)
        mm(j) = minasc(j) - (floor(hrasc(j))*60.)
        if hrasc(j) ge 24 then begin 
           hrasc(j) = hrasc(j) - 24
           dayasc(j) = day(k) + 1.
        endif else dayasc(j) = day(k)
        hrasc(j) = floor(hrasc(j))
        secasc(j) = (mm(j) - floor(mm(j)))*60.
        mm(j) = floor(mm(j))
        ;print, 'day, hh, mm, sec'
        ;print, dayasc(j), hrasc(j), mm(j), secasc(j)
        yday(j) = stand2yday(month(k), dayasc(j), year(k), hrasc(j), mm(j), secasc(j))     
        print, 'yday is ', yday(j)
     endfor
     
     yearmin = (yday*24.*60.)   ;+ (hrasc*60.) + mm + (secasc/60.)
     length = floor(yearmin(n_elements(yearmin) -1) - yearmin(0))
     time_B = findgen(length)+floor(yearmin(0)) +1
                                ;Now we are going to filter out any
                                ;induced digital signal we might get
                                ;by resampling. 
                                ;stop
     fftbx = fft(bx)
     fftby = fft(by)
     fftbz = fft(bz)
     filterB = make_array(n_elements(Bx), value = 1)

                                ;Here we make the array of the time steps between each index
     deltaB = (yearmin(1:n_elements(yearmin)-1) - yearmin(0:n_elements(yearmin)-2))*60. ; this is in seconds
                                ;here we are  determining the
                                ;frequency represented in each of the
                                ;indexes.  
     freqB = findgen(N_elements(fftBx))/(n_elements(Bx)*deltaB)
                                ;Since we are wanting to move to a 1
                                ;sample per a min. we have a nyquist
                                ;frequency of (1./120.) so here we are
                                ;trying to find at which index that
                                ;corresponds to. 
     find = abs((1./120.) - freqB)
     findmin = min(find) 
     index = where(findmin eq abs(find))
     if index(0) ne -1. then hif = index(0) else stop

                                ;Here we are creating the filter.     
     filterB(hif:n_elements(Bx)- hif) = 0
     filterB([ hif-1,n_elements(Bx) - hif+1]) = .3
     filterB([ hif-2,n_elements(Bx) - hif+2]) = .6
                                ;Here we apply that filter
     filtfftBx = filterB*fftBx 
     filtfftBy = filterB*fftBy 
     filtfftBz = filterB*fftBz 
                                ;Now we take the inverse fft
     DfftBx = fft(filtfftBx, /inverse)
     DfftBy = fft(filtfftBy, /inverse)
     DfftBz = fft(filtfftBz, /inverse)

     Bx1 = congrid(dfftBx, length, /interp)
     By1 = congrid(dfftBy, length, /interp)
     Bz1 = congrid(dfftBz, length, /interp)

     savefilename2 = strcompress( '../Data/Min_CRRES_data/crres_mag1min_data_'+storb+'.save' , /remove_all)

                                ;Because I'm not sure what to
                                ;do at the moment for the
                                ;filter since we are putting this on a
                                ;min. grid we'll just do the den.

     save, yday, hrasc, mm, secasc, time_B, den1, $
           filename = savefilename2

     Magfilenames(k) = savefilename2
     magorb(k) = long(storb)
;stop
  endfor
                      
  savefilenames = strcompress( '../Data/Min_CRRES_data/min_mag_files.save' , /remove_all)
  save, magfilenames, magorb, filename = savefilenames

end
