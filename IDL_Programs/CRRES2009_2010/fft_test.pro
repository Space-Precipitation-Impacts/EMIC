pro fft_test

length = findgen(600)
delta = 1./N_elements(length)
a = 4.*sin(6.*!pi*delta*length)
b = sin(70.*!pi*delta*length)
c = 10.*sin(150.*!pi*delta*length)
d = sin(400.*!pi*delta*length)

data = a+d

loadct, 6
plot, data
oplot, a , color = 9879823742903
;oplot, b, color = 4573489
;oplot, c, color = 23498237798423

;stop

datafft = fft(data)
filter = make_array(n_elements(length), value = 1)
filter1 = filter

hif = 350

filter1(hif/2.:600- hif/2.) = 0
filter1([ hif/2.-1,600 - hif/2.+1]) = .3
filter1([ hif/2.-2,600 - hif/2.+2]) = .6

filtfft = filter1*datafft

Dfft = fft(filtfft, /inverse)

plot, Dfft
oplot, a, psym = 3, color = 987589437536

stop

pdata = congrid(dfft, 100)

oplot, 6.*findgen(100), pdata, psym = 4, color = 437890573

end
