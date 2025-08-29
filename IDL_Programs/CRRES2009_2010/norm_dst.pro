pro norm_dst, datafolder, savefolder, tempfolder, figurefolder, onsetlength, mainlength, recovlength, opcr, mpcr, rpcr
; This program is specific to the CRRES mission and cuts the data and
; normalizes it properly... I think although still checking
; everything. As of July 14th 2009 there were a few questions with the
; emic event times. Alexa Halford

;the character size in plots
  ch = 1.5

;The CRRES Data
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC'+'.save',$
               /remove_all)
; Pauls EMIC data
  Paulsave =  strcompress(datafolder+'crres_events_Paul'+'.save',$
               /remove_all)
;The storm files.
 ;  stormfile = strcompress(datafolder+'Storm_phases.txt', /remove_all)
  stormfile = strcompress(datafolder+'CRRES_storm_phases.txt',  /remove_all)
 ; stormfile = strcompress(datafolder+'CRRES_test.txt', /remove_all)

  restore, crressave
  restore, Paulsave
  year_array = [1990, 1991]
;  Making sure that the EMIC data is correct.
  crrestime = doy+(UT/24.)
  paultime = pdoy+put
  length = onsetlength + mainlength + recovlength


;Getting out the storm phase data
  restore, strcompress(tempfolder+'CRRES_storm_phases_template.save', /remove_all)
  meep = read_ascii(stormfile, template = template)
  year = meep.year
  month = meep.month
  day = meep.day
  hour = meep.hour
  mday = meep.mday
  mmonth = meep.mmonth
  mhour = meep.mhour
  emonth = meep.emonth
  eday = meep.eday
  ehour = meep.ehour
  omm = meep.mm;-30.d
  mmm = meep.mmm;-30.d
  emm = meep.emm;-30.d

;in order to make sure julday didn't round oddly these arrays
;need to be specified as double persision. If they aren't IDL
;will sometimes round the hours so that they may be off by an hour in
;either direction which can cause a lot of programs. 
  onset_time = DBLARR(n_elements(day))
  mjul = DBLARR(n_elements(day)) ;onset_time
  ejul = DBLARR(n_elements(day)) ;onset_time

  minSymarray = make_array(N_elements(onset_time))
  recovSymarray = make_array(N_elements(onset_time))
  all_emic = make_array(length, value = 0)
  all_normstartcr = make_array(length, value = 0)
  all_normsym = make_array(N_elements(onset_time), length)
  all_normemic = make_array(n_elements(onset_time), length)
  scalelength = make_array(3,n_elements(onset_time))


;Here we create the julian times for the onsets, the minimum Sym (the
;end of the main phase) and the end of the recovery back up to 80%. In
;order to make sure that julday wasn't rounding the hours oddly
;everything had to be made sure to be double persision. 
  for l = 0, n_elements(day)-1 do begin
     jday = julday(month(l), day(l), year(l), hour(l), omm(l), 0.d)
     onset_time(l) = jday ;jul2yday(jday) - year*1000.
     mjul(l) = julday(mmonth(l), mday(l), year(l), mhour(l), mmm(l), 0.d)
     ejul(l) = julday(emonth(l), eday(l), year(l), ehour(l), emm(l), 0.d)
  endfor

;Here we start the main part of the program. 
  for k = 0l, n_elements(onset_time) - 1. do begin
     ;print, 'starting loop',k,'in Sym_prep'
                                ;Here we start defining the arrays for
                                ;each of the storm phases. The onset
                                ;array starts from 3 hours before the
                                ;onset of the storm. The mainphase array
                                ;goes from the start of the storm to
                                ;the min. Sym. The Recov time goes
                                ;from the end of the main phase to
                                ;when the Sym recovers to 80% or the
                                ;next storm starts. 
     otime = findgen(3.d*60.d)/(24.d*60.d) + onset_time(k) - (3.d/24.d)  
     maintime = findgen(floor(double(mjul(k) - onset_time(k))*24.d*60.d))/(24.d*60.d)+onset_time(k)
     recovtime = findgen(floor(double(ejul(k) - mjul(k))*24.d*60.d))/(24.d*60.d)+mjul(k)

;     if floor(double(mjul(k) - onset_time(k))*24.d*60.d)/10. - floor(floor(double(mjul(k) - onset_time(k))*24.d*60.d)/10.) ne 0 then $
;     print, floor(double(mjul(k) - onset_time(k))*24.d*60.d)/10. - floor(floor(double(mjul(k) - onset_time(k))*24.d*60.d)/10.), k
                                ;   maintime = [0, maintime+1]

