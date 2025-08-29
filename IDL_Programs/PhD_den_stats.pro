pro PhD_den_stats
; in this program we are looking for obvious changes in density at the
; start of the EMIC wave events. 

  figurefolder = '~/figures/'
  savefolder = '~/Savefiles/'
  tempfolder = '~/Templates/'
  datafolder = '~/Data/'

preon = 3. ;three hours prior to onset (preonset start time)
;Here we are restoring the CRRES 1 min data
  restore, datafolder + 'CRRES_1min_1990.save'
  restore, datafolder + 'CRRES_1min_1991.save'
  den = [den90, den91]
  time = findgen(n_elements(den))
  grad = deriv(time, den)
  pos = [rad90, rad91]
  vel2 = ((2./(pos*6378.1)) - (2./(350. + 6378.1 + 6.3*6378.1)))
  vel = sqrt(vel2) * sqrt(398600.4418)
  grad = grad/vel
; Here we are restoring the EMIC wave times
  restore, datafolder + 'CRRES_EMIC_2010.save'
  emicon = [oncrres90, oncrres91]
  emic = [syearmin90, syearmin91]
;Here we are finding where the EMIC waves occur
  index = where(finite(emicon))
;Now we start looking at the storms. First we re-create the file names and the template file names
  s1 = strpos('CRRES_storm_phases.txt', '.')
  file2 = strmid('CRRES_storm_phases.txt', 0,s1)
  file3 = strcompress(tempfolder + file2 + '_template.save')
;Here we are going to read in the powerspectrum data
  restore, datafolder + 'CRRES_powerspec_1min.save'
  Hdb = [Hdb90, Hdb91]
  hedb = [hedb90, hedb91]
  indb = where(Hedb ge hdb)
  db = hdb
  db(indb) = hedb(indb)
  Hintpower = [intpH90, intpH91]
  Heintpower = [intpHe90, intpHe91]
  inintpower = where(Heintpower ge Hintpower)
  intpower = Hintpower
  intpower(inintpower) = Heintpower(inintpower)
;Now we read in the storm data
  restore, file3
  meep = read_ascii(datafolder + 'CRRES_storm_phases.txt', template = template)
  spyear = meep.year
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
;Here we are going to be creating an array with the magnetospheric conditions
  magcondition = make_array(7, n_elements(quiet))
  magcondition(0,*) = quiet
  magcondition(1,*) = storm
  magcondition(2,*) = storm6
  magcondition(3,*) = onset
  magcondition(4,*) = main
  magcondition(5,*) = recovery
  magcondition(6,*) = recov6
  magstring = ['quiet', 'storm', 'storm_6day', 'pre-onset', 'main', 'recovery', 'recovery_6day']

;Here we are looping though the magnetospheric conditions. 
  for m = 0l, n_elements(magstring)-1 do begin
;First we will look at the superposed epoch of EMIC waves and
;density. 
   emiconmag = emicon*magcondition(m,*)
   dbmag = db*magcondition(m,*)
   powermag = intpower*magcondition(m,*)
;Here we are finding where the EMIC waves occur
   index = where(finite(emiconmag))    
   numbevents = n_elements(index)
;Here we are making the matrix of events and the density data for 5
;mins before and 5 mins after the onset of an EMIC wave event
     epochmatrix = make_array(n_elements(index), 11)
     epochmatrixgrad = epochmatrix
     epochmatrixdb = epochmatrix
     epochmatrixpower = epochmatrix
     timeaway = make_array(N_elements(index), value = !values.F_NAN)
     timeaway2 = make_array(N_elements(index), value = !values.F_NAN)
     for i = 0l, n_elements(index) -1 do begin
        epochmatrix(i,*) = den(index(i)-5.:index(i)+5.)
        epochmatrixgrad(i,*) = grad(index(i) -5.:index(i)+5.)
        epochmatrixdb(i,*) = dbmag(index(i) - 5.:index(i) + 5.)
        epochmatrixpower(i,*) = powermag(index(i) - 5.:index(i) + 5.)
        temp = where(grad(index(i) -5.:index(i)+5.) eq max(grad(index(i) -5.:index(i)+5.), /nan))
        if temp(0) ne -1 then timeaway(i) = temp(0) - 5. else print, 'no largest gradient on loop ', i 
        temp2 = where(grad(index(i) -5.:index(i)+5.) eq min(grad(index(i) -5.:index(i)+5.), /nan))
        if temp2(0) ne -1 then timeaway2(i) = temp2(0) - 5. else print, 'no min gradient on loop ', i 
     endfor
