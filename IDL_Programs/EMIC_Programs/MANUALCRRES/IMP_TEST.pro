Pro IMP_TEST
bdat=byte(1)
dat=bytarr(4)
text=strarr(1)
openr,u,/get_lun,'OMNI_1991.DAT'
for jj=0, 100 do $
begin
   fdat=double(0.0)
   sgn=1.
  for aa=0,3 do $         ;data component rows in file.
   begin
    READU,u,bdat
    dat(aa)=bdat
  end
   dat(0)=dat(0)-64   ; take off 2^30
   fdat=dat(0)*256.*256.*256+dat(1)*256.*256.+dat(2)*256.+dat(3)
   fdat=sgn*fdat
   ;a[j,i]=fdat
  	print,fdat
;stop
end
close,u
stop
END