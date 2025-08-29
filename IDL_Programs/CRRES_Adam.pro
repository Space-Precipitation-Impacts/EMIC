function CRRES_Adam

restore, '../Data/CRRES_1min_1990.save' 
restore, '../Data/CRRES_1min_1991.save'
restore, '../Data/CRRES_EMIC_2010.save'
restore, '../Data/CRRES_powerspec_1min.save'
restore, '../Data/CRRES_srv1min_1990.save'
restore, '../Data/CRRES_srv1min_1991.save'

den = [den90, den91]
B0 = [BO90, BO91]
dB = [DB90, DB91]
HdB = [HdB90, HdB91]
HedB = [HedB90, HedB91]
emic = [syearmin90, syearmin91]
orbit = [orbit90, orbit91]
yearmin = findgen(365.*24.*60.)
time = [yearmin, yearmin]
doy = [yearmin/60., yearmin/60.]
index = where((orbit ge 796) and (orbit le 796))

!P.multi = [0,1,3]
loadct, 6
set_plot, 'PS'
filename1 = '~/Desktop/CRRES_795_797.ps'
device, filename=filename1, /landscape , /color, Font_size = 20 ;, $
loadct = 6
plot, den[index], /ylog, yrange = [.1, 1000], ytitle = 'Cold plasma densit cm^-3', ystyle = 1
oplot, den[index]*emic[index], color = 50
plot, B0[index],/ylog, yrange = [50, 800], ytitle = 'Background B-field [nT]', ystyle = 1
oplot, B0[index]*emic[index], color = 50
plot, HedB[index], ytitle = 'wave amplitude nT', ystyle = 1
oplot, HedB[index]*emic[index], color = 50
oplot, HdB[index], color = 175
oplot, HdB[index]*emic[index], color = 50

device, /close_file
close, /all

openw, 33, '~/Desktop/datafile.dat'
printF, 33, 'Time mins', 'density', 'B0', 'HdB', 'HedB', 'EMIC', format = '(6a)'
For i= 0l, N_Elements(index) - 1 do begin
   PRINTF, 33, time[index[i]],den[index[i]], B0[index[i]], HdB[index[i]], HedB[index[i]], emic[index[i]], format = '(6f15.5)'
endfor
close, 33


restore, '../Templates/CRRES_asc_double_template.save'

meep = read_ascii('../Desktop/CRRES_0796/c9116816.asc', template = template)
time = meep.time
jul_day = Julday(06,17, 2001, 00, 00, time)
jul = (jul_day -2440587.5) * 86400.
Bx = meep.bx
By = meep.by
Bz = meep.bz
Bxmodel = meep.bxmodel
Bymodel = meep.bymodel
Bzmodel = meep.bzmodel

data = create_struct('time', jul, 'Bx', bx, 'By', by, 'Bz', bz, 'Bxmodel', bxmodel, 'Bymodel', bymodel, 'Bzmodel', bzmodel)

;store_data, 'CRRES', jul, data;data = data
return, data


end
