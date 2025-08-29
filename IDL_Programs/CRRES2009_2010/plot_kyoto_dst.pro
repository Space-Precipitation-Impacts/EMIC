pro plot_kyoto_dst, sbuffer, ebuffer, savefolder, figurefolder;, plot_all = plot_all
;this program makes plots for each of the events specifies in the
;document file used in the previous programs. 
  
;here we create the individual plots for the SW data


  CRRESsave =  strcompress(datafolder+'CRRES_EMIC'+'.save',$
               /remove_all)
  restore, strcompress(savefolder+'Dstready_events.save')
  restore, save_file_names(0) 

  allDst = make_array(n_elements(dsts), n_elements(save_file_names))

  for i = 0l, n_elements(save_file_names)-1. do begin
        restore, save_file_names(i)
;       
;        yday = make_array(n_elements(month))
 ;       for j = 0, n_elements(month)-1 do begin 
;           Julianday = julday(month(j), day(j), year(j), hh(j), mm(j), 00)
;           ydayindex = jul2yday(julianday)
;           yday(j) = long(ydayindex)
;        endfor
        

;stop
        dx = (findgen(n_elements(dsts)) - sbuffer)/60.
        fracday = dx/24.
        julonset = julday(month, day, year, hh, mm, 00)
        ydayonset = jul2yday(julonset)
        doy = ydayonset - (year*1000)
        doydx = doy + fracday
                                ;     KE = calc_dp(V*10^(-3.), dens) ; units nPa
 ;stop       
        plot_name = strcompress('../Figures/Dst'+string(floor(year))+'_'+string(floor(month))+'_'+$
                                string(floor(day))+'_'+string(floor(hh))+'.ps', /remove_all)        
        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = plot_name, /portrait
        
        plot, doydx, Dsts, ytitle = 'Dst nT', title =  strcompress(string(year)+' month'+string(floor(month))+' day'+$
                   string(floor(day))+' hour'+string(floor(hh))), xtitle = 'day of year', yrange = [min(Dsts)-2, max(Dsts)+2], ystyle = 1,$
                   xrange = [min(doydx), max(doydx)], xstyle = 1
        

        onsettimey = findgen(Max(dsts+2) - (min(dsts)-2)-1)+min(dsts)-2
        onsettimex= make_array(n_elements(onsettimey), value = doy)
        stormtime  = make_array(n_elements(Dsts), value = -40.)
        recovery  = make_array(n_elements(Dsts), value = -30.)

        oplot, onsettimex, onsettimey
        oplot, stormtime
        oplot, recovery


        device, /close_file
        close, /all

  endfor
  
end
