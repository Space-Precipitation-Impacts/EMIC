pro Dst_prep, event_file, sbuffer, ebuffer, datafolder, savefolder
;this procedure creates arrays of Dst data for each epoch given in the
;events.doc file. In order to run this procedure, you need to make
;sure that you have an asci template created and saved in the template
;folder which has all of the relavant variables defined. i.e. yar,
;month THis procedure does not maniputate the SW data
; - Alexa Halford
  
;modified to only look at Dst- Alexa Halford

                                ;If you are going to buffer around the start or the end of the event,
                                ;make sure that the program is getting the correct time intervales. 
  
  print, 'starting Dst_prep'
  print, 'starting to restore files.'
  
                                ;Here we are creating the file name
                                ;for the Save file containing the
                                ;events and restoring the files.
  S1 = strpos(event_file,'.')
  file2 = strmid(event_file,0,s1)
  file3 = strcompress(datafolder+file2+'_'+string(floor(sbuffer))+'_'+string(floor(ebuffer))+'.save', /remove_all)
  
  restore, file3, /ver

                                ; Here we are creating a string array
                                ; for the save file names.
  save_file_names = strarr(N_elements(onset_time))
  for k = 0l, n_elements(onset_time) - 1. do begin
                                ; print, 'starting loop',k,'in Dst_prep'
                                ; This next bit is used much farther
                                ; down. 
     caldat, onset_time(k), month, day, year, hh, mm, sec
     if year eq 1990 then restore, datafolder+'kyoto_Dst_1990.save'
     if year eq 1991 then restore, datafolder+'kyoto_Dst_1991.save'
;     if year eq 2001 then restore, datafolder+'kyoto_Dst_2001.save'
;     if year eq 2002 then restore, datafolder+'kyoto_Dst_2002.save'
;     if year eq 2003 then restore, datafolder+'kyoto_Dst_2003.save'
;     if year eq 2004 then restore, datafolder+'kyoto_Dst_2004.save'
;     if year eq 2005 then restore, datafolder+'kyoto_Dst_2005.save'
     
     if year eq 1990 then restore, datafolder+ 'kyoto_Sym_1990.save'
     if year eq 1991 then restore, datafolder+ 'kyoto_Sym_1991.save'
;     if year eq 2001 then restore, datafolder+ 'kyoto_Sym_2001.save'
;     if year eq 2002 then restore, datafolder+'kyoto_Sym_2002.save'
;     if year eq 2003 then restore, datafolder+'kyoto_Sym_2003.save'
;     if year eq 2004 then restore, datafolder+'kyoto_Sym_2004.save'
;     if year eq 2005 then restore, datafolder+'kyoto_Sym_2005.save'

    
 

    ;this is where I cut the arrays with the relevant time intervals to
     ;get only the time intervals in which I am interested in. The s at the
     ;end of the variables denotes that they are being saved... I needed a
     ;new variable name, and this was all I could come up with. 
     ;index = where((Dstjul ge time(k,0)) and (Dstjul le time(k, n_elements(time(k,*))-1)))
                                ;This is the start of the indexing
                                ;needed and used. 
     aconstant = where((Dstjul le time(k,0)) and (Dstjul ge (time(k,0) - (.02/24.))))
                                ;aconstant = fix(where((Dstjul - time(k,0)) eq min(abs(Dstjul- time(k,0)))), type = 3)
                                ;This was used sometimes when IDL
                                ;comoplaines about the other aconstant.
                                ;     aconstant = fix(where((Dstjul - time(k,0)) eq min(abs(Dstjul- time(k,0)))), type = 3)
                                ;I believe that the next two lines
                                ;where once printed and used as a test
                                ;to make sure the right days were
                                ;found. 
     caldat, dstjul(aconstant(0)), mtest, dtest, ytest, htest
     caldat, time(k,0), mtest, dtest, ytest, htest
                                ;Here we have created the indexing for
                                ;the storm events.
     index = findgen(n_elements(time(k,*))) + aconstant(0)
     
                                ; Here we have cut the Dst yearly file
                                ; into the appropriate Dst length for
                                ; the given storm. The length here
                                ; being the longest length of the
                                ; storms occuring during the CRRES mission.
     Dsts = Dst(index)
     Dstjuls = Dstjul(index)

     ;this is where I cut the arrays with the relevant time intervals to
     ;get only the time intervals in which I am interested in. The s at the
     ;end of the variables denotes that they are being saved... I needed a
     ;new variable name, and this was all I could come up with. 
                                ;index = where((Dstjul ge time(k,0)) and (Dstjul le time(k, n_elements(time(k,*))-1)))

                                ;aconstant = fix(where((Dstjul - time(k,0)) eq min(abs(Dstjul- time(k,0)))), type = 3)
     
     

                                ;Here we have time array and the
                                ;length array. The times array had
                                ;been multiplied by 60, but I think
                                ;that is not needed to make the times
                                ;array in units of min. 
     times = findgen(n_elements(Dst)) ; This puts the time in units of min. 
     ;times = findgen(n_elements(Dst))*60. ; This puts the time in units of min. 
     length = n_elements(dsts)
     
     
                                ;this meep creates the filename used for the save file. 
     yday = jul2yday(onset_time(k))
     stryday = yday - (year * 1000.)
     meep = strcompress (savefolder+ string(year)+'_'+string(month)+'_'+string(day)+'_'+string(hh)+'.save', /remove_all)
     ;this meep creates the filename used for the save file. 
     
       
                                ; Here we create the elements that we
                                ; want to save.
     onset = onset_time(k)
     months = month
     days = day
     hours = hh
     mins = mm
     years = year
     
     
     Dsts = Dst(index)
     Syms = Sym(index) 
     
     
     ;This creates the save file for each individual event that will be
     ;passed on to later programs and manipulated into the final form. 
     
;     save, dst, index, onset, times, dsts, Dstjuls, years, months, days, stryday, yday, hours, mins, length, filename = meep
     save, dst, sym, index, onset, times, syms, dsts, Dstjuls, years, months, days, stryday, yday, hours, mins, length, filename = meep

     ;this array contains the names of all of the individual event save
     ;files cantaining dst data. 
     
     save_file_names(k) = meep

  endfor
  
  
  ;this save file contains the array of the names of all the indicidual
  ;event save files containing SW data. I know that his starts to seem
  ;confusing, but is helps later on, 
  
  save, save_file_names, file = savefolder+'Dstready_events.save'
  
  
  print, 'program done'
  
end
