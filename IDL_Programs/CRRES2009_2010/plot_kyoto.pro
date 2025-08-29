pro plot_kyoto, sbuffer, ebuffer, savefolder, figurefolder;, plot_all = plot_all
;this program makes plots for each of the events specifies in the
;document file used in the previous programs. 
  
;here we create the individual plots for the SW data
;  restore, savefolder+ 'energy_input_files.save'
;  restore,  savefolder+'ready_events.save'
;  restore, savefolder+ 'Dst_energy_files.save'
;  restore, savefolder+ 'Aready_events.save'
;  restore, savefile(0)
  restore, strcompress(savefolder+'Dstready_events.save')
  restore, save_file_names(0) 
;  restore, Asave_file_names(0)
;  restore, Dstsavefile(0)


;if n_elements(savefile) le 1 then noepoch = 1 else noepoch = 0  

;  allAU = make_array(n_elements(ALs), n_elements(savefile))    
;  allAL = allAU
;  allAE = allAU
  allDst = make_array(n_elements(dsts), n_elements(save_file_names))
;  allsym = allAU
;  bconst = make_array(n_elements(dstsavefile))
;  mconst = make_array(n_elements(dstsavefile))

  for i = 0l, n_elements(save_file_names)-1. do begin
;     restore, savefile(i)
     restore, save_file_names(i) 
;     restore, Asave_file_names(i)
;     restore, Dstsavefile(i)

;     allAU(*,i) = AUs
;     allAL(*,i) = ALs
;     allAE(*,i) = AEs
     allDst(*,i) = dsts
;     allsym(*,i) = syms1
;     xconst = (findgen(n_elements(dsts)) - sbuffer)/60.
;     constants = linfit(xconst, dsts)
;     bconst(i) = constants(0)
;     mconst(i) = constants(1)

;     v = (vxs^2. + vys^2. + vzs^2.)^.5*10^(-3.)
;     B = btots*10^(9.)                  ;(Bxs^2. + Bys^2. + Bzs^2.)^.5*10^(9.)
;     Bt = [Bys^2. + Bzs^2.]^.5
;     clock =  Acos(Bzs/Bt)
;     ax = (findgen(n_elements(ALs)) - sbuffer)/(60.)
;          caldat, onset, month, day, year, hh, mm, sec
     plot_day = string(year)+string(month)+string(day)+string(hh)
;     plot_name = strcompress(figurefolder+''+plot_day+'.ps', /remove_all)
     
;     if keyword_set(plot_all) then begin     
;        !P.multi=[0,1,3]
;        set_plot, 'PS'
;        device, filename = plot_name, /portrait 
        
;        plot, ax, AEs, ytitle = ' AE nT', title = 'Auroral Indices  yearday =  '+plot_day
;        plot, ax, AUs, ytitle = ' AU nT'
;        plot, ax, ALs, ytitle = ' AL nT', xtitle = 'hours from onset'
        
;        device, /close_file
;        close, /all
        
        dx = (findgen(n_elements(dsts)) - sbuffer)/60.
                                ;     KE = calc_dp(V*10^(-3.), dens) ; units nPa
        
        plot_name = strcompress('../Figures/Dst'+string(year)+string(month)+string(day)+string(hh)+'.ps', /remove_all)        
        !P.multi=[0,1,1]
        set_plot, 'PS'
        device, filename = plot_name, /portrait
        
        plot, dx, Dsts, ytitle = 'Dst nT', title =  string(year)+string(month)+string(day)+string(hh)+string(mm), $
              xtitle = 'hours from onset', yrange = [min(Dsts)-2, max(Dsts)+2]
;        oplot, dx, syms1, color = 200
        
        device, /close_file
        close, /all
        
;        restore, save_file_names(i)
;        plot_name = strcompress(figurefolder+'indices'+string(year)+string(month)+string(day)+string(hh)+'.ps', /remove_all)
;        !P.multi=[0,1,4]
;        set_plot, 'PS'
;        device, filename = plot_name, /portrait
        
        
        