;     if floor(double(ejul(k) - mjul(k))*24.d*60.d)/10. - floor(floor(double(ejul(k) - mjul(k))*24.d*60.d)/10.) ne 0 then $
;        print,  floor(double(ejul(k) - mjul(k))*24.d*60.d)/10. - floor(floor(double(ejul(k) - mjul(k))*24.d*60.d)/10.), k
     ;   recovtime = [0, recovtime+1]


                                ;caldat, onset_time(k), month, day, year, hh, mm, sec
     
                                ;Here we pick out the correct Sym Data
                                ;to use.      
     if year(k) eq 1990 then restore, datafolder+'kyoto_Sym_1990.save'
     if year(k) eq 1991 then restore, datafolder+'kyoto_Sym_1991.save'
     
                                ;this is where I cut the arrays with the relevant time intervals to
                                ;get only the time intervals in which I am interested in. The s at the
                                ;end of the variables denotes that they are being saved... I needed a
                                ;new variable name, and this was all I could come up with. 
                                ;just switched ge and le (so was le
                                ;and ge before). I think the way it is
                                ;now is right and gives the correct
                                ;dates, so this is what I'm using. 
     oconstant = where((Dstjul ge otime(0)) and (Dstjul le (otime(n_elements(otime)-1))))
     mainconstant = where((Dstjul ge maintime(0)) and (Dstjul le (maintime(n_elements(maintime)-1))))
     recovconstant = where((Dstjul ge recovtime(0)) and (Dstjul le (recovtime(n_elements(recovtime)-1))))
     

                                ; This seems like it should be better, but IDL complained and
                                ; wouldn't work so used the above method
                                ;  oconstant = fix(where((Dstjul - otime(0)) eq min(abs(Dstjul-otime(0)))), type = 3)
                                ;  mainconstant = fix(where((Dstjul - maintime(0)) eq min(abs(Dstjul- maintime(0)))), type = 3)
                                ;  recovconstant = fix(where((Dstjul -$
                                ;  recovtime(0)) eq min(abs(Dstjul-$
                                ;  recovtime(0)))), type = 3)


                                ;checking to make sure that the onset times are right. 
                                ;    caldat, SymJul(oconstant(0)), aa, bb, cc, dd
                                ;     print, 'onset time - 3 hours ', aa, bb, cc, dd
                                ;     print, 'onset time from file ', month(k), day(k), year(k), hour(k)

                                ;This was once needed but not used now.
                                ;     aconstant = fix(where((Dstjul - time(k,0)) eq min(abs(Dstjul- time(k,0)))), type = 3)
                                ;     caldat, dstjul(aconstant(0)), mtest, dtest, ytest, htest
                                ;     caldat, time(k,0), mtest, dtest, ytest,

                                ; this was a check used to make sure the oconstant wasn't -1
                                ;help, oconstant

                                ;Here we create the indexes we want
                                ;for each phase. The length of each of
                                ;the arrays plus the startting point
                                ;in each of the arrays.  
     oindex = findgen(n_elements(otime)) + oconstant(0)
     mainindex = findgen(n_elements(maintime)) + mainconstant(0)
     recovindex = findgen(n_elements(recovtime)) + recovconstant(0)


                                ;Here we finally cut the data.
     oSyms = Sym(oindex)
     mainSyms = Sym(mainindex)
     recovSyms = Sym(recovindex)
     
                                ;The next two loops deals with cutting the
                                ;EMIC wave events for each storm phase.
    if year(k) eq 1990 then  begin 
       ocrresevents = crres_event90(oindex)
       maincrresevents = crres_event90(mainindex)
       recovcrresevents = crres_event90(recovindex)
       ocrresjul = julemicCRRES_90(oindex)
       ostartcr = startCRRES_90(oindex)
       mstartcr = startCRRES_90(mainindex)
       rstartcr = startCRRES_90(recovindex)
    endif

    if year(k) eq 1991 then  begin
       ocrresevents = crres_event91(oindex) 
       maincrresevents = crres_event91(mainindex) 
       recovcrresevents = crres_event91(recovindex) 
       ocrresjul = julemicCRRES_91(oindex)
       ostartcr = startCRRES_91(oindex)
       mstartcr = startCRRES_91(mainindex)
       rstartcr = startCRRES_91(recovindex)
    endif

     oDstjuls = Dstjul(oindex)
     mainDstjuls = Dstjul(mainindex)
     recovDstjuls = Dstjul(recovindex)
;stop
     

                                ;This is where I was going to cut
                                ;pauls events but haven't yet done that.
                                ;     optime  = make_array(n_elements(otime), value = 0)
     
                                ;This is the total length of the storm
                                ;in minutes.
     length = onsetlength + mainlength + recovlength


                                ;normalizing the times and data to the
                                ;predefined lengths
                                ;Congrid just resamples the arrays to
                                ;the new length that is defined. 
     foSyms = congrid(oSyms, onsetlength)
     fmainSyms = congrid(mainsyms, mainlength)
     frecovSyms = congrid(recovsyms,recovlength)
     focrresevents = congrid(ocrresevents, onsetlength)
     fmaincrresevents = congrid(maincrresevents,mainlength)
     frecovcrresevents = congrid(recovcrresevents, recovlength)
     minSymarray(k) = mainsyms(N_elements(mainsyms)-1)
     recovSymarray(k) = recovSyms(0)
