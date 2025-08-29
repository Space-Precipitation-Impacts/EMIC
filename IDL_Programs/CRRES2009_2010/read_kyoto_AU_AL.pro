Pro read_kyoto_AU_AL, year_array, datafolder, savefolder, templatefolder
;this program was created to read in the AL AU data from Kyoto data
;center. It was created on April 4th 2008 by Alexa Halford

;make sure that the template to read in the AL AU data has been
;created useing make_template.pro and named kyoto_ALAU_template.save
;The variables in the template should be type1, name, type2, min1 -
;min60, hourave for a total of 64 columns 

;here we restore the template for reading in the Kyoto auroral data
restore, templatefolder+'kyoto_AUAL_template.save'

kyotofile = strarr(n_elements(year_array), 12)
kyotosave = strarr(n_elements(year_array))


for i = 0l, n_elements(year_array)-1. do begin
    for j = 0l,11 do begin
       if j lt 9 then kyotofile(i,j) = strcompress(datafolder+'Auroral_Indicies/Kyoto_ALAU_'+string(floor(year_array(i)))+'_0'+string(j+1)+'.txt',/remove_all) else $
       kyotofile(i,j) = strcompress(datafolder+'Auroral_Indicies/Kyoto_ALAU_'+string(floor(year_array(i)))+'_'+string(j+1)+'.txt',/remove_all)
    endfor
    kyotosave(i) =  strcompress(datafolder+'kyoto_ALAU_'+string(floor(year_array(i)))+'.save',/remove_all)
endfor 


;This for loop goes through the years
for ii = 0l,n_elements(year_array)-1 do begin    
   ;This section creates the variable arrays


   leapyear = (year_array(ii)/4.) - floor(year_array(ii)/4.)
   if leapyear ne 0. then begin
   yearhours = 365.*24.
   yearmins = 365.*24.*60. 
   endif else begin
   yearhours = 366.*24.
   yearmins = 366.*24.*60. 

   endelse

   marker = strarr(yearmins*2.)