;        syday = floor(stryday)
;        fracday = stryday - syday
;        shr = floor(fracday*24.)
;        frachr = fracday*24. - shr
;        smm = floor(frachr*60.)
;        ndate = julday(1, syday, year, shr, smm)
;        caldat, ndate, nmonth, nday, nyear, nhr, nmm, nss
;        ch = 2
;        plot, ax, AEs, ytitle = 'AE index ', yrange = [min(AEs)-5,max(AEs)+5], xcharsize = 0.01, $
;              title = strcompress(string(nyear)+':'+string(nmonth)+':'+string(nday), /remove_all)+'  '+ $
;              strcompress(string(nhr)+':'+ string(nmm) +':'+ string(floor(nss)), /remove_all),$
;              ymargin = [0.1,2], charsize = ch ;, title = 'Indice inputs', 
;        plot, ax, ALs, ytitle = 'AL index ', yrange = [min(ALs)-5,max(ALs)+5], xcharsize = 0.01,$
;              ymargin = [0.1,.1], charsize = ch;
;        plot, ax, Dsts1, ytitle = 'Dst index nT', xcharsize = 0.01,$ 
;              yrange = [min([Dsts1, syms1])-2, max([Dsts1, syms1])+2], ymargin = [.1,.1], charsize = ch
;        plot, ax, syms1,  ytitle = 'Sym index nT', xtitle = 'hours from onset', $
;              yrange = [min([Dsts1, syms1])-2, max([Dsts1, syms1])+2], ymargin = [2,.15], charsize = ch
;        device, /close_file
;        close, /all
        
;        possym = make_array(n_elements(ps), value = 1)
;        posdst = make_array(n_elements(pd), value = 1)
;        possymindex = where(ps ge 0, complement = negsymindex)
;        posdstindex = where(pd ge 0, complement = negdstindex)
;        if negsymindex(0) ne -1 then possym(negsymindex) = -1 
;        if negdstindex(0) ne -1 then posdst(negdstindex) = -1 
;        difference = abs(pd-ps)
        
        
;        plot_name = strcompress(figurefolder+'difference'+string(year)+string(month)+string(day)+string(hh)+'.ps', /remove_all)
;        !P.multi=[0,1,2]
;        set_plot, 'PS'
;        device, filename = plot_name, /portrait
        
;        plot, ax, difference, ytitle = 'pressure corrected (Dst - Sym) ', $
;              yrange = [min([difference])-5.,max([difference])+5.], xcharsize = 2
;        plot, ax, possym, psym = 4, yrange = [-2, 2], $
;              title = 'where pressure corrected (dst and sym) are postive or negative'
;        oplot, ax, posdst
        
;        device, /close_file
;        close, /all
        
;     endif
  endfor
  
;if noepoch ne 1 then begin
;  AUmean_n_u =make_array(n_elements(allAU(*,0))) 
;  AUprec24 = fltarr(n_elements(allAU(*,0)))
;  AUprec50 = fltarr(n_elements(allAU(*,0)))
;  AUprec75 = fltarr(n_elements(allAU(*,0)))
;  AUmed =  fltarr(n_elements(allAU(*,0)))

;  Almean_n_u =make_array(n_elements(allAl(*,0))) 
;  Alprec24 = fltarr(n_elements(allAl(*,0)))
;  Alprec50 = fltarr(n_elements(allAl(*,0)))
;  Alprec75 = fltarr(n_elements(allAl(*,0)))
;  Almed =  fltarr(n_elements(allAl(*,0)))

;  Aemean_n_u =make_array(n_elements(allAe(*,0))) 
;  Aeprec24 = fltarr(n_elements(allAe(*,0)))
;  Aeprec50 = fltarr(n_elements(allAe(*,0)))
;  Aeprec75 = fltarr(n_elements(allAe(*,0)))
;  Aemed =  fltarr(n_elements(allAe(*,0)))

;  dstmean_n_u =make_array(n_elements(alldst(*,0))) 
;  dstprec24 = fltarr(n_elements(alldst(*,0)))
;  dstprec50 = fltarr(n_elements(alldst(*,0)))
;  dstprec75 = fltarr(n_elements(alldst(*,0)))
;  dstmed =  fltarr(n_elements(alldst(*,0)))

;  symmean_n_u =make_array(n_elements(allsym(*,0))) 
;  symprec24 = fltarr(n_elements(allsym(*,0)))
;  symprec50 = fltarr(n_elements(allsym(*,0)))
;  symprec75 = fltarr(n_elements(allsym(*,0)))
;  symmed =  fltarr(n_elements(allsym(*,0)))
  
;  for nn = 0, n_elements(allAU(*,0))-1 do begin 
;     AUgood = where(finite(allAU(nn,*)), count)
;     AUn_set = count
;     AUp75 = long(75.*AUn_set/100.)
;     AUp25 = long(25.*AUn_set/100.)
;     AUp50 = long(50.*AUn_set/100.)
     
;     ALgood = where(finite(allAL(nn,*)), count)
;     ALn_set = count
;     ALp75 = long(75.*ALn_set/100.)
;     ALp25 = long(25.*ALn_set/100.)
;     ALp50 = long(50.*ALn_set/100.)
     
;     Aegood = where(finite(allAe(nn,*)), count)
;     Aen_set = count
;     Aep75 = long(75.*Aen_set/100.)
;     Aep25 = long(25.*Aen_set/100.)
;     Aep50 = long(50.*Aen_set/100.)
     
