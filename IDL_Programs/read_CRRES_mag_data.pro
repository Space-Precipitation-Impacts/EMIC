pro read_CRRES_mag_data;, tempf, dataf
;This program attempts to read in all the CRRES data and possibly
;write it to ascii files for each year, but more importantly it writes
;everything to save files. 


  
;here we restore and read in the cr file which will allow us to put
;times and orbits with all of the other CRRES data

  tempf = '../Templates/'
  dataf = '../Data/'
  magdataf = '../../../Volumes/Time\ Machine\ Backups/crres/'


  restore, tempf+'crfiles_template.save'
  meep = read_ascii(dataf+'crmagfiles.shr', template = template)
  sorbit = meep.field01
  syear = meep.field02
  smonth = meep.field03
  sday = meep.field04
  filename1 = meep.field14
  
  magfile = strcompress(magdataf + 'crres_asc/'+filename1(0)+'.asc')
  
  restore, tempf+'CRRES_asc_template.save'
  jeep = read_ascii(magfile, template = template)
 
  orbit = make_array(N_elements(jeep.time), value = sorbit(0))
  year = make_array(n_elements(jeep.time), value = syear(0))
  month = make_array(n_elements(jeep.time), value = smonth(0))
  day = make_array(n_elements(jeep.time), value = sday(0))
  milasc = jeep.time
  Bx = jeep.Bx
  By = jeep.By
  Bz = jeep.Bz
  modelBx = jeep.Bxmodel
  modelBy = jeep.Bymodel
  modelBz = jeep.Bzmodel
  savefilename = magdataf + strcompress('crres_asc/crres_raw_mag'+string(orbit(0))+'.save' ,/remove_all)  
  save, orbit, year, month, day, milasc, Bx, By, Bz, modelBx, modelBy, modelBz, $
        filename = savefilename

  for i = 1l, n_elements(filename1)-1. do begin 
     
     magfile = strcompress(magdataf +'crres_asc/'+filename1(i)+'.asc')
     print, 'on loop ', i, ' file name ', magfile
     restore, tempf+'CRRES_asc_template.save'
     jeep = read_ascii(magfile, template = template)
     
     aa = make_array(N_elements(jeep.time), value = sorbit(i))
     bb = make_array(n_elements(jeep.time), value = syear(i))
     cc = make_array(n_elements(jeep.time), value = smonth(i))
     dd = make_array(n_elements(jeep.time), value = sday(i))
     orbit = [aa]
     year = [bb]
     month = [cc]
     day = [dd]
     
     milasc = [jeep.time]
     Bx = [jeep.Bx]
     By = [jeep.By]
     Bz = [jeep.Bz]
     modelBx = [jeep.Bxmodel]
     modelBy = [jeep.Bymodel]
     modelBz = [jeep.Bzmodel]
     save, orbit, year, month, day, milasc, Bx, By, Bz, modelBx, modelBy, modelBz, $
           filename =magdataf +  strcompress('crres_asc/crres_raw_mag'+string(orbit(0))+'.save' ,/remove_all)

  endfor
  
   
;  for k = 1l, n_elements(denfile) -1 do begin 
;     feep = read_ascii(dataf+'CRRES_data/'+denfile(k), template = template)
;;     if n_elements(feep) ne 1 then begin
;     yrday = [yrday, feep.field2]
;     strtime = [strtime, feep.field3]
;     fce = [fce, feep.field4]
;     fuhr = [fuhr, feep.field5]
;     fpe = [fpe, feep.field6]
;     den = [den, feep.field7];
;     if min(feep.field2) lt 90000 then print, 'bad data in file ', denfile(k)
;;     endif
;  endfor
                      

;stop  

end
