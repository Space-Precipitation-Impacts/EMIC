Pro read_sym, year_array, datafolder, savefolder, templatefolder

;this program was created to read in the AL AU data from Kyoto data
;center. It was created on April 4th 2008 by Alexa Halford

;make sure that the template to read in the AL AU data has been
;created useing make_template.pro and named kyoto_ALAU_template.save
;The variables in the template should be type1, name, type2, min1 -
;min60, hourave for a total of 64 columns 

;here we restore the template for reading in the Kyoto auroral data
restore, templatefolder+'kyoto_Dst_template.save'

symfile = strarr(n_elements(year_array), 12)
symsave = strarr(n_elements(year_array))


for i = 0l, n_elements(year_array)-1. do begin
    for j = 0l,11 do begin
       if j lt 9 then symfile(i,j) = strcompress(datafolder+'Sym_Asym/Kyoto_Sym_Asym_'+string(floor(year_array(i)))+'_0'+string(j+1)+'.txt',/remove_all) else $
       Symfile(i,j) = strcompress(datafolder+'Sym_Asym/Kyoto_Sym_Asym_'+string(floor(year_array(i)))+'_'+string(j+1)+'.txt',/remove_all)
    endfor
    Symsave(i) =  strcompress(datafolder+'kyoto_Sym_'+string(floor(year_array(i)))+'.save',/remove_all)
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

   marker2 = strarr(yearmins*4.)   
   marker = strarr(yearmins*4.)
   Dst = make_array(yearmins*4.)
   Sym = make_array(yearmins)
   Asym = Sym
   hourave = make_array(yearhours*4.) 
   Symave = make_array(yearhours)
   Asymave = make_array(yearhours)
   close, /all
   startindex = 0
   hourindex = 0

      ;This for loop goes through the months
      for jj = 0l,11 do begin
        restore, Templatefolder+'kyoto_Sym_template.save'
         meep = read_ascii(Symfile(ii,jj), template = template)
         ;help, jj, startindex, meep.field01
         ;this loop goes through the hours for each month 
         for kk = 0l, n_elements(meep.field01) -1 do begin 
            dst(kk*60.+startindex) = meep.field03(kk)
            dst(kk*60.+1+startindex) = meep.field04(kk)
            dst(kk*60.+2+startindex) = meep.field05(kk)
            dst(kk*60.+3+startindex) = meep.field06(kk)
            dst(kk*60.+4+startindex) = meep.field07(kk)
            dst(kk*60.+5+startindex) = meep.field08(kk)
            dst(kk*60.+6+startindex) = meep.field09(kk)
            dst(kk*60.+7+startindex) = meep.field10(kk)
            dst(kk*60.+8+startindex) = meep.field11(kk)
            dst(kk*60.+9+startindex) = meep.field12(kk)
            dst(kk*60.+10+startindex) = meep.field13(kk)
            dst(kk*60.+11+startindex) = meep.field14(kk)
            dst(kk*60.+12+startindex) = meep.field15(kk)
            dst(kk*60.+13+startindex) = meep.field16(kk)
            dst(kk*60.+14+startindex) = meep.field17(kk)
            dst(kk*60.+15+startindex) = meep.field18(kk)
            dst(kk*60.+16+startindex) = meep.field19(kk)
            dst(kk*60.+17+startindex) = meep.field20(kk)
            dst(kk*60.+18+startindex) = meep.field21(kk)
            dst(kk*60.+19+startindex) = meep.field22(kk)
            dst(kk*60.+20+startindex) = meep.field23(kk)
            dst(kk*60.+21+startindex) = meep.field24(kk)
            dst(kk*60.+22+startindex) = meep.field25(kk)
            dst(kk*60.+23+startindex) = meep.field26(kk)
            dst(kk*60.+24+startindex) = meep.field27(kk)
            dst(kk*60.+25+startindex) = meep.field28(kk)
            dst(kk*60.+26+startindex) = meep.field29(kk)
            dst(kk*60.+27+startindex) = meep.field30(kk)
            dst(kk*60.+28+startindex) = meep.field31(kk)
            dst(kk*60.+29+startindex) = meep.field32(kk)
            dst(kk*60.+30+startindex) = meep.field33(kk)
            dst(kk*60.+31+startindex) = meep.field34(kk)
            dst(kk*60.+32+startindex) = meep.field35(kk)
            dst(kk*60.+33+startindex) = meep.field36(kk)
            dst(kk*60.+34+startindex) = meep.field37(kk)
            dst(kk*60.+35+startindex) = meep.field38(kk)
            dst(kk*60.+36+startindex) = meep.field39(kk)
            dst(kk*60.+37+startindex) = meep.field40(kk)
            dst(kk*60.+38+startindex) = meep.field41(kk)
            dst(kk*60.+39+startindex) = meep.field42(kk)
            dst(kk*60.+40+startindex) = meep.field43(kk)
            dst(kk*60.+41+startindex) = meep.field44(kk)
            dst(kk*60.+42+startindex) = meep.field45(kk)
            dst(kk*60.+43+startindex) = meep.field46(kk)
            dst(kk*60.+44+startindex) = meep.field47(kk)
            dst(kk*60.+45+startindex) = meep.field48(kk)
            dst(kk*60.+46+startindex) = meep.field49(kk)
            dst(kk*60.+47+startindex) = meep.field50(kk)
            dst(kk*60.+48+startindex) = meep.field51(kk)
            dst(kk*60.+49+startindex) = meep.field52(kk)
            dst(kk*60.+50+startindex) = meep.field53(kk)
            dst(kk*60.+51+startindex) = meep.field54(kk)
            dst(kk*60.+52+startindex) = meep.field55(kk)
            dst(kk*60.+53+startindex) = meep.field56(kk)
            dst(kk*60.+54+startindex) = meep.field57(kk)
            dst(kk*60.+55+startindex) = meep.field58(kk)
            dst(kk*60.+56+startindex) = meep.field59(kk)
            dst(kk*60.+57+startindex) = meep.field60(kk)
            dst(kk*60.+58+startindex) = meep.field61(kk)
            dst(kk*60.+59+startindex) = meep.field62(kk)
            ;This for loop gives the strdate for each of the mins. 
            for lpkk =(startindex+kk*60.),(59.+startindex+kk*60.),1 do begin
               marker(lpkk) = strmid(meep.field02(kk), 14, 3)
               marker2(lpkk) = strmid(meep.field02(kk), 11, 1)
            endfor
         endfor
      hourave(hourindex:(hourindex+n_elements(meep.field63)-1.)) = meep.field63
      startindex = startindex + n_elements(meep.field01)*60.
      hourindex = hourindex + n_elements(meep.field63)
   endfor

Asymindex = where((marker eq 'ASY') and (marker2 eq 'H'))
Symindex = where((marker eq 'SYM') and (marker2 eq 'H'))
sym = dst(symindex)
Asym = dst(Asymindex)

year = year_array(ii)
   close, /all
   DstJul = findgen(n_elements(sym))/(24.*60.)+ julday(1,1,year,0,0,0)
   ;this is the save file which is used in the rest of the main program
   save, Sym, Asym, dstJul, filename = Symsave(ii)

endfor


end