;     if k eq 1 then stop
;fostartcr = congrid(ostartcr, onsetlength) ;this isn't quiet right but we'll use for now to get an idea.
     ;fmstartcr = congrid(mstartcr,mainlength)
     ;frstartcr = congrid(rstartcr, recovlength)     
                                ;These are the scale lengths used to
                                ;resample the data to the normalized
                                ;lengths. 
     scalelength(0,k) = onsetlength/n_elements(osyms)
     scalelength(1,k) = mainlength/n_elements(mainsyms)
     scalelength(2,k) = recovlength/n_elements(recovsyms)
                                ;This was a test to see what the scale
                                ;length of the 1991 3 24 5 storm.
                                ;if k eq 22 then stop
     fostartcr = make_array(onsetlength, value = 0)
     indexocr = where(ostartcr ne 0)
     if indexocr(0) ne -1 then begin 
        for iocr = 0, n_elements(indexocr)-1. do $
           fostartcr(indexocr(iocr)*scalelength(0,k)) = ostartcr(indexocr(iocr))
     endif
     fmstartcr = make_array(mainlength, value = 0)
     indexmcr = where(mstartcr ne 0)
     if indexmcr(0) ne -1 then begin 
        for imcr = 0, n_elements(indexmcr)-1. do $
           fmstartcr(indexmcr(imcr)*scalelength(1,k)) = mstartcr(indexmcr(imcr))
     endif
     frstartcr = make_array(recovlength, value = 0)
     indexrcr = where(rstartcr ne 0)
     if indexrcr(0) ne -1 then begin 
        for ircr = 0, n_elements(indexrcr)-1. do $
           frstartcr(indexrcr(ircr)*scalelength(2,k)) = rstartcr(indexrcr(ircr))
     endif
     

                                ;Here is a check to make sure that the congrid is just resampling. 
                                ;print, 'diff. between first points,$
                                ;onsets', oSyms(0) - foSyms(0),$
                                ;' midpoints ', mainsyms(0) - fmainSyms(0),$
                                ;' recovery ',recovsyms(0) - frecovSyms(0)
                                ;print, 'diff. between end points, onsets', $
                                ;oSyms(n_elements(osyms)-1) - $
                                ;foSyms(n_elements(fosyms)-1), ' midpoints ', $
                                ;mainSyms(n_elements(mainsyms)-1) - $
                                ;fmainSyms(n_elements(fmainsyms)-1), $
                                ;' recovery ', $
                                ;recovSyms(n_elements(recovsyms)-1) -$
                                ;frecovSyms(n_elements(frecovsyms)-1)

                                ;print, scalelength(*,k), 'scale lengths'

                                ;Here we take the normalize data and
                                ;refit it together. 
     normSyms = make_array(length)
     normCRRES = normSyms
     normstartcr = normSyms
     normSyms(0:onsetlength -1 ) = foSyms 
     normSyms(onsetlength : onsetlength+mainlength -1) = fmainSyms

     normSyms(onsetlength+mainlength :length -1) = frecovSyms

     normCRRES(0:onsetlength -1 ) = focrresevents 
     normCRRES(onsetlength : onsetlength + mainlength-1) = fmaincrresevents
     normCRRES( onsetlength + mainlength : length -1) = frecovcrresevents
     normstartcr(0:onsetlength -1 ) = fostartcr
     normstartcr(onsetlength : onsetlength + mainlength-1) = fmstartcr
     normstartcr( onsetlength + mainlength : length -1) = frstartcr
                                ; Here we are creating the plot of the
                                ; normalized Sym with the CRRES EMIC
                                ; events over plotted.
     recov80 = min(mainSyms)+(abs(min(mainSyms))*.8)
     plot_name = strcompress(figurefolder+'Norm_Sym'+string(floor(year(k)))+'_'+string(floor(month(k)))+'_'+$
                                string(floor(day(k)))+'_'+string(floor(hour(k)))+'.ps', /remove_all)        
        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = plot_name, /portrait
        
        plot, findgen(n_elements(normSyms)),normSyms, ytitle = 'Sym nT recov80 = '+string(recov80), $
              title =  strcompress(string(year(k))+' month'+string(floor(month(k)))+' day'+$
              string(floor(day(k)))+' hour'+string(floor(hour(k)))), xtitle = 'normalized storm phase', $
              yrange = [min([fmainSyms, frecovSyms]), max([foSyms, fmainSyms, 20.])], ystyle = 1,$
              xrange = [0, length], xstyle = 1
        oplot,findgen(n_elements(normSyms)), normCRRES*10. ;, psym = 4.;focrresevents*10.;, psym = 4
        onsettimey = findgen(Max([normSyms,20]) - (min(normSyms)-2)-1)+min(normsyms)-2
        onsettimex= make_array(n_elements(onsettimey), value = fosyms(n_elements(fosyms)-1))
        maintimey = findgen(Max([normSyms,20]) - (min(normSyms)-2)-1)+min(normsyms)-2
        maintimex= make_array(n_elements(maintimey), value = n_elements(fmainsyms)-1 + n_elements(fosyms))

                                ;Here we're ploting the 80%
                                ;recovery of the min. Sym.
        ;print, recov80
        recovery  = make_array(length, value = recov80)
        oplot, recovery

                                ;Here we're just plotting the onset and min. Sym times
        oplot, onsettimex, onsettimey
        oplot, maintimex, maintimey
        ;oplot, recovtimex, recovtimey




        device, /close_file
        close, /all
                                ;Here we are just adding the CRRES
                                ;EMIC events 

        all_emic = all_emic + normCRRES
        all_normsym(k,*) = normSyms
        all_normemic(k,*) = normCRRES
        all_normstartcr = all_normstartcr + normstartcr
  endfor
      
                                ;The main look is all done now. 
                                ;Now we are starting the superposed
                                ;epoch analysis and finding the mean,
                                ;the median and the 25 and 75th
                                ;percentiles. 
     
     mean_n_u = make_array(n_elements(all_normsym(0,*))) 
     prec24 = fltarr(n_elements(all_normsym(0,*)))
     prec50 = fltarr(n_elements(all_normsym(0,*)))
     prec75 = fltarr(n_elements(all_normsym(0,*)))
     
                                ;Sym75 this is going to be an array of
                                ;the number for the storms in the top
                                ;25%  and Sym25 the bottom 25%

     for nn = 0, n_elements(all_normsym(0,*))-1 do begin 
        good = where(finite(all_normsym(*,nn)), count)
        n_set = count
        p75 = long(75.*n_set/100.)
        p25 = long(25.*N_set/100.)
        
        array = all_normsym[*,nn]
        array = array(good)
        mean_n_u(nn) = mean(array)
        prec50(nn) = median(array)
        ii = sort(array)
        if nn eq (onsetlength+mainlength -1) then begin
           Sym75 = ii(findgen(long(25.*N_set/100.))+p75)
           Sym25 = ii(findgen(long(25.*N_set/100.)))
        endif
        prec75(nn) = array(ii(p75))
        prec24(nn) = array(ii(p25))
     endfor


                                ;loadct, 2, ncolors = 256
        !P.multi = [0,1,1]
        loadct, 6
        set_plot, 'PS'
        plotname = 'Sym25_75_percentiles'
        filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
        device, filename=filename1, /landscape , /color;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        xarray = findgen(n_elements(all_normSym(0,*)))
        maxy = max(all_normSym)
        miny = min(all_normSym)
        plot, xarray, all_normSym(Sym25(0), *), psym = 2, yrange = [miny, maxy]
        for precloop = 1l, n_elements(Sym25)-1 do oplot, xarray, all_normSym(Sym25(precloop),*), psym = 2
        for plp = 0, n_elements(Sym75)-1 do oplot, xarray, all_normSym(Sym75(plp),*), psym = 4

        device, /close_file
        close, /all

        !P.multi = [0,1,2]
        loadct, 6
        set_plot, 'PS'
        plotname = 'A_test'
        filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
        device, filename=filename1, /landscape , /color;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        xarray = findgen(n_elements(all_normSym(0,*)))
        iimin = sort(minsymarray)
        miny = min([minsymarray, recovsymarray])
        maxy = max([minsymarray, recovsymarray])
        plot, findgen(n_elements(minsymarray)), minsymarray(iimin), yrange = [miny, maxy],$
              ytitle = 'Sym for min (line) and start of recovery (*)', xtitle = 'storm number'
        oplot, findgen(n_elements(minsymarray)), recovsymarray(iimin), psym = 2
        beep = minsymarray - recovsymarray
        print, 'where beep = 0', where(beep eq 0)
        jjmin = sort(beep)
        plot, findgen(n_elements(minsymarray)),beep(jjmin), psym = 4, $
              ytitle = 'difference between the start of Sym recovery and Sym min', $
              xtitle = 'storm number', title = 'average difference'+string(mean(minsymarray - recovsymarray))
        device, /close_file
        close, /all




                                ;Here we are ploting the superposed
                                ;epoch of the entire normalized data
                                ;arrays. 

                                ;loadct, 2, ncolors = 256
        !P.multi = [0,1,1]
        loadct, 6
        set_plot, 'PS'
        plotname = 'CRRES_norm_Sym'
        filename1 = strcompress(figurefolder+'stat_'+plotname+'.ps', /remove_all)
        device, filename=filename1, /portrait , /color;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        
        
        x = findgen(length)
        plot, x, prec50, ytitle = 'Sym (nT) and occurance of EMIC waves (counts*10.) ', $
              yrange = [-150, max(all_emic*10)], ystyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = 'phase of storm', xrange = [min(x), max(x)], xstyle = 1, charsize = ch   ;, ymargin = [0.1,2] ;, psym = 5
        oplot,x,  mean_n_u, color = 50, thick = 4

        oplot,x, prec75, color = 200, thick = 4;, linestyle = 2
        oplot,x, prec24, color = 200, thick = 4
        oplot, x, prec50, color = 50;, linestyle = 2
        xyouts, onsetlength*.1, -125, 'onset', charsize = ch
        xyouts, (mainlength+onsetlength)*.5,  -125, 'Main phase', charsize = ch
        xyouts, length*.6, -125,  'recovery phase', charsize = ch
        oplot, x, all_emic*10.

        onsettimey = findgen(Max(all_emic*10.)+150)-150
        onsettimex= make_array(n_elements(onsettimey), value = n_elements(fosyms)-1)
        maintimey =findgen(Max(all_emic*10.)+150)-150
        maintimex= make_array(n_elements(maintimey), value = n_elements(fmainsyms)-1 + n_elements(fosyms))

        oplot, onsettimex, onsettimey
        oplot, maintimex, maintimey


        device, /close_file
        close, /all


                                ;Here we are ploting the scaling
                                ;factor for each of the storms (color)
                                ;and then the emic wave events (along
                                ;with the total count)
        !P.multi = [0,1,2]
