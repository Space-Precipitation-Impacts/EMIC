pro EMIC_LT_LS
; this is the first of two programs that creates most of the polar
; plots used in the EMIC/ storm study. The second program does many of
; the same things, but this was getting long. 


restore, '../Templates/CRRES_EMIC_template.save'

  jeep = read_ascii('../Data/CRRES_emic.txt', template = template)
  hMLT = make_array(365.*24.*60., value = !values.F_NAN)
  hLS = hmlt
  
  UT = jeep.field13
  orbit = jeep.field01
  duration = jeep.field26
  endUT = jeep.field18
  Humlt1 = jeep.field15
  HUmlt2 = jeep.field20
  HULS1 = jeep.field16
  HULS2 = jeep.field21
  hden = jeep.field03

  doy = make_array(n_elements(orbit))
  year = make_array(n_elements(orbit))
                                ;Here we restore the orbit file for
                                ;the CRRES mission.
  restore,'../Templates/CRRES_orbit_template.save'
  beep = read_ascii('../Data/crres_orbit.txt', template = template)
  CRorbit = beep.orbit
  starttime = beep.start
  CRdoy = beep.doy
  cryear = beep.year



                                ;Here we find the doy for each of the
                                ;events and also create the year array
                                ;as well.
  for i = 0l, n_elements(orbit)-1 do begin
     index = where(CRorbit eq orbit(i))
     if index(0) ne -1 then doy(i) = crdoy(index(0)) $
     else print, 'no match'
                                ; I don't think that this is
                                ; needed. The UT time (hour) when put
                                ; into Julday should work out right.
                                ; if Starttime(index) gt UT(i) then doy(i) = doy(i)+1.
     year(i) = cryear(index(0))
  endfor

  in90 = where(year eq 90)
  in91 = where(year eq 91)
                                ;Because the indexing starts at min 0
                                ;on the first day of year, we need to
                                ;subtract 1 from the days of year to
                                ;get the right index.
  doy90 = doy(in90) -1. 
  doy91 = doy(in91) -1.
  ut90 = ut(in90)
  ut91 = ut(in91)
  endUT90 = endut(in90)
  endut91 = endut(in91)
  hmlt190 = humlt1(in90)
  hmlt191 = humlt1(in91)
  hmlt290 = humlt2(in90)
  hmlt291 = humlt2(in91)
  hls190 = huls1(in90)
  hls191 = huls1(in91)
  hls290 = huls2(in90)
  hls291 = huls2(in91)
  thden90 = hden(in90)
  thden91 = hden(in91)

  syearminHu90 = make_array(365.*24.*60., value = !Values.F_NAN)
  syearminHu91 = make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt90 =  make_array(365.*24.*60., value = !Values.F_NAN)
  hmlt91 = hmlt90
  hls90 = hmlt90
  hls91 = hmlt90
  hden90 = hmlt90
  hden91 = hmlt90

  oncrres90 = hmlt90
  oncrres91 = hmlt90

  for i = 0l, n_elements(UT90) -1 do begin
     syearminHu90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = 1
     hmlt90(Floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):Floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = (hmlt190(i) + hmlt290(i))/2.
     hls90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = (Hls190(i) + hls290(i))/2.
     oncrres90((doy90(i)*24.*60.) + (Ut90(i)*60.)) = 1
     hden90(floor(((doy90(i)*24.*60.) + (Ut90(i)*60.))):floor(((doy90(i)*24.*60.) + (endUt90(i)*60.)))) = thden90(i)
  endfor

  for i = 0l, n_elements(UT91) -1 do begin
     syearminHu91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = 1
     hmlt91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = (hmlt191(i) + hmlt291(i))/2.
     hls91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):Floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = (Hls191(i) + hls291(i))/2.
     oncrres91((doy91(i)*24.*60.) + (Ut91(i)*60.)) = 1
     hden91(floor(((doy91(i)*24.*60.) + (Ut91(i)*60.))):floor(((doy91(i)*24.*60.) + (endUt91(i)*60.)))) = thden91(i)
  endfor

     
  s1 = strpos('CRRES_storm_phases.txt','.')
  file2 = strmid('CRRES_storm_phases.txt',0,s1)
  file3 = strcompress('../Templates/'+file2+'_template.save')

  
                                ; Here we restoring and reaging in the
                                ; storms and their phases during the
                                ; CRRES mission.
  restore, file3  
  meep = read_ascii('../Data/CRRES_storm_phases.txt', template = template)
  year = meep.year
  month = meep.month
  day = meep.day
  hh = meep.hour
  mm = meep.mm
  mmonth = meep.mmonth
  mday = meep.mday
  mhour = meep.mhour
  mmm = meep.mmm
  emonth = meep.emonth
  eday = meep.eday
  ehour = meep.ehour     
  emm = meep.emm

  onyday = stand2yday(month, day, year, hh, mm, 0.)
  mainyday = stand2yday(mmonth, mday, myear, mhour, mmm, 0.)
  recyday = stand2yday(emonth, eday, eyear, ehour, emm, 0.)
  
                                ;these are the indices for the storm phases 
  on90 = where(year eq 1990.)
  on91 = where(year eq 1991.)
                                ;These are the start and end of the
                                ;storms. once again we had to subtract
                                ;one from the year days inorder to
                                ;make sure we get the right index
                                ;number. 
  styday90 = onyday(on90) - (3./24.) -1.
  onyday90 = onyday(on90) -1.
  mainyday90 = mainyday(on90) -1.
  recov90 = recyday(on90) -1.
  styday91 = onyday(on91) - (3./24.) -1.
  onyday91 = onyday(on91) -1.
  mainyday91 = mainyday(on91) -1.
  recov91 = recyday(on91) -1.

                                ;Here we make the year array for the storms
  storm90 = make_array(365.*24.*60., value = !values.F_NAN)
  storm91 = make_array(365.*24.*60., value = !values.F_NAN)
  onphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  onphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  mainphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  mainphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  recovphase90 = make_array(365.*24.*60., value = !values.F_NAN)
  recovphase91 = make_array(365.*24.*60., value = !values.F_NAN)
  
                                ;Here we put a 1 during the times when
                                ;there is a storm.
  for ii = 0,n_elements(onyday90) -1 do begin
     storm90(styday90(ii)*24.*60.:recov90(ii)*24.*60.) = 1
     onphase90(styday90(ii)*24.*60.:onyday90(ii)*24.*60.) = 1
     mainphase90(onyday90(ii)*24.*60.:mainyday90(ii)*24.*60.) = 1
     recovphase90(mainyday90(ii)*24.*60.:recov90(ii)*24.*60.) = 1
  endfor

  for jj = 0,n_elements(onyday91) -1 do begin
     storm91(styday91(jj)*24.*60.:recov91(JJ)*24.*60.) = 1
     onphase91(styday91(jj)*24.*60.:onyday91(jj)*24.*60.) = 1
     mainphase91(onyday91(jj)*24.*60.:mainyday91(jj)*24.*60.) = 1
     recovphase91(mainyday91(jj)*24.*60.:recov91(jj)*24.*60.) = 1
  endfor

                                ;here we determining when is a non
                                ;storm, or quiet time. 
  quiet90 = make_array(365.*24.*60., value = !values.F_NAN)
  quiet91 = make_array(365.*24.*60., value = !values.F_NAN)

  stormindex90 = where(finite(storm90), complement = quietindex90)
  stormindex91 = where(finite(storm91), complement = quietindex91)
  totalstormmins = N_elements(stormindex90) + N_elements(Stormindex91) ; This is the total 
                                ;amount of minuets of storms in the CRRES mission. 
                                ;The CRRES mission lasted about 640800
                                ;mins. 
  print, 'amount of CRRES Mission  which had storms', totalstormmins/640800. 
  print, 'storm mins', totalstormmins
  print, 'amount of onset', N_elements(where(finite(onphase90))) +  N_elements(where(finite(onphase91)))
  print, 'amount of main', N_elements(where(finite(mainphase90))) + N_elements(where(finite(mainphase91)))
  print, 'amount of recov', N_elements(where(finite(recovphase90))) + N_elements(where(finite(recovphase91)))
  print, 'amount of EMIC waves', N_elements(where(finite(hmlt90))) + N_elements(where(finite(hmlt91)))
  print, 'amount of storm time EMIC waves', N_elements(where(finite(hmlt90*storm90))) + N_elements(where(finite(hmlt91*storm91)))
  print, 'amount of main and recov time EMIC waves', N_elements(where(finite(hmlt90*mainphase90))) + N_elements(where(finite(hmlt90*recovphase90))) + N_elements(where(finite(hmlt91*mainphase91))) + N_elements(where(finite(hmlt91*recovphase91)))

  
  quiet90(quietindex90) = 1.
  quiet91(quietindex91) = 1.
  
    print, 'amount of quiet time EMIC waves', N_elements(where(finite(hmlt90*quiet91))) + N_elements(where(finite(hmlt91*quiet91)))

  allarray = [oncrres90, oncrres91]

  mlt90 = hmlt90 * storm90
  mlt91 = hmlt91 * storm91
  ls90 = hls90 * storm90
  ls91 = hls91 * storm91
  numarray = [oncrres90 * storm90,oncrres91 * storm91]
  den90 = hden90*storm90
  den91 = hden91*storm91


  omlt90 = hmlt90 * onphase90
  omlt91 = hmlt91 * onphase91
  ols90 = hls90 * onphase90
  ols91 = hls91 * onphase91
  numonarray = [oncrres90 * onphase90,oncrres91 * onphase91]
  oden90 = hden90*onphase90
  oden91 = hden91*onphase91

  mmlt90 = hmlt90 * mainphase90
  mmlt91 = hmlt91 * mainphase91
  mls90 = hls90 * mainphase90
  mls91 = hls91 * mainphase91
  nummainarray = [oncrres90 * mainphase90,oncrres91 * mainphase91]
  mden90 = hden90*mainphase90
  mden91 = hden91*mainphase91

  rmlt90 = hmlt90 * recovphase90
  rmlt91 = hmlt91 * recovphase91
  rls90 = hls90 * recovphase90
  rls91 = hls91 * recovphase91
  numrecovarray = [oncrres90 * recovphase90,oncrres91 * recovphase91]
  rden90 = hden90*recovphase90
  rden91 = hden91*recovphase91

  maxden90 =  max(hden90(where(finite(hden90))))
  maxden91 =  max(hden91(where(finite(hden91))))
  maxdensity = max([maxden90, maxden91])*.57



        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = '../figures/CRRES_Hu_Storm_LS_LT.ps', /portrait
                                ;Here we plot the Dst        
        plot, mLT91, ls91, psym = 4, xrange = [0,24], yrange = [0,10], xstyle = 1, ystyle = 1, $
              xtitle = 'Magnetic Local time', ytitle ='L-Shell', title = 'Storm time (3hrs before onset till 80% recov) EMIC events from CRRES' 
        oplot, mlt90, ls90, psym = 4


        device, /close_file
        close, /all


    

         loadct, 6
         sym = 4
         line = 0
        !P.multi=[0,2,2]
        set_plot, 'PS'
        device, filename = '../figures/CRRES_Hu_phase_LS_LT.ps', /landscape, /color
                                ;Here we plot the Dst        
        out = .9


        plot, hmLT90,  hls90, xrange = [0,24], yrange = [0,10], xstyle = 1, ystyle = 1,linestyle = line, psym = sym, $
              xtitle = 'Magnetic Local time', ytitle ='L-Shell', title = 'EMIC events black non storm time green storm time'
        oplot, hmlt91, hls91,linestyle = line, psym = sym
        oplot, mlt91, color = 150, linestyle = line, ls91, psym = sym
        oplot, mlt90, ls90, color = 150, linestyle = line, psym = sym;, color = 150
        in = where(numarray eq 1, allcount)
        xyouts, .01, .3, strcompress(string(allcount) + 'storm EMIC events'), charsize = .75, $
                color = 150
        in2 = where(allarray eq 1, every)
        xyouts, .01, 1.1, strcompress(string(every) + 'EMIC events'), charsize = .75
