pro val_crfiles,orbit,eph_bin,date
common init_parameter,idl_path,data_path,eph_path,res_path,eve_path,spl_int,fre_int,log_path

  cd,eph_path[0]
  texts=strarr(1)
  ;orbit='512'
  openr,/get_lun,uu,'crfiles.shr'
  print,'Extracting Ephmerius file Infromation for Orbit: ',orbit
  while (not eof(uu)) do $
   begin
    readf,uu,texts
    ;stop
    if strtrim(strmid(texts(0),1,4),1) EQ strtrim(orbit,2) then $
      begin
       eph_bin=strmid(texts(0),46,8)
       date=strmid(texts(0),6,10)
       ;stop
    endif
  endwhile
  free_lun,uu
  cd,idl_path[0]
  ;stop
  end