;     dstgood = where(finite(alldst(nn,*)), count)
;     dstn_set = count
;     dstp75 = long(75.*dstn_set/100.)
;     dstp25 = long(25.*dstn_set/100.)
     
;     symgood = where(finite(allsym(nn,*)), count)
;     symn_set = count
;     symp75 = long(75.*symn_set/100.)
;     symp25 = long(25.*symn_set/100.)
     
;     AUarray = allAU[nn,*]
;     AUbarray = AUarray(AUgood)
;     AUmean_n_u(nn) = mean(AUarray)
;     AUmed(nn) = median(AUarray, /even)
;     AUii = sort(AUarray)
;     AUprec75(nn) = AUarray(AUii(AUp75))
;     AUprec24(nn) = AUarray(AUii(AUp25))
;     AUprec50(nn) = AUarray(AUii(AUp50))

;     Alarray = allAl[nn,*]
;     Alarray = Alarray(Algood)
;     Almean_n_u(nn) = mean(Alarray)
;     Almed(nn) = median(Alarray, /even)
;     Alii = sort(Alarray)
;     Alprec75(nn) = Alarray(Alii(Alp75))
;     Alprec24(nn) = Alarray(Alii(Alp25))
;     Alprec50(nn) = Alarray(Alii(Alp50))

;     Aearray = allAe[nn,*]
;     Aearray = Aearray(Aegood)
;     Aemean_n_u(nn) = mean(Aearray)
;     Aemed(nn) = median(Aearray, /even)
;     Aeii = sort(Aearray)
;     Aeprec75(nn) = Aearray(Aeii(Aep75))
;     Aeprec24(nn) = Aearray(Aeii(Aep25))
;     Aeprec50(nn) = Aearray(Aeii(Aep50))

;     dstarray = alldst[nn,*]
;     dstarray = dstarray(dstgood)
;     dstmean_n_u(nn) = mean(dstarray)
;     dstmed(nn) = median(dstarray, /even)
;     dstii = sort(dstarray)
;     dstprec75(nn) = dstarray(dstii(dstp75))
;     dstprec24(nn) = dstarray(dstii(dstp25))

;     symarray = allsym[nn,*]
;     symarray = symarray(symgood)
;     symmean_n_u(nn) = mean(symarray)
;     symmed(nn) = median(symarray, /even)
;     symii = sort(symarray)
;     symprec75(nn) = symarray(symii(symp75))
;     symprec24(nn) = symarray(symii(symp25))

;  endfor

;  x = (findgen(n_elements(AUmean_n_u))- sbuffer)/60.

; result = linfit( x, dstmean_n_u)
; print, 'linear fit of dst', result
  
;        !P.multi=[0,1,3]
;        set_plot, 'PS'
;        loadct, 6
;        device, filename =figurefolder+'KyotoA_ave.ps', /color, /landscape ;, /portrait 
;        ch = 2
        
;        plot, x, AUmean_n_u, ytitle = 'AU [nT]', thick = 4, $ ;color = 50,$
;              xcharsize = 0.01, ymargin = [0.1,2], charsize = ch, yrange = [min(AUprec24), max(AUprec75)]
;        oplot, x, AUprec24, color = 200, thick = 4
;        oplot, x, AUprec75, color = 200, thick = 4, linestyle = 2
;        oplot, x, AUmed, color = 50, linestyle = 2
;;        oplot, x, AUprec50, color = 50, thick = 4;

;        plot, x, Almean_n_u, ytitle = 'AL [nT]', thick = 4, $
;              xcharsize = 0.01, ymargin = [0.1,2], charsize = ch, yrange = [min(Alprec24), max(Alprec75)]
;        oplot, x, Alprec24, color = 200, thick = 4
;        oplot, x, Alprec75, color = 200, thick = 4, linestyle = 2
;        oplot, x, Almed, color = 50, linestyle = 2
;;        oplot, x, Alprec50, color = 50, thick = 4
        
;        plot, x, Aemean_n_u, ytitle = 'AE [nT]', thick = 4, xtitle = 'Hours from onset', $
;              ymargin = [0.1,2], charsize = ch, yrange = [min(AEprec24), max(AEprec75)]
;        oplot, x, Aeprec24, color = 200, thick = 4
;        oplot, x, Aeprec75, color = 200, thick = 4, linestyle = 2
;        oplot, x, Aemed, color = 50, linestyle = 2
;;        oplot, x, Aeprec50, color = 50, thick = 4

;;        AUarray = allAU[60,*]        
;;        plot, auarray(sort(auarray))
        
;        device, /close_file


  
;        !P.multi=[0,1,2]
;        set_plot, 'PS'
;        loadct, 6
;        device, filename =figurefolder+'kyotoDst_ave.ps', /color, /landscape;, /portrait 
;        ch = 2


