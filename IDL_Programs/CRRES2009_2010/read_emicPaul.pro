pro read_emicPaul, year_array, datafolder, templatefolder  
;this program was created to read in the EMIC wave events from Paul.
;It was created on April 4th 2008 by Alexa Halford
;Make sure that the template to read in the data has been
;created useing make_template.pro and named crres_events_Paul.save

  
                                ;here we restore the template
                                ;for reading Paul's EMIC events
  restore, Templatefolder+'crres_events_Paul.save', /ver
                                ;Here we create the file names
                                ;of Paul's EMIC events save and
                                ;text files along with the orbital data.  
  Paulsave =  strcompress(datafolder+'crres_events_Paul'+'.save',$
               /remove_all)
  Paulfile = strcompress(datafolder+'crres_events_Paul.txt',$
                          /remove_all)  
  CRRESorbitfile = strcompress(datafolder+'crres_orbit.txt',$
                          /remove_all)  
  
                                ; Here we are reading in Paul's data.
  meep = read_ascii(Paulfile, template = template)
  PUT = meep.field002
  PendUT = meep.field003
  Porbit = meep.field001
  Pduration = meep.field022

                                ;I don't think this is needed
                                ;and is taken out when using JULDAY
                                ;This is because Paul has the UT time
                                ;in fraction of a day so if the event
                                ;started the day after the start of
                                ;the orbit, it would go beyond 1. 
                                ;  for loop = 0, n_elements(UT) - 1 do begin 
                                ;     if UT(loop) ge 1 then UT(loop) = UT(loop) - 1.
                                ;  endfor
  
                                ;Here we create the arrays for the doy
                                ;and years for Paul's EMIC events.
  Pdoy = make_array(n_elements(porbit))
  Pyear = make_array(n_elements(porbit))

                                ; Here we restore and get the orbital data.
  restore, templatefolder+'CRRES_orbit_template.save'
  beep = read_ascii(CRRESorbitfile, template = template)
  CRorbit = beep.orbit
  starttime = beep.start
  CRdoy = beep.doy
  cryear = beep.year

                                ; Here we creating the arrays for the
                                ; day of year and year arrays.
  for i = 0l, n_elements(Porbit)-1 do begin
     index = where(CRorbit eq Porbit(i))
     if index(0) ne -1 then Pdoy(i) = crdoy(index(0)) $
     else print, 'no match'
                                ;This next line is not needed due to
                                ;how Julian time deals with the hours.
                                ;     if Starttime(index) gt PUT(i) then Pdoy(i) = Pdoy(i)+1.
     Pyear(i) = 1900+ floor(cryear(index(0)))
  endfor

     close, /all     

     save, Porbit, Put, PendUT, Pdoy, Pduration, Pyear, filename = Paulsave

end
