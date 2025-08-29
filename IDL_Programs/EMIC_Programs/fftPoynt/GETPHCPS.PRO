Pro GetPhCps
;
; Colour Set up for Cross Phase
; See Colr for colour bar
; Postscript version without the white at the top of the
; colour bar
; C. Waters
NCol=!d.n_colors
Red=[0,90,70,80,90,10,150,180,180,$
     200,200,170,10,150,190,220,240,255,$
     255,255,255,255,255,255,255,255,255,$
     255,255,230,220,220,210,170,120,90]
Green=[0,10,10,10,10,10,150,200,240,$
       250,255,255,255,255,255,255,255,255,$
       255,255,255,255,240,220,190,160,130,$
       110,0,0,30,5,50,20,0,0]
Blue=[0,100,150,180,220,255,240,250,250,$
      230,210,190,60,160,200,220,220,230,$
      210,170,0,0,0,0,0,0,0,$
      5,0,0,150,200,190,150,120,70]
 Rd=IntArr(NCol)
 Gr=IntArr(NCol)
 Bl=IntArr(NCol)
 Mlt=Fix(NCol/36)
 Rmn=NCol-(Mlt*36)
 Mlt1=Mlt+1
 Mlt2=Mlt
 If (Rmn GT 0) Then Mlt2=Mlt1
 Cnt=0
 For i=0,35 do $
 Begin
  For j=0,Mlt2-1 do $
  Begin
   Rd(Cnt)=Red(i)
   Gr(Cnt)=Green(i)
   Bl(Cnt)=Blue(i)
   Cnt=Cnt+1
  End
  If (i+1 GE Rmn) Then Mlt2=Mlt
 End
; Rd(0)=0
; Gr(0)=0
; Bl(0)=0
; Rd(NCol-1)=255
; Gr(NCol-1)=255
; Bl(NCol-1)=255
 TVLCT,Rd,Gr,Bl
End