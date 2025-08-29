pro prep_CRRES_srv_1min 
;In this program we are creating the yearly save files for the CRRES
;data 
;*****************here we create the year arrays for the ephemeris data*********
;  savefilenames = strcompress( '../Data/Min_CRRES_data/min_psn_eph_den_files.save' , /remove_all)
;  restore, savefilenames

  tempf = '../Templates/'
  dataf = '../Data/'
  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crsrvfiles.shr', template = template)
  sorbit = meep.field01
  syear = meep.field02
  smonth = meep.field03
  sday = meep.field04
  filename1 = meep.field14

  print, filename1

  index90 = where(sorbit le 386.)
  index91 = where(sorbit ge 388.)
   
  orbit90 = make_array(365.*24.*60., value =!Values.F_NAN)
  year90 = make_array(365.*24.*60., value =!Values.F_NAN) 
  month90 = make_array(365.*24.*60., value =!Values.F_NAN)
  day90 = make_array(365.*24.*60., value =!Values.F_NAN)
  srv_time90 = make_array(365.*24.*60., value =!Values.F_NAN)
  ls90 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlt90 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlat90 = make_array(365.*24.*60., value =!Values.F_NAN)
  bx90 = make_array(365.*24.*60., value =!Values.F_NAN)
  by90 = make_array(365.*24.*60., value =!Values.F_NAN)
  bz90 = make_array(365.*24.*60., value =!Values.F_NAN)
   
  orbit91 = make_array(365.*24.*60., value =!Values.F_NAN)
  year91 = make_array(365.*24.*60., value =!Values.F_NAN) 
  month91 = make_array(365.*24.*60., value =!Values.F_NAN)
  day91 = make_array(365.*24.*60., value =!Values.F_NAN)
  srv_time91 = make_array(365.*24.*60., value =!Values.F_NAN)
  ls91 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlt91 = make_array(365.*24.*60., value =!Values.F_NAN)
  mlat91 = make_array(365.*24.*60., value =!Values.F_NAN)
  bx91 = make_array(365.*24.*60., value =!Values.F_NAN)
  by91 = make_array(365.*24.*60., value =!Values.F_NAN)
  bz91 = make_array(365.*24.*60., value =!Values.F_NAN)
  
  for i = 0, N_elements(index90) -1  do begin 
     ;filenameeph = strcompress('../Data/Min_CRRES_data/crres_pos_1min_'+string(i)+'_data.save', /remove_all)
     print, 'on loop of 1990', i
     srvsavefile = strcompress(dataf + 'CRRES_data/srv_files/'+filename1(index90(i))+'_1min.save')
     restore, srvsavefile

     time_srv = time_srv - (1.*24.*60.)
     aindex = time_srv(0)
     bindex = time_srv(N_elements(time_srv)-1)
                                ;remember have to subtract a day to
                                ;get the right indexing
     orbit90(aindex:bindex) = orbit1
     year90(aindex:bindex) = year1
     month90(aindex:bindex) = month1
     day90(aindex:bindex) = day1
     srv_time90(aindex:bindex) = time_srv
     ls90(aindex:bindex) = lshell
     mlt90(aindex:bindex) = magLT
     mlat90(aindex:bindex) = maglat
     bx90(aindex:bindex) = bx1
     by90(aindex:bindex) = by1
     bz90(aindex:bindex) = bz1
  endfor
;orbit 387 straddels 1990 and 1991 but since there is no srv file for
;it, we wont worry about it. 
print, 'there are this many elements in index90', n_elements(index91)
  for j = 0, N_elements(index91)-1 do begin 
     print, 'on loop of 1991', j
     print, 'filename = ', filename1(index91(j))
     srvsavefile = strcompress(dataf + 'CRRES_data/srv_files/'+filename1(index91(j))+'_1min.save')
     restore, srvsavefile

     time_srv = time_srv - (1.*24.*60.)
     aindex = time_srv(0)
     bindex = time_srv(N_elements(time_srv)-1)
                                ;remember have to subtract a day to
                                ;get the right indexing
     orbit91(aindex:bindex) = orbit1
     year91(aindex:bindex) = year1
     month91(aindex:bindex) = month1
     day91(aindex:bindex) = day1
     srv_time91(aindex:bindex) = time_srv
     ls91(aindex:bindex) = lshell
     mlt91(aindex:bindex) = magLT
     mlat91(aindex:bindex) = maglat
     bx91(aindex:bindex) = bx1
     by91(aindex:bindex) = by1
     bz91(aindex:bindex) = bz1
  endfor
  
;stop
savefilename90 = '../Data/CRRES_srv1min_1990.save'
savefilename91 = '../Data/CRRES_srv1min_1991.save'
save, orbit90, year90, month90, day90, srv_time90, ls90, mlt90, mlat90, bx90, by90, bz90,$
       filename = savefilename90

save, orbit91, year91, month91, day91, srv_time91, ls91, mlt91, mlat91, bx91, by91, bz91,$
       filename = savefilename91




end
