pro prep_CRRES_data_min 
;In this program we are creating the yearly save files for the CRRES
;data 
;*****************here we create the year arrays for the ephemeris data*********
  savefilenames = strcompress( '../Data/Min_CRRES_data/min_psn_eph_den_files.save' , /remove_all)
  restore, savefilenames
  ephindex90 = where(ephorb le 386.)
  ephindex91 = where(ephorb ge 388.)
;  print, ephorb(ephindex91(0))
;  print, ephfilenames(ephindex91(0))

;  print, ephindex91
   
  orbit90 = make_array(365.*24.*60., value =!Values.F_NAN)
  year90 = make_array(365.*24.*60., value =!Values.F_NAN) 
  month90 = make_array(365.*24.*60., value =!Values.F_NAN)
  day90 = make_array(365.*24.*60., value =!Values.F_NAN)
  eph_time90 = make_array(365.*24.*60., value =!Values.F_NAN)
  ls90 = make_array(365.*24.*60., value =!Values.F_NAN)
  rad90 = make_array(365.*24.*60., value =!Values.F_NAN)
  loct90 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlt90 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlat90 = make_array(365.*24.*60., value =!Values.F_NAN)
  
 
  orbit91 = make_array(365.*24.*60., value =!Values.F_NAN)
  year91 = make_array(365.*24.*60., value =!Values.F_NAN) 
  month91 = make_array(365.*24.*60., value =!Values.F_NAN)
  day91 = make_array(365.*24.*60., value =!Values.F_NAN)
  eph_time91 = make_array(365.*24.*60., value =!Values.F_NAN)
  ls91 = make_array(365.*24.*60., value =!Values.F_NAN)
  rad91 = make_array(365.*24.*60., value =!Values.F_NAN)
  loct91 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlt91 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlat91 = make_array(365.*24.*60., value =!Values.F_NAN)
  
  for i = 0, N_elements(ephindex90) -1  do begin 
     ;filenameeph = strcompress('../Data/Min_CRRES_data/crres_pos_1min_'+string(i)+'_data.save', /remove_all)
 
     restore, ephfilenames(ephindex90(i))

     time_eph = time_eph - (1.*24.*60.)
     aindex = time_eph(0)
     bindex = time_eph(N_elements(time_eph)-1)
                                ;remember have to subtract a day to
                                ;get the right indexing
     orbit90(aindex:bindex) = sorbit
     year90(aindex:bindex) = syear
     month90(aindex:bindex) = smonth
     day90(aindex:bindex) = sday
     eph_time90(aindex:bindex) = time_eph
     ls90(aindex:bindex) = lshell
     rad90(aindex:bindex) = radius
     loct90(aindex:bindex) = localtime
     mlt90(aindex:bindex) = magLT
     mlat90(aindex:bindex) = maglat

  endfor

;  387 is the orbit that bridges the two years. 
   rstfilename = strcompress('../Data/Min_CRRES_data/crres_pos_1min_387_data.save', /remove_all)

   restore, rstfilename
   
                                ;remember have to subtract a day to
                                ;get the right indexing

   time_eph = time_eph - (1.*24.*60.)
                                ;this is the index for where the array starts for the year 1990
   aindex = time_eph(0)
                                ;this index is for where the array ends for the year 1990
   bindex = N_elements(eph_time90)-1.
                                ;This is the index for where the year 1990 ends in the restored data
   cindex = where((time_eph/(60.*24.)) ge 365.) -1
                                ;this is the index for where the year 1991 begins in the restored data
   dindex = where((time_eph/(60.*24.)) ge 365.) 
                                ;This is the index for the end time in
                                ;the year array
   eindex = time_eph(n_elements(time_eph)-1.) - (365.*24.*60.)
                                ;this is the end index for the
                                ;restored data
   findex = n_elements(time_eph)-1.

   
     orbit90(aindex:bindex) = sorbit(0:cindex(0))
     year90(aindex:bindex) = syear(0:cindex(0))
     month90(aindex:bindex) = smonth(0:cindex(0))
     day90(aindex:bindex) = sday(0:cindex(0))
     eph_time90(aindex:bindex) = time_eph(0:cindex(0))
     ls90(aindex:bindex) = lshell(0:cindex(0))
     rad90(aindex:bindex) = radius(0:cindex(0))
     loct90(aindex:bindex) = localtime(0:cindex(0))
     mlt90(aindex:bindex) = magLT(0:cindex(0))
     mlat90(aindex:bindex) = maglat(0:cindex(0))

     orbit91(0:eindex) = sorbit(dindex(0):findex)
     year91(0:eindex) = syear(dindex(0):findex)
     month91(0:eindex) = smonth(dindex(0):findex)
     day91(0:eindex) = sday(dindex(0):findex)
     eph_time91(0:eindex) = time_eph(dindex(0):findex)
     ls91(0:eindex) = lshell(dindex(0):findex)
     rad91(0:eindex) = radius(dindex(0):findex)
     loct91(0:eindex) = localtime(dindex(0):findex)
     mlt91(0:eindex) = magLT(dindex(0):findex)
     mlat91(0:eindex) = maglat(dindex(0):findex)


   


  for j = 0, N_elements(ephindex91)-1 do begin 
     print, 'j = ', j
     restore, ephfilenames(ephindex91(j))
     print,  ephfilenames(ephindex91(j))
     print, ephorb(ephindex91(j))

                                ;remember have to subtract a day to
                                ;get the right indexing

     time_eph = time_eph - (1.*24.*60.)
     aindex = time_eph(0)
     bindex = time_eph(N_elements(time_eph)-1)


     orbit91(aindex:bindex) = sorbit
     year91(aindex:bindex) = syear
     month91(aindex:bindex) = smonth
     day91(aindex:bindex) = sday
     eph_time91(aindex:bindex) = time_eph
     ls91(aindex:bindex) = lshell
     rad91(aindex:bindex) = radius
     loct91(aindex:bindex) = localtime
     mlt91(aindex:bindex) = magLT
     mlat91(aindex:bindex) = maglat 

  endfor
