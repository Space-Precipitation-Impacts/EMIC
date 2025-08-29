pro read_eventfile, event_file, sbuffer, ebuffer, datafolder, savefolder, templatefolder
;event file should be in the form year month day hour min sec with
;spaces between them. 
;created by Alexa Halford
  
  print, 'starting to read in the event file'
                                ;  restore, savefolder+'inputfile.save'
                                ; Here we are creating the file names
                                ; used in this program.
  s1 = strpos(event_file,'.')
  file2 = strmid(event_file,0,s1)
  file3 = strcompress(Templatefolder+file2+'_template.save')
  savefile =  strcompress(Datafolder+file2+'_'+string(floor(sbuffer))+'_'+string(floor(ebuffer))+'.save', /remove_all)

  
                                ;I've levent in this bit of a
                                ;loop because we might want to use the
                                ;frey events again later in the study.
                                ;  if file2 ne 'Freyevents' then begin  
  
                                ; Here we restoring and reaging in the
                                ; storms and their phases during the
                                ; CRRES mission.
  restore, file3  
  meep = read_ascii(datafolder+event_file, template = template)
  year = meep.year
  month = meep.month
  day = meep.day
  hh = meep.hour
  mm = meep.mm
                                ; these should be zero when dealing
                                ; with storms. mm is olny zero when
                                ; using Dst
                                ;     mm = meep.mm
                                ;     sec = meep.sec
  mday = meep.mday
  mmonth = meep.mmonth
  mhour = meep.mhour
  mmm = meep.mmm
  emonth = meep.emonth
  eday = meep.eday
  ehour = meep.ehour     
  emm = meep.emm
  eventstr = strarr(N_elements(year))  
  
                                ;Here we are creating the julian times
                                ;for the onsets and recoverys.    
  onset_time = julday(month, day, year, hh, mm, 0.d)          
  recovery_time = julday(emonth, eday, year, ehour, emm, 0.d)  
                                ; Here we are cheacking to make sure that the times are all right.
                                ;    for k = 0, n_elements(onset_time(*,0))-1 do begin 
                                ;     caldat, onset_time(k,0), mtest, dtest, ytest, htest
                                ;     print, 'year ', year(k), ' month ', month(k), ' day ', day(k), ' hour ', hh(k) 
                                ;     print, 'year ', ytest, ' month ', mtest, ' day ', dtest, ' hour ', htest 
                                ;  endfor

                                ; This is again left in in case we use the Frey events.
                                ;  endif else begin     
                                ;     onset_time = read_frey(event_file)
                                ;     eventstr =strarr(N_elements(onset_time))
                                ;     caldat, onset_time, month, day, year, hh, m, 0. ; sec
                                ;  endelse
  
                                ;this creates relevent arrays which will be used later in the program 
                                ;Here we find the year days for the
                                ;onest and recovery times.
  yday = jul2yday(onset_time)
  ryday = jul2yday(recovery_time)
                                ;  array_length = sbuffer + ebuffer +
                                ;This is in min. and has three hours added pre onset.
  array_length = (recovery_time - onset_time)*24.*60. + 3.*60. 
  time = make_array(n_elements(onset_time), max(array_length), /double)
                                ;This is just defining the time difference of 1 min. in Julian time.
  min1 = julday(0.d,0.d,1.d,0.d,1.d,0.d) - julday(0.d,0.d,1.d,0.d,0.d,0.d)

                                ; Here we are finding the onest time
                                ; in Julian days and then creating a
                                ; time array of the maximum length of
                                ; the storm events (in minuets).
  for i = 0l, n_elements(yday)-1  do begin
     starttime =  onset_time(i) - (julday(0.d,0.d,1.d,0.d,3.*60.d,0.d) - julday(0.d,0.d,1.d,0.d,0.d,0.d))
     time(i,*) = dindgen(max(array_length))/(24.d0*60.d0) + starttime 
  endfor
                                ; Here we are testing to make sure that the onset times are correct.
                                ;for k = 0, n_elements(time(*,0))-1 do begin
                                ;  caldat, time(k,0), mtest, dtest, ytest, htest
                                ;  print, 'year ', ytest, ' month ', mtest, ' day ', dtest, ' hour ', htest 
                                ;endfor 
 
  save, onset_time, recovery_time,  time, filename = savefile
  
end