;        loadct, 6


        plotname = 'storm_emic'
        filename1 = strcompress(figurefolder+'stat_'+plotname+'.ps', /remove_all)
        set_plot, 'PS'
;        device;, decomposed = 0
;        winnum = 1
;        window, winnum, xsize = 600, ysize = 700, title =filename1  
        device, filename=filename1, /landscape ;, /color ;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        
        index = where(all_normemic(0,*) eq 0)
;        all_normemic(0,index) = !values.F_NaN
        x = findgen(length)
        
        nonum = where(all_normemic eq 0)
        all_normemic(nonum) = !Values.F_NaN
        plot, x, all_normemic(0,*), ytitle = 'EMIC events for each storm (psyms) and occurance of EMIC waves (counts) ', $
              yrange = [0, n_elements(all_normemic(*,1))], ystyle = 1, xrange = [min(x), max(x)],$
              title = 'Emic events during storms with scaling factor for each storm', $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = 'emic event', xstyle = 1, psym = 7, $ ; thick = 7,
              pos = [0.,0.,.9,1.]               ;, ymargin = [0.1,2] ;, psym = 5
        loadct, 27, ncolors = max([scalelength])+1.

;        polyfill, [0,onsetlength,onsetlength, 0], [0,0,1,1], color = (scalelength(0,0))
;        polyfill, [onsetlength,mainlength+onsetlength,mainlength+onsetlength,onsetlength], [0,0,1,1],$
;                  color = scalelength(1,0)  ;color = (2./scalelength(1,0))*255.
;        polyfill, [mainlength+onsetlength, recovlength+onsetlength+mainlength, recovlength+onsetlength+mainlength,$
;                   mainlength+onsetlength], [0,0,1,1], color = scalelength(2,0)    ; color = (2./scalelength(2,0))*255.

        for jj = 0l, n_elements(all_normemic(*,1))-1 do begin 
           polyfill, [0,onsetlength,onsetlength, 0], [jj,jj,jj+1,jj+1], color = scalelength(0,jj) ; color = (2./scalelength(0,jj))*255.
           polyfill, [onsetlength,mainlength+onsetlength,mainlength+onsetlength, onsetlength], [jj,jj,jj+1,jj+1], $
                     color = scalelength(1,jj)  ;color = (2./scalelength(1,jj))*255.
           polyfill, [mainlength+ onsetlength,recovlength+ onsetlength+mainlength,recovlength+ onsetlength+mainlength, $
                      mainlength+ onsetlength], [jj,jj,jj+1,jj+1], color = scalelength(2,jj)  ;color = (2./scalelength(2,jj))*255.
           oplot, x, all_normemic(jj,*)*jj+.5, psym = 7
                                ;thick = 7
                                ;This was a test/check
                                ;           if jj eq 30 then stop
        endfor

        xyouts, onsetlength*.1, -125, 'onset'
        xyouts, (mainlength+onsetlength)*.5,  -125, 'Main phase'
        xyouts, length*.6, -125,  'recovery phase'
        oplot, x, all_emic
        
        onsettimey = findgen(jj)
        onsettimex= make_array(n_elements(onsettimey), value = n_elements(fosyms)-1)
        maintimey =findgen(jj)
        maintimex= make_array(n_elements(maintimey), value = n_elements(fmainsyms)-1 + n_elements(fosyms))

        oplot, onsettimex, onsettimey
        oplot, maintimex, maintimey


