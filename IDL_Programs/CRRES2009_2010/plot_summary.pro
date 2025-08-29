pro plot_summary, datafolder, figurefolder
;this program makes plots for each week of the CRRES mission. 
  

  restore, datafolder + 'kp_CDAWeb1990.save'
  restore, datafolder + 'kyoto_Dst_1990.save'
  restore, datafolder + 'kyoto_ALAU_1990.save'
 
  kp = kp/10.
  AE = AU - AL
  ;stop
                                ;I'm starting the plots from
                                ;the 24th of July, the mission
                                ;started on the 25th, and the yearday
                                ;of the 24th of july is 205
  startday = julday(7, 24, 1990, 0, 0, 0)
  week = 7.*24.*60.-1.
  julweek =  julday(1, 7, 1990, 23, 59, 0) - julday(1,1,1990,0,0,0)
  firstloop = ceil((365.-205.)*24.*60./(7.*24.*60.))
  fwi = 203.*24.*60.            ;this is the index of the first week we want to plot
  
  xday = findgen(7.*24.*60.-1.)/(24.*60.)

  print, 'in the first loop'
  for i = 0l, firstloop -1 do begin
     print, 'on loop number ', i
        caldat, startday, month, day, year 
        plot_name = strcompress(figurefolder+string(year)+'_'+string(month)+'_'+string(day)+'.ps', /remove_all)        
        !P.multi=[0,1,3]
        set_plot, 'PS'
        device, filename = plot_name, /landscape
        
;        plot, Ajul(fwi:fwi+week), AE(fwi:fwi+week), yrange =
;        [min([AE(fwi:fwi+week), AL(fwi:fwi+week)]), $
;dstjul(fwi:fwi+week) ; this was used as the x data before chainging
;it to xday. and  kpjul(fwi:fwi+week) for the K index xrange =
;[dstjul(fwi), dstjul(fwi+week)] xrange = [kpjul(fwi), kpjul(fwi+week)]
        plot, xday, AE(fwi:fwi+week), yrange = [min([AE(fwi:fwi+week), AL(fwi:fwi+week)]), $
                                                max([AE(fwi:fwi+week),AL(fwi:fwi+week)])], ytitle = 'AE and AL nT', $
              xtitle = 'Days since start time', xrange = [min(xday), max(xday)], xstyle = 1,$ ;[Ajul(fwi), ajul(fwi+week)], xstyle = 1,$
              title = 'year ' + string(year)+' month '+string(month)+' start day  '+string(day), xticks = 14, xminor = 6
        oplot, xday, AL(fwi:fwi+week)

        plot, xday, Dst(fwi:fwi+week), yrange = [min(Dst(fwi:fwi+week)), max(Dst(fwi:fwi+week))] , ytitle = 'Dst nT',$
              xtitle = 'Days since start', xrange = [min(xday), max(xday)], xstyle = 1, xticks = 14, xminor = 6
        
        plot, xday, kp(fwi:fwi+week), yrange = [min(kp(fwi:fwi+week)), max(kp(fwi:fwi+week))], ytitle = 'kp', $
              xtitle = 'Days since start', xrange = [min(xday), max(xday)], xstyle = 1, xticks = 14, xminor = 6
        
        device, /close_file
        close, /all

        startday = startday + julweek
        fwi = fwi + week + 1.
  endfor

;  stop
  restore, datafolder + 'kp_CDAWeb1991.save'
  restore, datafolder + 'kyoto_ALAU_1991.save'
  restore, datafolder + 'kyoto_Dst_1991.save'

  kp = kp/10.
  AE = AU - AL
 

  startday = julday(1, 1, 1991, 24, 0, 0)
  week = 7.*24.*60. - 1.
  julweek =  julday(1, 7, 1990, 23, 59, 59) - julday(1,1,1990,0,0,0)
  secondloop = ceil((287.)/(7.))
  fwi = 0.                      ;this is the index of the first week we want to plot
  print, 'starting second loop'
  for i = 0l, secondloop-1 do begin
     print, 'on loop number', i
        caldat, startday, month, day, year 
        plot_name = strcompress(figurefolder+string(year)+'_'+string(month)+'_'+string(day)+'.ps', /remove_all)        
        !P.multi=[0,1,3]
        set_plot, 'PS'
        device, filename = plot_name, /landscape
        

        plot, xday, AE(fwi:fwi+week), yrange = [min([AE(fwi:fwi+week), AL(fwi:fwi+week)]), $
                                                max([AE(fwi:fwi+week),AL(fwi:fwi+week)])], ytitle = 'AE and AL nT',$
              xtitle = 'Days since start', xrange = [min(xday), max(xday)], xstyle = 1,$;[Ajul(fwi), ajul(fwi+week)], xstyle = 1,$
              title = 'year ' + string(year)+' month '+string(month)+' start day  '+string(day), xticks = 14, xminor = 6
        oplot, xday, AL(fwi:fwi+week)

        plot, xday, Dst(fwi:fwi+week), yrange = [min(Dst(fwi:fwi+week)), max(Dst(fwi:fwi+week))] , ytitle = 'Dst nT',$
                      xtitle = 'Days since start', xrange = [min(xday), max(xday)], xstyle = 1, xticks = 14, xminor = 6
        plot, xday, kp(fwi:fwi+week), yrange = [min(kp(fwi:fwi+week)), max(kp(fwi:fwi+week))], ytitle = 'kp',$
                      xtitle = 'Days since start', xrange = [min(xday), max(xday)], xstyle = 1, xticks = 14, xminor = 6
        device, /close_file
        close, /all

        startday = startday + julweek
        fwi = fwi + week + 1.
  endfor


;stop

end
