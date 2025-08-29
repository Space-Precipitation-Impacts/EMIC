Pro read_emicCRRES, year_array, datafolder,templatefolder   
;this program was created to read in the Dst data from Hu's
;EMIC wave list. It was created on April 4th 2008 by Alexa Halford
;Make sure that the template to read in the data has been
;created using make_template.pro and named CRRES_emic_template.save
;You will also need the file named crres_orbit.txt and it's
;template folder in order to get the yearday associated with the orbit out.
  
                                ;Here we restore the template for reading in the data
  restore, Templatefolder+'CRRES_EMIC_2010_template.save', /ver
                                ; Here we create the name of the save
                                ; file for the CRRES_EMIC events, the
                                ; text folder containing the CRRES
                                ; EMIC events, and the CRRES orbits
                                ; with their day of year. 
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC_2010'+'.save',$
               /remove_all)
  CRRESfile = strcompress(datafolder+'CRRES_EMIC_2010.txt',$
                          /remove_all)  
  CRRESorbitfile = strcompress(datafolder+'crres_orbit.txt',$
                          /remove_all)  
  
                                ; Here we read in the CRRES text file
                                ; containing the EMIC events.
  meep = read_ascii(CRRESfile, template = template)
  orbit = meep.orbit
  shh = meep.shour
  smm = meep.smin
;  duration = meep.field26
  ehh = meep.ehour
  emm = meep.emin
  duration = (ehh*60. + emm) - (shh*60. + smm) 
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

                                ;Here I am going to make sure that I
                                ;get all of the onset times for these
                                ;events. The last two for loops seem
                                ;to be missing something. 
     CRRES_onset90 = make_array(365.*24.*60., value = 0.) 
     CRRES_onset91 = CRRES_onset90
     index90 = where(year eq 90.)
     index91 = where(year eq 91.)
     orbit90 = orbit(index90)
     orbit91 = orbit(index91)
     year90 = year(index90)
     year91 = year(index91)
     doy90 = doy(index90)
     doy91 = doy(index91)
     shh90 = shh(index90)
     shh91 = shh(index91)
     smm90 = smm(index90)
     smm91 = smm(index91)
     stand90 = yday2stand(doy90)
     stand91 = yday2stand(doy91)
     month90 = stand90(0,*)
     month91 = stand91(0,*)
     day90 = stand90(1,*)
     day91 = stand91(1,*)
     for i = 0l, n_elements(index90)-1. do begin
        tempindex = doy90(i)*24.*60. -1. + shh90(i)*60. + smm90(i)
        crres_onset90(tempindex) = 1
     endfor

     for i = 0l, n_elements(index91)-1. do begin
        tempindex = doy91(i)*24.*60. -1. + shh91(i)*60. + smm91(i)
        crres_onset91(tempindex) = 1
     endfor
     
     restore, '../Data/CRRES_1min_1990.save'
     restore, '../Data/CRRES_1min_1991.save'
     LS90events = crres_onset90*LS90
     LS91events = crres_onset91*LS91
     mlt90events =crres_onset90*MLT90
     mlt91events =crres_onset91*MLT91
     nin90 = where(finite(LS90events))
     nin91 = where(finite(LS91events))
     mim90 = where(finite(MLT90events))
     mim91 = where(finite(MLT91events))

     filename1 = strcompress('../Data/CRRES_EMIC_Events.txt', /remove_all)
     openW, 101, filename1
     printf, 101, format = '(9A10)', 'orbit', 'year', 'month', 'day', 'hour', 'min', 'ls', 'mlt'
    

     for j = 0l, n_elements(index90) -1 do begin 
        printf, 101, format = '(6i2, 2f7.3)', orbit90(j), year90(j), month90(j),$
                day90(j), shh90(j), smm90(j), ls90events(nin90(j)), mlt90events(mim90(j))
     endfor

     for j = 0l, n_elements(index91) -1 do begin 
        printf, 101, format = '(6i2, 2f7.3)', orbit91(j), year91(j), month91(j), $
                day91(j), shh91(j), smm91(j),  ls91events(nin91(j)), mlt91events(mim91(j))
     endfor
     close, /all
     
     emicyear = year
     save, orbit, shh, smm, ehh, emm, UT, endUT,  doy, duration, year,  emicyear, crres_jul90, crres_jul91, crres_event90, crres_event91, julemicCRRES_90, julemicCRRES_91, startCRRES_90, startCRRES_91, crres_onset90, crres_onset91, filename = CRRESsave
  
end
