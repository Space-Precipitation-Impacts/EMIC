function monthstr, month

strmonth = strarr(n_elements(month))

for j = 0, n_elements(month)-1 do begin

   case month(j) of 
      1: strmonth(j) = 'Jan'
      2: strmonth(j) = 'Feb'
      3: strmonth(j) = 'Mar'
      4: strmonth(j) = 'Apr'
      5: strmonth(j) = 'May'
      6: strmonth(j) = 'Jun'
      7: strmonth(j) = 'Jul'
      8: strmonth(j) = 'Aug'
      9: strmonth(j) = 'Sep'
      10: strmonth(j) = 'Oct'
      11: strmonth(j) = 'Nov'
      12: strmonth(j) = 'Dec'
   endcase


endfor

return, strmonth
end

