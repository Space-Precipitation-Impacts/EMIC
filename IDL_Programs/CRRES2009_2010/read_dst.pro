Pro read_dst, year_array, datafolder,templatefolder 
  
;this program was created to read in the Dst data from Kyoto data
;center. It was created on April 4th 2008 by Alexa Halford
  
;make sure that the template to read in the Dst data has been
;created useing make_template.pro and named kyoto_Dst_template.save
;The variables in the template should be type1, name, type2, min1 -
;min60, hourave for a total of 64 columns 
  
;here we restore the template for reading in the Kyoto auroral data
  restore, Templatefolder+'kyoto_Dst_template.save'
  
  Dstfile = strarr(n_elements(year_array))
  Dstsave = strarr(n_elements(year_array))
  
   
  for i = 0l, n_elements(year_array)-1. do begin
     Dstfile(i) = strcompress(datafolder+'Kyoto_Dst/Kyoto_Dst_'+string(floor(year_array(i)))+'.txt',$
                              /remove_all)
     Dstsave(i) =  strcompress(datafolder+'kyoto_Dst_'+string(floor(year_array(i)))+'.save',$
                               /remove_all)
  endfor 
 
  
;This for loop goes through the years
  for ii = 0l,n_elements(year_array)-1 do begin    
                                ;This section creates the variable arrays
     year = year_array(ii)
     print, 'creating save file for year ', year
     hourindex = 0
     
                                ;This for loop goes through the months
     restore, templatefolder+'kyoto_Dst_template.save'
     meep = read_ascii(Dstfile(ii,0), template = template)
                                ;help, jj, startindex, meep.field01
                                ;this loop goes through the hours for each month 
     yearhours = N_elements(meep.field01)*24.
     yearmins = N_elements(meep.field01)*24.*60. 
     
     marker2 = strarr(yearmins)   
     marker = strarr(yearmins)
     Dst = make_array(yearhours)
     dayave = make_array(yearhours) 
     close, /all
     
;if year eq 2004 then stop

        for kk = 0l, n_elements(meep.field01) -1 do begin 
           dst(kk*24.) = meep.field04(kk)
           dst(kk*24.+1) = meep.field05(kk)
           dst(kk*24.+2) = meep.field06(kk)
           dst(kk*24.+3) = meep.field07(kk)
           dst(kk*24.+4) = meep.field08(kk)
           dst(kk*24.+5) = meep.field09(kk)
           dst(kk*24.+6) = meep.field10(kk)
           dst(kk*24.+7) = meep.field11(kk)
           dst(kk*24.+8) = meep.field12(kk)
           dst(kk*24.+9) = meep.field13(kk)
           dst(kk*24.+10) = meep.field14(kk)
           dst(kk*24.+11) = meep.field15(kk)
           dst(kk*24.+12) = meep.field16(kk)
           dst(kk*24.+13) = meep.field17(kk)
           dst(kk*24.+14) = meep.field18(kk)
           dst(kk*24.+15) = meep.field19(kk)
           dst(kk*24.+16) = meep.field20(kk)
           dst(kk*24.+17) = meep.field21(kk)
           dst(kk*24.+18) = meep.field22(kk)
           dst(kk*24.+19) = meep.field23(kk)
           dst(kk*24.+20) = meep.field24(kk)
           dst(kk*24.+21) = meep.field25(kk)
           dst(kk*24.+22) = meep.field26(kk)
           dst(kk*24.+23) = meep.field27(kk)

        endfor
     
     dstmin = rebin(dst, yearmins, /sample)
     dst = dstmin
     
     
     close, /all
     DstJul = findgen(n_elements(dst))/(24.*60.)+ julday(1,1,year,0,0,0)
                                ;this is the save file which is used
                                ;in the rest of the main program
     save, Dst, Dstjul, filename = Dstsave(ii)
     
  endfor

  
end