;        plot,findgen(10), findgen(256), pos = [.95,0.,1.,1.], yrange = [0,255], ystyle = 1. 
;        polyfill, [0,10,10,0], [0.01 ,0.01,(1)/128., (1)/128.], color = 0
;        for kk = 1l, 255 do begin
;           polyfill, [0,10,10,0], [kk,kk,kk+1, kk+1], color = kk
;        endfor
        
                                ;Here we create the color bar for the
                                ;scaling length 
        loadct, 0
        plot,findgen(10), findgen(max([scalelength])), pos = [.95,0.,1.,1.], yrange = [0,max([scalelength])], ystyle = 1., $
             ytitle = 'scaling factor'
       
        loadct, 27, ncolors = max([scalelength])
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 0
        for kk = 1l, max([scalelength])-1. do begin
           polyfill, [0,10,10,0], [kk,kk,kk+1, kk+1], color = kk
        endfor
;        image = TVRD(0,0,!d.X_size, !d.Y_size, true = 1)
;        write_PNG, filename1, image, r, g, b
        
        device, /close_file
        close, /all



                                ;Here we create the superposed epoch
                                ;for each of the phases of the storms.

        onsetmean = mean_n_u(0:onsetlength-1)
        mainmean = mean_n_u(onsetlength : onsetlength + mainlength -1)
        recovmean = mean_n_u(onsetlength+mainlength : length -1)

        onset50 = prec50(0:onsetlength-1)
        main50 = prec50(onsetlength : onsetlength + mainlength -1)
        recov50 = prec50(onsetlength+mainlength : length -1)

        onset75 = prec75(0:onsetlength-1)
        main75 = prec75(onsetlength : onsetlength + mainlength -1)
        recov75 = prec75(onsetlength+mainlength : length -1)

        onset25 = prec24(0:onsetlength-1)
        main25 = prec24(onsetlength : onsetlength + mainlength -1)
        recov25 = prec24(onsetlength+mainlength : length -1)

        oallstartcr = all_normstartcr(0:onsetlength-1)
        mallstartcr = all_normstartcr(onsetlength : onsetlength + mainlength -1)
        rallstartcr = all_normstartcr(onsetlength+mainlength : length -1)
        
                                ; Here we start the plot for the super
                                ; posed epoch analysis where we
                                ; determine the values for each
                                ; individual phases.





        ohistcr = make_array(onsetlength/(onsetlength*opcr))
        ostep = onsetlength*opcr
        oxcr = findgen(n_elements(ohistcr))/n_elements(ohistcr)*100.
        for ocr = 0l, n_elements(ohistcr)-1 do ohistcr(ocr) = total(oallstartcr(ocr*ostep:ocr*ostep+ostep-1))


        mhistcr = make_array(mainlength/(mainlength*mpcr))
        mstep = mainlength*mpcr
        mxcr = findgen(n_elements(mhistcr))/n_elements(mhistcr)*100.
        for mcr = 0l, n_elements(mhistcr)-1 do mhistcr(mcr) = total(mallstartcr(mcr*mstep:mcr*mstep+mstep-1))


        rhistcr = make_array(recovlength/(recovlength*rpcr))
        rstep = recovlength*rpcr
        rxcr = findgen(n_elements(rhistcr))/n_elements(rhistcr)*100.
        for rcr = 0l, n_elements(rhistcr)-1 do rhistcr(rcr) = total(rallstartcr(rcr*rstep:rcr*rstep+rstep-1))

        ohistcr = congrid(ohistcr, onsetlength)
        mhistcr = congrid(mhistcr, mainlength)
        rhistcr = congrid(rhistcr, recovlength)
        ymax = max([rhistcr, mhistcr, ohistcr])
                                ;loadct, 2, ncolors = 256
        !P.multi = [0,3,1]
        loadct, 6
        set_plot, 'PS'
        plotname = 'CRRES_norm_Sym'
        filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
        device, filename=filename1, /landscape , /color;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        
        
        ox = findgen(onsetlength)/onsetlength * 100.
        plot, ox, onsetmean, ytitle = 'Sym (nT) and occurance of EMIC waves ', charsize = ch+.5, $
              yrange = [-100, ymax], ystyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = '3 hours before onset', ymargin = [0.1,.01],pos = [0.,0.,.15,1.] ;, psym = 5
        ;oplot,ox,  mean_n_u, color = 50, thick = 4

        oplot,ox, onset75, color = 200, thick = 4;, linestyle = 2
        oplot,ox, onset25, color = 200, thick = 4
        oplot, ox, onset50, color = 50;, linestyle = 2
