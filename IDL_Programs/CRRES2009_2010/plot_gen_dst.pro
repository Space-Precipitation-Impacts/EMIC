pro plot_gen_dst ; , datafolder, figurefolder
;this program makes plots for each week of the CRRES mission. 

lengthday = 1
syear = 1990

datafolder = '../Data/'

figurefolder = '../figures/'
  restore, datafolder + 'kyoto_Sym_1991.save'

;.compile jul2yday
yday = jul2yday(dstjul)


dayindex = where(yday ge 68.7 and yday lt 70)
xday = yday(dayindex)
onsetlength = 60.*3. ;180.
mainlength = 6000.;3000.
recovlength = 12000.;8000.
length = onsetlength + mainlength + recovlength
;The CRRES Data
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC'+'.save',$
               /remove_all)

;The storm files.

  restore, crressave

;  Making sure that the EMIC data is correct.

;Getting out the storm phase data
  year = 1991.
  month = 3.
  day = 10.
  hour = 0.
  mday = 10.
  mmonth = 3.
  mhour = 4.
  emonth = 3.
  eday = 10.
  ehour = 18.
  omm = 30.
  mmm = 11.
  emm = 20.

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
     jday = julday(month, day, year, hour, omm, 0.d)
     onset_time = jday ;jul2yday(jday) - year*1000.
     mjul = julday(mmonth, mday, year, mhour, mmm, 0.d)
     ejul = julday(emonth, eday, year, ehour, emm, 0.d)
     
     oyday = jul2yday(jday); - year*1000.
     myday = jul2yday(mjul); - year*1000.
     eyday = jul2yday(ejul); - year*1000.

sdayindex = where(yday eq (oyday - (3./24.)))
sxday = yday(sdayindex)
odayindex = where(yday eq oyday)
oxday = yday(odayindex)
mdayindex = where(yday eq myday)
mxday = yday(mdayindex)
edayindex = where(yday eq eyday)
exday = yday(edayindex)


       !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = '../Desktop/storm_example.ps', /landscape
        

        plot, xday, sym(dayindex), yrange = [min(sym(dayindex)), max(sym(dayindex))] , ytitle = 'Sym nT',$
              xtitle = 'Year Day', xrange = [min(xday), max(xday)], xstyle = 1, $ ;, xticks = 24, xminor = 6,$
              title = 'Geomagnetic storm on the September 24th 1991 onwards' , charsize = 1.5, thick = 2, ystyle = 1
;        oplot, xday, make_array(n_elements(sym(dayindex)), value = -40)
;        oplot, xday,  make_array(n_elements(sym(dayindex)), value = -10.8)

        stimey = findgen(Max([sym(dayindex),20]) - (min(Sym(dayindex))-2)-1)+min(sym(dayindex))-2
        stimex= make_array(n_elements(stimey), value = sxday)

        onsettimey = findgen(Max([sym(dayindex),20]) - (min(Sym(dayindex))-2)-1)+min(sym(dayindex))-2
        onsettimex= make_array(n_elements(onsettimey), value = oxday(0))

        maintimey = findgen(Max([sym(dayindex),20]) - (min(Sym(dayindex))-2)-1)+min(sym(dayindex))-2
        maintimex= make_array(n_elements(maintimey), value = mxday(0))

        recovtimey = findgen(Max([sym(dayindex),20]) - (min(Sym(dayindex))-2)-1)+min(sym(dayindex))-2
        recovtimex= make_array(n_elements(maintimey), value = exday(0))

        oplot, stimex, stimey
        oplot, onsettimex, onsettimey, color = 200
        oplot, maintimex, maintimey, color = 200
        oplot, recovtimex, recovtimey

        device, /close_file
        close, /all


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
     recovSymarray(k) = recovSyms(0)+1.
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

 ;    normCRRES(0:onsetlength -1 ) = focrresevents 
 ;    normCRRES(onsetlength : onsetlength + mainlength-1) = fmaincrresevents
 ;    normCRRES( onsetlength + mainlength : length -1) = frecovcrresevents
 ;    normstartcr(0:onsetlength -1 ) = fostartcr
 ;    normstartcr(onsetlength : onsetlength + mainlength-1) = fmstartcr
 ;    normstartcr( onsetlength + mainlength : length -1) = frstartcr
                                ; Here we are creating the plot of the
                                ; normalized Sym with the CRRES EMIC
                                ; events over plotted.
     recov80 = min(mainSyms)+(abs(min(mainSyms))*.8)
     plot_name = strcompress('../Desktop/Norm_storm_example.ps', /remove_all)        
        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = plot_name, /portrait
        
        plot, findgen(n_elements(normSyms)),normSyms, ytitle = 'Sym nT recov80 = '+string(recov80), $
              title =  strcompress(string(year(k))+' month'+string(floor(month(k)))+' day'+$
              string(floor(day(k)))+' hour'+string(floor(hour(k)))), xtitle = 'normalized storm phase', $
              yrange = [min([fmainSyms, frecovSyms]), max([foSyms, fmainSyms, 20.])], ystyle = 1,$
              xrange = [0, length], xstyle = 1

;        oplot,findgen(n_elements(normSyms)), normCRRES*10. ;, psym = 4.;focrresevents*10.;, psym = 4
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
      
endfor
;       !P.multi=[0,1,1]
;        set_plot, 'PS'
;        device, filename = '../Desktop/norm_storm_example.ps', /landscape
;        ;
;
;        plot, xday, sym(dayindex), yrange = [min(sym(dayindex)), max(sym(dayindex))] , ytitle = 'Sym nT',$
;              xtitle = 'Year Day', xrange = [min(xday), max(xday)], xstyle = 1, $ ;, xticks = 24, xminor = 6,$
;              title = 'Geomagnetic storm on the September 24th 1991 onwards' , charsize = 1.5, thick = 2
;;        oplot, xday, make_array(n_elements(sym(dayindex)), value = -40)
;        oplot, xday,  make_array(n_elements(sym(dayindex)), value = -10.8)
;        
;        device, /close_file
;        close, /all






stop 


end
