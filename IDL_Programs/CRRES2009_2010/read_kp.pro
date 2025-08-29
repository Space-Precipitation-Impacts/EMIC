Pro read_kp, year_array, datafolder,templatefolder 
  
;this program was created to read in the kp data from Kyoto data
;center. It was created on April 4th 2008 by Alexa Halford
  
;make sure that the template to read in the kp data has been
;created useing make_template.pro and named kyoto_kp_template.save
;The variables in the template should be type1, name, type2, min1 -
;min60, hourave for a total of 64 columns 
  
;here we restore the template for reading in the Kyoto auroral data
  restore, Templatefolder+'kp_template.save'

  kpfile = strarr(n_elements(year_array))
  kpsave = strarr(n_elements(year_array))
   
  for i = 0l, n_elements(year_array)-1. do begin
     kpfile(i) = strcompress(datafolder+'Kp_CDAWeb_index/'+string(floor(year_array(i)))+'_kp.txt',$
                              /remove_all)
     kpsave(i) =  strcompress(datafolder+'kp_CDAWeb'+string(floor(year_array(i)))+'.save',$ 
                              /remove_all)
  endfor 
 
  
;This for loop goes through the years
  for ii = 0l,n_elements(year_array)-1 do begin    
                                ;This section creates the variable arrays
     year = year_array(ii)
     print, 'creating save file for year ', year
     hourindex = 0
     
                                ;This for loop goes through the months
     restore, templatefolder+'kp_template.save'
     meep = read_ascii(kpfile(ii,0), template = template)
                                ;help, jj, startindex, meep.field01
                                ;this loop goes through the hours for each month 
   ;leapyear = (year_array(ii)/4.) - floor(year_array(ii)/4.)
   ;if leapyear ne 0. then begin
      length = 365.*24.*60.
   ;endif else begin
   ;   length = 366.*24.*60. 
   ;endelse
   kp = meep.kp(1:n_elements(meep.kp) -2)

     yearhours = length/60.
     yearmins = length
     
     close, /all
     
;if year eq 2004 then stop

    ; stop
     kpmin = rebin(kp, yearmins, /sample)
     kp = kpmin/10.
     
     
     close, /all
     kpJul = (findgen(n_elements(kp)))/(24.*60.)+ julday(1,1,year,0,0,0)
                                ;this is the save file which is used
                                ;in the rest of the main program
     save, kp, kpjul, filename = kpsave(ii)
     
  endfor

  
end