;        oplot, hmlt91*oncrres91, hls91*oncrres91, psym = 2, color = 200
;        oplot, hmlt90*oncrres90, hls90*oncrres90, psym = 2, color = 200
        allmlt = [hmlt90, hmlt91]
        allls = [hls90, hls91]
        sallmlt = [mlt90, mlt91]
        sallls = [ls90, ls91]
        print, 'Average MLT',  mean(allmlt, /nan), 'Average LS', mean(allls, /nan)
        print, 'Average storm time MLT', mean(sallmlt, /nan), 'Average Storm time LS', mean(sallls, /nan)
        
        
        plot, omLT91, ols91,  xrange = [0,24], yrange = [0,10], xstyle = 1, ystyle = 1, linestyle = line, psym = sym,$
              xtitle = 'Magnetic Local time', ytitle ='L-Shell', title = '3hrs before onset till onset' 
        oplot, omlt90, ols90, linestyle = line , psym = sym
        in = where(numonarray eq 1, oncount)
        xyouts, .01, out, strcompress(string(oncount) + ' EMIC events'), charsize = .75
;        oplot, omlt91*oncrres91, ols91*oncrres91, psym = 2, color = 200
;        oplot, omlt90*oncrres90, ols90*oncrres90, psym = 2, color = 200


        plot, mmLT91, mls91, xrange = [0,24], yrange = [0,10], xstyle = 1, ystyle = 1, linestyle = line, psym = sym, $
              xtitle = 'Magnetic Local time', ytitle ='L-Shell', title = 'Main phase' 
        oplot, mmlt90, mls90, linestyle = line , psym = sym
        in = where(nummainarray eq 1, maincount)
        xyouts, .01, out, strcompress(string(maincount) + ' EMIC events'), charsize = .75
