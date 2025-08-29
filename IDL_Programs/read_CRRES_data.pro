pro read_CRRES_data;, tempf, dataf
;This program attempts to read in all the CRRES data and possibly
;write it to ascii files for each year, but more importantly it writes
;everything to save files. 
  
;here we restore and read in the cr file which will allow us to put
;times and orbits with all of the other CRRES data

tempf = '../Templates/'
dataf = '../Data/'
magdataf = '../../'


  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crfiles.shr', template = template)
  sorbit = meep.field01
  syear = meep.field02
  smonth = meep.field03
  sday = meep.field04
  filename1 = meep.field14
  
  ephfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(0)+'.eph')
  psnfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(0)+'.psn')

  
  restore, tempf+'CRRES_eph_template.save'
  jeep = read_ascii(ephfile, template = template)
 
  orbit = make_array(N_elements(jeep.field1), value = sorbit(0))
  year = make_array(n_elements(jeep.field1), value = syear(0))
  month = make_array(n_elements(jeep.field1), value = smonth(0))
  day = make_array(n_elements(jeep.field1), value = sday(0))
  mileph = jeep.field1
  LS = jeep.field2
  rad = jeep.field3
  loct = jeep.field4
  mlt = jeep.field5
  mlat = jeep.field6

  restore, tempf + 'CRRES_psn_template.save'
  beep = read_ascii(psnfile, template = template)
  
  milpsn = beep.field1
  x_eci = beep.field2
  y_eci = beep.field3
  z_eci = beep.field4

  for i = 1l, n_elements(filename1)-1. do begin 
     

     ephfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(i)+'.eph')
     psnfile = strcompress(dataf + 'CRRES_data/crres_eph_asc/'+filename1(i)+'.psn')

     restore, tempf+'CRRES_eph_template.save'
     jeep = read_ascii(ephfile, template = template)
 
     aa = make_array(N_elements(jeep.field1), value = sorbit(i))
     bb = make_array(n_elements(jeep.field1), value = syear(i))
     cc = make_array(n_elements(jeep.field1), value = smonth(i))
     dd = make_array(n_elements(jeep.field1), value = sday(i))
     orbit = [orbit, aa]
     year = [year, bb]
     month = [month, cc]
     day = [day, dd]


     mileph = [mileph, jeep.field1]
     LS = [LS, jeep.field2]
     rad = [rad, jeep.field3]
     loct = [loct, jeep.field4]
     mlt = [mlt, jeep.field5]
     mlat = [mlat, jeep.field6]


     restore, tempf + 'CRRES_psn_template.save'
     beep = read_ascii(psnfile, template = template)

     milpsn = [milpsn, beep.field1]
     x_eci = [x_eci, beep.field2]
     y_eci = [y_eci, beep.field3]
     z_eci = [z_eci, beep.field4]
     
  endfor
  

  restore, tempf+ 'CRRES_den_filenames_template.save'
  denf = strcompress(dataf + 'CRRES_data/CRRES_particle_filenames.txt')
  deep = read_ascii(denf, template = template)
  denfile = deep.field1

;  restore, tempf+'CRRES_den_template.save'
;  feep = read_ascii(dataf+'CRRES_data/CRRESpwe/particle/orbit0016a.txt', template = template)
;  yrday = feep.field2
;  strtime = feep.field3
;  fce = feep.field4
;  fuhr = feep.field5
;  fpe = feep.field6
;  den = feep.field7
  
  
;  for k = 1l, n_elements(4) -1 do begin 
;     ;
;     feep = read_ascii(dataf+'CRRES_data/CRRESpwe/particle/orbit00'+string(16+k)+'a.txt', template = template)
;     yrday = [yrday, feep.field2]
;     strtime = [strtime, feep.field3]
;     fce = [fce, feep.field4]
;     fuhr = [fuhr, feep.field5]
;     fpe = [fpe, feep.field6]
;     den = [den, feep.field7]

;  endfor

  restore, tempf+'CRRES_den_template.save'
  feep = read_ascii(dataf+'CRRES_data/'+denfile(0), template = template)
  yrday = feep.field2
  strtime = feep.field3
  fce = feep.field4
  fuhr = feep.field5
  fpe = feep.field6
  den = feep.field7
  
  
  for k = 1l, n_elements(denfile) -1 do begin 
     feep = read_ascii(dataf+'CRRES_data/'+denfile(k), template = template)
;     if n_elements(feep) ne 1 then begin
     yrday = [yrday, feep.field2]
     strtime = [strtime, feep.field3]
     fce = [fce, feep.field4]
     fuhr = [fuhr, feep.field5]
     fpe = [fpe, feep.field6]
     den = [den, feep.field7];
     if min(feep.field2) lt 90000 then print, 'bad data in file ', denfile(k)
;     endif
  endfor
                      
 save, orbit, year, month, day, mileph, ls, rad, loct, mlt, mlat, milpsn, x_eci, y_eci, z_eci, yrday, strtime, fce, fuhr, fpe, den, filename = '../Data/CRRES_data/crres_raw_data.save' 
stop  

end