;Here we are going to be creating the superpose epoch
     epochave = make_array(11, value = !values.F_NAN)
     epochgrad = epochave
     epochdb = epochave
     epochpower = epochave
     ave25 = epochave
     ave75 = epochave
     grad25 = epochave
     grad75 = epochgrad
     db25 = epochgrad
     db75 = epochgrad
     power25 = epochgrad
     power75 = epochgrad
     stdave = epochgrad
     stdgrad = epochgrad
     stddb = epochgrad
     stdpower = epochgrad 
     for j = 0l, 10 do begin
        epochave(j) = total(epochmatrix(*,j), /NAN)/n_elements(index)
        epochgrad(j) = total(epochmatrixgrad(*,j), /NAN)/n_elements(index)
        epochdb(j) = total(epochmatrixdb(*,j), /NAN)/n_elements(index)
        epochpower(j) = total(epochmatrixpower(*,j), /NAN)/n_elements(index)
        stdev= quartiles(epochmatrix(*,j))
        stdevgrad = quartiles(epochmatrixgrad(*,j))
        stdevdb = quartiles(epochmatrixdb(*,j))
        stdevpower = quartiles(epochmatrixpower(*,j))
        ave75(j) = stdev(0)
        grad75(j) = stdevgrad(0)
        db75(j) = stdevdb(0)
        power75(j) = stdevpower(0)
        ave25(j) = stdev(1)
        grad25(j) = stdevgrad(1)
        db25(j) = stdevdb(1)
        power25(j) = stdevpower(1)
        stdave(j) = stdev(4) 
        stdgrad(j) = stdevgrad(4)
        stddb(j) = stdevdb(4)
        stdpower(j) = stdevpower(4)
     endfor


     numbertime = make_array(n_elements(epochgrad)*2, value = 0.)
     temptime = make_array(n_elements(epochgrad), value = 0.)
     for i = 0l, n_elements(temptime)-1 do begin
        temp2 = where(timeaway eq i - 5.)
        if temp2(0) ne -1  then begin 
           temp3 = float(N_elements(temp2))/(float(numbevents))
           print, temp3
           numbertime(i*2:i*2+1) = temp3 ;float(N_elements(temp2))/(float(numbevents))
           temptime(i) = temp3 ;float(N_elements(temp2))/(float(numbevents))
        endif
;        help, temp2
;        print, temptime
     endfor
     timeave = total(temptime*(findgen(11) - 5.))
     timeavearray = make_array(100, value = timeave)
     stddevtime =  sqrt(total(((findgen(11) - 5.) - timeave)^2. * temptime))
     stdtimeaway1 =  make_array(100, value = timeave - stddevtime)
     stdtimeaway2 =  make_array(100, value = timeave + stddevtime)

     numbertime2 = make_array(n_elements(epochgrad)*2, value = 0.)
     temptime2 = make_array(n_elements(epochgrad), value = 0.)
     for i = 0l, n_elements(temptime2)-1 do begin
        temp2 = where(timeaway2 eq i - 5.)
        if temp2(0) ne -1  then begin 
           temp3 = float(N_elements(temp2))/(float(numbevents))
           print, temp3
           numbertime2(i*2:i*2+1) = temp3 ;float(N_elements(temp2))/(float(numbevents))
           temptime2(i) = temp3 ;float(N_elements(temp2))/(float(numbevents))
        endif
;        help, temp2
;        print, temptime2
     endfor
     timeave2 = total(temptime2*(findgen(11) - 5.))
     stddevtime2 =  sqrt(total(((findgen(11) - 5.) - timeave2)^2. * temptime2))
     timeave2array = make_array(100, value = timeave2)
     stdtimeaway21 =  make_array(100, value = timeave2 - stddevtime2)
     stdtimeaway22 =  make_array(100, value = timeave2 + stddevtime2)

     numbertime3 = make_array(n_elements(epochgrad)*2, value = 0.)
     temptime3 = make_array(n_elements(epochgrad), value = 0.)
     in3 = where(abs(numbertime2) ge abs(numbertime))
     numbertime3 = abs(numbertime)
     numbertime3(in3) = abs(numbertime2(in3))
     temptime3 = abs(temptime)
     intemp3 = where(abs(temptime2) ge abs(temptime))
     temptime3(intemp3) = abs(temptime2(intemp3))
     timeave3 = total(temptime3*(findgen(11) - 5.))
     stddevtime3 =  sqrt(total(((findgen(11) - 5.) - timeave3)^2. * temptime3))
     timeave3array = make_array(100, value = timeave3)
     stdtimeaway31 =  make_array(100, value = timeave3 - stddevtime3)
     stdtimeaway32 =  make_array(100, value = timeave3 + stddevtime3)

     xhist = [-5, -4, -4, -3, -3, -2, -2, -1, -1, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5]