;        oplot, mmlt91*oncrres91, mls91*oncrres91, psym = 2, color = 200
;        oplot, mmlt90*oncrres90, mls90*oncrres90, psym = 2, color = 200

        plot, rmLT91, rls91, xrange = [0,24], yrange = [0,10], xstyle = 1, ystyle = 1, linestyle = line, psym = sym, $
              xtitle = 'Magnetic Local time', ytitle ='L-Shell', title = 'recovery phase' 
        oplot, rmlt90, rls90, linestyle = line , psym = sym
        in = where(numrecovarray eq 1, recovcount)
        xyouts, .01, out, strcompress(string(recovcount) + ' EMIC events'), charsize = .75
 ;       oplot, rmlt91*oncrres91, rls91*oncrres91, psym = 2, color = 200
 ;       oplot, rmlt90*oncrres90, rls90*oncrres90, psym = 2, color = 200


        device, /close_file
        close, /all
        
;********************************************************************************************************************
;********************************************************************************************************************


;stop




;Here we want to plot the density for all EMIC wave events and also
;for those not occuring during storm times. 

        tden  = [hden90, hden91] ;t for total
        tmlt = [hmlt90, hmlt91]
        tls = [hls90, hls91]


        qden  = [hden90*quiet90, hden91*quiet91] ;q for quiet
        qmlt = [hmlt90*quiet90, hmlt91*quiet91]
        qls = [hls90*quiet90, hls91*quiet91]

        sden  = [hden90*storm90, hden91*storm91] ;s for storm
        smlt = [hmlt90*storm90, hmlt91*storm91]
        sls = [hls90*storm90, hls91*storm91]


        theta = findgen(25)*!pi/12.
        lsr = findgen(11)
        
        polarx = lsr * cos(theta)
        polary = lsr * sin(theta)
        
        polarden = fltarr(24., 10.)
        qpolarden = fltarr(24., 10.)
        spolarden = fltarr(24., 10.)

        
