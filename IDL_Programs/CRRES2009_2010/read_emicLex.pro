Pro read_emicLex, year_array, datafolder,templatefolder   
;this program was created to read in the Dst data from Hu's
;EMIC wave list. It was created on April 4th 2008 by Alexa Halford
;Make sure that the template to read in the data has been
;created using make_template.pro and named CRRES_emic_template.save
;You will also need the file named crres_orbit.txt and it's
;template folder in order to get the yearday associated with the orbit out.
  
                                ;Here we restore the template for reading in the data
  restore, Templatefolder+'CRRES_emicLex_template.save', /ver
                                ; Here we create the name of the save
                                ; file for the CRRES_EMIC events, the
                                ; text folder containing the CRRES
                                ; EMIC events, and the CRRES orbits
                                ; with their day of year. 
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC'+'.save',$
               /remove_all)
  CRRESfile = strcompress(datafolder+'CRRES_emicLex.txt',$
                          /remove_all)  
  CRRESorbitfile = strcompress(datafolder+'crres_orbit.txt',$
                          /remove_all)  
  
                                ; Here we read in the CRRES text file
                                ; containing the EMIC events.
  meep = read_ascii(CRRESfile, template = template)
  orbit = meep.field1
  shh = meep.field2
  smm = meep.field3
;  duration = meep.field26
  ehh = meep.field4
  emm = meep.field5
  duration = meep.field6        ;(ehh*60. + emm) - (shh*60. + smm) 
  UT = shh + (smm/60.)
  endUT = ehh + (emm/60.)
  

                                ;Here we create the arrays for the day
                                ;of year and the year.
  doy = make_array(n_elements(orbit))
  year = make_array(n_elements(orbit))
                                ;Here we restore the orbit file for
                                ;the CRRES mission.
  restore, templatefolder+'CRRES_orbit_template.save'
  beep = read_ascii(CRRESorbitfile, template = template)
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

     close, /all

                                ; Here we split up the events
                                ; according to the year. This is done
                                ; because all the other data I have is
                                ; split up this way and it makes it
                                ; easier to combine with that data. 
     index90 = where(year eq 90)
     index91 = where(year eq 91)


                                ;Here we create the Julian times for
                                ;each of the year arrays. 
     CRRES_jul90 = julday(0,doy(index90), 1990, shh(index90),smm(index90),0) 
     CRRES_jul91 = julday(0,doy(index91), 1991, shh(index91),smm(index91),0) 

                                ;Here we make the arrays for each of
                                ;the events.
     CRRES_event90 = make_array(365.*24.*60., value = 0)
     CRRES_event91 = make_array(365.*24.*60., value = 0)

                                ;Here we are just creating the time
                                ;arrays of the entire years which the
                                ;CRRES mission took place.
     jan90 = julday(1,1,1990,0,0,0)
     jan91 = julday(1,1,1991,0,0,0)
     julemicCRRES_90 = findgen(365.*24.*60.)/(24.*60.)+jan90
     julemicCRRES_91 = findgen(365.*24.*60.)/(24.*60.)+jan91
     
                                ;Here we are splitting up the duration
                                ;into the 1990 and 1991 years.
     duration90 = duration(index90)
     startCRRES_90 = CRRES_event90
     startCRRES_91 = CRRES_event91
     for ii = 0l, n_elements(index90)-1 do begin
        diff = CRRES_jul90(ii) - julemicCRRES_90
                                ;This is finding the index where the
                                ;event is occuring in the full year array.
        a = where(abs(diff) eq min(abs(diff))) ;fix( , type = 3)
                                ; Here is just a check to make sure it
                                ; is all okay.
        if a(0) eq -1 then stop
                                ;this is the array for the start times
                                ;of the emic events
        startCRRES_90(a(0)) = 1
                                ; This is where we create the year
                                ; array where 0 is when an event is
                                ; not occuring and 1 when an EMIC
                                ; event is occuring.
        for j = 0, duration90(ii)-1 do begin
           CRRES_event90(j+a(0)) = 1
        endfor
     
     endfor

                                ;Here we are doing the same thing as
                                ;the previous loop but for the year 1991.
     duration91 = duration(index91)
     for ii = 0l, n_elements(index91)-1 do begin
        diff2 = CRRES_jul91(ii) - julemicCRRES_91 
        a = where(abs(diff2) eq min(abs(diff2))) ;fix( , type = 3)
        if a(0) eq -1 then stop
        startCRRES_91(a(0)) = 1
        for j = 0, duration91(ii)-1 do begin
           CRRES_event91(j+a(0)) = 1
        endfor
     endfor


     emicyear = year
     save, orbit, shh, smm, ehh, emm, UT, endUT,  doy, duration, year,  emicyear, crres_jul90, crres_jul91, crres_event90, crres_event91, julemicCRRES_90, julemicCRRES_91, startCRRES_90, startCRRES_91, filename = CRRESsave
  
end
