Pro xy_plots3_ps
ct =long(0)
ct2 =long(0)
mlat =fltarr(12)
poynt =fltarr(12)
text=' '
openr,u,'mlat_ut.txt',/get_lun
readf,u,text
while not eof(u) do $
begin
readf,u,mlats,poynts
 ;if abs(text) LT 10.0 then $
 ;begin
 ;print,text
mlat[ct]=mlats
poynt[ct]=poynts

 ct = ct + 1
end
close,u
FName=DIALOG_PICKFILE(title='Select File', FILTER = '*.*',/WRITE,/NOCONFIRM)
set_plot,'ps'
device,filename=FName,yoffset=3, ysize=13
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.02
;window,0,xsize=700
day=['-30 to -25','-25 to -20','-20 to -15','-15 to -10','-10 to -5','-5 to 0','0 to 5','5 to 10','10 to 15',$
'15 to 20','20 to 25','25 to 30']
XVAL = FINDGEN(12)/6. + .085
YVAL = mlat;poynt
plot,xval,yval, XTICKV = XVAL,xrange=[0,2],xstyle=13,xtiCKS = 11,xcharsize=0.8,XTICKNAME = day,/nodata,/YNOZERO,$
xtitle='L Shell',ytitle='Time (hours)',title='CRRES MLAT Coverage Orbit 3 - 1067',ymargin=[8,2]
;AXIS, XAXIS=0,XTICKn=DAY
FOR I = 0, 11 DO $
begin
BOX, XVAL[I] - .08, !Y.CRANGE[0], $
     XVAL[I] + 0.08, YVAL[I], 0
!P.charsize=0.8
xyouts,2000+1300*i,1100,day[i],ORIENTATION=60,/device

end
!P.charsize=1.0

xyouts,7000,720,'Magnetic Latitude (!Uo!n)',ORIENTATION=0,/device

;xrange=[xval[0]-xval[0]/2+0.013,1]
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.04
device,/close
end