pro CRRES_check 

datafolder = '~/Data/CRRES/'
tempfolder = '~/Templates/'

restore, datafolder + 'CRRES_EMIC_2010.save'
restore, datafolder + 'CRRES_1min_1990.save'
restore, datafolder + 'CRRES_1min_1991.save'
restore, datafolder + 'CRRES_powerspec_1min.save'
s1 = strpos('CRRES_storm_phases.txt', '.')
file2 = strmid('CRRES_storm_phases.txt', 0,s1)
file3 = strcompress(tempfolder + file2 + '_template.save')
preon = 3. ;three hours prior to onset (preonset start time)

emic = [syearmin90, syearmin91]
den = [den90, den91]
dengrad = den[1:n_elements(den)-1] -  den[0:n_elements(den)-2]
rad = [rad90, rad91]
radgrad = rad[1:n_elements(rad)-1] -  rad[0:n_elements(rad)-2]
temp = where(radgrad < 0.)
dengrad[temp] = -1.*dengrad[temp]
db = [db90, db91]

max_amp90 = make_array(n_elements(ut90),value = !Values.F_NAN)
max_amp91 = make_array(n_elements(ut91),value = !Values.F_NAN)

max_den90 = make_array(n_elements(ut90),value = !Values.F_NAN)
max_den91 = make_array(n_elements(ut91),value = !Values.F_NAN)

min_amp90 = make_array(n_elements(ut90),value = !Values.F_NAN)
min_amp91 = make_array(n_elements(ut91),value = !Values.F_NAN)

min_den90 = make_array(n_elements(ut90),value = !Values.F_NAN)
min_den91 = make_array(n_elements(ut91),value = !Values.F_NAN)

for i = 0l, n_elements(UT90) -1 do begin
   temp = db90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i))
   tempden = den90(floor(doy90(i)*24.*60.):floor(doy90(i)*24.*60.)+ duration90(i))
   max_den90(i) = max(tempden, /nan)
   min_den90(i) = min(tempden, /nan)
   max_amp90(i) = max(temp, /nan)
   min_amp90(i) = min(temp, /nan)
endfor


for i = 0l, n_elements(UT91) -1 do begin
   temp = db91(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i))
   max_amp91(i) = max(temp, /nan)
   min_amp91(i) = min(temp, /nan)
   tempden = den91(floor(doy91(i)*24.*60.):floor(doy91(i)*24.*60.)+ duration91(i))
   max_den91(i) = max(tempden, /nan)
   min_den91(i) = min(tempden, /nan)
endfor

max_amp = [max_amp90, max_amp91]
min_amp = [min_amp90, min_amp91]
max_den = [max_den90, max_den91]
min_den = [min_den90, min_den91]
;plot, max_amp, psym = 2
;stop
;plot, min_amp, psym = 2
;stop

print, 'max of max', max(max_amp, /nan)
print, 'max of min', max(min_amp, /nan)
print, 'min of max', min(max_amp, /nan)
print, 'min of min', min(min_amp, /nan)



emic = [syearmin90, syearmin91]
den = [den90, den91]
db = [db90, db91]

;Now we read in the storm data
  restore, file3
  meep = read_ascii(datafolder + 'CRRES_storm_phases.txt', template = template)
  spyear = meep.yaer
  spmonth = meep.month
  spday = meep.day
  sphour = meep.hour
  spmin = meep.mm
  spmmonth = meep.mmonth
  spmday = meep.mday 
  spmhour = meep.mhour
  spmmin = meep.mmm
  spemonth = meep.emonth
  speday = meep.eday
  spehour = meep.ehour
  spemin = meep.emm
;Here we are creating the arrays we will need for the different magnetospheric conditions.  
  year_array_length = 365.*24.*60.
  quiet90 = make_array(year_array_length, value = !values.F_NAN)
  storm90 = quiet90
  storm690 = quiet90
  onphase90 = quiet90
  mainphase90 = quiet90 
  recovphase90 = quiet90
  recov6phase90 = quiet90
  quiet91 =quiet90
  storm91 = quiet90
  storm691 = quiet90
  onphase91 = quiet90
  mainphase91 = quiet90 
  recovphase91 = quiet90
  recov6phase91 = quiet90
