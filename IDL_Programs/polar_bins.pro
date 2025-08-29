function polar_bins, data, mlt, ls, mltbin, lsbin, mltmax, lsmax

  ;This is for mlt thus must be 24 hours
theta = (findgen(mltbin)/mltbin)*24.*!pi/12.
lsr = (findgen(lsbin)/lsbin)*lsmax


new_data = make_array(mltbin, lsbin, value = !values.F_NAN)

for j = 0l, n_elements(new_data(0,*))-1 do begin
   lsmeep = make_array(n_elements(data), value = !values.F_NAN)
   inle = where((ls ge j) and (ls lt j+1))
   if inls(0) ne 01 then lsmeep(inls) = 1
   for i = 0





end