;Here we are going to plot the results
     !P.multi = [0,1,5]
     loadct, 6
     set_plot, 'PS'
     plotname = 'PhD_den_grad'
     filename1 = strcompress(figurefolder + plotname+'_'+magstring(m)+'.ps', /remove_all)
     device, filename=filename1, /landscape , /color ;, $
     char = 1.75
     x = findgen(11) -5.
     maxave = max([[epochave], [ave25], [ave75]])
     minave = min([[epochave], [ave25], [ave75]])
     plot, x, epochave, yrange = [minave - 1, maxave + 1], xrange = [-5, 5], $
           ystyle = 1, xstyle = 1, $
           title = 'Superposed epoch of density for '+magstring(m), xtitle = 'time from start of EMIC wave event', $
           ytitle = 'ave den cm^-3', pos = [.0,0.82,1.,1.],$
           xcharsize = 0.01, charsize = char
     oplot, x, ave25, color = 50
     oplot, x, ave75, color = 50
;     oplot, x, epochave - stdave, color = 150
     maxgrad = max([[epochgrad], [grad25], [grad75]])
     mingrad = min([[epochgrad], [grad25], [grad75]])
     plot, x, epochgrad, yrange = [mingrad-1, maxgrad+1], xrange = [-5, 5], $
           ystyle = 1, xstyle = 1, title = 'Superposed epoch of density gradient for '+magstring(m), xtitle = 'time from start of EMIC wave event', $
           ytitle = 'ave den gradient', pos = [.0,0.62,1.,.79], $
           xcharsize = 0.01, charsize = char
     oplot, x, grad25, color = 50
     oplot, x, grad75, color = 50

     plot, xhist, numbertime, ytitle = '% of events', xtitle = 'time from start of EMIC wave event (mins.)', $
           xrange = [-5, 5], xstyle = 1., pos = [.0,0.42,1.,.58], $
           charsize = char, $
           title = 'time of max gradient from start of event', xcharsize = 0.01
     yval = findgen(100)/100. 
     oplot, timeavearray, yval, color = 125, thick = 4
     oplot, stdtimeaway1, yval, color = 50, thick = 4
     oplot, stdtimeaway2, yval, color = 50, thick = 4
     xyouts, 0., 0.0, 'Standerd deveation is' + strcompress(stddevtime, /remove_all), charsize = 1.2

     plot, xhist, numbertime2, ytitle = '% of events', xtitle = 'time from start of EMIC wave event (mins.)', $
           xrange = [-5, 5], xstyle = 1., pos = [.0,0.22,1.,.38], $
           charsize = char, xcharsize = 0.01,$
           title = 'time of min. gradient from start of event'
;     yval = findgen(100)/100. 
     oplot, timeave2array, yval, color = 125, thick = 4
     oplot, stdtimeaway21, yval, color = 50, thick = 4
     oplot, stdtimeaway22, yval, color = 50, thick = 4
     xyouts, 0., 0.0, 'Standerd deveation is' + strcompress(stddevtime2, /remove_all), charsize = 1.2


     plot, xhist, numbertime3, ytitle = '% of events', xtitle = 'time from start of EMIC wave event (mins.)', $
           xrange = [-5, 5], xstyle = 1.,$
           pos = [0.0,0.0,1.,.18], $
           charsize = char, $
           title = 'time of max abs(gradient) from start of event'
;     yval = findgen(100)/100. 
     oplot, timeave3array, yval, color = 125, thick = 4
     oplot, stdtimeaway31, yval, color = 50, thick = 4
     oplot, stdtimeaway32, yval, color = 50, thick = 4
     xyouts, 0., 0.0, 'Standerd deveation is' + strcompress(stddevtime2, /remove_all), charsize = 1.2

     device, /close_file
     close, /all





;Now we will look at the Correlation between the density and the db
  index = where(finite(emiconmag))    
;Here we are making the matrix of events and the density data for 5
;mins before and 5 mins after the onset of an EMIC wave event
  cor_value = make_array(N_elements(index))
;     for i = 0l, n_elements(index) -1 do begin
;        epochmatrix = den(index(i)-5.:index(i)+5.)
;        epochmatrixgrad(i,*) = grad(index(i) -5.:index(i)+5.)
;        epochmatrixdb(i,*) = dbmag(index(i) - 5.:index(i) + 5.)
;        epochmatrixpower(i,*) = powermag(index(i) - 5.:index(i) + 5.)
;     endfor



  endfor
stop
end
