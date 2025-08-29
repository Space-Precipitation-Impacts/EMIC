Pro xy_plots4_ps
ct =long(0)
ct2 =long(0)
mlat =fltarr(25)
poynt =fltarr(25)
text=' '
openr,u,'mlt_ut.txt',/get_lun
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
day=[' 0 - 1',' 1 - 2',' 2 - 3',' 3 - 4',' 4 - 5',' 5 - 6',' 6 - 7',' 7 - 8',' 8 - 9','9 - 10','10 - 11','11 - 12','12 - 13',$
	'13 - 14','14 - 15','15 - 16','16 - 17','17 - 18','18 - 19','19 - 20','20 - 21','21 - 22','22 - 23','23 - 24']
XVAL = FINDGEN(24)/10. + .085
YVAL = poynt
plot,xval,yval, XTICKV = XVAL,xrange=[0,2],xstyle=13,xtiCKS = 24,xcharsize=0.8,XTICKNAME = day,/nodata,/YNOZERO,$
xtitle='L Shell',ytitle='Time (hours)',title='CRRES Magnetic Local Time Coverage Orbit 3 - 1067',ymargin=[8,2]
;AXIS, XAXIS=0,XTICKn=DAY
FOR I = 0, 22 DO $
begin
BOX, XVAL[I] - .045, !Y.CRANGE[0], $
     XVAL[I] + 0.045, YVAL[I], 0
!P.charsize=0.85
xyouts,2000+635*i,1100,day[i],ORIENTATION=60,/device

end
xyouts,7000,720,'Magnetic Local Time (hour)',ORIENTATION=0,/device

;xrange=[xval[0]-xval[0]/2+0.013,1]
!P.charsize=1.0
!Y.style=3
!P.ticklen=0.04
device,/close
end