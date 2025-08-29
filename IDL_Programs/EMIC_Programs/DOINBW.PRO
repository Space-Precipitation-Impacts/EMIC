Pro doinbw
;
; Black and White Scale for Grey Scale Plots
; See Colr for colour bar
;
  NCol=!d.n_colors
  If (NCol gt 256) then NCol=256
  ColDiv=256/10+1
  NmC=Fix(NCol/ColDiv)
                                ;Print,'In DoInBW, NCol=',NCol,' NumCols=',NmC
  Rd=IntArr(NCol)
  pow=0.75
  for ii=0,255 do Rd(ii)=Round(float(ii)^pow/((255.)^pow)*255.)
  Tmp=Rd
  for jj=0,255 do begin
     Rd(jj)=Tmp(255-jj)         ; Reverse
  endfor
  kk=0
  for j=0,NmC-1 do begin
     jj=j*ColDiv
     for i=0,ColDiv-1 do begin
        Rd(kk)=Rd(jj)
        kk=kk+1
     endfor
  endfor
  for ii=255-Coldiv,255 do Rd(ii)=(Rd(255)+Rd(255-coldiv-1))/2
                                ;Rd(0)=0
  Rd(NCol-1)=0
  Gr=Rd
  Bl=Rd
  TVLCT,Rd,Gr,Bl
                                ;print,Rd
                                ;stop
End