;*************************Here we are creating the year arrays for the
;x,y,z, components ***************************************************
  psnindex90 = where(psnorb le 386.)
  psnindex91 = where(psnorb ge 388.)
  print, psnorb(psnindex91(0))
  print, psnfilenames(psnindex91(0))

;  print, ephindex91
   
  porbit90 = make_array(365.*24.*60., value =!Values.F_NAN)
  pyear90 = make_array(365.*24.*60., value =!Values.F_NAN) 
  pmonth90 = make_array(365.*24.*60., value =!Values.F_NAN)
  pday90 = make_array(365.*24.*60., value =!Values.F_NAN)
  psn_time90 = make_array(365.*24.*60., value =!Values.F_NAN)
  x_eci90 = make_array(365.*24.*60., value =!Values.F_NAN)
  y_eci90 = make_array(365.*24.*60., value =!Values.F_NAN)
  z_eci90 = make_array(365.*24.*60., value =!Values.F_NAN)
  
 
  porbit91 = make_array(365.*24.*60., value =!Values.F_NAN)
  pyear91 = make_array(365.*24.*60., value =!Values.F_NAN) 
  pmonth91 = make_array(365.*24.*60., value =!Values.F_NAN)
  pday91 = make_array(365.*24.*60., value =!Values.F_NAN)
  psn_time91 = make_array(365.*24.*60., value =!Values.F_NAN)
  x_eci91 = make_array(365.*24.*60., value =!Values.F_NAN)
  y_eci91 = make_array(365.*24.*60., value =!Values.F_NAN)
  z_eci91 = make_array(365.*24.*60., value =!Values.F_NAN)
  
  for i = 0, N_elements(psnindex90) -1  do begin 
     ;filenameeph = strcompress('../Data/Min_CRRES_data/crres_pos_1min_'+string(i)+'_data.save', /remove_all)
 
     restore, psnfilenames(psnindex90(i))
     ;We subtract a day off so that we are using the correct indexing
     time_psn = time_psn - (1.*24.*60.)
     aindex = time_psn(0)
     bindex = time_psn(N_elements(time_psn)-1)
                                ;remember have to subtract a day to
                                ;get the right indexing
     porbit90(aindex:bindex) = orbit
     pyear90(aindex:bindex) = year
     pmonth90(aindex:bindex) = month
     pday90(aindex:bindex) = day
     psn_time90(aindex:bindex) = time_psn
     x_eci90(aindex:bindex) = sx_eci
     y_eci90(aindex:bindex) = sy_eci
     z_eci90(aindex:bindex) = sz_eci

  endfor

;  387 is the orbit that bridges the two years. 
   rstfilename = strcompress('../Data/Min_CRRES_data/crres_xyz_1min_387_data.save', /remove_all)
   
   restore, rstfilename
   
                                ;remember have to subtract a day to
                                ;get the right indexing

   time_psn = time_psn - (1.*24.*60.)
                                ;this is the index for where the array starts for the year 1990
   aindex = time_psn(0)
                                ;this index is for where the array ends for the year 1990
   bindex = N_elements(psn_time90)-1.
                                ;This is the index for where the year 1990 ends in the restored data
   cindex = where((time_psn/(60.*24.)) ge 365.) -1
                                ;this is the index for where the year 1991 begins in the restored data
   dindex = where((time_psn/(60.*24.)) ge 365.) 
                                ;This is the index for the end time in
                                ;the year array
   eindex = time_psn(n_elements(time_psn)-1) - (365.*24.*60)
                                ;this is the end index for the
                                ;restored data
   findex = n_elements(time_psn)-1

   
   porbit90(aindex:bindex) = orbit(0:cindex(0))
   pyear90(aindex:bindex) = year(0:cindex(0))
   pmonth90(aindex:bindex) = month(0:cindex(0))
   pday90(aindex:bindex) = day(0:cindex(0))
   psn_time90(aindex:bindex) = time_psn(0:cindex(0))
   x_eci90(aindex:bindex) = sx_eci(0:cindex(0))
   y_eci90(aindex:bindex) = sy_eci(0:cindex(0))
   z_Eci90(aindex:bindex) = sz_eci(0:cindex(0))

   porbit91(0:eindex) = orbit(dindex(0):findex)
   pyear91(0:eindex) = year(dindex(0):findex)
   pmonth91(0:eindex) = month(dindex(0):findex)
   pday91(0:eindex) = day(dindex(0):findex)
   psn_time91(0:eindex) = time_psn(dindex(0):findex)
   x_eci91(0:eindex) = sz_eci(dindex(0):findex)
   y_eci91(0:eindex) = sy_eci(dindex(0):findex)
   z_eci91(0:eindex) = sz_eci(dindex(0):findex)
   
  for j = 0, N_elements(psnindex91)-1 do begin 
     print, 'j = ', j
     restore, psnfilenames(psnindex91(j))
     print,  psnfilenames(psnindex91(j))
     print, psnorb(psnindex91(j))

                                ;remember have to subtract a day to
                                ;get the right indexing

     time_psn = time_psn - (1.*24.*60.)
     aindex = time_psn(0)
     bindex = time_psn(N_elements(time_psn)-1)


     porbit91(aindex:bindex) = orbit
     pyear91(aindex:bindex) = year
     pmonth91(aindex:bindex) = month
     pday91(aindex:bindex) = day
     psn_time91(aindex:bindex) = time_psn
     x_eci91(aindex:bindex) = sx_eci
     y_eci91(aindex:bindex) = sy_eci
     z_eci91(aindex:bindex) = sz_eci

  endfor