;Now we are creating the arrays with 1's where there were those specific conditions.   
  for k = 0l, n_elements(spyear) -1. do begin 
;Here we are finding the yeardays
     onyday = stand2yday(spmonth(k), spday(k), spyear(k), sphour(k), spmin(k), 0.)
     mainyday = stand2yday(spmmonth(k), spmday(k), spyear(k), spmhour(k), spmmin(k), 0.)
     recyday = stand2yday(spemonth(k), speday(k), spyear(k), spehour(k), spemin(k), 0.)
;now we are finding the start of the storm, the onset time, the
;minimum sym-H value and the end of the recovery phase.
     styday = onyday - (preon/24.) - 1.
     onyday = onyday - 1.
     mainyday = mainyday -1.
     recov = recyday -1.
;now we are putting 1's where those conditions occurred.      
     if spyear(k) eq 1990 then begin 
        storm90(styday*24.*60.:recov*24.*60.) = 1
        storm690(styday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
        onphase90(styday*24.*60.:onyday*24.*60.-1) = 1
        mainphase90(onyday*24.*60:mainyday*24.*60.-1) = 1
        recovphase90(mainyday*24.*60.:recov*24.*60.) = 1
        recov6phase90(mainyday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
     endif
     if spyear(k) eq 1991 then begin 
        storm91(styday*24.*60.:recov*24.*60.) = 1
        storm691(styday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
        onphase91(styday*24.*60.:onyday*24.*60.-1) = 1
        mainphase91(onyday*24.*60:mainyday*24.*60.-1) = 1
        recovphase91(mainyday*24.*60.:recov*24.*60.) = 1
        recov6phase91(mainyday*24.*60.:mainyday*24.*60. + 6.*24.*60.) = 1
     endif
  endfor
;now we are finding where there were not storms in 1990, and 1991
;during the CRRES mission. 
  nsindex90 = where(storm90 ne 1) 
  nsindex91 = where(storm91 ne 1)
;And now we can put in the quiet (and non-CRRES mission) times
  quiet90(nsindex90) = 1. 
  quiet91(nsindex91) = 1.
;Here we are creating the two year long arrays for everything  
  quiet = [quiet90, quiet91]
  storm = [storm90, storm91]
  storm6 = [storm690, storm691]
  onset = [onphase90, onphase91]
  main = [mainphase90, mainphase91]
  recovery = [recovphase90, recovphase91]
  recov6 = [recov6phase90, recov6phase91]

!P.multi = [0,1,1]
set_plot,'ps'
device,filename='~/Desktop/denVemicpower_CRRES_recovery6.ps',/color, /landscape
loadct,13
plot, den*emic, db*emic, psym = 2, /ylog, /xlog, xtitle = 'number density', ytitle = 'EMIC wave amplitude', yrange = [.01,50], ystyle = 1
oplot, den*emic*storm, db*emic*storm, color = 200, psym = 1;symbol = "<"
oplot, den*emic*onset, db*emic*onset, color = 200, psym = 4;symbol = "H"
oplot, den*emic*main, db*emic*main, color = 80, psym = 5;symbol = "S"
oplot, den*emic*recovery, db*emic*recovery, color = 250, psym = 6;symbol = "Tu"
oplot, den*emic*recov6, db*emic*recov6, color = 150, psym = 7;symbol = "Tr"

device,/close


!P.multi = [0,1,1]
set_plot,'ps'
device,filename='~/Desktop/dengradVemicpower_CRRES_recovery6.ps',/color, /landscape
loadct,13
plot, dengrad*emic, db*emic, psym = 2, /ylog, /xlog, xtitle = 'number density', ytitle = 'EMIC wave amplitude', yrange = [.01,50], ystyle = 1, xrange = [10^(-4.), 10^3.], xstyle = 1
oplot, dengrad*emic*storm, db*emic*storm, psym = 1,color = 200
oplot, dengrad*emic*onset, db*emic*onset, psym = 4,color = 200
oplot, dengrad*emic*main, db*emic*main, psym = 5,color = 80
oplot, dengrad*emic*recovery, db*emic*recovery, psym = 6,color = 250
oplot, dengrad*emic*recov6, db*emic*recov6, psym = 7,color = 150

device,/close

end