;        oplot, ox, all_emic(0:onsetlength-1)*10.
;        oplot, histogram(oallstartcr, binsize = floor(.05*onsetlength))*10, color = 200
        oplot, ox, ohistcr, color = 200


        mx = findgen(mainlength)/mainlength *100.
        plot, mx, mainmean,  title = 'Normalized Storms for the CRRES mission and EMIC wave occurance', charsize = ch+.5, $
              yrange = [-100,ymax], ystyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = 'main phase', ymargin = [.01,.01],pos = [.15,0.,.5,1.] ;, psym = 5
        ;oplot,mx,  , color = 50, thick = 4

        oplot,mx, main75, color = 200, thick = 4;, linestyle = 2
        oplot,mx, main25, color = 200, thick = 4
        oplot, mx, main50, color = 50;, linestyle = 2
;        oplot, mx, all_emic(onsetlength : onsetlength + mainlength -1)*10.
;        oplot, mx, histogram(mallstartcr, binsize = floor(.05*mainlength))*10, color = 200
        oplot, mx, mhistcr, color = 200

        rx = findgen(recovlength)/recovlength *100.
        plot, rx, recovmean, charsize = ch+.5, $
              yrange = [-100,ymax], ystyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = 'recovery phase', ymargin = [.01,.01],pos = [.5,0.,1.,1.] ;, psym = 5
        ;oplot,ox,  , color = 50, thick = 4

        oplot,rx, recov75, color = 200, thick = 4;, linestyle = 2
        oplot,rx, recov25, color = 200, thick = 4
        oplot, rx, recov50, color = 50;, linestyle = 2
