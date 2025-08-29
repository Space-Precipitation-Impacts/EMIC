pro test_read_1min 




tempf = '../Templates/'
dataf = '../Data/'



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
     LS =  jeep.field2
     rad = jeep.field3
     loct = jeep.field4
     mlt = jeep.field5
     mlat = jeep.field6


     startyday = stand2yday(month(0), day(0), year(0), 0., 0., 0.)
     
     startt = startyday*24.*60. + (mileph(0) *10^(-3.)/60.) ; this is in min. 
     endt = startyday*24.*60. + (mileph(n_elements(mileph)-1) *10^(-3.)/60.) ; this is in min. 
     
     length = floor(endt - startt)
     
     cls = congrid(LS, length)

stop

end
