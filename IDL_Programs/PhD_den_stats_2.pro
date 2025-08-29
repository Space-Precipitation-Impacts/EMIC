pro PhD_den_stats_2


preon = 3. ;three hours prior to onset (preonset start time)
;Here we are restoring the CRRES 1 min data
  restore, '../Data/CRRES_1min_1990.save'
  restore, '../Data/CRRES_1min_1991.save'
  den = [den90, den91]
  ls = [ls90, ls91]
  allorbit = [orbit90, orbit91]
  mlt = [mlt90, mlt91]
  time = findgen(n_elements(den))
  grad = deriv(time, den)
  pos = [rad90, rad91]
  vel2 = ((2./(pos*6378.1)) - (2./(350. + 6378.1 + 6.3*6378.1)))
  vel = sqrt(vel2) * sqrt(398600.4418)
  grad = grad/vel
; Here we are restoring the EMIC wave times
  restore, '../Data/CRRES_EMIC_2010.save'
  emicon = [oncrres90, oncrres91]
  emic = [syearmin90, syearmin91]
;Here we are finding where the EMIC waves occur
  index = where(finite(emicon))
;Now we start looking at the storms. First we re-create the file names and the template file names
  s1 = strpos('CRRES_storm_phases.txt', '.')
  file2 = strmid('CRRES_storm_phases.txt', 0,s1)
  file3 = strcompress('../Templates/'+ file2 + '_template.save')
;Here we are going to read in the powerspectrum data
  restore, '../Data/CRRES_powerspec_1min.save'
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
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
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


  index = where(finite(emicon))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad lt 0.) 
  indenpos = where(grad gt 0.)

  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad)))), ' percent'
  



  index = where(finite(emicon*quiet))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*quiet lt 0.) 
  indenpos = where(grad*quiet gt 0.)



  print, '**********     quiet     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*quiet)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*quiet)))), ' percent'
  





  index = where(finite(emicon*storm))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*storm lt 0.) 
  indenpos = where(grad*storm gt 0.)


  print, '**********     storm     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*storm)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*storm)))), ' percent'
  


  index = where(finite(emicon*onset))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*onset lt 0.) 
  indenpos = where(grad*onset gt 0.)


  print, '**********     onset     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*onset)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*onset)))), ' percent'
  
  




  index = where(finite(emicon*main))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*main lt 0.) 
  indenpos = where(grad*main gt 0.)



  print, '**********     main     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*main)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*main)))), ' percent'
  



  index = where(finite(emicon*recovery))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*recovery lt 0.) 
  indenpos = where(grad*recovery gt 0.)



  print, '**********     recovery     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*recovery)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*recovery)))), ' percent'
  





  index = where(finite(emicon*recov6))
  emicgrad = grad(index)
  inneg = where(emicgrad lt 0.) 
  inpos = where(emicgrad gt 0.)
  indenneg = where(grad*recov6 lt 0.) 
  indenpos = where(grad*recov6 gt 0.)
  
  print, '**********     recov6     ********'
  print, 'there are ', n_elements(where(finite(emicgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. gradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive gradient', float(n_elements(inpos))/float(n_elements(where(finite(emicgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den grad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(grad*recov6)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den grad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(grad*recov6)))), ' percent'
  

  realorbin = where(finite(allorbit))
  realorbit = allorbit(realorbin)
  singorbit = realorbit[uniq(realorbit, sort(realorbit))]
  newgrad = grad
  for i = 0l, n_elements(singorbit) -1 do begin 
     ;print, i
     index = where(allorbit eq singorbit(i))
     ;help, index
     if n_elements(index) gt 1. then begin
        temppos = pos(index)
        maxpos = max(temppos, /nan)
        ;help, maxpos
        
        inpos = where(temppos eq maxpos)
        tempgrad = grad(index)
        tempgrad1 = tempgrad(0:inpos(0))
        tempgrad2 = tempgrad(inpos(0) + 1. : n_elements(tempgrad) -1)
        temppos1 = temppos(0:inpos(0))
        temppos2 = temppos(inpos(0) + 1. : n_elements(tempgrad) -1)
        if temppos1(inpos(0)) - temppos1(0) lt 0. then newgrad(index(0): index(inpos(0))) = -1.*grad(index(0): index(inpos(0))) $
        else newgrad(index(inpos(0)): index(n_elements(index)-1)) = -1.*grad(index(inpos(0)): index(n_elements(index) -1))
     endif
  endfor

;stop

print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

  index = where(finite(emicon))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad lt 0.) 
  indenpos = where(newgrad gt 0.)

  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad)))), ' percent'
  



  index = where(finite(emicon*quiet))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*quiet lt 0.) 
  indenpos = where(newgrad*quiet gt 0.)



  print, '**********     quiet     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*quiet)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*quiet)))), ' percent'
  





  index = where(finite(emicon*storm))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*storm lt 0.) 
  indenpos = where(newgrad*storm gt 0.)


  print, '**********     storm     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*storm)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*storm)))), ' percent'
  


  index = where(finite(emicon*onset))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*onset lt 0.) 
  indenpos = where(newgrad*onset gt 0.)


  print, '**********     onset     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*onset)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*onset)))), ' percent'
  
  




  index = where(finite(emicon*main))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*main lt 0.) 
  indenpos = where(newgrad*main gt 0.)



  print, '**********     main     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*main)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*main)))), ' percent'
  



  index = where(finite(emicon*recovery))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*recovery lt 0.) 
  indenpos = where(newgrad*recovery gt 0.)



  print, '**********     recovery     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*recovery)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*recovery)))), ' percent'
  





  index = where(finite(emicon*recov6))
  emicnewgrad = newgrad(index)
  inneg = where(emicnewgrad lt 0.) 
  inpos = where(emicnewgrad gt 0.)
  indenneg = where(newgrad*recov6 lt 0.) 
  indenpos = where(newgrad*recov6 gt 0.)
  
  print, '**********     recov6     ********'
  print, 'there are ', n_elements(where(finite(emicnewgrad))), ' emic wave events'
  print, 'there are ', n_elements(inneg), ' emic waves with a neg. newgradient which is ', float(n_elements(inneg))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(inpos), ' emic waves with a positive newgradient', float(n_elements(inpos))/float(n_elements(where(finite(emicnewgrad)))), ' percent'
  print, 'there are ', n_elements(indenneg), 'mins of with neg. den newgrad which is ', float(n_elements(indenneg))/float(n_elements(where(finite(newgrad*recov6)))), ' percent'
  print, 'there are ', n_elements(indenpos), 'mins of with pos. den newgrad which is ', float(n_elements(indenpos))/float(n_elements(where(finite(newgrad*recov6)))), ' percent'
  




stop



end
