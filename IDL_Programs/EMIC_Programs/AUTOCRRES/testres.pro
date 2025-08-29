pro testres

eph_res,epph
eph_desc=strarr(n_elements(epph))
for ii=0,n_elements(eph_desc) -1 do $
 begin
 if epph[ii] EQ 'B' then $
  eph_desc[ii]='1\'+epph[ii] else $
 eph_desc[ii]='0\'+epph[ii]
endfor
print,eph_desc
end