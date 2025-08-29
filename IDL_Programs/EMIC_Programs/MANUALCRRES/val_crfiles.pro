pro val_crfiles,orbit,eph_bin,date
  texts=strarr(1)
  openr,/get_lun,uu,'crfiles.shr'
  print,'Extracting Ephmerius file Infromation for Orbit: ',orbit
  while (not eof(uu)) do $
   begin
    readf,uu,texts
    if strtrim(strmid(texts(0),1,4),1) EQ orbit then $
      begin
       eph_bin=strmid(texts(0),46,8)
       date=strmid(texts(0),6,10)
    endif
  endwhile
  free_lun,uu
  end