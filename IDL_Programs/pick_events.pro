pro pick_events, event_file, sbuffer, ebuffer,datafolder, savefolder, templatefolder, quietdst = quietdst, stormdst = stormdst, badsw = badsw
;event file should be in the form year month day hour min sec with
;spaces between them. 
;created by Alexa Halford
  
  print, 'starting to read in the event file'
  restore, savefolder+'inputfile.save'
  
  s1 = strpos(event_file,'.')
  file2 = strmid(event_file,0,s1)
  file3 = strcompress(Templatefolder+file2+'_template.save')
  savefile = strcompress(Datafolder+file2+'_'+string(sbuffer)+'_'+string(ebuffer)+'.save')
  restore, savefile
  yday = jul2yday(onset_time)
  print, 'total number of events', n_elements(onset_time)
  quiettime = make_array(n_elements(yday), value = 0)
  stormtime = make_array(n_elements(yday), value = 0)
  goodevents =  make_array(n_elements(yday), value = 0)
  
  for i = 0l, n_elements(yday)-1  do begin 
     caldat, onset_time(i), month, day, year, hour, mn, sc
;  print, year, month, day, hour, mn, sc
     if year eq 2001 then restore, Datafolder+'kyoto_Sym_2001.save' ;, /ver
     if year eq 2002 then restore, Datafolder+'kyoto_Sym_2002.save' ;, /ver
     if year eq 2003 then restore, Datafolder+'kyoto_Sym_2003.save' ;, /ver
     if year eq 2004 then restore, Datafolder+'kyoto_Sym_2004.save' ;, /ver
     if year eq 2005 then restore, Datafolder+'kyoto_Sym_2005.save' ;, /ver
     
     if year eq 2001 then restore, Datafolder+'kyoto_Dst_2001.save' ;, /ver
     if year eq 2002 then restore, Datafolder+'kyoto_Dst_2002.save' ;, /ver
     if year eq 2003 then restore, Datafolder+'kyoto_Dst_2003.save' ;, /ver
     if year eq 2004 then restore, Datafolder+'kyoto_Dst_2004.save' ;, /ver
     if year eq 2005 then restore, Datafolder+'kyoto_Dst_2005.save' ;, /ver
     
     
     
     aconstant = fix(where((Dstjul - time(i,0)) eq min(abs(Dstjul- time(i,0)))), type = 3)
     index = findgen(n_elements(time(i,*))) + aconstant(0)
     Dsts = Dst(index)
     Syms = Sym(index) 
     
     
                                ;    array_length = sbuffer + ebuffer +1
                                ;    time = make_array(n_elements(onset_time), array_length, /double)
                                ;    min1 = julday(0,0,1,0,1,0) - julday(0,0,1,0,0,0)
     
     if min([Dsts, syms]) ge -35 then quiettime(i) = 1 ;else stormtime(i) = 1 
;     if min([Dsts, syms]) ge -35 then print, 'quiet day ', month, day, year
     if max([Dsts, syms]) lt -40 then stormtime(i) = 1 
;     starttime =  onset_time(i) - (julday(0,0,1,0,sbuffer,0) - julday(0,0,1,0,0,0))
;     time(i,*) = dindgen(array_length)/(24.d0*60.d0) + starttime 
     
  endfor
  storm = where(stormtime eq 1)
  ;print, 'number of storm times ', n_elements(storm)
  quiet = where(quiettime eq 1)
  ;print, 'number of quiet times ', n_elements(quiet)
  
  if keyword_set(quietdst) then begin
     
     onset_time = onset_time*quiettime
     eventindex = where(onset_time ne 0)
     onset_time = onset_time(eventindex)
     print, 'number of quiet events  ', n_elements(eventindex)
     
  endif
  
  if keyword_set(stormdst) then begin
     
     onset_time = onset_time*stormtime
     eventindex = where(onset_time ne 0)
     onset_time = onset_time(eventindex)
     print, 'number of storm time events  ', n_elements(eventindex)
     
  endif
  avebad = 0
  for k = 0l, n_elements(onset_time) - 1. do begin
     caldat, onset_time(k), month, day, year, hh, mm, sec
     
     
     if year eq 2001 then restore, datafolder+'omni_ace_2001.save' ;, /ver
     if year eq 2002 then restore, datafolder+'omni_ace_2002.save' ;, /ver
     if year eq 2003 then restore, datafolder+'omni_ace_2003.save' ;, /ver
     if year eq 2004 then restore, datafolder+'omni_ace_2004.save' ;, /ver
     if year eq 2005 then restore, datafolder+'omni_ace_2005.save' ;, /ver
     
     
     bconstant = fix(where((SWjul - time(k,0)) eq min(abs(SWjul- time(k,0)))), type = 3)
     index = findgen(n_elements(time(k,*))) + bconstant(0)
     dens = den(index)          ;*(100.)^3.  ;#/m^3
     btots = bmag(index)        ;*10^(-9.) ; Tesla
     bys = by(index)            ;*10^(-9.)     ; Tesla
     bzs = bz(index)            ;*10^(-9.)     ; Tesla
     vxs = vx(index)            ;*10^(3.)      ; (m/s)
     vys = vy(index)            ;*10^(3.)      ; (m/s)
     vzs = vz(index)            ;*10^(3.)      ; (m/s)
     bxs = (btots^2. - bys^2. - bzs^2.)^.5
                                ;help, dens,btots, bys, bzs, vxs, vys, vzs, bxs 
     
     baddata = 0.
                                ;data_array = [dens, btots, bys, bzs, vxs, vys, vzs]
     goodindexb = where(finite(bzs), complement = baddatab)
     goodindexden = where(finite(dens), complement = baddataden)
     goodindexvx = where(finite(vxs), complement = baddatav)
     if baddatab(0) ne -1 then baddata = n_elements(baddatab) + baddata
     if baddataden(0) ne -1 then baddata = baddata + n_elements(baddataden)
     if baddatav(0) ne -1 then baddata = baddata + n_elements(baddatav)
     
     ;print, 'number of good points', n_elements(goodindexb)+n_elements(goodindexden)+n_elements(goodindexb)
                                ;print, 'number of bad points', baddata
     if baddata lt 5 then goodevents(k) = 1
     ;if baddata gt 0 then print, 'this is a bad day', month, day, year, hh, 'and has this many bad points', baddata
     
     avebad = avebad + baddata
     
  endfor
  
  print, 'ave. number of bad points', avebad/(k-1.)
  if keyword_Set(badsw) then begin
     onset_time = onset_time*goodevents
     eventindex = where(onset_time ne 0)
     print,  'number of good events  ', n_elements(eventindex)
     if eventindex(0) ne -1 then begin
        onset_time = onset_time(eventindex)
     endif else begin
        print, 'no good events? '
        stop
     endelse
  endif
;stop
  save, onset_time, time, filename = savefile
  
end
