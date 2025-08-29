pro PhD_sym_v_dst
;in this program I'm just creating a figure that shows how more
;storms might potentially be able to be observed in the Sym-H index
;then in the Dst index.

  restore, '../Data/kyoto_Sym_1991.save'
  restore, '../Data/kyoto_Dst_1991.save'
  
  !P.multi = [0,1,2]
  set_plot, 'PS'
  device, filename = '../figures/sym_v_dst_Aug_Sep_91_PhD.ps', /landscape, /color
  start = 214.*24.*60. - 1.*24.*60.
  enddate = 259.*24.*60. - 1.*24.*60. ;start + 7.*24.*60.
  
  xarray = findgen(enddate - start)/(24.*60.) + (start/(24.*60.))
  
  plot, xarray, sym(start:enddate), xrange = [min(xarray), max(xarray)], xstyle = 1, ytitle = 'Sym-H nT'
  oplot, xarray, make_array(n_elements(xarray), value = -50), linestyle = 5
  plot, xarray, dst(Start:enddate), xrange = [min(xarray), max(xarray)], xstyle = 1, ytitle = 'Dst nT', xtitle = 'Day of year'
  oplot, xarray, make_array(n_elements(xarray), value = -50), linestyle = 5
  
  device, /close_file
  close, /all
  

  !P.multi = [0,1,2]
  set_plot, 'PS'
  device, filename = '../figures/sym_v_dst_June_1_91_PhD.ps', /landscape, /color
  start = 152.*24.*60. - 1.*24.*60.
  enddate = start + 7.*24.*60.
  
  xarray = findgen(enddate - start)/(24.*60.) + (start/(24.*60.))
  
  plot, xarray, sym(start:enddate), xrange = [min(xarray), max(xarray)], xstyle = 1, $
        ytitle = 'Sym-H nT', title ='Start date June 1st 1991'
  oplot, xarray, make_array(n_elements(xarray), value = -50), linestyle = 5
  plot, xarray, dst(Start:enddate), xrange = [min(xarray), max(xarray)], xstyle = 1, $
        ytitle = 'Dst nT', xtitle = 'Day of year'
  oplot, xarray, make_array(n_elements(xarray), value = -50), linestyle = 5
  
  device, /close_file
  close, /all
  
  
end
