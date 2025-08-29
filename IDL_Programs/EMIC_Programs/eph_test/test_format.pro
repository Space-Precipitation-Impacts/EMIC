Pro test_format
y = fltarr(2,5)
y[0,*] = [2.1, 34.321, 100.2222,67.54,78.55]
y[1,*] = [2.10102, 34.31, 100.2,67.5444,7.5]
var = n_elements(y[0,*])
format_str='('+ string(var,format='(i5)') + '(f32.1))'
print,format_str
print,y,format=format_str
end