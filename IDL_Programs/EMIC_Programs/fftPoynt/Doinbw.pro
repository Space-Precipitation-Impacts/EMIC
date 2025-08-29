Pro DoInBW
;
; Black and White Scale for Grey Scale Plots
; See Colr for colour bar
;
NCol=!d.n_colors
ColDiv=2
NmC=Fix(NCol/ColDiv)
Print,'In DoInBW, NCol=',NCol,' NumCols=',NmC
Rd=IntArr(NCol)
Gr=IntArr(NCol)
Bl=IntArr(NCol)
kk=0
jj=0
For j=0,NmC-1 do $
Begin
 For i=0,ColDiv-1 do $
 Begin
  Rd(kk)=255-jj
  Gr(kk)=255-jj
  Bl(kk)=255-jj
  kk=kk+1
 End
 jj=jj+ColDiv
End
For ii=255-Coldiv,255 do $
Begin
 Rd(ii)=0
 Gr(ii)=0
 Bl(ii)=0
End
TVLCT,Rd,Gr,Bl
End