;   marker2 = strarr(yearmins*2.)
   auroral = make_array(yearmins*2.)
   AU = make_array(yearmins)
   AL = AU
   hourave = make_array(yearhours*2.) 
   AUave = make_array(yearhours)
   ALave = make_array(yearhours)
   close, /all
   startindex = 0
   hourindex = 0

      ;This for loop goes through the months
      for jj = 0l,11 do begin
        restore, Templatefolder+'kyoto_AUAL_template.save'
         meep = read_ascii(Kyotofile(ii,jj), template = template)
         ;help, jj, startindex, meep.min01
         ;this loop goes through the hours for each month 
         for kk = 0l, n_elements(meep.min01) -1 do begin 
            auroral(kk*60.+startindex) = meep.min01(kk)
            auroral(kk*60.+1+startindex) = meep.min02(kk)
            auroral(kk*60.+2+startindex) = meep.min03(kk)
            auroral(kk*60.+3+startindex) = meep.min04(kk)
            auroral(kk*60.+4+startindex) = meep.min05(kk)
            auroral(kk*60.+5+startindex) = meep.min06(kk)
            auroral(kk*60.+6+startindex) = meep.min07(kk)
            auroral(kk*60.+7+startindex) = meep.min08(kk)
            auroral(kk*60.+8+startindex) = meep.min09(kk)
            auroral(kk*60.+9+startindex) = meep.min10(kk)
            auroral(kk*60.+10+startindex) = meep.min11(kk)
            auroral(kk*60.+11+startindex) = meep.min12(kk)
            auroral(kk*60.+12+startindex) = meep.min13(kk)
            auroral(kk*60.+13+startindex) = meep.min14(kk)
            auroral(kk*60.+14+startindex) = meep.min15(kk)
            auroral(kk*60.+15+startindex) = meep.min16(kk)
            auroral(kk*60.+16+startindex) = meep.min17(kk)
            auroral(kk*60.+17+startindex) = meep.min18(kk)
            auroral(kk*60.+18+startindex) = meep.min19(kk)
            auroral(kk*60.+19+startindex) = meep.min20(kk)
            auroral(kk*60.+20+startindex) = meep.min21(kk)
            auroral(kk*60.+21+startindex) = meep.min22(kk)
            auroral(kk*60.+22+startindex) = meep.min23(kk)
            auroral(kk*60.+23+startindex) = meep.min24(kk)
            auroral(kk*60.+24+startindex) = meep.min25(kk)
            auroral(kk*60.+25+startindex) = meep.min26(kk)
            auroral(kk*60.+26+startindex) = meep.min27(kk)
            auroral(kk*60.+27+startindex) = meep.min28(kk)
            auroral(kk*60.+28+startindex) = meep.min29(kk)
            auroral(kk*60.+29+startindex) = meep.min30(kk)
            auroral(kk*60.+30+startindex) = meep.min31(kk)
            auroral(kk*60.+31+startindex) = meep.min32(kk)
            auroral(kk*60.+32+startindex) = meep.min33(kk)
            auroral(kk*60.+33+startindex) = meep.min34(kk)
            auroral(kk*60.+34+startindex) = meep.min35(kk)
            auroral(kk*60.+35+startindex) = meep.min36(kk)
            auroral(kk*60.+36+startindex) = meep.min37(kk)
            auroral(kk*60.+37+startindex) = meep.min38(kk)
            auroral(kk*60.+38+startindex) = meep.min39(kk)
            auroral(kk*60.+39+startindex) = meep.min40(kk)
            auroral(kk*60.+40+startindex) = meep.min41(kk)
            auroral(kk*60.+41+startindex) = meep.min42(kk)
            auroral(kk*60.+42+startindex) = meep.min43(kk)
            auroral(kk*60.+43+startindex) = meep.min44(kk)
            auroral(kk*60.+44+startindex) = meep.min45(kk)
            auroral(kk*60.+45+startindex) = meep.min46(kk)
            auroral(kk*60.+46+startindex) = meep.min47(kk)
            auroral(kk*60.+47+startindex) = meep.min48(kk)
            auroral(kk*60.+48+startindex) = meep.min49(kk)
            auroral(kk*60.+49+startindex) = meep.min50(kk)
            auroral(kk*60.+50+startindex) = meep.min51(kk)
            auroral(kk*60.+51+startindex) = meep.min52(kk)
            auroral(kk*60.+52+startindex) = meep.min53(kk)
            auroral(kk*60.+53+startindex) = meep.min54(kk)
            auroral(kk*60.+54+startindex) = meep.min55(kk)
            auroral(kk*60.+55+startindex) = meep.min56(kk)
            auroral(kk*60.+56+startindex) = meep.min57(kk)
            auroral(kk*60.+57+startindex) = meep.min58(kk)
            auroral(kk*60.+58+startindex) = meep.min59(kk)
            auroral(kk*60.+59+startindex) = meep.min60(kk)
            ;This for loop gives the strdate for each of the mins. 
            for lpkk =(startindex+kk*60.),(59.+startindex+kk*60.),1 do begin
               marker(lpkk) = strmid(meep.strdate(kk), 9, 2)
               ;marker2(lpkk) = strmid(meep.strdate(kk), 9, 2)
             endfor
         endfor
      hourave(hourindex:(hourindex+n_elements(meep.hourave)-1.)) = meep.hourave
      startindex = startindex + n_elements(meep.min01)*60.
      hourindex = hourindex + n_elements(meep.hourave)
   endfor

AUindex = where(marker eq 'AU')
ALindex = where(marker eq 'AL')
AL = auroral(ALindex)
AU = auroral(AUindex)

Year = year_array(ii)
   close, /all
   Ajul = findgen(n_elements(AU))/(24.*60.) + julday(1,1,year, 0, 0, 0)


;julday(month, day, year, hour, min, sec)
   ;this is the save file which is used in the rest of the main program
   save, AU, Al,Ajul, filename = kyotosave(ii)

endfor


end