;********************************here we are creating the year arrays
;for the density data************************************************
  denindex90 = where(denorb le 386.)
  denindex91 = where(denorb ge 388.)
  print, denorb(denindex91(0))
  print, denfilenames(denindex91(0))

;  print, denindex91
   
  den_time90 = make_array(365.*24.*60., value =!Values.F_NAN)
  den90 = make_array(365.*24.*60., value =!Values.F_NAN)
  
  den_time91 = make_array(365.*24.*60., value =!Values.F_NAN)
  den91 = make_array(365.*24.*60., value =!Values.F_NAN)
  
  for i = 0, N_elements(denindex90) -1  do begin 
     ;filenameden = strcompress('../Data/Min_CRRES_data/crres_pos_1min_'+string(i)+'_data.save', /remove_all)
 
     restore, denfilenames(denindex90(i))
                                ;we take a day off to make sure that
                                ;we get the right indexing.
     time_den = time_den - (1.*24.*60.)
     aindex = time_den(0)
     bindex = time_den(N_elements(time_den)-1)
                                ;remember have to subtract a day to
                                ;get the right indexing

     den_time90(aindex:bindex) = time_den
     den90(aindex:bindex) = den1

  endfor

 filethere = where(denorb eq 387)
 if filethere(0) ne -1 then begin
;  387 is the orbit that bridges the two years. 
   rstfilename = strcompress('../Data/Min_CRRES_data/crres_pos_1min_387_data.save', /remove_all)
   
   restore, rstfilename
   
                                ;remember have to subtract a day to
                                ;get the right indexing

   time_den = time_den - (1.*24.*60.)
                                ;this is the index for where the array starts for the year 1990
   aindex = time_den(0)
                                ;this index is for where the array ends for the year 1990
   bindex = N_elements(den_time90)-1.
                                ;This is the index for where the year 1990 ends in the restored data
   cindex = where((time_den/(60.*24.)) ge 365.) -1
                                ;this is the index for where the year 1991 begins in the restored data
   dindex = where((time_den/(60.*24.)) ge 365.) 
                                ;This is the index for the end time in
                                ;the year array
   eindex = time_den(n_elements(time_den)-1) - (365.*24.*60)
                                ;this is the end index for the
                                ;restored data
   findex = n_elements(time_den)-1

     den_time90(aindex:bindex) = time_den(0:cindex(0))
     den90(aindex:bindex) = den1(0:cindex(0))

     den_time91(0:eindex) = time_den(dindex(0):findex)
     den91(0:eindex) = den1(dindex(0):findex)

  endif

  for j = 0, N_elements(denindex91)-1 do begin 
     print, 'j = ', j
     restore, denfilenames(denindex91(j))
     print,  denfilenames(denindex91(j))
     print, denorb(denindex91(j))

                                ;remember have to subtract a day to
                                ;get the right indexing

     time_den = time_den - (1.*24.*60.)
     aindex = time_den(0)
     bindex = time_den(N_elements(time_den)-1)

     den_time91(aindex:bindex) = time_den
     den91(aindex:bindex) = den1

  endfor
  
;stop
savefilename90 = '../Data/CRRES_1min_1990.save'
savefilename91 = '../Data/CRRES_1min_1991.save'
save, orbit90, year90, month90, day90, eph_time90, ls90, rad90, loct90, mlt90, mlat90, $
      porbit90, pyear90, pmonth90, pday90, psn_time90, x_eci90, y_eci90, z_eci90, $
      den_time90, den90, filename = savefilename90

save, orbit91, year91, month91, day91, eph_time91, ls91, rad91, loct91, mlt91, mlat91, $
      porbit91, pyear91, pmonth91, pday91, psn_time91, x_eci91, y_eci91, z_eci91, $
      den_time91, den91, filename = savefilename91



end