;        oplot, rx, all_emic(onsetlength+mainlength  : length -1)*10.
;        oplot, rx, histogram(rallstartcr, binsize = floor(.05*recovlength))*10, color = 200
        oplot, rx, rhistcr, color = 200

        device, /close_file
        close, /all




        !P.multi = [0,0,7]

        set_plot, 'PS'
        plotname = 'CRRES_spec_Sym'
        filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
        device, filename=filename1, /landscape , /color;, $
                                ; xsize = 7, ysize = 9, xoffset =.5, yoffset = .5, /inches
        loadct, 0

        ox = findgen(onsetlength)/onsetlength * 100.
        plot, ox, make_array(n_elements(ox), value = 0), ytitle = 'Sym (nT) ', $
              yrange = [0, 4], ystyle = 1, xrange = [0,n_elements(ox)],xstyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = '3 hours before onset', ymargin = [0.1,.01],pos = [0.,0.,.15,.15], charsize = ch ;, psym = 5

        numbcolors = Abs(min([onset75, onset25, main75, main25,recov75, recov25]))+ abs(max([onset75, onset25, main75, main25, recov75, recov25]))+15
        minoff = abs(min([onset75, onset25, main75, main25,recov75, recov25]))+15
        loadct, 27, ncolors = numbcolors+1.+1.

        for oi25 = 0l, n_elements(ox) - 1 do begin
           polyfill, [oi25, oi25+1,oi25+1, oi25], [0,0,1,1], color = onset25(oi25)+minoff
        endfor
        for oi = 0l, n_elements(ox) - 1 do begin
           polyfill, [oi, oi+1,oi+1, oi], [1,1,2,2], color = onsetmean(oi)+minoff
        endfor
        for oi50 = 0l, n_elements(ox) - 1 do begin
           polyfill, [oi50, oi50+1,oi50+1, oi50], [2,2,3,3], color = onset50(oi50)+minoff
        endfor

        for oi75 = 0l, n_elements(ox) - 1 do begin
           polyfill, [oi75, oi75+1,oi75+1, oi75], [3,3,4,4], color = onset75(oi75)+minoff
        endfor

        loadct, 0
        plot, ox, ohistcr, ytitle = 'Occurance of EMIC waves', yrange = [0., max([ohistcr, mhistcr, rhistcr])], ystyle = 1, pos = [0.,.15,.15,1.], charsize = ch ;, psym = 5


        mx = findgen(mainlength)/mainlength *100.
        plot, mx, make_array(n_elements(mx), value = 0), $
              yrange = [0, 4], ystyle = 1, xrange = [0,n_elements(mx)], xstyle = 1,charsize = ch,$
              xtitle = 'main phase', ymargin = [.01,.01],pos = [.15,0.,.5,.15] ;, psym = 5
              
        loadct, 27, ncolors = numbcolors+1.+1.
        for mi = 0, n_elements(mx) - 1 do begin
           polyfill, [mi, mi+1,mi+1, mi], [1,1,2,2], color = mainmean(mi)+minoff
        endfor
        for mi75 = 0, n_elements(mx) - 1 do begin
           polyfill, [mi75, mi75+1,mi75+1, mi75], [3,3,4,4], color = main75(mi75)+minoff
        endfor
        for mi25 = 0, n_elements(mx) - 1 do begin
           polyfill, [mi25, mi25+1,mi25+1, mi25], [0,0,1,1], color = main25(mi25)+minoff
        endfor
        for mi50 = 0, n_elements(mx) - 1 do begin
           polyfill, [mi50, mi50+1,mi50+1, mi50], [2,2,3,3], color = main50(mi50)+minoff
        endfor

        loadct, 0
        plot, mx, mhistcr, pos = [.15,.15,.5,1.],  title = 'Normalized Storms for the CRRES mission and EMIC wave occurance', yrange = [0., max([ohistcr, mhistcr, rhistcr])], ystyle = 1, charsize = ch

        rx = findgen(recovlength)/recovlength *100.
        plot, rx, make_array(n_elements(rx), value = 0), $
              yrange = [0, 4], ystyle = 1, xrange = [0,n_elements(rx)], xstyle = 1, charsize = ch,$
              xtitle = 'recovery phase', ymargin = [.01,.01],pos = [.5,0.,.9,.15] ;, psym = 5
              
        loadct, 27, ncolors = numbcolors+1.+1.
        for ri = 0, n_elements(rx) - 1 do begin
           polyfill, [ri, ri+1,ri+1, ri], [1,1,2,2], color = recovmean(ri)+minoff
        endfor
        for ri75 = 0, n_elements(rx) - 1 do begin
           polyfill, [ri75, ri75+1,ri75+1, ri75], [3,3,4,4], color = recov75(ri75)+minoff
        endfor
        for ri25 = 0, n_elements(rx) - 1 do begin
           polyfill, [ri25, ri25+1,ri25+1, ri25], [0,0,1,1], color = recov25(ri25)+minoff
        endfor
        for ri50 = 0, n_elements(rx) - 1 do begin
           polyfill, [ri50, ri50+1,ri50+1, ri50], [2,2,3,3], color = recov50(ri50)+minoff
        endfor
        loadct, 0
        plot, rx, rhistcr, ymargin = [.01,.01],pos = [.5,.15,.90,1.0], yrange = [0., max([ohistcr, mhistcr, rhistcr])], ystyle = 1, charsize = ch ;, psym = 5


                                ;Here we create the color bar for the
                                ;scaling length
        loadct, 0
        ycb = findgen(numbcolors+1)+ min([onset25, main25, recov25,onset75, main75, recov75])
        plot,findgen(10),ycb, pos = [.95,0.,1.,1.],charsize = ch, $
             yrange = [min(ycb), max(ycb)], ystyle = 1., $
             ytitle = 'Sym'
       
        loadct, 27, ncolors = numbcolors+1+1.
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 0
        for kk = 0l, N_elements(ycb)-2 do begin
           polyfill, [0,10,10,0], [ycb(kk),ycb(kk),ycb(kk+1), ycb(kk+1)], color = kk
        endfor
        
        device, /close_file
        close, /all


        