;        plot, x, dstmean_n_u, ytitle = 'Dst [nT]', thick = 4,$
;              xcharsize = 0.01, ymargin = [0.1,2], charsize = ch, yrange = [min(dstprec24)-2, max(dstprec75)+2]
;        oplot, x, dstprec24, color = 200, thick = 4
;        oplot, x, dstprec75, color = 200, thick = 4, linestyle = 2
;        oplot, x, dstmed, color = 50, linestyle = 2
        
;        plot, x, symmean_n_u, ytitle = 'Sym-H [nT]', thick = 4, xtitle = 'Hours from onset',$
;              ymargin = [0.1,2], charsize = ch, yrange = [min(symprec24)-2, max(symprec75)+2]
;        oplot, x, symprec24, color = 200, thick = 4
;        oplot, x, symprec75, color = 200, thick = 4, linestyle = 2
;        oplot, x, symmed, color = 50, linestyle = 2
;        device, /close_file




;     endif

;indexminbm = where(abs(bconst) eq min(abs(bconst)))
;indexmaxbm = where(abs(bconst) eq max(abs(bconst)))
;indexmeanbm = where(abs(bconst) eq mean(abs(bconst)))


;indexminmb = where(abs(mconst) eq min(abs(mconst)))
;indexmaxmb = where(abs(mconst) eq max(abs(mconst)))
;indexmeanmb = where(abs(mconst) eq mean(abs(mconst)))

;posmave = mean(mconst(where(mconst ge 0)))
;negmave = mean(mconst(where(mconst lt 0)))
 
;print, 'pos m ave', posmave
;print, 'neg m ave', negmave

;print, 'b min, max, average', min(bconst), max(bconst), mean(abs(bconst))
;if indexminbm(0) ne -1 then print, 'matching m min', mconst(indexminbm)
;if indexmaxbm(0) ne -1 then print, 'matching m max', mconst(indexmaxbm)
;if indexmeanbm(0) ne -1 then print, 'matching m mean', mconst(indexmeanbm)
;print, 'm min, max, average', min(mconst), max(mconst), mean(abs(mconst))
;if indexminbm(0) ne -1 then print, 'matching b min', bconst(indexminmb)
;if indexmaxbm(0) ne -1 then print, 'matching b max', bconst(indexmaxmb)
;if indexmeanbm(0) ne -1 then print, 'matching b mean', bconst(indexmeanmb)

;;  bconstmean_n_u =make_array(n_elements(allbconst(*,0))) 
;;  bconstprec24 = fltarr(n_elements(allbconst(*,0)))
;;  bconstprec50 = fltarr(n_elements(allbconst(*,0)))
;;  bconstprec75 = fltarr(n_elements(allbconst(*,0)))
;;  bconstmed =  fltarr(n_elements(allbconst(*,0)))
     ;
;;     bconstgood = where(finite(allbconst(nn,*)), count)
;;     bconstn_set = count
;;     bconstp75 = long(75.*bconstn_set/100.)
;;     bconstp25 = long(25.*bconstn_set/100.)


;;     bconstarray = allbconst[nn,*]
;;     bconstarray = bconstarray(bconstgood)
;;     bconstmean_n_u(nn) = mean(bconstarray)
;;     bconstmed(nn) = median(bconstarray, /even)
;;     bconstii = sort(bconstarray)
;;     bconstprec75(nn) = bconstarray(bconstii(bconstp75))
;;     bconstprec24(nn) = bconstarray(bconstii(bconstp25))




;;     mconstn_set = n_elements(mconst)
;;     mconstp75 = long(75.*mconstn_set/100.)
;;     mconstp25 = long(25.*mconstn_set/100.)


;;     mconstarray = mconst
;;     mconstmean_n_u(nn) = mean(mconstarray)
;;     mconstmed(nn) = median(mconstarray, /even)
;;     mconstii = sort(mconstarray)
;;     mconstprec75(nn) = mconstarray(mconstii(mconstp75))
;;     mconstprec24(nn) = mconstarray(mconstii(mconstp25))


;        xlinfit = (findgen(N_elements(x)) - sbuffer)/60.
  
;        !P.multi=[0,1,1]
;        set_plot, 'PS'
;        loadct, 6
;        device, filename =figurefolder+'linfitDst.ps', /color, /landscape;, /portrait 
;        ch = 2

        
;        plot, xlinfit, mconst(0)*xlinfit + bconst(0), ytitle = 'linfit Dst [nT]', thick = 4,$
;              ymargin = [0.1,2], charsize = ch, yrange = [-40,20]

;        for loop = 0, n_elements(mconst)-1 do $
;        oplot, xlinfit, mconst(loop)*xlinfit + bconst(loop), color = 200, thick = 4
;;        oplot, xlinfit, 
        

;        device, /close_file



  
end
