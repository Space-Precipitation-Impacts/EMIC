pro plot_dst_emic, sbuffer, ebuffer, datafolder, savefolder, figurefolder;, plot_all = plot_all
;this program makes plots for each of the events specifies in the
;document file used in the previous programs. 
  
                                ;Creating the names of the files which
                                ;hold the CRRES EMIC wave events
  CRRESsave =  strcompress(datafolder+'CRRES_EMIC'+'.save',$
               /remove_all)
  Paulsave =  strcompress(datafolder+'crres_events_Paul'+'.save',$
               /remove_all)

                                ;Here we restore the CRRES data
  restore, crressave
  restore, Paulsave
  cryear = year

                                ; Here we restore the Dst data
                                ;Here we restore the file names that
                                ;we plan to work with which were
                                ;created in previous programs.
  restore, strcompress(savefolder+'Dstready_events.save')
  restore, save_file_names(0) 

  allDst = make_array(n_elements(syms), n_elements(save_file_names))


                                ;This loop goes through each storm
                                ;event during the CRRES mission.
  for i = 0l, n_elements(save_file_names)-1. do begin

                                ; Here we restore the relevent Dst data
        restore, save_file_names(i)
                                ; Here we create the CRRES years in
                                ; the correct format
        CRRESyear = make_array(n_elements(cryear))
        for cri = 0, n_elements(cryear)-1 do CRRESyear(cri) = 1900.+floor(cryear(cri))
                                ;Here we are creating the index to
                                ;find the correct years, I think that
                                ;I could use the CRRES_Event90 or 91
                                ;but this seems to work for now

;        index = where(CRRESyear eq years)   ; these are the indices where the emic event is in the same year. 
;        Pindex = where(pyear eq years) ; these are the indices where the emic event is in the same year. 
                                ;       crjulday = doy2julday(doy(index),year, hr, mn, sc)
                                ;Here we find the correct year day for
                                ;the EMIC events.
;        crfracday = ut/24. 
;        crevent = doy(index)+crfracday(index)
;        creventy = make_array(n_elements(crevent), value = -10)
;        Pevent = Pdoy(Pindex)+Put(Pindex)
;        Peventy = make_array(n_elements(Pevent), value = -20)

                                ;Here we are creating the x- axis for
                                ;the Dst data.
        dx = (findgen(n_elements(syms)) - sbuffer)/60. ;onset is at zero.
        fracday = dx/24.
        julonset = julday(months, days, years, hours, mins, 0.d)
        ydayonset = jul2yday(julonset)
        dstdoy = ydayonset - (years*1000) ;this is the zero point then 
        doydx = dstdoy + fracday
        
        if years eq 1990 then creventjul = julemicCRRES_90
        if years eq 1991 then creventjul = julemicCRRES_91
        ydaycrevent = jul2yday(creventjul)
        crevent = ydaycrevent - (years*1000.)
        if years eq 1990 then creventy = CRRES_event90
        if years eq 1991 then creventy = CRRES_Event91
                                ;This is just to find the 80%
                                ;recovery, but isn't excatly
                                ;correct because we've taken
                                ;the Dst over the longest storm length
                                ;which can lead to lower Dst after the
                                ;min. that we are interested in. 
        recov80 = min(Syms)+(abs(min(Syms))*.8)

                                ;Here we create the plot name
        plot_name = strcompress('../Figures/Dst'+string(floor(years))+'_'+string(floor(months))+'_'+$
                                string(floor(days))+'_'+string(floor(hours))+'.ps', /remove_all)        
        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = plot_name, /portrait
                                ;Here we plot the Dst        
        plot, doydx, Syms, ytitle = 'Dst nT recov80 = '+string(recov80), $
              title =  strcompress(string(years)+' month'+string(floor(months))+' day'+$
              string(floor(days))+' hour'+string(floor(hours))), xtitle = 'day of year', $
              yrange = [min(Syms)-2, max([max(Syms)+2, -5.])], ystyle = 1, xrange = [min(doydx), max(doydx)], xstyle = 1
                                ;Here we are ploting the CRRES and
                                ;Pauls EMIC events
        oplot, crevent, creventy*10.;, psym = 2
;        oplot, Pevent, Peventy, psym = 2
                                ;Here we are just ploting a line
                                ;through the onset time.
        onsettimey = findgen(Max(syms+2) - (min(syms)-2)-1)+min(syms)-2
        onsettimex= make_array(n_elements(onsettimey), value = dstdoy)
        oplot, onsettimex, onsettimey
                                ;Here we are just plotting
                                ;where "storm conditions" begin and
                                ;the "80%" recovery
        stormtime  = make_array(n_elements(Syms), value = -40.)
        recovery  = make_array(n_elements(Syms), value = recov80)
        oplot, stormtime
        oplot, doydx, recovery, linestyle = 2


        device, /close_file
        close, /all

  endfor

  
end