;Here we are creating the average electron density for EMIC
;wave events.
        for j = 0, n_elements(polarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(tden), value = 0)
           inls = where((tls ge j) and (tls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(polarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(tden), value = 0)
              inmlt = where((tmlt ge i) and (tmlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 polarden(i,j) = mean(tden(use))
              endif else begin
                 polarden(i,j) = 0.
              endelse
           endfor                      
        endfor

;Here we are creating the average electron density for quiet time EMIC
;wave events.

        for j = 0, n_elements(qpolarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(qden), value = 0)
           inls = where((qls ge j) and (qls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(qpolarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(qden), value = 0)
              inmlt = where((qmlt ge i) and (qmlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 qpolarden(i,j) = mean(qden(use))
              endif else begin
                 qpolarden(i,j) = 0.
              endelse
           endfor                      
        endfor

;Here we are creating the average electron density for storm time EMIC
;wave events.

        for j = 0, n_elements(spolarden(0,*))-1 do begin
           lsmeep = make_array(n_elements(sden), value = 0)
           inls = where((sls ge j) and (sls lt j+1))
           if inls(0) ne -1 then lsmeep(inls) = 1
           for i = 0, n_elements(spolarden(*,0))-1 do begin
              mltmeep = make_array(n_elements(sden), value = 0)
              inmlt = where((smlt ge i) and (smlt lt i+1))
              if inmlt(0) ne -1 then mltmeep(inmlt) = 1
              meep = mltmeep*lsmeep
              use = where(meep eq 1)
              if use(0) ne -1 then begin
                 spolarden(i,j) = mean(sden(use))
              endif else begin
                 spolarden(i,j) = 0.
              endelse
           endfor                      
        endfor


        denrange = maxdensity ;max([hden90, hden91]);max([polarden, qpolarden, spolarden]) + 1.
        print, 'max range ', denrange

        ymin = -10
        ymax = 10
        xmin = -10
        xmax = 10
        sysms = .5
        ch = .76
        sym = 4
        cl = 8
                yout = 9.
        xout = -12.
        miny = -10
        maxy = 10
        minx = -12
        maxx = 12
        offset = 1.
        syms = .25
        noonx = -11.8
        noony = 0.2
        duskx = -4 
        dusky = -9.8
        ytit = ''
        xtit = ''
        ych = .05
        xch = .05

        !P.multi=[0,4,0]
        set_plot, 'PS'
        device, filename = '../figures/CRRES_Hu_den_polar_all.ps', /landscape


;Here we are plotting the density for all events         
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. ,$
              yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.,0.5,0.45,1.],  $
              title = 'CRRES EMIC events', /isotropic, xsty = 4, ysty = 4, $
              ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(polarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(polarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),$
                       (K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),$
                        (K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((polarden(kk,k)/denrange)*255.) 
                                ;color = 256.-((polarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        ;these are making the reference circles.
        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
       for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), $
                                 findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



        ;*****************************************************
                                ;Here we are plotting the density for quiet time  events         
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. ,$
              yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.45,0.5,0.9,1.],  $
              title = 'CRRES EMIC quiet time events', /isotropic, xsty = 4, ysty = 4, $
              ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(qpolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(qpolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),$
                       (K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),$
                        (K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((qpolarden(kk,k)/denrange)*255.) 
                                ;color = 256.-((qpolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), $
                                 findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



        ;*****************************************************
                                ;Here we are plotting the density for storm time  events         
        plot, /polar,  make_array(360, value = 1), findgen(360)*2.*!pi/360. ,$
              yrange = [ymin, ymax], xrange = [xmin, xmax],$
              xtitle = xtit, ytitle = ytit, symsize = syms, pos = [0.25,0.0,0.75,.5],  $
              title = 'CRRES EMIC storm time events', /isotropic, xsty = 4, ysty = 4, $
              ycharsize = ych, xcharsize = xch
        Axis, 0, 0, xax = 0., ycharsize = ych, xcharsize = xch
        Axis , 0, 0, yax = 0., ycharsize = ych, xcharsize = xch
        loadct, cl, ncolors = 255
        for k = 0l, (n_elements(spolarden(0,*))) - 1 do begin
           for kk = 0l, (n_elements(spolarden(*,0))) - 1 do begin 
              xtemp = [k*cos(kk*!pi/12.),(K+1)*cos(kk*!pi/12.),(K+1)*cos((kk+1)*!pi/12.),$
                       (K)*cos((kk+1)*!pi/12.)]
              ytemp =  [k*sin(kk*!pi/12.),(K+1)*sin(kk*!pi/12.),(K+1)*sin((kk+1)*!pi/12.),$
                        (K)*sin((kk+1)*!pi/12.)]
              polyfill, xtemp, ytemp, color = 254. - ((spolarden(kk,k)/denrange)*255.) 
                                ;color = 256.-((spolarden(kk,k)/denrange)*256.)
           endfor
        endfor
        loadct, 0        

        xyouts, duskx, dusky, 'Dusk', charsize = ch
        xyouts, noonx, noony, 'Noon', charsize = ch        
        oplot, /polar, make_array(360, value = 1), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 3), findgen(360)*2.*!pi/360.
        oplot, /polar, make_array(360, value = 6.6), findgen(360)*2.*!pi/360. ;, color = 100
        oplot, /polar, make_array(360, value = 9), findgen(360)*2.*!pi/360.   ;, color = 50
        xyouts, 0.15, 6.7, '6.6 RE', charsize = ch
        xyouts, 0.15, 3.1, '3 RE', charsize = ch
        xyouts, 0.15, 9.1, '9 RE', charsize = ch
        for h = 1, 100 do oplot, /polar, make_array(360, value = 1)*(h/100.), $
                                 findgen(180)*2.*!pi/360.+(3.*!pi/2.)
        xyouts, -7.7, 0.5, '6.6 RE', charsize = ch
        xyouts, -4.1, 0.5, '3 RE', charsize = ch
        xyouts, -10.1, 0.5, '9 RE', charsize = ch



    

                                ;Here we create the color bar for the
                                ;scaling length
        loadct, 0
        denrange = maxdensity ;max(polarden) 
        print, 'max average density ', denrange
        plot,findgen(10), findgen(denrange), pos = [.92,0.,.98,.98], yrange = [0,denrange], ystyle = 1, $
             ytitle = 'electron density per a cubic centimeter', xcharsize = 0.01
       
        loadct, cl, ncolors = max(255)
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 255
        for kk = 1l, floor(256.) -1. do begin
           polyfill, [0,10,10,0], [(denrange/255)*kk,(denrange/255)*kk,(denrange/255)*(kk+1), (denrange/255)*(kk+1)], color = 254 - kk
        endfor


        device, /close_file
        close, /all



end