;**********************************************************************************************
;**********************************************************************************************
;**********************************************************************************************
;**********************************************************************************************
;**********************************************************************************************
;        all_normsym(k,*) = normSyms
        
        min_ansh = min(all_normsym)
        ansh = all_normsym - min_ansh
        max_ansh = max(ansh)
        ansh = (ansh/max_ansh)*250.
        onset_all = ansh(*,0:onsetlength-1) ;all_normsym(*,0:onsetlength-1)
        main_all =  ansh(*, onsetlength: onsetlength + mainlength -1) ;all_normsym(*, onsetlength: onsetlength + mainlength -1)
        recov_all= ansh(*, onsetlength + mainlength :length-1)  ;all_normsym(*, onsetlength + mainlength :length-1)


        !P.multi = [0,0,4]
        set_plot, 'PS'
        plotname = 'all_spec_Sym'
        filename1 = strcompress(figurefolder+plotname+'.ps', /remove_all)
        device, filename=filename1, /landscape , /color;, $
        loadct, 0
        numstorms = n_elements(all_normsym(*,0))
        ox = findgen(onsetlength+1)/(onsetlength+1) * 100.
;stop
        plot, ox(0:n_elements(ox)-1), make_array(n_elements(ox), value = 0), ytitle = 'Sym (nT) ', $
              yrange = [0, numstorms], ystyle = 1, xrange = [0,100.],xstyle = 1, $ ;yrange = [min(all_normsym), max(all_normsym)], $ 
              xtitle = '3 hours before onset', ymargin = [0.1,.01],pos = [0.,0.,.15,1.], charsize = ch ;, psym = 5

        numbcolors = Abs(min(ansh))+abs(max(ansh))
;        minoff = abs(min(all_normsym))
;        print, numbcolors, ' colors in plot', minoff, ' offset to Sym'
        for all = 0l, n_elements(all_normsym(*,0))-1 do begin
           loadct, 20, ncolors = numbcolors
           for oi = 0l, n_elements(ox) - 2 do begin
              polyfill, [ox(oi), ox(oi+1),ox(oi+1), ox(oi)], [all,all,all+1,all+1], color = onset_all(all,oi) ;+minoff
           endfor
           loadct, 0
           oplot, ox, all_normemic(all, 0:onsetlength-1) + all+.5, psym = 5
        endfor

        loadct, 0
        mx = findgen(mainlength+1)/(mainlength+1) *100.
        plot, mx(0:n_elements(mx)-1), make_array(n_elements(mx), value = 0), charsize = ch, $
              yrange = [0, numstorms], ystyle = 1, xrange = [0,100.], xstyle = 1,$
              xtitle = 'main phase', ymargin = [.01,.01],pos = [.15,0.,.5,1.] ;, psym = 5
              
        for all2 = 0l, n_elements(all_normsym(*,0))-1 do begin
           loadct, 20, ncolors = numbcolors
           for mi = 0, n_elements(mx) - 2 do begin
              polyfill, [mx(mi), mx(mi+1),mx(mi+1), mx(mi)], [all2,all2,all2+1,all2+1], color = main_all(all2,mi) ;+minoff
           endfor
           loadct, 0
           oplot, mx, all_normemic(all2, onsetlength:onsetlength+mainlength-1) + all2+.5, psym = 5
        endfor

        loadct, 0
        rx = findgen(recovlength+1)/(recovlength+1) *100.
        plot, rx(0:n_elements(rx)-1), make_array(n_elements(rx), value = 0), charsize = ch, $
              yrange = [0, numstorms], ystyle = 1, xrange = [0,100.], xstyle = 1,$
              xtitle = 'recovery phase', ymargin = [.01,.01],pos = [.5,0.,.9,1.] ;, psym = 5
              

        for all3 = 0l, numstorms-1 do begin
        loadct, 20, ncolors = numbcolors
           for ri = 0, n_elements(rx) - 2 do begin
              polyfill, [rx(ri), rx(ri+1),rx(ri+1), rx(ri)], [all3,all3,all3+1,all3+1], color = recov_all(all3,ri) ;+minoff
           endfor
           loadct, 0
           oplot, rx, all_normemic(all3, onsetlength + mainlength:length-1) + all3+.5, psym = 5
        endfor

                                ;Here we create the color bar for the
                                ;scaling length
        loadct, 0
        ycb = findgen(numbcolors)/(numbcolors)
        range = max(all_normsym)-min(all_normsym)
        ycb = ycb*range + min(all_normsym)
        plot,findgen(10),ycb, pos = [.95,0.,1.,1.], charsize = ch, $
             yrange = [min(ycb), max(ycb)], ystyle = 1., $
             ytitle = 'Sym'
       
        loadct, 20, ncolors = numbcolors
        polyfill, [0,10,10,0], [0 ,0,1, 1], color = 0
        for kk = 0l, N_elements(ycb)-2 do begin
           polyfill, [0,10,10,0], [ycb(kk),ycb(kk),ycb(kk+1), ycb(kk+1)], color = kk
        endfor
        
        device, /close_file
        close, /all




end
